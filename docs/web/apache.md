# Apache

Redbrick runs the latest instance of Apache on Hardcase. Configuration files associated with the web server can be viewed [here](https://github.com/redbrick/nix-configs//tree/master/services/httpd).

## Deploying Apache/httpd

users.nix needs to be generated before deploying Apache. Use this command:

```
cd /etc/nixos/services/httpd
ldapsearch -b o=redbrick -h ldap.internal -xLLL objectClass=posixAccount uid homeDirectory gidNumber | python3 ldap2nix.py /storage/webtree/ > users.nix
```

Then generate the preliminary certs for every domain so that httpd can start:

```
# List all acme-selfsigned-* services and put them in a txt file. Do this with `systemctl status acme-selfsigned-<tab>`
cat selfsigned-svcs.txt | xargs systemctl start
```

Now apache will start. Generate the real certs for each domain, one at a time as to not get rate limited

```
cd /var/lib/acme
for cert in *; do journalctl -fu acme-$cert.service & systemctl start acme-$cert.service && kill $!; done
systemctl reload httpd
```

