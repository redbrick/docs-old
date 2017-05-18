# Obelisk stuff

*Maybe at some stage give these bits their own pages.*

## Anyterm

Anyterm is a bitch.

## IRC Proxy

If you're restarting apache, you need to restart the ircproxy seperately:

''python /root/ircproxy.py''

- lil_cain\\
22/Jun/07

## Dokuwiki

Dokuwiki installed in /var/www/docs, symlinked to /home/docs/dokuwiki. www-data owns the data and conf folders so it can write to them, docs owns the rest. Should be secure enough as there are no public accounts on the system (that I can see) that have apache access.

- werdz\\
23/Dec/07
