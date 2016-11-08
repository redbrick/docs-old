In 2008 we decided that redbrick.dcu.ie should work again (well, for www and ssh traffic).

Originally we did this by pointing it at deathray, using jumpgate to forward the ssh traffic to login, and using apache to re-write www onto the redbrick.dcu.ie addresses. This worked great, but because the ssh traffic was coming via deathray it wasn't caught by fail2ban.

So, redbrick.dcu.ie is now an A record for 136.206.15.50 (the service ip for login). For the www traffic lighttpd is installed on minerva. The re-write rule to needed for this to work is:

	
	###
	### The important bit - this re-directs stuff from redbrick.dcu.ie to www.redbrick.dcu.ie
	###
	$HTTP["host"] =~ "^redbrick\.dcu\.ie$" { url.redirect = ( "^/(.*)" => "http://www.redbrick.dcu.ie/$1" ) }

