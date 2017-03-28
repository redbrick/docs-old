# Dirvish on RedBrick
As of August 2008 all redbrick backups are done using dirvish. Backups are
incremental, and stored for a length of time according to the expiration policy.

## Expiration Policy
The expiration policy is as follows:

* If it's the first day of the month, keep for one year
* Else, if it's the first day of the week, keep for one month
* Else, keep it for one week.

Expire policies can also be set on a per vault basis. The slapcat vault which
contains a daily ldif is set to be kept for longer. Partly because I thought
it'd be something you might want from 5 years ago, and partly because I wanted
to test it.

## What is backed up?

*  Everything

## Packaging Policy

The packaging system for backups is designed to keep the backup servers running
the same scripts/configs. It also enables the rapid redeployment of new backup
servers, moving forward to synergise our collaborative efforts year on year. As
of August 2009 the system is packaged on all backup servers.

# The dummy's guide
The dirvish setup is relatively complex, so I'll attempt to explain some basic
steps without going through too much detail.

### Removing backup jobs
This is controlled by `/etc/dirvish/daily.conf`. Simply comment out the line in
the "Runall" section, and that job won't be ran.

### Adding new jobs

#### Change the package

* Create a new directory, `debian/backup/$name`
* Create `debian/backup/$name/dirvish/`
* Create the `mountpoint`, usually `debian/machines/$servername`
* Copy a default.conf from one of the other backup locations, and put it in
	`debian/backup/$name/dirvish/`
* In the default.conf change the source location to what you want to backup.
* Build the package, as per the [package instructions](/procedures/redbrick-apt)

#### On the servers

* Upgrade to the new package
* Add an entry for the server in `/etc/fstab` (described below)
* Run `dirvish --vault $name --init`
* Add the name to the Runall section in `/etc/dirvish/daily.conf`

### Re-Install
All of the configuration data & scripts for dirvish is now in packages. If you
need to reinstall a machine, then you'll need to do the following:

* Install [redbrick-backup-server](/procedures/redbrick-apt)
* Init all of the vaults, as described above (this has to be done manually the
	first time for the cron job to run). This step takes fucking ages on severus
	because its RAID is a pile of soggy dicks.
* Re-sync the mysql slave, as per the [instructions](/services/mysql)
* Switch logwatch to run from /etc/cron.daily rather than /etc/cron.d so that it runs after dirvish

### Mounting Filesystems
Dirvish will mount whatever filesystems it thinks it needs for a particular
backup. It greps the source destination of your backup from /etc/fstab, and
mounts whatever is found.

This means you shouldn't need (or ever ever consider) having nfs dirs mounted
by default. They should all be left unmounted, and specified in /etc/fstab with
noauto.

```
# /etc/fstab: static file system information.
#
# Note, for the linux boxes the root export is specified with crossmnt, so other
# mounts within the root are accessible, usually /usr etc.
#
# For the bsd boxes where this is not an option each mount must be specified individually
# Scripts will assume the root mount is specified first in this file.
#
# All the nfs mounts should be set to noauto, dirvish will automatically mount and unmount
# nfs directories as it requires them, and backups should cancel if the dir can not be mounted.
```

### Take a break
If you want to work on the server or something you might want to run less
dirvish stuff for a day.

```
touch /backup/dirvish/.noexpire
```

and the expire job won't run the next time. It'll delete the file and run the
following day though.

This means that dirvish should finish up by about 9am on severus, or 3pm on
thunder, and you can do stuff without the disk i/o being shite.

You should be able to stop expire for one day without anything going crazy.
Stopping it for any longer than this will cause the expired images to backup,
and when the job eventually runs it'll take more than 24 hours. The system can
handle this, it won't run multiple dirvish jobs at the same time (that would
cause disk i/o meltdown). If dirvish will try to start every 15 minutes for
3 hours, and then just give up till the next day. When this happens the logwatch
mails could be out of sync etc, but nothing will asplode.

### The patch
The version of dirvish that comes with 8.04 is fatally flawed. As you should
probably know by now, dirvish is an ugly perl wrapper for rsync. Rync operates
by building a list of files to copy, and then copying them. Given that it takes
6 hours to backup /storage files will disappear. This will cause rsync to return
an error 24 "some files vanished". Dirvish will then think that the run has been
a failure.

The comment in /usr/sbin/dirvish that this code is only marked as a warning,
and not an error would lead you to believe that they've fixed the problem...
well they haven't.

