# REDBRICK SYSTEM ADMINISTRATOR POLICIES

{{:devotion_to_duty.png|}}

## Introduction

The purpose of this document is to brief new Redbrick system administrators on
the current setup, policies and practices in place and to serve as the place
to record all such information for current and future administrators.

## Admin Account Priviliges

By default, all admin accounts will be placed in the root group for su access
and the log group for read access to system logs. Accounts should not be
placed into any other 'system' or priviliged accounts (e.g. pgsql, mail, news,
etc.) but by all accounts (hah, bad pun!) can be placed into useful groups
(e.g. cvs, webgroup, helpdesk etc.)


## Root account

When su'ing to root, please observe the following:


*  Wait for the password prompt before typing in the password! Sometimes lag/terminal freezes or whatever can kick in. The other classic mistake is typing the password in place of the username (say for a console login).

*  Make sure LOGNAME is set to your unix name. The linux/solaris boxes will prompt you for this (on solaris use 'su -', on linux don't ever use 'su -'). On OpenBSD you can use 'su -m' to keep the environment.

*  Don't change the root account/finger information!

*  If you wish to use another shell, place customisations in your own file. For bash, /root/.bash_profile.`<USERNAME>` and for zsh /root/.zshrc.`<USERNAME>`. As for tcsh, no one uses that! :-)

/root/.zshrc and /root/.bash_profile source in the appropriate file as long as $LOGNAME is set right (see above). Do not put personal customisations into the default root account setup, remember other people have to use it.

Common aliases can be put in /root/.profile, familiarise yourself with the existing ones, they can come in handy.


*  Please keep /root tidy. In fact, important admin stuff should be done/kept in /srv/admin, that's what it's there for. Don't leave stuff strewn about the place! Make sure to check permissions and ownership on files you work on **constantly** especially files with important or sensitive information in them (e.g. always use "cp -p" when copying stuff about).

*  Only use root account when absolutely necessary. Many admin tasks can be done or tested first as a regular user.


## Gotchas

Couple of things to look out for:


*  killall command, never ever use it!

*  Solaris commands which share same name as Linux/BSD commands can often be radically different. Always check manpages.

*  Alias cp, mv & rm with the '-i' option.

*  If you're ever unsure, don't! Ask another admin or check the docs.

*  Always always double check commands before firing them off!

*  When using chown or chgrp, always supply '-h' option as by default Solaris chown/chgrp will change the ownership of the file a symlink POINTS TO - NOT the symlink itself!

## Admin mailing lists


*  All accounts in the root group must be on the admin mailing list and vice versa. Admins who leave/join the root group must be added/removed from the list respectively.

*  Admins should also join the admin-discuss list. This is the ideal list to discuss admin issues where a more open discussion or a wider input is needed. Admin-discuss should be used in preference of rb-admins for discussion, unless there is a good reason.

*  Elected admins should also be on the elected-admins list. This address is mainly used for mail to paypal and stuff.

*  There is also a [redbrick-fallout](http://groups.google.ie/group/redbrick-fallout) list on google which admins should join, for like when shit happens :) 

## Admin Account Responsibilities

As an adminisitrator, your normal user account has extra priviliges (namely being in the root group). For this reason, you should not run *any* untrusted or unknown programs or scripts. If you must, and source code is available you should check it before running it. Compile your own versions of other user's programs you use regularly. It is far too easy for other users to trojan your account in this manner and get root.

Do not use passwordless ssh keys on any of your accounts. When using an untrusted workstation (i.e. just about any PC in DCU!) always check for keyloggers running on the local machine and never use any non system or non personal copies of PuTTY/ssh - there's no way of knowing if they have been trojaned.

## General Responsibilities

Look after and regularly monitor all systems, network, hardware and user requests (ones that fall outside of helpdesk's realm, of course!).

Actively ensure system and network security. We can't police all user accounts and activities, but basic system security is paramount! Keep uptodate with bugtraq/securityfocus etc. Check system logs regularly, process listings, network connections, disk usage, etc.

RCS is used extensively throughout the system for all configuration files and documentation. The RCS commands you'll use most are probably co -l (checkout) and ci -u (check in). Don't forget to check out **before** editing the file.

## Downtime


All downtime must be scheduled and notified to the members well in advance by means of motd & .announce. If it's really important, a mail to redbrick-announce may be necessary.

All unexpected/unscheduled downtime (as a result of a crash or as an emergency precaution) must be explained to the members as soon as possible after the system is brought back. A post to .announce, notice in motd and possibly a mail to committee/admins is sufficient.

When performing a shutdown, start the shutdown 5 or 10 minutes in advance of the scheduled shutdown time to give people a chance to logout. It may also be useful to disable logins at this stage with a quick explanation in /etc/nologin.

## Documentation

Please read all the documentation before you do anything, but remember that the docs aren't complete and are sometimes out of date. Please update them as you go :D


## Past Incidents

Read up on past incidents (in the encyclopedia) namely:


*  Avocado

*  Fuckups, Inevitable Admin  :)

*  Julie Incident, The

*  Plop Incident, The

*  Pumpkin Incident, The

*  Spike



