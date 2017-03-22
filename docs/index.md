# Redbrick system documentation

The idea behind this wiki is to eventually properly document everything that
any admin could ever possibly need to know about our setup, which can be a
little nightmarish at times if you don't know where to look for things.
Hopefully, things will also be kept up to date.

The search box actually **works** (I was amazed at this. Search isn't meant to
work. Ever. For anything).

## Current stuff

* [Current to Do List](to_do_1502)
* [Paphos to do list](paphos_migration)
* [nagios to do list](nagios_to_do)
* [Suggested Ideas for scripts/projects](project-ideas)
* [To Do List For New Admins](new_admin_to_do)
* [RBVM management tool](rbvm)
* [March 2016 Downtime & Maintenance](post_mortem_mar16)

## New Admins
New admins, read:

* [policies](policies).
* [Testing accounts](testing)
* [Abuse@redbrick, and the committee stance on it](abuse)
* [IRC Operator Guide](irc_operator)
* [Mail setup for mutt](mail_setup)

---

# Full Contents

## Stuff on the Wall of the server room

* [Changing a local Password](passwd)

## Services

#### Messaging

* [News Server (the boards)](news)
* [IRC](irc)
* <del>[jabber](jabber)</del>
* <del>[peepd](peepd)</del>
* [Webchat (qwebirc)](webchat)

#### Ldap

* [LDAP](ldap)
* [RRS setup, how to not break stuff after clubs and socs day](rrs)

#### Storage

* [Current NFS setup](nfs)
* <del>[Fast storage space for users](faststorage)</del>

#### Mail

* [Exim email setup](exim)
* [Dovecot IMAP](dovecot) Dovecot
* [Mailman](Mailman) Redbrick Mailing Lists

#### NNTP

* [Setting up a new board](newboard)

#### Databases

* [MySQL](mysql)
* [postgres](postgres)
#### Network

* [.15 Address Space](mainaddressspace)
* [.16 Address Space](vmaddressspace)
* [Network setup](networksetup) (internal LAN, external LAN, switches, cable
	colours etc)
* [redbrick.dcu.ie](redbrick.dcu.ie)
* [tunnel.redbrick.dcu.ie](tunnel.redbrick.dcu.ie)
* <del>[VPN to Severus](severus_vpn)</del>
* [Switch Setup](Switch)
* [Gratuitous ARP](gratuitousarp) (or, how to force update an IP address's
	associated MAC on the router and other machines)

#### WWW

* [Redbrick SSL certs](ssl)
* [Mercurial (hg) hosting](hg)
* [Git hosting](git)
* [Webchat (qwebirc)](webchat)

#### Backups

* [Redbrick backups with dirvish](Dirvish)
* [Dirvish Tutorial](dirvish_tutorial)

## Machines

### Services
#### Paphos - Primary Services

* [User Management](useradm)
* [DNS](bind9)

#### Metharme - Web Applications

* [Web Server](apache24)
* [IceCast](icecast)

#### halfpint - Admin Bastion

* [DRAC Access](dracaccess)
* [Password Safe](pwsafe)
* [ DokuWiki](docs)
* [ Kinda the new sprout](sprout)

### User Login

#### Azazel - Primary User Login

* [Plan for /storage_move (this is all done!)](worf_plan)

#### Pygmalion - User Development

* [DRAC Access](dracaccess)
* [Pygmalion](pyg)
* <del>[Carbon](carbon)</del>

### Web

#### Murphy

**Murphy runs Linux now. I'll get around to documenting it's setup quirks soon,
but really there aren't many, it's a straight Lenny install with the usual
redbrick linux packages.**

* [Murphy ALOM Access](murphyalomaccess)

##### Old
Stuff from the dark ages (or, when we used Solaris 10)

* [murphy-disabled services](murphy-disabled services) - probably worth doing
	for all solaris boxes
* [Murphy general setup info](murphy)
* [OMG why does it have solaris](murphysolaris)
* [Redbrick Solaris (rspm) Package Manager documentation](redbrick_solaris_package_manager)
* [Live Upgrading Murphy](murphyliveupgrade)
* [Python setup on Murphy](murphypython)
* [lofiadm - Mounting ISOs on Solaris 10](lofiadm)
* [pkgsrc - (Experimental) NetBSD package management on Solaris](pkgsrc)

##### Even Older
Stuff from the Ubuntu 6.06 days

* [Murphy Pubcookie](pubcookie), because the docs on the pubcookie site are
	shit, and our setup is..eh..special.
* [Apache on Murphy](apacheonmurphy)
* [Murphy suPHP setup](suphp)

### VM Project

#### Cynic - VM Firewall

* [Cynic](cynic)
* [Cynic RSC Access](cynicrscaccess)
* [Installing Debian on Cynic](cynicdebian)

####  Daniel - VM Host

* [daniel](daniel)
* [x4140 ILOM](x4140ilom)
* [VM info and password resets](rbvmctl)
* [Compiling Xen](compilingxen)
* [RBVM management tool](rbvm)
* [Keeping Track of VM Server Options and Work](vmserverstuff)