This patch is in the [redbrick-dirvish package](/procedures/redbrick-apt). The last stable
release of dirvish was May 19th 2005, so I wouldn't be expecting a new release
anytime soon.

```
for ($runloops = 0; $runloops < 5; ++$runloops)
{
    logappend($log_file, sprintf("\n%s: %s\n", 'ACTION', join(' ', @cmd)));
            # create error file and connect rsync STDERR to it.
            # preallocate 64KB so there will be space if rsync
            # fills the filesystem.
    open (INHOLD, "<&STDIN");
    open (ERRHOLD, ">&STDERR");
    open (STDERR, ">$err_temp");
    print STDERR "         \n" x 6553;
    seek STDERR, 0, 0;
    open (OUTHOLD, ">&STDOUT");
    open (STDOUT, ">$log_temp");
    $status{code} = (system(@cmd) >> 8) & 255;
    #patch added by receive on sept 25th.
    $status{code} = 0 if ($status{code} == 24);
```

Note: this is actually telling dirvish to lie about the response code. Someone
who understands perl may wish to try find a more elegant solution.

# But I want to know more :(
Ok, fine. But I'm only talking about the specifics of our setup. Use the google
or read the [dirvish tutorial](dirvish_tutorial).

Note: the config files & scripts are here for discussion. They may not be
exactly the same as those currently in production.

### Back to that master.conf
Here's the master.conf, with comments thrown around.

```
#
# Redbrick dirvish conf
#
# This file is managed by the RedBrick-dirvish package.
# Changes made here will not be preserved as this file
# represents the global RedBrick backup configuration
#
# Local details, such as which vaults are currently
# enabled should be set in daily.conf
#
```

The master.conf contains options that should always be set globally, so for this
reason it's not marked as a conffile, and will be overwritten by package
upgrades.

```
# where all the backups are stored
bank:
        /backup
```

Dirvish uses a madly complicated system of branches, vaults, banks and god only
knows what else to describe itself, but you know all this, since you just read
the docs on google...

Anyway, the bank is the place we keep all the backups. This will probably always
be /backup

```
#
# List of directories to exclude globally. We try to
# catch large directories we don't need here. This
# can be further refined at a per vault level.
#

exclude:
        lost+found/
        /var/log/
        /var/tmp/
        /var/run/
        /var/lock/
        /var/lib/mysql/
        /var/lib/ldap/
        /var/lib/postgresql/8.3/main/
        /backup/
        /adminporn/
        /webmasterporn/
        /srv/
        /sys/
        /fast-storage/
        /storage/
        /mnt/
        /media/
        /machines/
        /dev/
        /proc/
        /tmp/
        /vmlinuz*
        /initrd*
        /bin/
        /sbin/
        /usr/bin/
        /usr/sbin/
        /usr/src/
        /usr/include/
        /usr/share/
        /usr/games/
        /usr/lib/
        /usr/X11R6/
        /lib/
        /lib32/
        /lib64/
        /home/docs
```

These are a list of files/directories to be ignored. These paths are relative to
the source directory. This isn't really documented in anything on dirvish. If
you need to know more about this find some docs on rsync.

```
#
# Expire Rules: We keep the first of the week for one month,
# and the first of the month for one year. Else, we keep it
# for just 7 days.
#

expire-default: +7 days

expire-rule:
#       MIN HR    DOM MON       DOW  STRFTIME_FMT

        *   *     *   *         1    +1 months
        *   *     1   *         *    +1 year
```

These rules specify how long we keep the data for, which I told you about at the
start. With these rules we shouldn't be running out of disk space anytime soon.
If we are, and that's why you're reading this then change them.

    whole-file: 1

This is an option that gets passed straight to rsync, about how it copies the
file. This should be slightly better at disk i/o at the expense of network
bandwidth (which, we have fucking loads of).

```
# permissions for logs, etc.
meta-perm: 600
```

Set these to 600, so people can't read them. Realistically, you won't want to
read them anyway, since logwatch sends you the important stuff.

```
pre-server: ; /usr/bin/dirvish-prebackup $DIRVISH_DEST $DIRVISH_SRC
post-server: ; /usr/bin/dirvish-postbackup $DIRVISH_DEST $DIRVISH_SRC
```

Dirvish supports executing scripts on the client and server both before and
after each vault executes. We don't really care about client stuff, cause we
don't have client really.

Note: The semi-colon there is important, I can't remember exactly why, but it
doesn't work without it.

