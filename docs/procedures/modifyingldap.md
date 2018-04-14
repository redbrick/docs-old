# Modifying LDAP Entries

How to modify something in LDAP, like, oh, say, disusering somebody.

Create a file with something similar to this:

```ldif
dn: uid=username,ou=accounts,o=redbrick
changetype: modify
replace: loginShell
loginShell: /usr/local/shells/disusered
```

Where: username is who you're editing loginShell is the attribute
/usr/local/shells/disusered is the value

Then run ldapmodify like this:

```bash
ldapmodify -x -D cn=root,ou=ldap,o=redbrick -y /etc/ldap.secret -f modifyfile
```

Where modifyfile is what you created above.