### Backups

#### Severus - Offsite Backup

* [Severus (backup server) general setup info](severus)
* [Moving severus to CSD](severuscolocation)

#### Thunder - Onsite Backup

* [thunder](thunder)

### Others

#### Admin Desktop

* [basementcat](basementcat)
* <del>[ceilingcat](ceilingcat)</del>

## Hardware

### Switches

* [Cisco IOS](ciscoios)
* [hadron](hadron)
* <del>[enzyme](enzyme)</del>
* [JunOS](junos)
* [Higgs](higgs)

### UPS

* [warmstart](warmstart)
* [electro](electro)
* [The PDUs](The PDUs)

### Other

* [Pike (IP-KVM)](pike)
* <del>[Munger (Printer)](munger)</del>

## Software
Software written by RedBrick, or with RedBrick customisations etc.

* [RedBrick Apt Repo (work in progress)](redbrick-apt)
* [Backported Packages](backport-packages)
* [Hey (and huh)](hey)
* [Rbusers](rbusers)
* [Chfn & Chsh for ldap](ldapchshchfn)
* [Small scripts](rbscripts)
* [putty](putty)
* [RedBrick MOTD setup](unifiedmotd)
* [Redbrick VM management tool](rbvm)
* [Icecast Streaming Service for DCUFM](icecast2)

## Other

* [Committee changeover procedure](committeechangeover)
* [Installing new machines](newinstalls)
* [Compiling a custom Ubuntu kernel](ubuntukernel)
* [What to do immediately after a power cut](post_powercut)

## Works In Progress

* [Rootholder public keys](gpgkeys)
* [Ticketing system](ticketing)
* [Munin](munin)
* [Nagios](nagios)

## Old Stuff
This stuff doesn't reflect the current setup, but may be useful sometime.

* [Murphy MySQL client bug](murphymysqlclientbug)
* [Exim on Solaris](exim_solaris)
* **[Carbon Reboot Warning](carbonrebootwarning)**
* [UPS Stuff](ups)
* [Murphy Zone Configuration](murphy-zones)
* [Murphy Jumpstart Configuration](murphy-jumpstart)
* [News Overview Fix](newsoverviewfix)
* **[What to do with carbon and deathray](carbonanddeathray) (namely the
	impending upgrade from sarge, and the now free storage space on them)**
* [Open Ports](openports)
* [IRC proxy](ircproxy)
* [Apache configuration on Solaris 10](apachesolaris)
* [PHP configuration on Solaris 10](phpsolaris)
* [Apache modules (suphp, pubcookie)](apachemodules)
* [Tomcat (and mod_jk)](tomcat-murphy)

#### Old Hardware

*  <del>[Minerva general setup info](minerva)</del>
*  <del>[Minerva storage setup and performance issues/solutions](minervastorage)</del>

# Useful Links

* [Ubuntu 6.06 Server Guide (PDF)](https///help.ubuntu.com/6.06/pdf/ubuntu/C/serverguide.pdf) -
	Contains a number of guides to setting up various services (DHCPD, Apache,
	Versioning, Mailman, etc).
* [Support cycles for a bunch of operating systems](http://www.redbrick.dcu.ie/~werdz/cycles.htm)
* [Solaris Hell Conversion Guide](http://www.cuddletech.com/blog/pivot/entry.php?id=562) -
	This (and some other posts on that blog) are helpful for trying to deal with
	solaris.


# System Documentation Redundancy
If sprout goes down, it'd be nice to have access to documentation, in case we
need said documentation to bring it back up :). There are three separate systems
for docs redundancy.

### docs(2|3).redbrick.dcu.ie
There are extra, read-only docs websites `docs2.redbrick.dcu.ie` and
`docs3.redbrick.dcu.ie` on severus and thunder, generated nightly as part of
dirvish. This is a full copy of the php and source files on sprout. Users can
login, put to prevent things going out of sync the content text files are
`chown`'d by the script to stop accidental editing. Page revisions and other
features work normally. This behaviour could easily be changed if either mirror
needed to take over as the primary site.

This functionality is provided by the [redbrick-docs2 package](redbrick-apt)

### docs(4|5).redbrick.dcu.ie
Docs4 and docs5 are on `showboat.theinternets.be` and `anubis.nowai.org`, and
mirrored with a [cronjob running on the mirror](docs_mirror_script). These sites
are just static html files. They're useful if the main sites aren't available,
but images etc. won't work properly, and there may be other issues. The script
to generate these mirrors is also a
[giant ball of hacks](http://www.laputan.org/mud/mud.html#BigBallOfMud),
in particular, only pages linked from this start page will be mirrored.

### CeilingCat, Lightning & Coke
In case of network failure or other act of god the pages are copied directly
from sprout to ceilingcat, lightning & coke as part of `/etc/daily.local`.
There are ssh keys set up so `root@sprout` can `scp` to `docs@$machine` without
a password.

There's no http server on these machines, but the docs are fairly readable in
plain text.
