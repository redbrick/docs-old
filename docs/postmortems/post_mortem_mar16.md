# Post Mortem March 16

Logs from admins discussing issue

``` text
14:32 <koffee> anyone able to shed any light?
14:35 <vadimck> is it mounted now?
14:35 <vadimck> this is /storage right?
14:36 <koffee> I have that mounted now; it's fine; just needed a mount -a
14:36 <koffee> (it was present in /etc/fstab, but wasn't mounted)
14:37 <koffee> box in question is paphos
15:15 <koffee> and to make matters worse, there's a disk I/O error on thunder
15:20 <koffee> I've unmounted the /backup filesystem
15:21 <zergless> thunders onboard disks or the /backup
15:26 <koffee> the /backup, the array it's been throwing disk errors
15:27 <zergless> ah wank
16:08 <koffee> also, that array has a standby backup power supply.... that we've never plugged in?!
16:11 <zergless> koffee: work remotely sure if you wanna head
16:20 <koffee> I'm going to go read this: http://www.dell.com/downloads/global/products/pvaul/en/cxseries_initialconfig.pdf
16:20 <koffee> and see if there's any way to access it.
16:20 <koffee> it's currently connected into gi 0/44 on hadron and into fa 0/12 on a switch to which basementcat is also connected.
16:21 <koffee> I need some way to get at the disk level management to ascertain what the issue is and get a replacement disk
16:51 <koffee> Have sorted the IPKVM issue anyway
17:41 <zergless> just disk level management now?
17:53 <koffee> not even
17:54 <koffee> might be able to manage it if its mounted via an external raid controller
17:55 <koffee> but otherwise we've no disk level visibility
17:59 <zergless> so we dunno which disk is erroring?
17:59 <koffee> I do, but I can't remove it safely from the array and make sure its rebuilding
18:01 <zergless> thats a bit more of an issue alright
18:13 <koffee> trying to trace down a replacement is tough
18:35 <zergless> gw: not the best from what i hear. issue on new kernal on paphos, and disk io errors on /backup
18:39 <gw> boo-urns
19:08 <koffee> o/
19:08 <koffee> tis fucked
19:22 <tbolt> koffee: What's going on? Anything I can help with?
19:25 <koffee> check the email it gives a tl;dr but need to see why the initramfs or initrd despite explicitly telling grub where the bootloader and root partition is
19:25 <tbolt> Did this work before? When was the last time we rebooted?
19:26 <koffee> there's a live-cd in paphos if I need to do another recovery, but won't try again til tomorrow
19:26 <koffee> it's not a reboot issue, its a new kernel
19:26 <koffee> the fstab is intact and pointing at the correct UUID
19:34 <tbolt> ah okay
```
