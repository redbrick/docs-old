# Minerva General Setup




## Hardware


*  2 x Xeon 5030 (I think) CPUs - dual core, 2.66GHz, netburst architecture, support VMX

*  6GB RAM

*  PCI Express and PCI-X buses present

*  3ware 9650SE RAID connected to the PCI-Ex bus

*  Intel integrated LAN controller with 2xGigE ports

*  Dell PERC6/E controller attached to Worf

## OS

Ubuntu 8.04

## Disk layout

''
/dev/sda - Dell PERC6/E connected to Worf (MD1000 array) in RAID 10\\
........1 (Pri) - /storage - Main storage volume - 2TB\\
''

''
/dev/sdb - Old array attached to 3ware POS\\
........1 (Pri) - Used to be /storage. 1.4TB\\
........2 (Pri) - Used to be (years ago) a place for backups. 1.4TB\\
''

''
/dev/sdc - SATA disk\\
........1 (Pri) - `<swap>` - 5.5GB\\
........2 (Pri) - /adminporn - 950MB\\
........3 (Pri) - Extended partition containing:\\
........5 (Ext) - RAID space for md0\\
........6 (Ext) - RAID space for md1\\
........7 (Ext) - RAID space for md2\\
........8 (Ext) - RAID space, seems to be unused\\
''

''
/dev/sdd - SATA disk\\
........1 (Pri) - Extended partition\\
........5 (Ext) - RAID space for md0\\
........6 (Ext) - RAID space for md1\\
........7 (Ext) - RAID space for md2\\
........8 (Ext) - RAID space, seems to be unused\\
........9 (Ext) - `<swap>`\\
.......10 (Ext) - Seems to be unused\\
''

''
/dev/md - Software RAID (spread over sdc and sdd)\\
.......0 - /var/tmp - 14GB\\
.......1 - / - 9.3GB\\
.......2 - /usr - 14G\\
''

Swap isn't in RAID 1 like the rest of them as the OS will stripe it by default if there are two swap partitions present. That way we get the performance of striping without the extra point of failure (software RAID drivers, etc).

## Network

Connected to internal and external LANs via the integrated Intel ethernet controller.


## Things to be aware of

### Rebooting

Every now and then, on reboot, minerva's initramfs refuses to recognise the root partition, so the system doesn't boot. I have no idea what causes this, it appears to be at complete random. Usually, doing a hard reboot fixes it. For this reason, **avoid rebooting minerva unless you have physical access to the server room**, as it may not come back up.

### RAID performance

Read [this page](minervastorage).

## IMAP

imap.redbrick.dcu.ie is currently ran from minerva, with courier. It is planned to replace courier.


## IRC

Ircd is on minerva. This will move once services are re-organised following a re-install of deathray in 2009