The `$DIRVISH_DEST` is, what it sounds like, the directory that is being copied
to. It gets passed as the first argument to the script (note, I don't actually
want the damn destination folder, i just wanted the name, but it didn't have
that option)

`$DIRVISH_SRC` is also what it sounds like :) It's used to actually mount the
thing, so it's fairly important.

### daily.conf

```
#
# Vaults listed here will be backed up daily.
#
# This file is provided by redbrick-dirvish, but local changes
# will be preserved as this file should be made here for
# valuts currently setup on this machine.
#

Runall:
#       storage         00:00
#       fast-storage    00:00
        slapcat         00:00
        carbon          00:00
        cynic           00:00
        deathray        00:00
#       minerva         00:00
#       sprout          00:00
#       murphy          00:00
#       morpheus        00:00
#       lightning       00:00
#       ceilingcat      00:00
        mysql           00:00
#       severus         00:00
#       coke            00:00
#       thunder         00:00
        localhost       00:00
```

This file lists all the vaults currently setup to run daily on the system. It
can be edited as vaults are setup and changes made here will be preserved.

The sequence is important - backups are ran in the order they're listed in this
file.

### What about that default.conf
Each of your vaults has it's own default.conf, in the dirvish directory. This
has similar options to master.conf, you can add to or override the master
options here.

```
client: severus
```

Since we use nfs, the client will always be the local hostname. In the package,
clients should be specified as CLIENT, and the postinst script will
automatically replace this with the actual machine hostname.

```
tree: /machines/carbon
```

This is the directory we want to backup

```
xdev: 0
```

This is fairly important. If true it won't leave the filesystem the backup
directory is located on. For machines that have lots of partitions mounted
together we need this option off. Imo, if you don't know why you need to do
otherwise, set this one to true.

Note: Only a value of 0 here will be interpreted as false. Anything else will be
true (even the word false). Yes, I know it's madness.

```
index: none
```

Having read this much documentation on dirvish you're now an expert, so you know
all about it's indexing and searching. I disabled it cause I didn't figure it
was much use, and I was trying to make the system as fast as possible.

```
image-default: %Y%m%d
```

This sets the default filename for images, in YYYYMMDD format. This will usually
be fine. You can put times and shit in there, but I wasn't bothered.

Note: Scripts may rely on being able to guess these directories just based on
the date. Don't change this unless you know what you're doing.

```
image-perm: 700
```

The permissions of the directory containing the new backup when the run is
completed. For stuff like storage where users have files this should be 755,
otherwise use 700.

### dirvish-prebackup
This script runs before each vault is backed up.

* $1 is the DIRVISH_DEST mentioned earlier. It'll look something like
	`/backup/storage/20090101/tree`
* $2 is the DIRVISH_SRC. It'll look more like /storage

We probably don't need both of these, but I was too lazy to change the script.

```
#!/bin/bash
#
# If this is a mysql backup, then try run the mysql backups, then stop mysql
#
mysqltest=`echo $1 | grep -c mysql`
if [ $mysqltest -ne 0 ]; then
    /usr/bin/dirvish-mysqldump &> /backup/dirvish/mysqlb-`date +%Y%m%d`.log
    /etc/init.d/mysql stop
fi
```

The backup boxes are setup as mysql slaves so that this can be copied nightly
by dirvish. The mysqldump script creates db dumps on a per-user level. These
may be useful to people, probably not much use if you need to restore mysql
from backups though. That's why the whole directory is backed up, and mysql
needs to be stopped for this.

```
#
# If this is the slapcat backup, then make an ldif.
# (this ldif will also be in the local backup, but it won't last as long there.)
#
slapcat=$(echo $1|grep -c slapcat)
if [ $slapcat -ne 0 ]; then
    ldapsearch -xLLL -h ldap.internal -y /etc/ldap.secret -D cn=root,ou=ldap,o=redbrick > /var/db/ldap/redbrick.ldif
    chmod 400 /var/db/ldap/redbrick.ldif
fi
```

Fairly obvious, use ldapsearch to dump ldap into a file.

```
severustest=`echo $1 | grep -c thunder`
if [ $severustest -eq 0 ]; then
        mountpoints=`cat /etc/fstab | awk '{print $2}' | grep $2`
        for mountpoint in $mountpoints; do

                #see if it's already mounted
                mountstatus=`grep -ic $mountpoint /etc/mtab`

                if [ $mountstatus -gt 0 ]; then
                        #if it's already mounted give an error message, but don't stop the script.
                        echo "Error: $mountpoint is already mounted. I was not expecting this."
                        echo "This directory will be unmounted when i'm done."
                else
                        #else mount the directory
                        mount $mountpoint
                fi
        done
fi
```

