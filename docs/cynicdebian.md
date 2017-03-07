Because debian is so much nicer than solaris Sun Microsystems have gone to great lengths to make it difficult for you to install it.

(These instructions are based on etch, things may change, obviously)

You should read the [Release Notes](http://www.debian.org/releases/etch/sparc/release-notes/ch-installing.en.html) before reading this.

## Actually booting the damn install

   * Get the CD, and put in in the disk.
   * Break cynic to an ok prompt.
   * setenv boot-device cdrom
   * Yes, i said cdrom, not dvd rom.
   * At this point, you're asking yourself why not just boot from the cd. You have to cold boot it, or it just doesn't work.
   * Use the LOM to poweroff the machine, wait at least 10 seconds, then poweron.
   * If it works then congratulations, you've passed the first hurdle. If you get an illegal instruction error you're doing it wrong.

## AAH, it's horrible

Presumably you're using minicom, and it is indeed horrible. It's about to get a whole lot worse though. I recommend you skip configuring networking here, and head straight for your next problem...

The disk firmware hasn't been included because it's not free enough.

When it fails to find your disks you'll get a menu, take the go back option. You should end up at the main install menu, you can drop to a shell from here.

## Getting busy with busybox

From the shell use ifconfig to get a network connection running.

    ifconfig eth0 up 136.206.15.23 netmask 255.255.255.0

should be enough.

Next you'll realise you have fuck all to actually test it with :) (you also have no dns or gateway)

    wget -O - http://136.206.15.70

or something. This will tell you if the network is running.

Sometimes it can take a few seconds for the network to appear to work. Keep beating it with ifconfig and it should eventually work.

Get the [firmware package](http://ftp.ie.debian.org/debian/pool/non-free/f/firmware-nonfree/firmware-qlogic_0.4+etchnhalf.1_all.deb) and download it to $other_machine. Put it somewhere simple where you can wget it without worrying about hostnames etc. and then wget it to /tmp

## WTF is an udpkg

Apparently it's some kind of mini dpkg only used by the debian installer. I know, I'd never heard of it either. Use udpkg -i to install the firmware you just downloaded.

Once you've done that you'll need to use modprobe to reload the disk module.

    modprobe -r qla2xxx
    modprobe -i qla2xxx

Tail out dmesg here, if it worked you'll see stuff about the disks.

If all that worked exit back to the installer

## I know there's a raid option here somewhere

You're hopefully in the disk partitioner at this point, and you've spend an hour trying to find out why you can't get a raid option. The answer is that you can't have it at the start of the disk, put swap or something at the start, then create raid volumes as normal.

After this the installer should continue as normal

## DON'T REBOOT YET

You need to install that firmware package into the new system before you reboot, or you won't be able to reboot

At the final screen select go back to get to the menu. Drop back to the shell.

The installed system is in /target. Move that deb you downloaded earlier into /target/tmp, and then chroot /target. Then install the package with dpkg.

Once you've installed the package exit the chroot and the shell. Then let the installation complete.

## OMG, it's booting the cd again!

Well, of course it is. Break back to an ok prompt, then:

    setenv boot-device disk

It should then boot normally.


## Other things you should probably know

#### Wiping the partition table

I had to do this during one install. Use dd as described in the release notes.

#### Ah, sure i'll just reboot here

During one install very late in teh night I rebooted from the chroot and didn't let the installer finish properly. I corrupted the entire apt database, and ended up installing from scratch. Don't do it. (or do, I don't really care)

#### Why is eth4 going mad?

eth4 is the dodgy onboard port. It'll go mad and spew crap all over the console.

You can use these filters for syslog-ng to stop it filling messages & syslog aswell.


	filter f_syslog { not facility(auth, authpriv) and not match("eth4"); };


	filter f_messages {
	        level(info,notice,warn)
	            and not facility(auth,authpriv,cron,daemon,mail,news)
	            and not match("eth4");
	};
