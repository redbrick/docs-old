## Bitlbee on RedBrick
This is set up on morpheus

The ubuntu default is for it to run in fork daemon mode, but I moved back to the recommended inetd method when I installed it (I have no idea why I did this, it was AGES ago).

```
[andrewj@obelisk ~]% cat /etc/init.d/bitlbee
#!/bin/sh

echo "Bitlbee runs from xinetd on this machine"
exit 0
```

```bash
[andrewj@obelisk ~]% cat /etc/xinetd.d/bitlbee
## xinetd file for BitlBee. Please check this file before using it, the
## user, port and/or binary location might be wrong.

service ircd
{
	socket_type     = stream
	protocol        = tcp
	wait            = no

	## You most likely want to change these two
	user            = bitlbee
	server          = /usr/sbin/bitlbee

	## You might want to limit access to localhost only:
	bind            = 136.206.15.54
	only_from       = 136.206.15.0


	## Thanks a lot to friedman@splode.com for telling us about the type
	## argument, so now this file can be used without having to edit
	## /etc/services too.
	type            = UNLISTED
	port            = 6667
}
```

This lets us bind only to the service ip, and restrict access to the subnet
(which might be why I did it).

`/etc/bitlbee/bitlbee.conf` is fairly standard, no authentication or anything.

```
Proxy = socks5://proxy3.dcu.ie:1080
```

User details are stored in /var/lib/bitlbee as xml data. It should be possible
to migrate the user data just by copying the xml files.
