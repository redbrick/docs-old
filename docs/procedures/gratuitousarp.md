# Sending a gratuitous ARP

Every now and then, you'll need to move an IP address from one machine to the
other. Normally, this will take a few hours to take effect, as the ARP table in
ISS's gateway (and the tables in all of our machines) will still associate the
old MAC with that IP, and will keep sending packets bound for that IP to the old
machine.

You can force all machines on the network to update their ARP caches using the
following command on the machine that just received the new IP:

```bash
arping -U -I eth0 136.206.15.XXX
```

(replace eth0 with the appropriate interface, and replace the IP as appropriate)

This works by having the recipient machine send ARP requests for its own IP
address.

There is another method using `send_arp` (a tool included with various HA Linux
packages), but it doesn't seem to work for external connections, possibly due to
security settings on ISS's router.

This version of arping is in the `iputils-arping` package, not the `arping`
package.
