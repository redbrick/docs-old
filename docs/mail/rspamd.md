# Rspamd

<img src="https://avatars2.githubusercontent.com/u/21975367?s=400&v=4" alt="rspamd" width="150" />

## Runbook

Rspamd requires Redis. It has a socket for management, which the
Dovecot sieve scripts for learning use, and a socket for milter
connections which Postfix uses for spam filtering.

The only manual steps are related to DNS and signing. You need to
add SPF, DKIM, and DMARC records for redbrick and lists.redbrick.
We use the same DKIM key for list.rb and rb because if a member sends
a mail to a list then it picks the rb key even though it should be
lists.rb.

```bash
# Save the output from this command
rspamadm dkim_keygen -k /var/secrets/redbrick.dcu.ie.$HOSTNAME.dkim.key -b 2048 -s $HOSTNAME -d redbrick.dcu.ie
ln -s /var/secrets/{,lists.}redbrick.dcu.ie.$HOSTNAME.dkim.key
chown rspamd:root *.dkim.key
chmod 400 *.dkim.key
# Add backslashes before the semicolons on the first line of the rspamd output
# Add the outputted DNS record to the domain.
# Also copy it and append ".lists" after "._domainkey"
# Now add the following records to rb and lists.rb
                        TXT     "v=spf1 mx -all"
_dmarc                  TXT     "v=DMARC1; p=reject; adkim=r; aspf=r; sp=reject"
```

## Administration

Rspamd runs a web interface on 127.0.0.1:11334. It can be used to
view the filtering history, train spam and ham, and view statistics
on the types of spam we are receiving. You will have to use an SSH
port tunnel from the mail box to view the page (don't expose it even
internally, it is not secure). The password is in the password safe.

## Troubleshooting

#### Mail getting marked as spam

First check for the `X-Spam` header on the mail. There's thresholds
specified in Rspamd as to when things get the header, and get dropped.
Search the log for the message ID and investigate the checks that Rspamd
ran on it. Note that Rspamd can learn from users moving mail in and out
of spam. It might be necessary to override the learning for a particular
domain if a majority of users move it to spam.
