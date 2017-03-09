# lofiadm - Mounting ISOs on Solaris 10

The tool lofiadm is used to create a device node for an ISO image, which can
then be mounted with the mount command. For example, on Murphy, the Solaris
10u6 ISO is in `/root/solaris10u6.iso`. If you wanted to install a package off
this, you'd need to mount it:

```
# lofiadm -a /root/solaris10u6.iso
/dev/lofi/1
```

The output of lofiadm is the name of the node created. Use this in mount:

```
# mount -F hsfs -o ro /dev/lofi/1 /mnt
```

Omg, it mounted:

```
# df
/                  (/dev/md/dsk/d10   ): 2455234 blocks   874721 files
(...various other mounts....)
/mnt               (/dev/lofi/1       ):       0 blocks        0 files
# ls /mnt
boot                         License
Copyright                    platform
installer                    Solaris_10
JDS-THIRDPARTYLICENSEREADME
#
```

Hooray for Solaris.

More info: http://www.cyberciti.biz/faq/howto-mount-sun-solaris-cd-iso-image/
