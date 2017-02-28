## tunnel.redbrick.dcu.ie


*  All traffic that goes to tunnel on any port is forwarded to port 22

*  Tunnel is a service ip (73), that's on minerva

*  The magic is done with iptables, the rule is in /etc/network/interfaces

	
	#
	# Tunnel.redbrick.dcu.ie
	#
	auto eth1:1
	iface eth1:1 inet static
	   address 136.206.15.73
	   netmask 255.255.255.255
	   post-up iptables -A PREROUTING -t nat -p tcp -d 136.206.15.73 --dport 1:65535 -j REDIRECT --to-port 22


## Old Tunnel

This was done with jumpgate, running on deathray.

	
	[root@deathray ~]# cat /etc/init.d/tunnel 
	#!/bin/bash
	
	#
	# tunnel - a script to run tunnel.redbrick.dcu.ie
	# by Andrew Harford (receive) 6/05/2008
	# (lil_cain helped (by telling me i'm shit))
	#
	
	if [ `ps -A | grep -c jumpgate` -gt 0 ]
	then 
	        echo "tunnel.redbrick is already running"
	        echo "(or at least it think's it is.)"
	        echo "(you could always pkill it anyway)"
	else
	        echo "Attempting to start tunnel.redbrick"
	        /usr/local/sbin/jumpgate -b tunnel.redbrick.dcu.ie -l 443 -a login.redbrick.dcu.ie -r 22
	        /usr/local/sbin/jumpgate -b tunnel.redbrick.dcu.ie -l 80 -a login.redbrick.dcu.ie -r 22
	        echo "If you haven't seen any errors, it's probably listening on 80 & 443"
	        echo "Good Luck"
	fi


This script gets called from /etc/rc.local. As you can see it was written in a hurry.

Jumpgate isn't in repos or anything, and from what I remember it needed to be beaten with a large stick to compile.

The new approach is much, much better. 

*  It can run on every port, each jumpgate instance can only run on one port.

*  It doesn't break fail2ban
