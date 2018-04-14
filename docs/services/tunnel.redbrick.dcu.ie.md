# tunnel.redbrick.dcu.ie

- All traffic that goes to tunnel on any port is forwarded to port 22
- Tunnel is a service ip (73), that's on azazel
- The magic is done with iptables, the rule is in `/etc/network/interfaces`

```text
  #
  # Tunnel.redbrick.dcu.ie
  #
  auto eth1:1
  iface eth1:1 inet static
     address 136.206.15.73
     netmask 255.255.255.255
     post-up iptables -A PREROUTING -t nat -p tcp -d 136.206.15.73 --dport 1:65535 -j REDIRECT --to-port 22
```
