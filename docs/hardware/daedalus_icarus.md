# Deadalus and Icarus

These 2 poweredge servers are twins, and thus share documentation too.

## Quick Facts

- Both are dual socket Poweredge 2950, DDR2
- Both run NixOS
- Daedalus has 32gb RAM, Icarus has 16gb because 1 DIMM died
- Daedalus' IP is `0.50`, Icarus' is `0.150`
- Their iDRAC IPs are `1.50` and `1.150` respectively
- Both run 802.3ad bonding on NICs 1 and 2, and have their iDRACs
set up in "shared" mode.
- Both boot from a 2x68gb SAS Hardware RAID1 pair, and also have
3x600gb SAS used for ZFS + in the future Gluster.

## Services

- [LDAP](/services/ldap)
- GlusterFS, eventually, or some other distributed storage to replace NFS

## Disk Management

MegaCli64 can be used to manage the hardware RAID controller. It is installed
on both machines. Take note that there is 1x RAID 1 and 3x RAID 0 set up on both.
The RAID 0's are effective passthrough for the 3 600gb sas disks used for ZFS.

```bash
# List event log
MegaCli -AdpEventLog -GetEvents -f events.log -a0 && cat events.log

# Check BBU
MegaCli -AdpBbuCmd -a0

# List physical disks, note enclosure IDs (E) + slot IDs (S)
MegaCli64 -PDList -a0 | less

# To create a RAID 0 for passthrough, use this command and replace E + S
MegaCli64 -CfgLdAdd -r0 [E:S] -a0

# To create a RAID 1 array
MegaCli64 -CfgLdAdd -r1 [E:S,E:S] -a0

# Mark a drive ready for replacement#
# If it's in a Raid 0 first delete that, replace N with the LD ID
MegaCli64 -LDInfo -Lall -a0
MegaCli64 -CfgLdDel -LN -a0

MegaCli -PDOffline -PhysDrv [E:S] -a0
MegaCli -PDMarkMissing -PhysDrv [E:S] -a0
MegaCli -PdPrpRmv -PhysDrv [E:S] -a0

# Insert new drive then mark as replacement
# Skip the first 2 steps for RAID 0, and just recreate the array at the end
# Get the array ID from CfgDsply
MegaCli -CfgDsply -a0
# R will be the index of the replacing drive in the array
MegaCli -PdReplaceMissing -PhysDrv [E:S] -ArrayN -rowR -a0
MegaCli -PDRbld -Start -PhysDrv [E:S] -a0
MegaCli -PDMakeGood -PhysDrv[E:S] -a0
```
