# Apache

hardcase, Redbrick's web server, serves or proxies all http requests. See
[`services/httpd`](https://github.com/redbrick/nix-configs/tree/master/services/httpd)
in nixos for current configuration

## www.redbrick.dcu.ie

[Redbrick vhost](https://github.com/redbrick/nix-configs/blob/master/services/httpd/default.nix#L27)
This is responsible for Rewriting legacy user dir addresses
`redbrick.dcu.ie/~username` too `username.redbrick.dcu.ie`

This vhost is configured to send all traffic to index.html as the current site
relies on react to decide on page loads

## Vhosts

We use a nix function to template out user
[vhosts](https://github.com/redbrick/nix-configs/blob/master/services/httpd/shared.nix)

All Vhosts are declared in
[vhost.nix](https://github.com/redbrick/nix-configs/blob/master/services/httpd/vhosts.nix).
These vhost can be used to explicitly overwrite user vhosts.

The vhost doesn't have to be the same as the user name this allows clubs,
societies or DCU sites to have different vhosts to their username. The reason
the dir is specified is some users have multiple sites in their webspaces with
different vhost.

### User vhosts Generation

To update the list of users in apache ssh to the apache server and run

```bash
cd services/httpd
ldapsearch -b o=redbrick -h ldap.internal -xLLL objectClass=posixAccount uid homeDirectory gidNumber | python3 ldap2nix.py /storage/webtree/ > users.nix
```

It will query ldap for a list of all users, clubs and societies and create the
users.nix that will be used in nixos rebuild.

Then generate the preliminary certs for every domain so that httpd can start:

```bash
# List all acme-selfsigned-* services and put them in a txt file. Do this with `systemctl status acme-selfsigned-<tab>`
cat selfsigned-svcs.txt | xargs systemctl start
```

Now apache will start. Generate the real certs for each domain, one at a time as
to not get rate limited

```bash
cd /var/lib/acme
for cert in *; do journalctl -fu acme-$cert.service & systemctl start acme-$cert.service && kill $!; done
systemctl reload httpd
```
