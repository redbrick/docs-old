# Guide to RRS for Clubs and Socs Days

Steps required to use a standalone RRS setup and then sync in changes afterwards.

## Before C&S Day

Some general notes on using slapadd and slapcat:

Purge the ldap database files before doing a slapadd. Always add everything in one go with slapadd
as this is faster. Always use the dry-run (-u) option before adding for real.

slapcat should only be run when slapd is r/o or not running. If slapd can't be stopped or made r/o
and a copy of the tree is needed, use this:

```bash
ldapsearch -xLLL -y /etc/ldap.secret -D cn=root,ou=ldap,o=redbrick > rb.ldif
```

Also, it's best to log your session (e.g. with script) when running the various batch commands that
produce a lot of output.

Make master ldap r/o (add "readonly on" to slapd.conf)

Stop slurpd.

Take backup of current tree, now that ldap is r/o.

```bash
slapcat -l slapcat.pre-newyear
```

At the start of each academic year, before c&s day, yearsPaid has to be decremented by 1 and newbie
set to False for every account. This can be done online with LDAP or offline with LDIF. LDIF method
is given here:

```bash
./newyear_ldif.py < slapcat.pre-newyear > slapcat.pre-rrs
```

If using the LDIF method, slapadd slapcat.pre-rrs back again (ldap still r/o)

The mailing out of renewal reminders can be done before or after c&s day. If done after, there'll
be less mails sent out.

```bash
useradm unpaid_warn
```

Take pre_sync backup copy for running sync with the new tree later on. This is used to keep a
record of current home directories and usertypes for all accounts, which is needed for any
renamed and/or converted accounts.

```bash
useradm pre_sync
```

Copy RRS directory and master slapd setup to the standalone RRS computer. Make sure user web server
runs as can read and execute the CGIs, write to rrs.log and the tracebacks directory (and nothing
else). As the webserver won't (well, *shouldn't*) have write access to the `rrs/` directory, any
changes made to the *.py files won't result in the automatic update of the corresponding `.pyc`
file, so it's best to make sure these are updated manually: this is only to help speed up execution.
Setup a `.htaccess` file to require a password. Enforce SSL only if possible. Modify `rbconfig.py`
to point to the localhost LDAP.

If there is no network connection, the DCU LDAP tree needs to be imported into the redbrick one.
However, this should be done regardless of network connectivity!

```bash
./make-rb-dcu-tree.sh
```

Join rb & dcu trees into one ldif file to add in one go as this will speed things up a lot!

```bash
 cat slapcat.pre-rrs rb-dcu-tree.ldif > slapcat.pre-rrs-dcu
```

Always do a dry run before any major slapadd:

```bash
slapadd -v -u -l slapcat.pre-rrs-dcu
```

Adding this for real will take a long time. Although there is a -q (quick) option for slapadd, it
might be best not to use it.

```bash
slapadd -v -l slapcat.pre-rrs-dcu
```

Truncate rrs.log. This should always be empty before starting to use rrs for real! Make sure the CGI
can still write to it!

```bash
> rrs.log
```

Make sure uidNumber.txt is correct (it should be, if copied across!).

```bash
useradm create_uidNumber
```

At this point, rrs should be ready to go.

If you're paranoid, the continous_rrs_backup.sh script will prove useful.

## After C&S Day

After using rrs, i.e. c&s day is finished, shutdown slapd and do a slapcat, removing the dcu tree
from the output:

```bash
pkill slapd
slapcat -l - | remove_dcutree_ldif.py > slapcat.rrs
```

Copy rrs.log, uidNumber.txt and slapcat.rrs back to useradm machine.

Turn off *all* MTAs until ldap is back and all accounts are in sync again. Home directories will be
moving around a bit, so we don't want mail getting bounced.

```bash
/etc/init.d/exim stop
```

**XXX:** This only disables the smtp daemon, invoking sendmail from the command line might still
start up a local delivery ?

Any machines which point nss & pam at the master need to be pointed at a backup ldap server on
another machine as the ldap rebuild will take a few minutes, might as well be nice to our users :-)

Turn off master slapd & slurpd.

```bash
/etc/init.d/slapd stop
```

Move ldap dbs out to clear db, but keep a backup just in case.

``` bash
mv /var/db/ldap/redbrick /var/db/ldap/redbrick.pre-sync
mkdir /var/db/ldap/redbrick
```

Now add the new tree.

``` bash
slapadd -v -l slapcat.rrs
```

Make master ldap r/w again, but restrict write access to root only by commenting out any "by self
write" ACLs in slapd.conf as useradm sync needs to set passwords for the new users.

Start master slapd up again. Don't start slurpd.

```bash
/etc/init.d/slapd start
```

Remove files which indicate if a renewal has been mailed. These might still be here from a previous
year's run.

``` bash
rm -rf renewal_mailed/
```

Do sync stuff. Run *1* step at a time. First with -T to make sure it will do the right thing then
run the step for real. This will involve hitting ^C after completing each step so that test mode can
be run on the next step i.e:

```bash
useradm sync -T
```

 | C at prompt for next step
 | -------------------------

``` bash
useradm sync
```

 | C at prompt for next step, rinse, wash, repeat.
 | -----------------------------------------------

The sync command is designed to be run again and again, i.e. there won't be any repeated actions
(which is why a record is kept of which users were sent a renewal mail). This is useful if it bombs
out at any stage!

Stop master slapd.

```bash
/etc/init.d/slapd stop
```

Take post-sync backup now that it's shutdown.

``` bash
slapcat -v -l slapcat.post-sync
```

Move ldap dbs out to clear db, but keep a backup just in case.

``` bash
mv /var/db/ldap/redbrick /var/db/ldap/redbrick.post-sync
mkdir /var/db/ldap/redbrick
```

Re-add post-sync backup so that it's all nicely indexed.

``` bash
slapcat -v -l slapcat.post-sync
```

Go back to full r/w slapd again, so re-enable user write access.

Point nss & pam back to master server on machines that were changed.

Restart nscd on all machines.

Start MTA.

Load slapcat.post-sync on ldap backup servers using similar procedure (redirect nss & pam, shutdown
slapd, move dbs out, slapadd, start slapd, point nss & pam back again)

## Later On

A month or two after c&s day, unpaid accounts need to be disabled.

```bash
useradm unpaid_disable
```

Also the unpaid accounts from last year (the "grace" accounts) need to be deleted. This is a good
time to make a backup! And don't forget to log your session, so you have a record.

``` bash
useradm list_unpaid_grace
```

These accounts will be **DELETED** permanently. Please **MAIL THIS LIST TO ADMINS@ BEFORE** running
unpaid_delete so that it can be checked by everyone. After another few days these accounts can be
deleted. You should check that the previous day's backup jobs have completed successfully before
running a delete.

```bash
useradm unpaid_delete
```

Usually people who haven't paid (yet) request their shell to be enabled again. Admins can find these
fee-evaders:

``` bash
useradm list_unpaid_reset
```

...and then crack down on them:

``` bash
useradm unpaid_disable
```
