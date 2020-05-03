# Redbrick System Documentation

The idea of Redbrick documention is to keep an up to date information about the
technical infrastructure of Redbrick. This is mostly intended for admins, future
admins, webmasters, and everybody else who is grumpy and has no life.

The search box actually **works** (I was amazed at this. Search isn't meant to
work. Ever. For anything).

## Current stuff

- [Current TODO list](plans/TODO-2017)
- [Suggested Ideas](plans/project-ideas)

---

## New Admins

You will regret this decision. But if you are sure make sure you are familiar
with the following:

- [Policies](procedures/policies)
- [Abuse@redbrick, and the committee stance on it](procedures/abuse)
- [Nixos - by god there's a lot of it](procedures/nixos)

---

## Operations

Day to day running of things.

- [IRC Operator Guide](procedures/irc_operator)
- [IRC](services/irc)
- [LDAP](services/ldap)
- [News Server (the boards)](services/news)
- [Clubs and Socs Day](procedures/rrs)
- [Changing a local Password](procedures/passwd)
- [Committee changeover procedure](procedures/committeechangeover)
- [Installing new machines](procedures/newinstalls)
- [Responding to tickets](procedures/ticketing)

#### Storage

- [Current NFS setup](services/nfs)

#### NNTP

- [Setting up a new board](procedures/newboard)

#### Databases

- [MySQL](services/mysql)
- [postgres](services/postgres)

#### Network

- [.15 Address Space](network/mainaddressspace)
- [Network setup](network/networksetup) (internal LAN, external LAN, switches,
  cable colours etc)
- [tunnel.redbrick.dcu.ie](services/tunnel.redbrick.dcu.ie.md)
- [Switch Setup](procedures/switch)
- [Gratuitous ARP](procedures/gratuitousarp) (or, how to force update an IP
  address's associated MAC on the router and other machines)
- [JunOS Configuration](network/junos)

#### WWW

- [Redbrick SSL certs](web/ssl)
- [Webchat (qwebirc)](web/webchat)

#### Backups

- [BackupPC](services/backuppc)
- [Moving severus to CSD](procedures/severuscolocation)

---

## Emergencies

After each emergency remember to write a postmortem!

- [What to do immediately after a power cut](procedures/post_powercut)

---

## Machines

### Services

#### Daedalus + Icarus - LDAP + Distributed storage

- [LDAP](services/ldap)
- NFS, (a.k.a /storage) from Icarus

#### Paphos - Primary Services

- [DNS](services/bind9)
- [IceCast](services/icecast2)

#### Zeus - Secondary Services

- [Techweek](web/techweek)

#### Hardcase - Web Applications

- [Web Server](web/apache)
- [Mail docs index](mail)
- [Website](web/website)

#### halfpint - Admin Bastion

- [DRAC Access](procedures/dracaccess)
- [Password Safe](procedures/pwsafe)

### User Login

#### Azazel - Primary User Login

#### Pygmalion - User Development

- [DRAC Access](procedures/dracaccess)

## Security

- [Rootholder public keys](procedures/gpgkeys)

## Hardware

### Switches

- [Cisco IOS](network/ciscoios)
- [Hadron](network/hadron)
- [JunOS](network/junos)
- [Higgs](network/higgs)

### UPS

- [The PDUs](hardware/the_pdus)

### Other

- [Dell IP-KVM](hardware/ipkvm)

## Software

Software written by RedBrick, or with RedBrick customisations etc.

- [Backported Packages](procedures/backport-packages)
- [Hey (and huh)](services/hey)
- [Rbusers](procedures/rbusers)
- [Chfn & Chsh for ldap](procedures/ldapchshchfn)
- [Small scripts](procedures/rbscripts)
- [RedBrick MOTD setup](services/unifiedmotd)
- [Icecast Streaming Service for DCUFM](services/icecast2)

---

## System Documentation Redundancy

### Github

Github is where docs are stored. They are plain markdown but they are easily
accessed and read from anywhere.

### ReadTheDocs

Docs are auto deployed to [readthedocs](https://readthedocs.io) on commit to the
`master` branch. They should always be up to date. They are available at
[docs.redbrick.dcu.ie](https://docs.redbrick.dcu.ie) and
[redbrick.rtfd.io](https://redbrick.rtfd.io)
