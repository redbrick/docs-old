# Redbrick Apt

The aim of this is to make setting up machines and pushing out updates easier. May also facilitate other people using our packages if anyone actually wanted to. It runs as the rbpkg user, from it's home directory.

I followed [ this tutorial](http://www.debian-administration.org/article/Setting_up_your_own_APT_repository_with_upload_support) to set it up. Well, kinda. Ours doesn't do automated importing or anything like that. [This manual](http://alioth.debian.org/scm/viewvc.php/*checkout*/mirrorer/docs/manual.html?revision=HEAD&root=mirrorer) is about the best thing I've found on reprepro.


## Adding Packages

The passphrase for the gpg key to sign the release is needed whenever it is updated. This is in pwsafe.

### Easy Way


	su rbpkg
	add_package /path/to/package.deb


The add_package script is in ~rbpkg/bin. The script will ensure that the right arguments are passed to reprepro, and that the permissions are correct afterwards.


### Package Checks

The scripts to add packages will use lintian(1) to check the packages. If an error is found then you'll have to confirm that you want the import to continue. Some errors will be unavoidable, but, try keep them to a minimum.

### Hard Way


	su rbpkg
	cd ~/public_html/apt
	reprepro --ask-passphrase -C main -Vb . includedeb stable /path/to/package.deb



This will break permissions on the files :(


	chmod 755 `find /webtree/r/rbpkg/apt/dists/ -type d`
	chmod 644 `find /webtree/r/rbpkg/apt/dists/ -type f`
	chmod 755 `find /webtree/r/rbpkg/apt/pool/ -type d`
	chmod 644 `find /webtree/r/rbpkg/apt/pool/ -type f`


The add_packages script should be used in preference of adding packages manually.

## Building Packages

http://www.tldp.org/HOWTO/Debian-Binary-Package-Building-HOWTO/ was the simplest guide I could find.
Most were setup for building big things, which doesn't really apply to us. Most things also focused on building source packages first, which doesn't really apply either.

### Dummy's Guide to Building New Packages


*  cp -ar the template directory in ~rbpkg/packages

*  add in scripts, manpages etc. Remove the placeholder content

*  edit debian/DEBIAN/control so that it matches the new package

*  `set_changelog `

*  `build`

### Dummy's Guide to Updating Packages


*  make changes

*  update debian/DEBIAN/control

*  `set_changelog `

*  `build`

### Notes


*  Things which are compressed should generally use 'gzip --best'. Not doing this makes lintian complain.

## Sources.list


	deb http://packages.redbrick.dcu.ie/ stable main


The keyring can be installed with the redbrick-keyring package, or downloaded from http://packages.redbrick.dcu.ie

## Testing Packages

In some cases it might be appropriate to package unstable/testing builds for testing environments. The repo contains two components - redbrick and redbrick-test. Packages add with the 'add_testing' script will go into redbrick-test. Users should consider redbrick-test to be unstable-rawhide-development-testing-which-may-eat-your-babies.


	deb http://packages.redbrick.dcu.ie/ unstable main



# Packages

Note, the meta dependences included below are mostly provided as an example of what a package will provide, and may not be a complete list of the dependencies of the current versions of these packages. Use apt-cache(8) to check the full list of current dependencies for these packages.

## Meta

*  **redbrick-server** -  pulls in things that are needed on all servers, not just login servers: logwatch-apt, logwatch-chkrootkit, redbrick-nagios-nrpe, nfs-kernel-server, openssh-server, syslog-ng, redbrick-root-env, fail2ban, exim4-daemon-light, openntpd|ntp

*  **redbrick-login-server** - this pulls in almost everything in the redbrick repo to create a login.redbrick environment. Also depends on sl, vim, pwsafe, weechat-curses, irssi etc.

*  **redbrick-backup-server** - Depends on redbrick-server, ldap-utils, and all the backup system packages. Conflicts with mlocate, cause this seems to run for ages and use loads of disk space on these machines.

## Userland


*  **[c-hey](/services/hey)**, for both i386 and amd64

*  **[huh](/services/hey)**, for amd64 only. The i386 hey doesn't support huh. This package still requires that you manually configure syslog.ng as per the docs. It also doesn't set up it's group and stuff, this should be changed in the next version of this package. The huh.i386 package is a dummy to satisfy the dependency of redbrick-login-server.

*  **redbrick-news**: news, usenet, newsbeuter

*  **[redbrick-noscripts](/procedures/rbscripts)**: nohelp, noforward, nopermwarn

*  **redbrick-mail**: mdfrm, mdmake, vcard.filter, octet-filter. Creates /usr/local/etc/mailcap, and pulls in all the dependencies for converting attachments.

*  **[redbrick-motd](/services/unifiedmotd)**: update_motd, init script to fix motd on boot, cron script to update nightly and /etc/motd.* files.

*  **[redbrick-help](/procedures/rbscripts)**: the help script, and the message shown on login.

*  **[rbquota](/procedures/rbscripts)**

*  **[rbusers](/procedures/rbusers)**, for both i386 and amd64

*  **[redbrick-local](/procedures/ldapchshchfn)**: Redbrick specific scripts and stuff which need to go in /usr/local/bin to be higher on the path than the system defaults. Note: this package should not "replace" any ubuntu packages. Contains: chsh & chfn for ldap, and the screen wrapper script.

*  **redbrick-shells**: Creates symlinks for /usr/local/shells. Depends on redbrick-shell-env, redbrick-shell-disabled, ksh, tcsh & csh

*  **redbrick-shell-disabled**: Contains the binaries for the expired & disabled shells. This is arch dependant, nothing else should be in here.

*  **redbrick-shell-env**: shell/mutt/slrn/irssi config files. This package contains config files for various things, and as such "Replaces" the config files owned by the original package. This package should only contain config files and should be the only package that "replaces" another for this purpose. The only dependencies of this package should be shells it configures - bash, zsh and packages which /etc/shell_cmd requires to exist - rbquota and redbrick-help. It should "recommend" any other packages which it has config files for.

*  **[peepd-irssi](/services/peepd)**: Irssi scripts to use with peepd.

## System


*  **logwatch-apt**: Apt script for logwatch based on apticron

*  **logwatch-chkrootkit**: Chkrootkit script for logwatch.

*  **redbrick-logwatch**: Depends logwatch-apt, logwatch-chkrootkit. Moves the log mail time to 12.30pm by default, and mails system-reports. Replaces /etc/cron.daily/00logwatch.

*  **redbrick-root-env**: root shell environment.

*  **redbrick-nagios-nrpe**: replaces /etc/nagios/nrpe.cfg with global redbrick version. Depends: nagios-nrpe-server, nagios-plugins.

*  **redbrick-cron-scripts**: Standalone cron scripts. Currently the only script is 'dpkglist', which saves the output of 'dpkg -l' to /var/backups nightly.

*  **[peepd](/services/peepd)**: atlas' twitter irc gateway

*  **mail2nntp** - this is needed on the mailhosts to post mailing lists to boards via aliases.

*  **apt-wtfdidichange** - script to show changes to text files provided by packages.

*  **munin-plugins-redbrick** - Extra plugins for munin. This package was called munin-plugins-extra, but there's a package in lenny/lucid with the same name. Has stuff for mysql, dovecot, slapd etc.

## Backup System

These packages are designed to keep the [backup systems](dirvish) on [thunder](thunder) and [severus](severus) in sync, and also to allow backup servers to be quickly redeployed when necessary.


*  **redbrick-dirvish**: Contains all the configuration for the dirvish system. Also patches /usr/sbin/dirvish to stop it complaining about error 24.

*  **redbrick-backup-dir**: Contains the directories that need to be created for the Redbrick backup system.

*  **redbrick-mysqlslave**: Scripts for making backups of slave mysql servers with dirvish.

*  **redbrick-docs2**: Scripts for mirroring the docs wiki using backups taken by dirvish.

*  **logwatch-dirvish**: Logwatch script to report on backup activity, based on the report script in the development branch of dirvish.

*  **logwatch-mysqlslave**: Logwatch script to report the status of mysql slaves.


## Backport Packages

See the list of packages [backported](/procedures/backport-packages) to hardy from other debian/ubuntu releases.

#  Man Pages

Everything packaged into /usr/(s)bin should have a corresponding manpage. Not everything has man pages yet, but, I'm adding them as things are upgraded.

The name and directory will depend on the category..
 1.  Executable programs or shell commands
 2.  System calls (functions provided by the kernel)
 3.  Library calls (functions within program libraries)
 4.  Special files (usually found in /dev)
 5.  File formats and conventions eg /etc/passwd
 6.  Games
 7.  Miscellaneous (including macro  packages  and  conventions), e.g. man(7), groff(7)
 8.  System administration commands (usually only for root)
 9.  Kernel routines [Non standard]

Generally, RedBrick man pages will be in category 1 or 8.

An example script in category 1 would be located in usr/share/man/man1/example-script.1

This is a sample man page you can edit.


	.TH script-name 8  "August 2009" "version 0.2" "REDBRICK SYSTEM DOCUMENTATION"
	.SH NAME
	script-name \- 1 line description of what I do
	.SH SYNOPSIS
	\fBscript-name\fR arg1 [arg2]
	.SH DESCRIPTION
	This script does stuff
	.PP
	more detail on what the script does
	.SH SEE ALSO
	\fBdirvish\fR(8), \fBdirvish-postbackup\fR(8)
	.SH FURTHER READING
	https://docs.redbrick.dcu.ie
	.SH AUTHOR
	Your Name `<you@redbrick.dcu.ie>`
	.SH PACKAGING
	This script is part of the \fBredbrick-example\fR package. This, and other
	RedBrick packages are maintained by the RedBrick System Administrators
	`<adm1ns@redbrick.dcu.ie>`


Use `nroff -man` to test the formatting is ok. Manpages must be compressed with `gzip ---best`
