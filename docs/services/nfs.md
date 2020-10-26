# Network File System

NFS is used to serve the notorious `/storage` directory across all our machines,
which in turn serves `/home`, `/webtree`, and some other critical folders.

## Deployment

- NFS is deployed with Nix on [Icarus](/hardware/daedalus_icarus)
- It is backed onto the Powervault MD1200, with all its disk passed through
  single-drive RAID 0's to allow for the setup of ZFS:
  - 1 mirror of 2x 500gb drives
  - 1 mirror of 2x 750gb drives
  - 1 mirror of 2x 1tb drives
  - Stripe across all mirrors for 2tb usable storage
  - 1 hot spare 750gb drive
- ZFS is configured with compression on and dedup off
- The ZFS pool is called `zbackup`

## Redbrick Special Notes

- On each machine, `/storage` is where NFS is mounted, but `/home` and
  `/webtree` are symlinks into there.
- There are 2 scripts used to control quotas, detailed below
- This is supposed to backup to [Albus](/hardware/albus) using
  [backuppc](/services/backuppc), but it's broken at the moment

## `zfsquota` and `zfsquotaquery`

These are 2 bash scripts run as systemd services on Icarus to manage
quotas. This is achieved through getting and setting the `userquota` and
`userused` properties of the ZFS dataset.

ZFSQuota will read the `quota` field from LDAP and sync this with the
`userquota` value on the dataset. It is not event driven - it runs on a timer
every 3 hours and syncs all LDAP quotas with ZFS. It can be kicked off manually,
which is decribed below. Users with no quota in LDAP will have no quota in
/storage, and users who have their quota removed will persist on ZFS.
Changing user names has no impact on this since it is synced using uidNumber.

ZFSQuotaQuery returns the quota + used space of a particular user. This
is used to then inform `rbquota` which provides the data for the MOTD used
space report. Both of these scripts are defined + deployed in the Nix
config repo. It runs on port 1995/tcp.

## Operation

In general, there isn't too much to do with NFS. Below are some commands
of interest for checking its status.

```bash
# On the NFS server, list the exported filesystems
showmount -e

# Get the real space usage + fragmentation percent from ZFS
zpool list zbackup

# Check a user's quota
zpool get userquota@m1cr0man zbackup
zpool get userused@m1cr0man zbackup

# Delete a quota from ZFS (useful if a user is deleted)
zpool set userquota@123456=none zbackup

# Get all user quota usage, and sort it by usage
zfs userspace -o used,name zbackup | sort -h | tee used_space.txt

# Resync quotas (this command will not return until it is finished)
systemctl start zfsquota

# Check the status of zfsquotaquery
systemctl status zfsquotaquery
```

## Troubleshooting

In the event where clients are unable to read from NFS, your priority
should be restoring the NFS server rather than unmounting NFS from clients.
This is because NFS is mounted in `hard` mode everywhere, meaning that it
will block on IO until a request can be fulfilled.

### Check the server

```bash
# Check the ZFS volume is readable and writable
ls -l /zbackup/home
touch /zbackup/testfile

# Check that rpc.mountd, rpc.statd and rpcbind are running and lisening
ss -anlp | grep rpc

# Check the above services for errors (don't worry about blkmap)
systemctl status nfs-{server,idmapd,mountd}
journalctl -fu nfs-server -u nfs-idmapd -u nfs-mountd
```

### Check the client

```bash
# Check for connection to NFS
ss -atp | grep nfs

# Check the fstab entry
grep storage /etc/fstab

# Check if the NFS server port can be reached
telnet 192.168.0.150 2049
# Entering gibberish should cause the connection to close

# Remount read-only
mount -o remount,ro /storage

# Not much left you can do but remount entirely or reboot
```
