# Murphy general setup info

## Paths on Murphy

Before you read anything else about Murphy, I need to get this out of the way.

**STOP PUTTING THE NATIVE SOLARIS UTILITIES BEHIND THE GNU AND BSD ONES IN THE
DEFAULT PATH VARIABLE!! IT KEEPS BLOODY BREAKING THINGS!**

I may physically harm the next person who goes and does this. You've been
warned.

{{ :rtfm.png|Read The Fucking Manual (Go to xkcd.com for more vital tips)}}

## Hardware setup

* Sun Fire T2000
* ALOM management card
* 16GB RAM
* 2x73GB 15K SAS disks
* Quad gigabit ethernet
* Solaris 10

## Installation
Read up the [jumpstart](/legacy/procedures/murphy-jumpstart) notes for more
about this.

## Packages
Packages on murphy fall into three broad categories:

* Sun packaged stuff, from Sun. We use pca to manage updates to these.
* [Blastwave](http://www.blastwave.org/) packaged stuff. This place is good for
	userland utilities mostly. It comes with a program called `pkgutil` to manage
	itself. Blastwave stuff is in `/opt/csw`
* [Redbrick Packages](/legacy/procedures/redbrick_solaris_package_manager)

## Exim
This is installed from blastwave, and managed by solaris `svcadm`.

```
[root@murphy ~]# ls /etc/exim    
lrwxrwxrwx   1 root     root          17 Jan  4 05:32 /etc/exim -> /opt/csw/etc/exim
[root@murphy ~]# ls /var/log/exim
lrwxrwxrwx   1 root     root          21 Jan  4 05:43 /var/log/exim -> /opt/csw/var/log/exim
```

All of the exim stuff is in `/opt/csw`, those symlinks are there for
convienience. The installed version is over a year old, but there's no major
fixes since then.

## Logwatch
This is also installed from blastwave. All the stuff for this is dumped into
`/opt/csw/etc/log.d`. It doesn't come with the nice split structure like on
debian where we can put our own additions into `/etc/`, so all our
customisations are in `/local/logwatch`. Any files here are symlinked into their
appropiate locations in `/opt/csw/etc/log.d`

```
[root@murphy ~]# ls /etc/logwatch
lrwxrwxrwx   1 root     root          15 Jan  7 09:13 /etc/logwatch -> /local/logwatch
```

This is here for convienience.

## syslog
We're using the standard solaris syslog, but it's configured to log to more
debian like locations, and do remote logging to sprout.

```
[root@murphy ~]# cat /etc/syslog.conf
#  /etc/syslog.conf     Configuration file for syslogd.
#
#  This syslog.conf was hacked together from the shiny debian defaults
#  on carbon, cause the solaris one was a pile of shite.
#

#
# First some standard logfiles.  Log by facility.
#

auth.info                               /var/log/auth.log

*.info                                  /var/log/syslog
daemon.info                             /var/log/daemon.log
kern.info                               /var/log/kern.log
lpr.info                                /var/log/lpr.log
mail.info                               /var/log/mail.log
user.info                               /var/log/user.log

# cron seems to log to /var/cron/log rather than syslog, so
# /var/log/cron.log should be a symlink to that.
# cron.info                             /var/log/cron.log

#
# Some `catch-all' logfiles.
#

*.debug;news.none;mail.none;auth.none                                   /var/log/debug
*.info;*.notice;*;warn;auth;cron,daemon.none;mail,news.none             /var/log/messages

#
# Emergencies are sent to everybody logged in.
#

*.emerg                         *

#
# Remote logging
# Send everything except auth.debug to sprout
#

*.debug;auth.info                       @log.internal
```

Taking that `syslog.conf` from carbon really only gave me a template to start
from, the syntax is subtly different enough that I had to change pretty much
every line. I wouldn't suggest touching this setup unless you *really* have to.

## NFS Server
Like everything else, murphy has an nfs server for backups.

```
[root@murphy ~]# cat /etc/dfs/dfstab

#       /etc/dfs/dfstab
#
#       Place share(1M) commands here for automatic execution on entering init state 3.
#
#       The syntax of this file is wildly different to linux/bsd. Man share_nfs before
#       making any changes here. It also doesn't like ip addresses, you should use host
#       names here, and enter them in /etc/hosts

share -F nfs    -o ro=severus.internal,root=severus.internal            /
share -F nfs    -o ro=severus.internal,root=severus.internal            /var


[root@murphy ~]# ls -l /etc/exports
lrwxrwxrwx   1 root     root          10 Jan 17 00:55 /etc/exports -> dfs/dfstab
```

It keeps all it's export information in `/etc/dfs/dfstab`. I've symlinked it to
`/etc/exports` so that the next person to look for the exports file won't waste
10 minutes ;)

## TODO
* fail2ban, or something similar
