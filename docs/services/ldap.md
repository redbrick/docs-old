# LDAP

LDAP is our directory service. It stores usernames, passwords, UIDs,
quotas, and other user specific info.

LDAP's structure is different to most other database systems. If you are not
familiar with it, I recommend investing some time into looking at how schemas
and distinguished names work.

## Deployment

- OpenLDAP is deployed with Nix to Daedalus and Icarus
- Daedalus is the master, Icarus is slaved to it and can
  be used as a read only failover
- `ldap.internal` and `ldap2.internal` are slaved to Daedalus +
  Icarus respectively
- Both servers store their data in `/var/db/openldap`
- The ldap.secret, which should **ALWAYS** have permissions `400`,
  and owned by the openldap user, is stored in `/var/secrets`. It is not
  automatically created and must be copied when setting up new hosts
- `rb-ldap` and `useradm` are wrappers around LDAP that are custom built

## Redbrick Special Notes

- The root user password is in the passwordsafe
- The OID for most of the schema is [DCU's](http://www.oid-info.com/cgi-bin/display?oid=1.3.6.1.4.1.9736&submit=Display&action=display)
- The configs that exist for NixOS were mostly ported from our last
  LDAP server (Paphos) to maintain compatibility
- At the time of writing, LDAP is not configured with TLS
- There are 2 scripts to manage quotas on /storage that run on
  the server serving NFS (`zfsquota` and `zfsquotaquery`). They are
  covered under the NFS documentation.
- There's a user in ldap called testing, for testing.
  The password is in pwsafe.

## Operation

The `ldap*` suite of commands can be used to manage LDAP. Their man pages are
very well documented, but we've provided most common operations below.

Note that the ldap.secret is a crypted file, and not equal to the actual password you
need to run ldap commands.

### ldapsearch recipes

ldapsearch can be used with and without authenticating as root. Without root,
some fields (such as the password hash, altmail) will be hidden.

```bash
# Dump the entire LDAP database in LDIF form, which can be used as a form of backup
ldapsearch -b o=redbrick -xLLL -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt

# Find a user by name, and print their altmail
ldapsearch -b o=redbrick -xLLL -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt uid=m1cr0man altmail

# Find quotas for all users edited by m1cr0man
ldapsearch -b o=redbrick -xLLL updatedby=m1cr0man quota

# Find all member's usernames
ldapsearch -b o=redbrick -xLLL objectClass=member uid

# Find all expired users. Notice here that you can query by hidden fields, but you can't read them
ldapsearch -b o=redbrick -xLLL 'yearsPaid < 1' uid
```

### ldapmodify recipes

You can instead pass a file with `-f` when necessary.
To test a command add `-n` for no-op mode.
Changing `updatedby` and `updated` is added to each command as good practise.

```bash
# Add quota info to a user
ldapmodify -x -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt << EOF
dn: uid=testing,ou=accounts,o=redbrick
changetype: modify
add: quota
quota: 3G
-
replace: updatedby
updatedby: $USER
-
replace: updated
updated: $(date +'%F %X')
EOF

# Change a user's shell
ldapmodify -x -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt << EOF
dn: uid=testing,ou=accounts,o=redbrick
changetype: modify
replace: loginShell
loginShell: /usr/local/shells/disusered
-
replace: updatedby
updatedby: $USER
-
replace: updated
updated: $(date +'%F %X')
EOF

# Update yearsPaid
ldapmodify -x -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt << EOF
dn: uid=testing,ou=accounts,o=redbrick
changetype: modify
replace: yearsPaid
yearsPaid: 1
-
replace: updatedby
updatedby: $USER
-
replace: updated
updated: $(date +'%F %X')
EOF
```

### ldapadd recipes

Occasionally you'll need to add people or things to ldap manually, such as a
user you're recreating from backups, or a reserved system name such as a new
machine. This is where ldapadd comes in.

```bash
# Create a file to read the new entry from
cat > add.ldif << EOF
dn: uid=redbrick,ou=reserved,o=redbrick
uid: redbrick
description: DNS entry
objectClass: reserved
objectClass: top
EOF

# Import the ldif
ldapadd -x -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt -f add.ldif

# Note if you are importing a full ldif onto a new server, use slapadd instead
# Ensure slapd is not running first
slapadd -v -l backup.ldif
```

### Other recipes

On a yearly basis, the yearsPaid fields must be incremented for every users,
and last year's newbies need to be not newbies anymore.
Remember to take off `-n` when you are ready to rock.
Adding the `updated` and `updatedby` fields from above to these queries
would be a good idea.

```bash
# Decrement yearsPaid
# WARNING NOT IDEMPOTENT, RUN ONCE
ldapsearch -b o=redbrick -xLLL -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt objectClass=member yearsPaid |\
tee yearsPaid-$(date +'%F').backup.ldif |\
awk '/yearsPaid/ { print "changetype: modify\nreplace: yearsPaid\nyearsPaid: " $2 - 1 } ! /yearsPaid/ {print $0}' |\
ldapmodify -x -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt -n

# De-newbie last year's users
ldapsearch -b o=redbrick -xLLL -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt newbie=TRUE dn |\
tee newbie-$(date +'%F').backup.ldif |\
awk '/^dn/ {print $0"\nchangetype: modify\nreplace: newbie\nnewbie: FALSE\n"}' |\
ldapmodify -x -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt -n

# Set quotas of users without quotas
ldapsearch -b o=redbrick -xLLL '(&(objectClass=posixAccount)(!(quota=*)))' dn |\
awk '/^dn/ {print $0"\nchangetype: modify\nadd: quota\nquota: 2G\n"}' |\
ldapmodify -x -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt -n
```

## Troubleshooting

First off, it's worth calling out that if you are coming here to find
help with a client side issue, chances are the DNS rule applies:

`It's probably not LDAP`

With that out of the way, here's some things to check - in order.

### Check reachability of LDAP

Run from the master and also from the problem client. It should return
m1cr0man's details. If you get an `invalid credentials` or
`object not found` check that the LDAP auth config hasn't changed. If
you get a connection error then restart the service.

```bash
ldapsearch -h ldap.internal -p 389 -xLLL -b o=redbrick uid=m1cr0man
```

### Verify LDAP can be written to

Get the password from the passwordsafe. Run this from the master.

```bash
ldapmodify -D cn=root,ou=ldap,o=redbrick -x -y filewithpwd.txt << EOF
dn: uid=m1cr0man,ou=accounts,o=redbrick
changetype: modify
replace: quota
quota: 3G
EOF
```

Run the command from the first troubleshooting step to verify the value changed.
If it fails with an auth issue, triple check your password file (it should
contain the plain text password). If it fails with a non-auth issue, then check
the service logs.

### Enable debug logging

OpenLDAP produces a nice set of logs when the `loglevel` is _not_ set.
Remove `loglevel` from `extraConfig` in the Nix config and switch, then run this
command to tail the logs:

```bash
journalctl -fu openldap
```

### Re-syncing Secondary LDAP Server(s)

In the event a secondary server becomes out of sync with the master,
it can be synced by stopping the server, deleting its database files,
then restarting the server.

Do this after ensuring that `config.redbrick.ldapSlaveTo` is set
correctly.
