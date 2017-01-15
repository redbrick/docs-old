### Severus VPN

Since severus will soon be hosted over at CSD it needs a VPN link to the internal network over the external network. This is done with OpenVPN running on sprout...... (finish me)


##### routing

I'm afraid I can't say anything about the VPN link itself, but the routing is done with a static route from all the machines, added as a post-up in /etc/network/interfaces, through sprout. Sprout has sysctl net.inet.forwarding set to 1, and a pf.conf which disallows traffic from the external interface to the VPN subnet (192.168.3.0/24) or the internal subnet (192.168.0.0/24).
