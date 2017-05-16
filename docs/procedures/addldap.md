# Adding Data to LDAP

Occasionally you'll need to add people or things to ldap manually, such as a
user you recreating from backups, or a reserved system name such as a new
machine.

Put the information you would like to add into a file, or if its short or one
entry you can use stdin, in the case of adding a reserved name the file should
look something like this, replacing both instances of redbrick with the reserved
name you would like to add:

``` bash
$ cat update.reservered
dn: uid=redbrick,ou=reserved,o=redbrick
uid: redbrick
description: DNS entry
objectClass: reserved
objectClass: top
```

Then run the following command:

``` bash
ldapadd -D cn=root,ou=ldap,o=redbrick -y /etc/ldap.secret -x -f update.resevered
```

Done, if you opted to use stdin, leave the -f off the end of the command, paste
the data into your terminal after running the command and finish with a `ctrl-d`
