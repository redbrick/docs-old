# SSL Certs

## Background

Redbrick has a wildcard SSL cert for *.redbrick.dcu.ie, issued by The SSL
Store/RapidSSL. It was purchased before LetsEncrypt supported wildcard certs and
for the sake of the price paid is being kept in use until it expires.

At the time of writing, our cert deployment looks like so:

| Host      | Location              | RapidSSL? | LetsEncrypt? |
| --------- | --------------------- | --------- | ------------ |
| albus     | /etc/apache2/ssl      | Y         | N            |
| metharme  | /etc/apache2/ssl      | Y         | N            |
| pygmalion | /etc/apache2/ssl      | Y         | N            |
| paphos    | /etc/apache2/ssl      | Y         | N            |
| paphos    | /etc/dovecot/ssl      | Y         | N            |
| azazel    | /etc/letsencrypt/live | N         | Y            |

## LetsEncrypt

CertBot is set up on Azazel and Metharme, in `/local/usr/sbin`. It is cron'd to
run at 02:30 and 14:30 daily and log to `/var/log/le-renew.log`. The Apache on
Azazel is configured to use this cert for redbrick.dcu.ie and
azazel.redbrick.dcu.ie

For more configuration info on Certbot see
[here](https://certbot.eff.org/#ubuntutrusty-apache)

## The RapidSSL Cert

### Paperwork

This should be on the grant app at the start of each year, in the past it has
not been approved. The price is $149 for the year.

Rapidssl will email admins@rb about a month before the cert is due for renewal
with instructions, this usually happens around April.

The cert was purchased through [The SSL Store](https://www.thesslstore.com/),
credentials in pwsafe under "ssl".

### Renewal

#### Jargon

- Key (.key): Used to sign the cert, generated locally
- Cert Signing Request (.csr): Used to request a cert from the CA for domain(s),
  Subject details what domains it will be requesting for
- Certificate (.crt/.cer): The actual certificate served to clients
- CA Bundle/Intermediate Cert (.crt/.cer/.pem): The cert issued by the CA to
  verify they issued it
- Other files (.p7b): Don't worry about these

#### Generating a CSR

**NOTE**: You most likely do not need to do this! These instructions exist in
the event the key and CSR are lost.

- Start generating a CSR with this command:

```bash
openssl req –new –newkey rsa:2048 –nodes –keyout redbrick.dcu.ie.key –out redbrick.dcu.ie.csr
```

- Enter the relevant information as prompted from the table below:

| Field               | Value                               |
| ------------------- | ----------------------------------- |
| Common Name         | *.redbrick.dcu.ie                  |
| Organization Name   | Redbrick - DCU's Networking Society |
| Organizational Unit | Admins                              |
| City/Locality       | Glasnevin                           |
| State/Province      | Dublin                              |
| Country/Region      | IE                                  |

- Check your Subject line matches the one below:

```bash
/etc/apache2/ssl# openssl req -in redbrick.dcu.ie.csr -text -noout | grep Subject
        Subject: C=IE, ST=Dublin, L=Glasnevin, O=Redbrick - DCU's Networking Society, OU=SysAdmin, CN=*.redbrick.dcu.ie
```

- Keep the generated files safe and make sure they have an octal mode of "0500"
  or stricter

#### Requesting a new cert

- Proceed to
  [The SSL Store Buy Page](https://www.thesslstore.com/client/wildcard-certificates.aspx)
  or similar and use the redbrick.dcu.ie.csr to request a new cert
- In order to verify ownership of the domain, The SSL Store will offer to email
  a link to webmaster@redbrick.dcu.ie. Last time this was tried it did not work,
  and we used DNS validation instead. To do this: - Select DNS verification on
  The SSL Store website - Log into paphos and open up the bind config
  (`/etc/bind/master/db.Redbrick.dcu.ie`) - Update the serial - Add a TXT field
  with the requested hash from the SSL store - Save,
  `named-checkconf db.Redbrick.dcu.ie` to test, and `service bind9 reload` to
  apply - `dig @136.206.15.53 -t txt redbrick.dcu.ie` and check the record is
  there - Give it a few minutes and The SSL Store should pick it up - Undo these
  changes

You cert should be active and you should have a `Download Certificate` button on
the Order Details page.

#### Updating the deployed certs

These steps are mostly from updating Metharme, but should apply to other hosts.

- Back up the relevant SSL folder like so

```bash
cd ssl_folder
mkdir backup_$(date +'%F')
cp * backup_$(date +'%F')/
ls -l backup_$(date +'%F')
# There should be >= 4 files in here
```

- Download the certificate zip file from the SSL Store. This will contain a
  number of files:

| ZIP file name                    | SSL folder file name      |
| -------------------------------- | ------------------------- |
| ServerCertificate.cer            | redbrick.dcu.ie.crt       |
| CACertificate-INTERMEDIATE-1.cer | redbrick.dcu.ie_chain.crt |
| CACertificate-ROOT-2.cer         | unused                    |
| PKCS7.p7b                        | unused                    |

(Note: If you do not get an intermediate cert, you can download the RapidSSL
wildcard intermediate SHA2 CA from
[here](https://www.thesslstore.com/knowledgebase/ssl-support/ca-bundle/))

- Copy the files to the relevant places in the ssl folder
- Test the changes
  - Apache: `apache2ctl configtest`
  - Dovecot: `doveconf | grep ssl`
- Apply the changes
  - Apache: `apache2ctl restart`
  - Dovecot: `doveadm reload`
- Validate the changes
  - Apache:
    [here](https://www.thesslstore.com/ssltools/ssl-checker.php?hostname=https://www.redbrick.dcu.ie#results)
    (make sure to test domains served by each apache)
  - Dovecot:
    `openssl s_client -CApath /etc/ssl/certs/ -connect 136.206.15.58:993 2>/dev/null | grep -ie 'verify return code' -e rapidssl`
- Delete the previous year's backup folder(s) (BE CAREFUL NOT TO DELETE YOUR OWN
  ONE)

If something goes wrong along the way just restore the old certs and call an old
admin.
