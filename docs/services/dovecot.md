#  Dovecot

As of July 2009 dovecot replaced the old courier imap system on RedBrick.
Dovecot runs on morpheus, and has a service address of .58 for imap. Dovecot is
better than courier cause of it's indexing abilities. Webmail relies on this
imap server to, like, work.

These docs are incomplete, but I've tried to update them with what I can
remember.

### imaps
We only use imaps, on port 993. This is set in dovecot.conf

### ssl
Dovecot uses the same [ssl](/procedures/ssl) certs as apache, but keeps it's own
copy in `/etc/dovecot`.

### indexes

I had to set this manually in dovecot.conf, and manually set the permissions on
the index directory.

```
mail_location = maildir:~/Maildir:INDEX=/var/mail/indexes/%u


[root@morpheus /]# ls -ld /var/mail/indexes
drwxrwsrwt 58 root mail 4.0K 2009-07-28 14:11 /var/mail/indexes
```

### ldap
Originally when it was in testing on deathray dovecot talked to ldap for
usernames/passwords, but this seemed to break on the morpheus migration, so it
is currently (at least, as far as I can remember) set to use pam instead.
