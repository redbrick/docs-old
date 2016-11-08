# Cynic

## Needs to be Completed for VM Project


*  Routing

*  Exim


## Setup

## /etc/rc hacks

#### Don't Bork my motd pls

	
	# DON'T TOUCH THE MOTD - PATCH BY RECEIVE MARCH 09
	#if [ ! -f /etc/motd ]; then
	#       install -c -o root -g wheel -m 664 /dev/null /etc/motd
	#fi
	#T=`mktemp /tmp/_motd.XXXXXXXXXX`
	#if [ $? -eq 0 ]; then
	#       sysctl -n kern.version | sed 1q > $T
	#       echo "" >> $T
	#       sed '1,/^$/d' `< /etc/motd >`> $T
	#       cmp -s $T /etc/motd || cp $T /etc/motd
	#       rm -f $T
	#fi

#### syslog-ng

	
	echo 'starting system logger (syslog-ng)'
	#rm -f /dev/log
	#if [ X"${named_flags}" != X"NO" ]; then
	#       rm -f /var/named/dev/log
	#       syslogd_flags="${syslogd_flags} -a /var/named/dev/log"
	#fi
	#if [ -d /var/empty ]; then
	#       rm -f /var/empty/dev/log
	#       mkdir -p -m 0555 /var/empty/dev
	#       syslogd_flags="${syslogd_flags} -a /var/empty/dev/log"
	#fi
	#syslogd ${syslogd_flags}
	/usr/local/sbin/syslog-ng

