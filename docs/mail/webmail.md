# Webmail/Rainloop

<img src="https://www.rainloop.net/static/img/logo-256x256-tiny.png" alt="rspamd" width="150" />

## Runbook

The vhost should already be configured as part of our NixOS apache config,
see the vhosts.nix.

```bash
# Download and extract the rainloop release into $webtree/vhosts/rainloop
mkdir -p /storage/webtree/vhosts/rainloop
cd /storage/webtree/vhosts/rainloop
unzip ~/rainloop-latest.zip -d .
chown -R wwwrun:wwwrun .
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
# Log in to https://webmail.redbrick.dcu.ie/?admin, default creds can be
# found online
# Change the admin password, save to passwordsafe under "rainloop-admin"
# Go to domains -> add domain
name: redbrick.dcu.ie
# It's important to use localmail so that it connects over localhost
imap: localmail.redbrick.dcu.ie
imap port: 993
imap secure: SSL/TLS
smtp: localmail.redbrick.dcu.ie
smtp port: 587
smtp secure: STARTTLS
# In sieve configuration
server: localmail.redbrick.dcu.ie
port: 4190
secure: SSL/TLS
# Go to contacts, configure the mysql connection
type: MySQL
Dsn: mysql:host=mysql.internal;port=3306;dbname=rainloop
User: rainloop
password: thepassword
# Save password to passwordsafe under "rainloop-mysql"
```

## Administration

Our rainloop admin password is in the passwordsafe under `rainloop-admin`. The
MySQL password is under `rainloop-mysql`. You can visit [this page](https://webmail.redbrick.dcu.ie/?admin)
to view the admin interface, although there is very little you will ever need
to use it for after initial setup.

## Troubleshooting

#### Can't log in/can't send mail

Rainloop checks credentials directly against Dovecot. Check the configuration
on the admin page. Then check the Dovecot logs.
