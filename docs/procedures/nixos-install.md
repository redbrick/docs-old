# Installing NixOS

It is ideal to use ZFS when possible. It can compress the nix store up to 2x which
greatly speeds up IO on spinning disks.

Try to use JBOD mode for disks on RAID controllers if it is available. 1-disk RAID 0s
is also possible but it will complicate disk replacements.

With a ZFS root you will need a software RAID-1 partition on each disk aswell for /boot.
Make sure to use metadata=0.9 as to not mess with MBR boot data for BIOS booting.

This guide will assume you know how to configure your RAID controller and how to modify
`zpool create` to manage your own disk layout.

- Create partitions on the target disk.

```bash
parted /dev/sda
> mklabel msdos
> mkpart primary ext4 1M 384M
> mkpart primary 384M 2432M
> mkpart primary 2432M 100%
> toggle 1 boot
> print
> quit
```

- Format disks and create Zpool. Use disk ID so that ZFS never gets confused

```bash
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
# Figure out which disk is sda3
export DISK=/dev/disk/by-id/wwn-....
export HOSTNAME=hardcase
zpool create \
    -o feature@skein=enabled \
    -O checksum=skein \
    -o feature@lz4_compress=enabled \
    -O compress=lz4 \
    -o feature@large_dnode=enabled \
    -O dnodesize=auto \
    -O dedup=on \
    -O acltype=posixacl \
    -O atime=off \
    -O xattr=sa \
    -O mountpoint=none \
    -o comment="$HOSTNAME ZFS Storage" \
    zstorage $DISK
zfs create -o mountpoint=legacy zroot/nixos
zfs create -o mountpoint=legacy zroot/nixos/store
```

- If trying to boot using GRUB create a separate pool for rootfs

```bash
export DISK=/dev/disk/by-id/ata-TOSHIBA_DT01ACA300_13F7L8WGS-part3
zpool create \
    -o feature@skein=disabled \
    -o feature@sha512=disabled \
    -o feature@edonr=disabled \
    -o feature@large_dnode=disabled \
    -o feature@lz4_compress=enabled \
    -O compress=lz4 \
    -O acltype=posixacl \
    -O atime=off \
    -O xattr=sa \
    -O mountpoint=none \
    -o comment="$HOSTNAME ZFS Root" \
    -R /mnt zboot $DISK
```

- Set up mounts and install system

```bash
mount -t zfs zroot/nixos /mnt
mkdir -p /mnt/{boot,nix}
mount -t zfs zroot/nixos/store /mnt/nix
mount /dev/sda1 /mnt/boot
swapon /dev/sda2
nixos-generate-config --root /mnt
export http_proxy="http://proxy.internal:3128/"
export https_proxy="$http_proxy"
export HTTP_PROXY="$http_proxy"
export HTTPs_PROXY="$http_proxy"
export CURL_NIX_FLAGS="-x $http_proxy"
# Here you would clone your git repo to /mnt/etc/nixos and set system config
# if you have a repo
nixos-install
# RECORD THE NEW ROOT PASSWORD IN PASSWORDSAFE
swapoff /dev/sda2
umount /mnt/boot /mnt/nix /mnt
# SUPER IMPORTANT otherwise pool import will fail on first boot
zpool export zroot
```

Done!