Mounts any file systems that match the source directory dirvish is going to try
backup (in the sequence their specified in /etc/fstab).

If the file system is already mounted then this will fail.

```
# exit with the return code of the mount commands
# we want the backup to drop out if the directory doesn't mount
#
exit
```

As per comments it exits with the return code of the last command. This means
that if the mount fails the vault will not run (if this script doesn't exit with
0 dirvish will exit).

### dirvish-postbackup
This script is ran after each vault is backed up. It has the same parameters as
preserver.

```
#!/bin/bash
#
# If this is mysql then restart mysql
#
mysqltest=`echo $1 | grep -c mysql`
if [ $mysqltest -ne 0 ]; then
    /etc/init.d/mysql start
fi
```

Pre_server stops the mysql server for the mysql vault so that a clean copy of
`/var/lib/mysql` can be taken. It needs to be re-started here.

```
#
# unmount any file systems
# unless of course it's /
# unmounting that would be bad.
#


hostname=`hostname`
severustest=`echo $1 | grep -c $hostname`
if [ $severustest -eq 0 ]; then
        # mounts may be within mounts, we use the reverse sort
        # to unmount the deepest mount first
        mountpoints=`cat /etc/fstab | awk '{print $2}' | grep $2 | sort -r`
        for mountpoint in $mountpoints; do
                umount -fl $mountpoint
        done
fi
```

This is similar to the mount in pre_server. The main differences are that it
unmounts instead of mounts (obviously), and that it reverses the order.

```
#
# setup the symlinks
#
if [ -d $1 ]; then
    cd $1
    #we're now in /backup/vault/date/tree
    cd ..
    #we're now in /backup/vault/date
    logdir=`pwd`
    cd ..
    #we're now in /backup/vault
    if [ -h current ]; then
            rm ./current
    fi
    if [ -h current_log ]; then
            rm ./current_log
    fi
    ln -s $1 current
    ln -s $logdir/summary current_log
fi
```

This (admittedly lazy) code sets up two symlinks

* `/backup/$vault/current` -> `/backup/$vault/$date/tree`
* `/backup/$vault/current_log` -> `/backup/$vault/$date/summary`

The current symlink is used so that the most recent complete successful backup
can always be located by any other scripts that may be ran (or, just for users).

The current_log symlink is for logwatch. It finds all the current_logs,
processes them, and then removes the symlink so that they won't be reported
again.

```
#
# If this is sprout then update docs2.rb
#
docstest=`echo $1 | grep -c sprout`
if [ $docstest -ne 0 ]; then
        if [ -f /usr/bin/dirvish-docscopy ]; then
                /usr/bin/dirvish-docscopy &> /backup/dirvish/rbdocs-`date +%Y%m%d`.log
        fi
fi


  exit 0
```

*Edit(voy): `exit 0` might be tabbed in wrong.. Original documentation had it
off.*

This script always exits with a 0 return code.

### /etc/cron.daily/00dirvish

```
#! /bin/bash  
fatallog=/backup/dirvish/omgwtf-`date +%Y%m%d`.log
```

This logfile will be used to record failures to start the job.

```
retrycount=12   
# this is three hours
```

The retrycount is how many times we should attempt to start `dirvish-runall`
before giving up.

```
while [ "$retrycount" -gt 0 ]; do
    alreadyrunning=`ps -A| egrep -w '(dirvish|dirvish-runall|dirvish-expire)'|wc -l`
    if [ "$alreadyrunning" -gt 0 ]; then
            date=`date`
            echo "$date Found instance of dirvish running. Will retry in 15 minutes." >> $fatallog
            sleep 900
    else
            #end teh loops
            let retrycount=0
    fi
    let retrycount-=1
done
```

Some quick and dirty testing. We *really* don't want to start dirvish if another
dirvish job is running. It'll keep waiting 15 minutes until the retrycount is 0.
That's 3 hours. After 3 hours I figure it's best to give up till tomorrow.

```
alreadyrunning=`ps -A| egrep -w '(dirvish|dirvish-runall|dirvish-expire)'|wc -l`
if [ "$alreadyrunning" -gt 0 ]; then
    date=`date`
    echo "$date Dirvish is still running. Exiting Now." >> $fatallog
    exit 1
fi
```

