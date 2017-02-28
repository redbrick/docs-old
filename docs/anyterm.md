# Anyterm

Anyterm is a fucking heap of shite

## Dependencies

Install libboost-dev and zlib1g-dev from apt

## Building

The latest anyterm is 1.1.29 which is built from source and lives in /opt/anyterm. To compile it needs a patch to [SmtpClient.cc](https///github.com/gentoo/gentoo-portage-rsync-mirror/blob/master/www-apache/anyterm/files/anyterm-1.1.29-gcc-4.4.patch), then

	
	make
	make install


There's an init script /etc/init.d/anyterm that runs anyterm on localhost:7777. The command anyterm runs is a python script that sshes to login.redbrick.

## Apache config

There's an apache vhost for anyterm on metharme to do https and proxy into the anyterm.


# Ajaxterm

I like this lots more, cause it's installed from apt. 

### apache config

	
	`<VirtualHost *:443>`
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
	        `<Proxy *>`
	                Order deny,allow
	                Allow from all
	        `</Proxy>`
	        ProxyPass / http://localhost:8022/
	        ProxyPassReverse / http://localhost:8022/
	
	`</VirtualHost>`
	
	`<VirtualHost *:80>`
	        ServerName ajaxterm.redbrick.dcu.ie
	        DocumentRoot /var/www/
	
	        ErrorLog /var/log/apache2/ajaxtermError.log
	        LogLevel warn
	
	        CustomLog /var/log/apache2/ajaxterm.log combined
	
	        ProxyRequests off
	        `<Proxy *>`
	                Order deny,allow
	                Allow from all
	        `</Proxy>`
	        ProxyPass / http://localhost:8022/
	        ProxyPassReverse / http://localhost:8022/
	
	        RewriteEngine on
	        RewriteCond %{SERVER_PORT} ^80$
	        RewriteCond %{HTTP_HOST} ajaxterm\.redbrick\.dcu\.ie
	        RewriteRule .*$  https://ajaxterm.redbrick.dcu.ie$1 [NC,R,L]
	`</VirtualHost>`


### init config

Modify the init script. Change:

	
	start-stop-daemon --start --pidfile $PIDFILE --exec $DAEMON -- --daemon --port=$PORT --uid=ajaxterm >/dev/null || return 2

to:

	
	start-stop-daemon --start --pidfile $PIDFILE --exec $DAEMON -- --daemon --port=$PORT --uid=ajaxterm --command=/usr/local/bin/anyterm.py >/dev/null || return 2


# Anyterm.py

Is a hack python script.

	
	#!/usr/bin/python
	
	something = raw_input( "Username: " )
	
	import os, re
	
	while ( re.search(r'[^a-zA-Z0-9_.-]', something ) ):
	        print "Sorry, but you have invalid characters in your username. Please try again!"
	        something = raw_input( "Username: " )
	else:
	        os.system( 'ssh %s@login.redbrick.dcu.ie' % something )
	

