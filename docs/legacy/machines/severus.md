# Severus General Setup Info

## Hardware Setup


*  Xeon 3050 CPU (2.13GHz, Core architecture, dual-core, supports VMX)

*  2GB RAM

*  3ware 9650SE RAID card

*  2U enclosure

*  Ubuntu 8.04

## Disk Layout


*  7x500gb disks in raid 5. This is /backup

*  One 250gb disk for the OS. has /, /var, swap etc.

## Backup Setup

Read [dirvish](/legacy/procedures/dirvish)

## Mysql

Severus is a mysql replication slave. The replication user is called replication, the password for this is in pwsafe. The [mysql docs](http://dev.mysql.com/doc/refman/5.0/en/replication-howto.html) on how to set this up are fairly good.

## Splunk

Severus has some splunk stuff, werdz knows about this.
