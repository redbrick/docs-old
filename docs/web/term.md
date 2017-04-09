# Web terminal
Redbrick runs multiple web terminal.
  - [anyterm](#anyterm)
  - [ajaxterm](#ajaxterm)
  - [wetty](#wetty)

## Anyterm
`Anyterm` is a fucking heap of shite.

Running at [anyterm.redbrick.dcu.ie](https://anyterm.redbrick.dcu.ie)

### Dependencies
Install `libboost-dev` and `zlib1g-dev` from `apt`

### Building
The latest `anyterm` is 1.1.29 which is built from source and lives in
`/opt/anyterm`. To compile it needs a patch to [SmtpClient.cc](https://github.com/gentoo/gentoo-portage-rsync-mirror/blob/master/www-apache/anyterm/files/anyterm-1.1.29-gcc-4.4.patch),
then
```
$ make
$ make install
```
There's an init script `/etc/init.d/anyterm` that runs anyterm on
`localhost:7777`. The command `anyterm` runs is a python script that SSHes to
`login.redbrick`.

### Apache config
There's an apache vhost for anyterm on metharme to do https and proxy into the
anyterm.

## Ajaxterm
I like this lots more, cause it's installed from apt.

Running at [ajaxterm.redbrick.dcu.ie](https://ajaxterm.redbrick.dcu.ie)

### Apache config

```
<VirtualHost *:443>`
	ServerName ajaxterm.redbrick.dcu.ie
	SSLEngine On
	SSLCertificateFile /etc/apache2/ssl/redbrick.dcu.ie.crt
	SSLCertificateKeyFile /etc/apache2/ssl/redbrick.dcu.ie.key
	ServerName ajaxterm.redbrick.dcu.ie
	DocumentRoot /var/www/ajaxterm

	ErrorLog /var/log/apache2/ajaxtermError443.log
	LogLevel warn

	CustomLog /var/log/apache2/ajaxterm443.log

	ProxyRequests Off
	<Proxy *>
		Order deny,allow
		Allow from all
	</Proxy>
	ProxyPass / http://localhost:8022/
	ProxyPassReverse / http://localhost:8022/
</VirtualHost>

<VirtualHost *:80>
	ServerName ajaxterm.redbrick.dcu.ie
	DocumentRoot /var/www/
	ErrorLog /var/log/apache2/ajaxtermError.log
	LogLevel warn
	CustomLog /var/log/apache2/ajaxterm.log combined
	RewriteEngine on
	RewriteCond %{SERVER_PORT} ^80$
	RewriteCond %{HTTP_HOST} ajaxterm\.redbrick\.dcu\.ie
	RewriteRule .*$  https://ajaxterm.redbrick.dcu.ie$1 [NC,R,L]
</VirtualHost>
```

### Init Config
Modify the init script. Change:

```
start-stop-daemon --start --group=$AJAXTERM_GID --pidfile $PIDFILE --exec $DAEMON -- --daemon --port=$PORT --serverport=$SERVERPORT \
                                --uid=$AJAXTERM_UID >/dev/null
```
to:
```
start-stop-daemon --start --group=$AJAXTERM_GID --pidfile $PIDFILE --exec $DAEMON -- --daemon --port=$PORT --serverport=$SERVERPORT \
                                --uid=$AJAXTERM_UID --command=/usr/local/bin/anyterm.py >/dev/null
```

### Anyterm.py
Is a hack python script.

```
#!/usr/bin/python

something = raw_input( "Username: " )

import os, re

while ( re.search(r'[^a-zA-Z0-9_.-]', something ) ):
        print "Sorry, but you have invalid characters in your username. Please try again!"
        something = raw_input( "Username: " )
else:
        os.system( 'ssh %s@login.redbrick.dcu.ie' % something )
```

## Wetty
I like this best because it actually looks good and runs from a container.

Running at [redbrick.dcu.ie/wetty](https://redbrick.dcu.ie/wetty)

### Source
When installing butlerx got sick of the lack of development on the project and
decided to fork it and pull in changes from contributors such as mobile support
and reconnect button. As well as make it better for running from a container and
better ssh support.

His fork is on [github](https://github.com/butlerx/wetty)

### Setup

Specify the host to ssh to and the port to run on in the docker-compose file then just run
```
docker-compose up -d
```
Then just use apache to proxy to the port.
