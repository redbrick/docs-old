# Redbrick System Documentation

The idea of Redbrick documention is to keep an up to date information about the
technical infrastructure of Redbrick. This is mostly intended for admins, future
admins, webmasters, and everybody else who is grumpy and has no life.

The search box actually **works** (I was amazed at this. Search isn't meant to
work. Ever. For anything).

## Current stuff

- [Current TODO list](/plans/TODO-2017)
- [Suggested Ideas](/plans/project-ideas)

---

## New Admins

You will regret this decision. But if you are sure make sure you are familiar
with the following:

- [Policies](/procedures/policies)
- [Abuse@redbrick, and the committee stance on it](/procedures/abuse)

---

## Operations

Day to day running of things.

- [IRC Operator Guide](/procedures/irc_operator)
- [IRC](/services/irc)
- [LDAP](/services/ldap)
- [News Server (the boards)](/services/news)
- [Clubs and Socs Day](/procedures/rrs)
- [Changing a local Password](/procedures/passwd)
- [Committee changeover procedure](/procedures/committeechangeover)
- [Installing new machines](/procedures/newinstalls)
- [Responding to tickets](/procedures/ticketing)

#### Storage

- [Current NFS setup](/services/nfs)

#### Mail

- [Exim email setup](/services/exim)
- [Dovecot IMAP](/services/dovecot)
- [Mailing Lists (Mailman)](/services/mailman)
- [Mail setup for mutt](/procedures/mail_setup)

#### NNTP

- [Setting up a new board](/procedures/newboard)

#### Databases

- [MySQL](/services/mysql)
- [postgres](/services/postgres)

#### Network

- [.15 Address Space](/network/mainaddressspace)
- [.16 Address Space](/legacy/network/vmaddressspace)
- [Network setup](/network/networksetup) (internal LAN, external LAN, switches,
  cable colours etc)
- [tunnel.redbrick.dcu.ie](/services/tunnel.redbrick.dcu.ie)
- [Switch Setup](/procedures/switch)
- [Gratuitous ARP](/procedures/gratuitousarp) (or, how to force update an IP
  address's associated MAC on the router and other machines)
- [JunOS Configuration](/network/junos)

#### WWW

- [redbrick.dcu.ie](/web/redbrick.dcu.ie)
- [Redbrick SSL certs](/procedures/ssl)
- [Mercurial (hg) hosting](/services/hg)
- [Webchat (qwebirc)](/web/webchat)

#### Backups

- [BackupPC](/services/backuppc)
- [Moving severus to CSD](/procedures/severuscolocation)

---

## Emergencies

After each emergency remember to write a postmortem!

- [What to do immediately after a power cut](/procedures/post_powercut)

---

## Machines

### Services

#### Daedalus + Icarus - LDAP + Distributed storage

- [LDAP](/services/ldap)
- NFS, (a.k.a /storage) from Icarus

#### Paphos - Primary Services

- [DNS](/services/bind9)

#### Zeus - Secondary Services and New web

- [Techweek](/web/techweek)
- [Website](/web/website)

#### Metharme - Web Applications

- [Web Server](/web/apache)
- [IceCast](/services/icecast2)

#### halfpint - Admin Bastion

- [DRAC Access](/procedures/dracaccess)
- [Password Safe](/procedures/pwsafe)

### User Login

#### Azazel - Primary User Login

#### Pygmalion - User Development

- [DRAC Access](/procedures/dracaccess)

## Security

- [Rootholder public keys](/procedures/gpgkeys)

## Hardware

### Switches

- [Cisco IOS](/network/ciscoios)
- [Hadron](/network/hadron)
- [JunOS](/network/junos)
- [Higgs](/network/higgs)

### UPS

- [The PDUs](/hardware/the_pdus)

### Other

- [Dell IP-KVM](/hardware/ipkvm)

## Software

Software written by RedBrick, or with RedBrick customisations etc.

- [RedBrick Apt Repo (work in progress)](/procedures/redbrick-apt)
- [Backported Packages](/procedures/backport-packages)
- [Hey (and huh)](/services/hey)
- [Rbusers](/procedures/rbusers)
- [Chfn & Chsh for ldap](/procedures/ldapchshchfn)
- [Small scripts](/procedures/rbscripts)
- [RedBrick MOTD setup](/services/unifiedmotd)
- [Icecast Streaming Service for DCUFM](/services/icecast2)

---

## System Documentation Redundancy

### docs.redbrick.dcu.ie

This is a self hosted version running on halfpint. Its a cron job that pull from
github once an hour and if it finds an update it rebuilds the site.

### Github

Github is where docs are stored. They are plain markdown but they are easily
accessed and read from anywhere.

### ReadTheDocs

Docs are auto deployed to [readthedocs](https://readthedocs.io) on commit to the
`master` branch. They should always be up to date.
