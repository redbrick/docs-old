# redbrick.dcu.ie

In 2008 we decided that redbrick.dcu.ie should work again (well, for www and ssh
traffic).

Originally we did this by pointing it at deathray, using jumpgate to forward the
ssh traffic to login, and using apache to re-write www onto the redbrick.dcu.ie
addresses. This worked great, but because the ssh traffic was coming via
deathray it wasn't caught by fail2ban.

So, redbrick.dcu.ie is now an A record for 136.206.15.50 (the service ip for
login). For the www subdomain traffic apache is installed on azazel. Apache
redirects all traffic to www subdomain

```apache
redirect 301 / https://www.redbrick.dcu.ie
```

## SSL Oddity

Because we want members to SSH to azazel but meth is the web server, Apache is
set up on azazel with LetsEncrypt, and forwards connections to meth.

certbot lives in `/local/usr/sbin` and has a cron set to run at 02:30 and 14:30
everyday. It logs to `/var/log/le-renew.log`
