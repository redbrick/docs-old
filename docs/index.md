# Redbrick system documentation

The idea behind this wiki is to eventually properly document everything that
any admin could ever possibly need to know about our setup, which can be a
little nightmarish at times if you don't know where to look for things.
Hopefully, things will also be kept up to date.

The search box actually **works** (I was amazed at this. Search isn't meant to
work. Ever. For anything).

## Current stuff

* [Current to Do List](/procedures/to_do_1502)
* [Paphos to do list](/procedures/paphos_migration)
* [nagios to do list](/procedures/nagios_to_do)
* [Suggested Ideas for scripts/projects](/procedures/project-ideas)
* [To Do List For New Admins](/procedures/new_admin_to_do)
* [RBVM management tool](/legacy/services/rbvm)
* [March 2016 Downtime & Maintenance](/postmortems/post_mortem_mar16)

## New Admins
New admins, read:

* [policies](/procedures/policies).
* [Testing accounts](/procedures/testing)
* [Abuse@redbrick, and the committee stance on it](/procedures/abuse)
* [IRC Operator Guide](/procedures/irc_operator)
* [Mail setup for mutt](/procedures/mail_setup)

---

# Full Contents

## Stuff on the Wall of the server room

* [Changing a local Password](/procedures/passwd)

## Services

#### Messaging

* [News Server (the boards)](/services/news)
* [IRC](/services/irc)
* <del>[jabber](/legacy/services/jabber)</del>
* <del>[peepd](/legacy/services/peepd)</del>
* [Webchat (qwebirc)](/services/webchat)

#### Ldap

* [LDAP](/services/ldap)
* [RRS setup, how to not break stuff after clubs and socs day](/procedures/rrs)

#### Storage

* [Current NFS setup](/services/nfs)
* <del>[Fast storage space for users](/legacy/services/faststorage)</del>

#### Mail

* [Exim email setup](/services/exim)
* [Dovecot IMAP](/services/dovecot) Dovecot
* [Mailman](/services/mailman) Redbrick Mailing Lists

#### NNTP

* [Setting up a new board](/procedures/newboard)

#### Databases

* [MySQL](/services/mysql)
* [postgres](/services/postgres)

#### Network

* [.15 Address Space](/network/mainaddressspace)
* [.16 Address Space](/legacy/network/vmaddressspace)
* [Network setup](/network/networksetup) (internal LAN, external LAN, switches, cable
	colours etc)
* [redbrick.dcu.ie](/web/redbrick.dcu.ie)
* [tunnel.redbrick.dcu.ie](/services/tunnel.redbrick.dcu.ie)
* <del>[VPN to Severus](/legacy/procedures/severus_vpn)</del>
* [Switch Setup](/procedures/switch)
* [Gratuitous ARP](/procedures/gratuitousarp) (or, how to force update an IP address's
	associated MAC on the router and other machines)

#### WWW

* [Redbrick SSL certs](/procedures/ssl)
* [Mercurial (hg) hosting](/services/hg)
* [Git hosting](/legacy/services/git)
* [Webchat (qwebirc)](/services/webchat)

#### Backups

* [Redbrick backups with dirvish](/legacy/procedures/dirvish)
* [Dirvish Tutorial](/legacy/procedures/dirvish_tutorial)

## Machines

### Services
#### Paphos - Primary Services

* [User Management](useradm)
* [DNS](bind9)

#### Metharme - Web Applications

* [Web Server](apache24)
* [IceCast](/services/icecast2)

#### halfpint - Admin Bastion

* [DRAC Access](/procedures/dracaccess)
* [Password Safe](pwsafe)
* [ DokuWiki](docs)
* [ Kinda the new sprout](sprout)

### User Login

#### Azazel - Primary User Login

* [Plan for /storage_move (this is all done!)](worf_plan)

#### Pygmalion - User Development

* [DRAC Access](dracaccess)
* [Pygmalion](pyg)

<del>[Carbon](/legacy/machines/carbon)</del>

### Web

#### Murphy

**Murphy runs Linux now. I'll get around to documenting it's setup quirks soon,
but really there aren't many, it's a straight Lenny install with the usual
redbrick linux packages.**

* [Murphy ALOM Access](/legacy/procedures/murphyalomaccess)

##### Old
Stuff from the dark ages (or, when we used Solaris 10)

* [murphy-disabled services](murphy-disabled services) - probably worth doing
	for all solaris boxes
* [Murphy general setup info](/legacy/machines/murphy)
* [OMG why does it have solaris](/legacy/procedures/murphysolaris)
* [Redbrick Solaris (rspm) Package Manager documentation](/legacy/procedures/redbrick_solaris_package_manager)
* [Live Upgrading Murphy](/legacy/procedures/murphyliveupgrade)
* [Python setup on Murphy](/legacy/procedures/murphypython)
* [lofiadm - Mounting ISOs on Solaris 10](/legacy/procedures/lofiadm)
* [pkgsrc - (Experimental) NetBSD package management on Solaris](/legacy/procedures/pkgsrc)

##### Even Older
Stuff from the Ubuntu 6.06 days

