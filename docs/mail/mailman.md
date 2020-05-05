# Mailman

<img src="https://www.list.org/images/logo2010-2.jpg" alt="mailman" width="150" />

Mailman is split into 2 distinct parts, mailman-core and mailman-web.
Mailman-web is split into Hyperkitty and Postorius.

Mailman-core is the brains of the operation, serving the primary API
for interacting with lists. It manages subscriptions, approvals, etc.

Postorius is the the frontend for mailing list management. It provides
the subscription, held message and list setting interfaces.

Hyperkitty is the frontend for the mailing list archives. It is a slave
to Postorius and Mailman-core, and has no real administrative functions
or powers on its own beyond saving and serving the archives.

Mailman-web also has a Django administration page. You will only use this
page once during initial setup, and never again.

## Runbook

Mailman has its own LDAP user so that it can authenticate with Postfix
and spoof mails (see the Postfix sender whitelist). It is called `mailmgr`.
You need to configure Mailman to use this. Their password is in the
passwordsafe.

Mailman also relies on a Postgresql database. You will need to create the
user and database if not done already. The existing credentials are in the
password safe.

Please note that the deployment of Mailman is not secure since the mailmgr
password has to be added to the Nix config, and thus exists in the Nix store.
If any future admins find another way to do this please change it.

```bash
# Used by mailman-core
cat > /var/secrets/mailman.nix << EOF
{
  dbUser = "mailman";
  dbPassword = "mailman_psql_pwd";
  emailUser = "mailmgr@redbrick.dcu.ie";
  emailPassword = "mailmgrpwd";
}
EOF

# Used by mailman-web
cat > /var/secrets/mailman.json << EOF
{
	"db_user": "mailman",
	"db_password": "mailman_psql_pwd",
	"email_user": "mailmgr@redbrick.dcu.ie",
	"email_password": "mailmgrpwd"
}
EOF

chmod 400 /var/secrets/mailman.nix
chmod 440 /var/secrets/mailman.json
```

Once you've run `nixos-rebuild switch` you will need to do these things:

```bash
chown mailman:wwwrun /var/secrets/mailman.json
# Create files needed for postfix to map mail to mailman
# They are created in /var/lib/mailman/data
# These files are regenerated when certain actions are taken, and mailing lists
# won't work until they are updated.
cd /var/lib/mailman && sudo -u mailman mailman aliases && systemctl restart postfix
# Create a django superuser for mailman-web
cd /var/lib/mailman-web && sudo -u wwwrun mailman-web createsuperuser
# Nav to https://lists.redbrick.dcu.ie/admin/login/?next=/admin/
# Change the example.com site to lists.redbrick.dcu.ie, display name Redbrick Lists
```

## Administration

The `mailadm` group in LDAP provides users with superuser privileges in
Mailman. This means that you can see and manage every list and its archives
on Mailman-web. Simply add users to this group and give re-log into
the frontend to gain the privileges.

Mailman's data is primarily stored in /var/lib/mailman. This directory contains
part of the metadata for the archives and thus must be backed up.
/var/lib/mailman-web contains a fulltext search index for the archives but this
can be rebuilt if necessary.

List subscriptions can be managed from the frontend, but it's also possible
to do mass operations on the command line when necessary. Mailman can invoke
a Python script which can be used to take any action using the Mailman API.

```python
# Open an interactive python shell in the context of a list
$ mailman shell -l nixos-discuss@lists.redbrick.dcu.ie
# Get the properties of the list object to see what you can do
>>> import json
>>> json.dumps(vars(m), default=str)
# Example command. Drop all held requests for a list.
# Adapted from https://lists.mailman3.org/archives/list/mailman-users@mailman3.org/message/2JACJENOUDODYHRVL6VCNZNFRZNIRIE3/
>>> req_db = IListRequests(m)
>>> requests = list(req_db.held_requests)
>>> from mailman.app.moderator import handle_message
>>> results = [handle_message(m, req.id, Action.discard) for req in requests]
>>> results
# Exit the shell to commit (ctrl+D)
```

## Troubleshooting

#### Lists getting spammed

If non-members keep spamming the list, go to [this page](https://lists.redbrick.dcu.ie/postorius/lists/announce-redbrick.lists.redbrick.dcu.ie/settings/message_acceptance)
for the respective list and set "Default action to take when a non-member
posts to the list" to "Discard".

#### Can't mail a mailing list

If it's brand new, check if it is listed in `/var/lib/mailman/data/postfix_lmtp`.
If not regenerate that file with this command (taken from runbook above):

```bash
cd /var/lib/mailman && sudo -u mailman mailman aliases && systemctl restart postfix
```

#### Log spam about failed tasks

Log into the [Django admin page](https://lists.redbrick.dcu.ie/admin/django_q/ormq/)
and clear all the queued tasks. Then ensure that the site domain matches
the email domain.
