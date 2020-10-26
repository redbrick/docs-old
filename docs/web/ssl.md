# SSL Certs

## Background

Redbrick has a wildcard SSL cert for \*.redbrick.dcu.ie, issued by The SSL
Store/RapidSSL. It was purchased before LetsEncrypt supported wildcard certs and
for the sake of the price paid was being kept in use until it expires.

At the time of writing, our cert deployment looks like so:

| Host      | Location         | RapidSSL? | LetsEncrypt? |
| --------- | ---------------- | --------- | ------------ |
| albus     | /etc/apache2/ssl | Y         | N            |
| pygmalion | /etc/apache2/ssl | Y         | N            |
| paphos    | /etc/apache2/ssl | Y         | N            |
| paphos    | /etc/dovecot/ssl | Y         | N            |
| hardcase  | /var/lib/acme/   | N         | Y            |

## NixOS and SSL Certs

On hardcase, we have a very sophisticated system for managing certs. We now
correctly generate certs for all domains and aliases explicitly for all the
vhosts we have. The cert for our own top level domain is a LetsEncrypt
wildcard cert. There's a number of components to this system.

### Port 80 Vhost

There is only one port 80 vhost configured for Apache. This vhost serves
the webroot for the Acme module, which will add and remove files needed for
HTTP-01 validation. The path of this folder is `config.security.acme.webroot`.

Any traffic that is not destined for the `/.well-known/acme-challenge` URL
is promoted to HTTPS, and thus goes to the corresponding vhost for that domain.
This means that NONE of our other vhosts are served on port 80 - everything
is explicitly HTTPS now. All domains use HTTP-01 validation, except for our
own domain...

### DNS-01 Validation

Redbrick used to have its own acme module written by m1cr0man to support DNS-01,
but after this was merged into nixpkgs we switched back to the regular module.
The configuration we use utilises [rfc2136](https://go-acme.github.io/lego/dns/rfc2136/)
to talk to our Bind9 DNS server. The process for DNS-01 involves adding a TXT
record to our domain, requesting LE to verify it exists, then removing the
record. Lego (the application the acme module uses) handles this.

There is a key shared between the DNS server and hardcase which is stored in
`/var/secrets/certs.secret`, which is an environment variables file. See the
rfc2136 docs linked above for the keys.

The key must be generated on the DNS server. This is done with this command:

```bash
tsig-keygen dnsupdate.${tld} > /var/secrets/dnskeys.conf
```

Our dns module is configured to import the key from this file.

### The magic certs config

We have a [complex Nix config](https://github.com/redbrick/nix-configs/blob/cc99a5e27aa505224f6ce628b346c4ca69c1c84a/services/certs/default.nix)
which generates certs from the vhosts list in the Apache config. It accounts
for vhost names and all its aliases. It tries to find the [domain's TLD](https://github.com/redbrick/nix-configs/blob/cc99a5e27aa505224f6ce628b346c4ca69c1c84a/common/variables.nix#L24)
to minimise the number of certs that are required. This is subject to fail
under certain conditions:

- The TLD does not point to our web server
- The hostname or one of the aliases does not point to our web server

This causes the HTTP-01 validation to fail for that vhost, and thus no cert
will get generated for it at all. The [broken domains](https://github.com/redbrick/nix-configs/blob/cc99a5e27aa505224f6ce628b346c4ca69c1c84a/common/variables.nix#L12)
list allows us to work around that, by providing an explicit mapping of a
domain to what its cert domain will be. This bypasses the domainTld function.

NixOS will create 3 systemd pieces for every cert bundle: A renew service,
a renew timer, and a selfsigned cert service. This selfsigned service allows
us to start Apache before the certs are initially generated. When deploying a
new web server, you will need to run this service for all domains. See
the Apache docs for the steps here.

The renew service does not automatically restart Apache, instead we have a
[systemd timer](https://github.com/redbrick/nix-configs/blob/cc99a5e27aa505224f6ce628b346c4ca69c1c84a/services/httpd/default.nix#L155)
to restart Apache at 5am on Saturdays.

### Regenerating all certs, and pruning dead ones

It may happen that LetsEncrypt requests everyone to regenerate their certs,
which happened us once. The fastest way to do this is by using the list
of folders as service names and an awk script:

```bash
cd /var/lib/acme
ls -1 | awk '{ print "acme-" $1 }' | xargs systemctl start
```

There may be reason to do this every once in a while regardless: When
you run that command, any domains which do not have certs associated with them,
and thus have no systemd service, will fail to start. You should delete these
folders as they are no longer used.

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
| Common Name         | \*.redbrick.dcu.ie                  |
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
wildcard intermediate SHA1 CA from
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
    `openssl s_client -CApath /etc/ssl/certs/ -connect 136.206.15.58:993 2>/dev/null`
    `| grep -ie 'verify return code' -e rapidssl`
- Delete the previous year's backup folder(s) (BE CAREFUL NOT TO DELETE YOUR OWN
  ONE)

If something goes wrong along the way just restore the old certs and call an old
admin.
