# Hardcase

Known for its hard to open top cover.

## Details

- Type: Dell PowerEdge R410
- OS: NixOS
- CPU: 2 x Intel Xeon X5570 @ 2.93GHz
- RAM: 48GB, incorrectly populated
- Storage: LSI Logic SAS1068E "Fake" RAID controller
- Disks: 2 x 500GB SATA disks in RAID 1
- Drives: Internal SATA DVD+/-RW
- Network: 2x Onboard Ethernet, 802.3ad bonding
- iDRAC NIC: Shared on port 1
- Hardcase's IP is `0.158`
- Its iDRAC IP is `1.158`

## Services

- PostgreSQL
- [Gitea](/services/git)
- [Apache](/web/apache)
- [pastebin](/services/paste)
- [monitoring](/monitoring)

## Disk Management

LSIUtil can be used to manage the hardware RAID controller. It is installed on
this machine. It has a remarkably easy to use interface, just run `lsiutil` and
choose the actions you want to take like an automated phone support line.
