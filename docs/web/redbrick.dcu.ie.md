# redbrick.dcu.ie

In 2008 we decided that redbrick.dcu.ie should work again (well, for www and ssh traffic).

Originally we did this by pointing it at deathray, using jumpgate to forward the ssh traffic to
login, and using apache to re-write www onto the redbrick.dcu.ie addresses. This worked great, but
because the ssh traffic was coming via deathray it wasn't caught by fail2ban.

So, redbrick.dcu.ie is now an A record for 136.206.15.50 (the service ip for login).
For the www subdomain traffic apache is installed on azazel. Apache redirects all traffic to www
subdomain

``` apache
redirect 301 / https://www.redbrick.dcu.ie
```

## Cert

We have a wildcard cert from rapidssl to cover all out subdomains but this doesnt include
redbrick.dcu.ie, so we've certbot set up on azazel to use LetsEncrypt for redbrick.dcu.ie and
azazel.redbrick.dcu.ie.
certbot lives in `/local/usr/sbin` and has a cron set to run at 02:30 and 14:30 everyday. It logs to
`/var/log/le-renew.log`

### External docs

[certbot](https://certbot.eff.org/#ubuntutrusty-apache)
