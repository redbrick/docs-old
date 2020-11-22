# Albus

The one with the full front facia of drive bays.
Mostly used for backups.

## Details

- Type: Dell PowerEdge R515
- OS: NixOS
- CPU: 2 x Opteron 4334 6 core @ 3.2GHz
- RAM: 32GB
- Storage: LSI MegaRAID SAS 2108 RAID controller
- Disks: 2 x 300gb SAS for boot, 8x 1tb SATA ZFS
- Drives: Internal SATA DVD+/-RW
- Network: 4x Onboard Ethernet, 802.3ad bonding
- iDRAC NIC: Shared on port 1
- Albus's IP is `0.56`
- Its iDRAC IP is `1.56`

## Services

- [ZnapZend](/services/znapzend)

## Installation Notes

- Hardware RAID must be set up in the BIOS or using MegaCli64.
- The boot disks are in RAID 1, all other disks are in individual RAID 0's.
- The RAID controller firmware does not work under UEFI and thus the OS must be installed in legacy mode.