```
/usr/sbin/dirvish-runall --quiet &> /backup/dirvish/runall-`date +%Y%m%d`.log
```

Run dirvish-runall, which will run dirvish for each vault in the master.conf in
sequence. All the output is caught in a logfile for logwatch. If there's no errors
this log will be blank.

```
exit 0
```

### /etc/cron.daily/ZZdirvish-expire
Usually the one script would call runall and expire, however in our case that
could mean we mightn't see logwatch until long after the backups had been made,
so it gets ran last. The logs for this get reported the next day.

```
#!/bin/bash
#
# This script should be linked to /etc/cron.daily/ZZZdirvish
# as it needs to run last
#
expirelog=/backup/dirvish/expire-`date +%Y%m%d`.log
fatallog=/backup/dirvish/omgwtf-`date +%Y%m%d`.log

if [ -f /backup/dirvish/.noexpire ]; then
    echo "Found .noexpire. Dirvish-expire cancelled." > $expirelog
    rm /backup/dirvish/.noexpire
    exit 0
fi

I put this in so that you could set expire not to run for a day. This might be useful if you want to work on something.

alreadyrunning=`ps -A| egrep -w '(dirvish|dirvish-runall|dirvish-expire)'|wc -l`
if [ "$alreadyrunning" -gt 0 ]; then
    sleep 900
    date=`date`
    echo "$date Found instance of dirvish running. Will retry in 15 minutes." >> $fatallog
fi
alreadyrunning=`ps -A| egrep -w '(dirvish|dirvish-runall|dirvish-expire)'|wc -l`
if [ "$alreadyrunning" -gt 0 ]; then
    date=`date`
    echo "$date Dirvish is still running. Exiting Now." >> $fatallog
    exit 1
fi
```

This is like in the cron.sh, testing for already running dirvish before
starting. It doesn't bother with retries because if it fails something is
probably going wrong and it'd be best just to leave it.

```
/usr/sbin/dirvish-expire >> $expirelog 2>&1
echo
echo Expire completed at `date` >> $expirelog
```

### How all this fits together
I got bored of writing, so I drew a picture :)
{{:dirvish:dirvish.png}}

# Other scripts

### dirvish-docscopy
This gets called by dirvish-postbackup if the vault is sprout.

```
#!/bin/bash

#

# Copy from the latest backup to sync docs2.rb with docs.rb
# Make the whole thing read only, and mark that on the frontpage

#

# Copy the dokuwiki from current backup to local

cp -pruv /backup/sprout/current/var/www/htdocs/docs /var/www
chown -R www-data:root /var/www/docs

# Replace the template file with the read-only message

cp -a /usr/share/redbrick-docs2/main.php /var/www/docs/lib/tpl/default
```

This template file has the pink message box at the top with the read only
message, so it needs to be copied in every time.

```
# Make all the text pages read-only by www
chown root:root /var/www/docs/data/pages/*.txt
chmod 644 /var/www/docs/data/pages/*.txt
```

This is so changes can't be made to the this copy, cause they'll be lost.
dokuwiki seems to handle this hack nicely.

### dirvish-mysqldump

```
#!/bin/bash

if [ ! -f /etc/mysql/backup.conf ]; then
        echo "WARNING: The file /etc/mysql/backup.conf file is missing."
        echo "This file is provided by redbrick-mysqlslave and is"
        echo "required in order for the backup system to operate normally"
        exit 1
fi

PASSWORD=`grep -i password /etc/mysql/backup.conf | awk '{print $2}'`
USER=`grep -i user /etc/mysql/backup.conf | awk '{print $2}'`
auth="-u $USER -p$PASSWORD"
```

The backup user needs to be setup as per the [mysql](/services/mysql) docs to have access
and a password for this.

```
databases=`find /var/lib/mysql/ -maxdepth 1 -type d -printf "%P \n"`
umask 066
mysql="mysqldump --create-options --force --lock-all-tables --skip-comments "
```

Not sure why I picked all those options to mysqldump, was ages ago.

```
for database in $databases; do
    if [ $database != "dumps" ]; then
            $mysql $database $auth > /var/lib/mysql/dumps/$database.sql
    fi
done
```

Since the dumps directory is inside /var/lib/mysql it'll get caught in that find
command to list all the databases, so we make sure we're not trying to take a
dump of it.

### Logwatch Mysql Script