* [Murphy Pubcookie](/services/pubcookie), because the docs on the pubcookie site are
	shit, and our setup is..eh..special.
* [Apache on Murphy](/legacy/procedures/apacheonmurphy)
* [Murphy suPHP setup](/services/suphp)

### VM Project

#### Cynic - VM Firewall

* [Cynic](/legacy/machines/cynic)
* [Cynic RSC Access](/legacy/procedures/cynicrscaccess)
* [Installing Debian on Cynic](/legacy/procedures/cynicdebian)

####  Daniel - VM Host

* [daniel](/legacy/machines/daniel)
* [x4140 ILOM](/legacy/procedures/x4140ilom)
* [VM info and password resets](/legacy/services/rbvmctl)
* [Compiling Xen](/legacy/procedures/compilingxen)
* [RBVM management tool](/legacy/services/rbvm)
* [Keeping Track of VM Server Options and Work](/legacy/procedures/vmserverstuff)

### Backups

#### Severus - Offsite Backup

* [Severus (backup server) general setup info](/machines/severus)
* [Moving severus to CSD](/procedures/severuscolocation)

#### Thunder - Onsite Backup

* [thunder](thunder)

### Others

#### Admin Desktop

* [basementcat](/legacy/machines/basementcat)
* <del>[ceilingcat](/legacy/machines/ceilingcat)</del>

## Hardware

### Switches

* [Cisco IOS](/network/ciscoios)
* [hadron](/network/hadron)
* <del>[enzyme](enzyme)</del>
* [JunOS](/network/junos)
* [Higgs](/network/higgs)

### UPS

* [warmstart](/legacy/machines/warmstart)
* [electro](/legacy/machines/electro)
* [The PDUs](/machines/the_pdus)

### Other

* [Pike (IP-KVM)](/network/pike)
* <del> [Munger (Printer)](/legacy/other/munger)</del>

## Software
Software written by RedBrick, or with RedBrick customisations etc.

* [RedBrick Apt Repo (work in progress)](/legacy/procedures/redbrick-apt)
* [Backported Packages](/procedures/backport-packages)
* [Hey (and huh)](/services/hey)
* [Rbusers](/procedures/rbusers)
* [Chfn & Chsh for ldap](/procedures/ldapchshchfn)
* [Small scripts](/procedures/rbscripts)
* [putty](/services/putty)
* [RedBrick MOTD setup](/services/unifiedmotd)
* [Redbrick VM management tool](/legacy/services/rbvm)
* [Icecast Streaming Service for DCUFM](/services/icecast2)

## Other

* [Committee changeover procedure](/procedures/committeechangeover)
* [Installing new machines](/procedures/newinstalls)
* [Compiling a custom Ubuntu kernel](/legacy/procedures/ubuntukernel)
* [What to do immediately after a power cut](/procedures/post_powercut)

## Works In Progress

* [Rootholder public keys](/legacy/procedures/gpgkeys)
* [Ticketing system](/procedures/ticketing)
* [Munin](/legacy/services/munin)
* [Nagios](/services/nagios)

## Old Stuff
This stuff doesn't reflect the current setup, but may be useful sometime.

* [Murphy MySQL client bug](/legacy/procedures/murphymysqlclientbug)
* [Exim on Solaris](/legacy/procedures/exim_solaris)
* **[Carbon Reboot Warning](/legacy/procedures/carbonrebootwarning)**
* [UPS Stuff](/legacy/machines/ups)
* [Murphy Zone Configuration](/legacy/procedures/murphy-zones)
* [Murphy Jumpstart Configuration](/legacy/procedures/murphy-jumpstart)
* [News Overview Fix](/procedures/newsoverviewfix)
* **[What to do with carbon and deathray](/legacy/procedures/carbonanddeathray)
	(namely the impending upgrade from sarge, and the now free storage space on
	them)**
* [Open Ports](/legacy/procedures/openports)
* [IRC proxy](/legacy/services/ircproxy)
* [Apache configuration on Solaris 10](/legacy/procedures/apachesolaris)
* [PHP configuration on Solaris 10](/legacy/procedures/phpsolaris)
* [Apache modules (suphp, pubcookie)](/procedures/apachemodules)
* [Tomcat (and mod_jk)](/legacy/procedures/tomcat-murphy)

#### Old Hardware

*  <del>[Minerva general setup info](/legacy/machines/minerva)</del>
*  <del>[Minerva storage setup and performance issues/solutions](/legacy/procedures/minervastorage)</del>

# Useful Links

* [Ubuntu 6.06 Server Guide (PDF)](https///help.ubuntu.com/6.06/pdf/ubuntu/C/serverguide.pdf) -
	Contains a number of guides to setting up various services (DHCPD, Apache,
	Versioning, Mailman, etc).
* [Support cycles for a bunch of operating systems](http://www.redbrick.dcu.ie/~werdz/cycles.htm)
* [Solaris Hell Conversion Guide](http://www.cuddletech.com/blog/pivot/entry.php?id=562) -
	This (and some other posts on that blog) are helpful for trying to deal with
	solaris.
