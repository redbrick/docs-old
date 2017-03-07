# Minerva Storage and Performance Issues

## Disk Layout

See [this page](minerva) for full partition layout.

## Performance

The 3ware RAID card we have doesn't seem to like the vast amounts of traffic we inflict on it. It's noticeably slower than the RAID arrays in carbon and deathray. While the twins have 15000RPM SCSI disks in their arrays (minerva has 7200RPM SATA disks), this can only be part of the reason for the performance decrease, as minerva has twice (or 4 times?) as many disks in the array. Which would logically mean more speed. So the controller is at least partly to blame.

### I/O settings

As suggested by the 3ware knowledge base ([here](http://www.3ware.de/KB/article.aspx@id=10036) and [here](http://www.3ware.de/KB/article.aspx@id=11050)), a number of tweaks were made to increase performance. The following was added to /etc/rc.local:

''
# Settings to improve performance on 3ware 9650SE\\

echo 64 > /sys/block/sda/queue/max_sectors_kb\\
echo 512 > /sys/block/sda/queue/nr_requests\\
echo "deadline" > /sys/block/sda/queue/scheduler\\
echo 20 > /proc/sys/vm/dirty_background_ratio\\
echo 60 > /proc/sys/vm/dirty_ratio\\
\\
blockdev --setra 16384 /dev/sda
''

These increased performance a little, but not hugely.

We contacted encom, but they just directed us to the 3ware KB article.

### NFS settings

Another separate, but related issue is NFS. File access seems to be even slower from other machines, so we increased the rsize and wsize in the mount options on carbon, deathray and murphy to 64K (rsize=65536,wsizr=65536). This significantly improved performance over NFS. I think it's due to the NFS block size now matching the file system block size, causing less fragmentation. In addition, the internal switch was upgraded from an unmanaged 100M switch to an unmanaged 1000M switch.

Eventually we'd like to connect to murphy via a crossover cable. This would allow us to use a GigE link that supported jumbo frames (we can't afford a switch that supports them), which should increase performance even more. We're choosing murphy as it's currently primary login and will become our web server. See [here](minerva) for more on this.

-werdz
23/Dec/2007
