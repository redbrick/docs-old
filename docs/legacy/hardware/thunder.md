# Thunder General Setup Info

## Hardware Setup


*  Pentium 4

*  2GB RAM

*  DELL CERC RAID Controller

*  Tower enclosure

*  Ubuntu 8.04

## Disk Layout


*  4x500gb disks on the controller

*  This is split into a raid 10 array for the OS

*  And a raid 5 array for /backup

## Backup Setup

Read [dirvish](/legacy/procedures/dirvish)

## Mysql

Thunder is a mysql replication slave. The replication user is called replication, the password for this is in pwsafe. The [mysql docs](http://dev.mysql.com/doc/refman/5.0/en/replication-howto.html) on how to set this up are fairly good. The procedure for resyncing this with the master is documented on the [mysql](/services/mysql) page.

## Known Issues


*  The onboards SATA ports appear not to work

*  It doesn't like talking to USB keyboards.

*  ~~One of the older disks (disk 2), may be dodgy.~~ They were both dodgy. They died. I cried.