```
#!/bin/bash

if [ ! -f /etc/mysql/backup.conf ]; then
        echo "WARNING: The file /etc/mysql/backup.conf file is missing."
        echo "This file is provided by redbrick-mysqlslave and is"
        echo "required in order for the backup system to operate normally"
        exit 1
fi

PASSWORD=`grep -iw password: /etc/mysql/backup.conf | awk '{print $2}'`
USER=`grep -iw user: /etc/mysql/backup.conf | awk '{print $2}'`
auth="-u $USER -p$PASSWORD"
```

```
mysql $auth < /backup/dirvish/mysql/status.sql | egrep -v '(Master_SSL|Master_Port|Master_User|Replicate)'
```

The .sql file just contains "show slave status\G". We egrep out some of the
useless output so it's a bit easier to read. The really important stuff here is
to see that's it not fallen behind the master, and that we see the error
blocking it(if any).

If this continues to fail for a longer period of time than the master server is
keeping logs (usually only a few days) you'll basically be setting it up from
scratch, which will be a fucking pain.

```
/etc/init.d/mysql status | egrep '(Uptime|Threads)'
```

Can't remember why I wanted this stuff in here, guess I had a reason though.

### Dirvish Logwatch Script

```
#!/bin/bash

#
# Script to cat logs of the last dirvish run to logwatch
#


backupdirs=`find /backup -mindepth 1 -maxdepth 1 -type d | grep -v "lost+found"`

for backupdir in $backupdirs; do

        logfile=$backupdir/current_log
```

Find all the /backup/$vault/current_log, and print them in a nice readable format. Delete the symlink after so they're not printed again.

```
        if [ -f $logfile ]; then
                echo
                vaultname=`grep vault $logfile|awk '{print $2}'`
                echo "===============[ $vaultname ]================"
                if [ `grep -c "Status: success" $logfile` -eq "0" ]
                then
                        echo "** WARNING: Backup not successful"
                        echo
                        # If there was a failure then we want to see more log
                        egrep -v '(^\s|^exclude)' $logfile
```

If the logfile doesn't report success then show a warning, and print more detail.

```
                fi
                egrep '(Backup-begin:|Backup-complete:|Status:)' $logfile
                echo
                #delete the symlink to the file, so that it won't be reported again
                #the original will remain in /backup/vault/date/summary
                rm $logfile
        else
                # If no backup last night, then warn.
                # Also, try to guess the last night a backup occurred.
                # (yes, it's crude.)
                cd $backupdir
                echo "===============[ `pwd|awk -F/ '{print $3}'` ]================"
                echo "** WARNING: This vault not backed up!"
                last=`(ls -dt [0-9]* 2>/dev/null)|head -1`
                if [ "z$last" = "z" ]; then
                        last="NEVER"
                fi
                echo "             (last backup: $last)"

        fi
done
```

If there's no log for today, then warn.

```
cronfiles=`find /backup/dirvish/ -type f -name "*.log*"`

for cronlog in $cronfiles; do

        if [ -f $cronlog ]; then
                if [ -s $cronlog ]; then
                        echo
                        echo "===============[ ${cronlog:(-19)} ]================"
                        cat $cronlog
                        echo
                fi
                rm $cronlog
        fi
done
```

This gets all the .log files from /backup/dirvish. This is usually runall,
expire and omgwtf. The substring thing is a bit hacky, and assumes that you have
a log file in the format ABCDEF-YYYYMMDD.log. If you don't nothing should break,
it just won't look as pretty.

Once the logs get printed with logwatch they're deleted. Empty logs don't get
printed. (runall is usually empty).

# Performance Tweaks

## Rsync3
Version 3 of rsync introduced a new feature whereby it could begin copying
before it had completed building the file list. This makes our backup times much
better. Rsync 3 is in hardy-backports, and the repo should be enabled and pinned
for it.


```
#/etc/apt/preferences  
Package: rsync
Pin: release a=hardy-backports
Pin-Priority: 800

Package: *
Pin: release a=hardy-backports
Pin-Priority: 400
```

## OBSD Servers
The read performance with linux clients on v3 is [fucking terrible](http://wtf.hijacked.us/wiki/index.php/OpenBSD_NFS_Server_with_Linux_Clients).
Like, seriously terrible. Force these to use v2 in `/etc/fstab`

```
192.168.0.17:/                  /machines/puffy nfs noauto,nosuid,nodev,soft,intr,ro,noquota,vers=2   0  2
```
