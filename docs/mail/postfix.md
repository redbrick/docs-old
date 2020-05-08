# Postfix

![postfix](http://www.postfix.org/mysza.gif)

## Runbook

Postfix relies on all other parts of the stack.
Beyond the Nix configuration there's nothing else to do, however during
deployment you will likely need to do a few service restarts as you
configure its dependant services (AKA all other services).

The steps on adding the necessary DNS records are in the Rspamd runbook.

## Administration

#### Whitelists and Blacklists

Everyone needs to be authenticated to send mail via our MTA, and they can
only send mail under their own username or any aliases they own. However
you may sometimes need to add an exception to this rule for a service. The
only one that exists at the time of writing is Mailman's `mailmgr` account.
They are allowed to spoof their from address in order to send mail for the
mailing lists. The sender whitelist is in the Nix configs [here](https://github.com/redbrick/nix-configs/blob/2b62829f78dfbb844e4e227dc75c0c960205a480/services/postfix/default.nix#L23).

There is also a blacklist of domains we do not accept mail from over port
25 (AKA unauthenticated). This list only includes our own domain. This means
that an external mail server or client can't spoof an email from Redbrick and
send it to Redbrick. Only our own authenticated users can send mail under our
domain.

#### Aliases

Mail aliases are maintained in the Nix config [here](https://github.com/redbrick/nix-configs/blob/master/services/postfix/aliases.nix).
In general, we should not be granting aliases to users since it's hard to
manage. It should be used to manage special addresses like committee, chair,
etc to ensure mails go to the correct person. Some legacy user aliases
were carried over when the mailing stack was revamped.

## Troubleshooting

Postfix doesn't store any data itself, it's pretty stateless. This makes it
quite easy to debug.

Generally all you will want to do is watch the log. You can do this with
journalctl. The log entries tend to contain domain names, to and from fields
where appropriate. If you are trying to find where in the validation pipeline
a mail is being dropped then filter by message ID.

#### Spam filtering

Postfix will drop a lot of mail without even contacting rspamd if it does not
meet the restrictions specified [here](https://github.com/redbrick/nix-configs/blob/2b62829f78dfbb844e4e227dc75c0c960205a480/services/postfix/default.nix#L236).
It will always log the reason for dropping the mail, and there is good
documentation online for pretty much every rejection reason. However, you
should read the git blame on the restrictions in the Nix config to figure out
why those restrictions exist in the first place. For example,
`reject_non_fqdn_sender` and `reject_unknown_sender_domain` come before
`permit_sasl_authenticated` so that users cannot send email under domains
which do not exist or we do not own.

#### User can't send mail under their address

If people are struggling to send mail with their Redbrick address, make sure
they are connecting to port 587, specifying STARTTLS and using their Redbrick
credentials. You can see if someone is authenticated or not from the logs.
Postfix connects to Dovecot for authentication over a unix socket. You could
check the Dovecot logs for auth issues too, but generally error messages will
get relayed back to Postfix and back to the clients.

#### Mail dropped because user is not recognised

Postfix checks 2 places to ensure a recipient address is valid before accepting
a mail, as defined by `local_recipient_maps`. The first is mailman - it will
check if the full email address matches one it is responsible for. This is
configured [here](https://github.com/redbrick/nix-configs/blob/2b62829f78dfbb844e4e227dc75c0c960205a480/services/postfix/mailman.nix#L156),
read the Mailman docs to see how that is generated.
Secondly it will contact LDAP to ensure a user exists with the given
address (accounting for aliases automatically). This is configured [here](https://github.com/redbrick/nix-configs/blob/2b62829f78dfbb844e4e227dc75c0c960205a480/services/postfix/default.nix#L150).
