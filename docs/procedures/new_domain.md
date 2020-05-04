# Configuring a new domain

Every year, our free testing domain will expire and we have to move to
the next one. We aren't buying a full domain on purpose here, it is a
great new admin first task and it expires in the first few days of May.

## Pre-rebuild changes

Do these things before running `nixos-rebuild switch`

- run `rndc -k /etc/bind/rndc.key freeze $olddomain`
- Stop bind
- Rewrite `/var/db/bind/$olddomain*` and update the domain name

## Nix config changes

- Update the `redbrick.tld` in the host's configuration.nix.
- If configured, update the domain details in `services/dns/default.nix`

## Post-rebuild changes

- Rename `/var/mail/$olddomain` -> `/var/mail/$newdomain`
- Remove `/var/lib/acme/$olddomain`
- Run `systemctl start acme-$newdomain.service`
- Restart things that depend on certs (httpd, postfix, dovecot, etc)
