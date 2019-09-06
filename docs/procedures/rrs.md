# Guide to RRS for Clubs and Socs Days

## Before C&S Day

Some general notes on using slapadd and slapcat:

Purge the ldap database files before doing a slapadd. Always add everything in
one go with slapadd as this is faster. Always use the dry-run (-u) option before
adding for real.

slapcat should only be run when slapd is r/o or not running. If slapd can't be
stopped or made r/o and a copy of the tree is needed, use this:

```bash
ldapsearch -xLLL -y /etc/ldap.secret -D cn=root,ou=ldap,o=redbrick > rb.ldif
```

Also, it's best to log your session (e.g. with script) when running the various
batch commands that produce a lot of output.

Make master ldap r/o (add "readonly on" to slapd.conf)

Stop slurpd.

Take backup of current tree, now that ldap is r/o.

```bash
slapcat -l slapcat.pre-newyear
```

At the start of each academic year, before c&s day, yearsPaid has to be
decremented by 1 and newbie set to False for every account. This can be done
online with LDAP or offline with LDIF. LDIF method is given here:

```bash
./newyear_ldif.py < slapcat.pre-newyear > slapcat.pre-rrs
```

If using the LDIF method, slapadd slapcat.pre-rrs back again (ldap still r/o)

The mailing out of renewal reminders can be done before or after c&s day. If
done after, there'll be less mails sent out.

```bash
rb-ldap alert-unpaid
```

## Post C&S

Once you've added all the new users using the `rb-ldap add` command you need to generate the uservhost config for apache.
This is accomplished by running `rb-ldap generate` then moving the generated list of users vhosts to apache.

## Later On

A month or two after c&s day, unpaid accounts need to be disabled.

```bash
rb-ldap disable-unpaid
```

Also the unpaid accounts from last year (the "grace" accounts) need to be
deleted. This is a good time to make a backup! And don't forget to log your
session, so you have a record.

```bash
useradm list_unpaid_grace
```

These accounts will be **DELETED** permanently. Please **MAIL THIS LIST TO
ADMINS@ BEFORE** running `delete-unpaid` so that it can be checked by everyone.
After another few days these accounts can be deleted. You should check that the
previous day's backup jobs have completed successfully before running a delete.

```bash
rb-ldap delete-unpaid
```

Usually people who haven't paid (yet) request their shell to be enabled again.
Admins can find these fee-evaders:

```bash
useradm list_unpaid_reset
```

...and then crack down on them:

```bash
rb-ldap disable-unpaid
```
