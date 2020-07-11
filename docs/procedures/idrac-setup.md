# Network Config on iDRAC/BMC

For all our newest hosts (any running NixOS) that have the 802.11 bonding
configured, we are using the iDRAC NIC sharing system and tagged VLANs to
get iDRAC access through NIC1 on the host. This means we only need 2
network cables going into a host instead of 3, and do not need a management
switch in each rack.

Run these commands from the Linux prompt of the machine you're configuring.

- Set nic mode to shared

```bash
ipmitool delloem lan set shared
```

- Set network config

```bash
ipmitool lan set 1 vlan id 4
ipmitool lan set 1 ipaddr 192.168.1.WHATEVER
ipmitool lan set 1 defgw ipaddr 192.168.1.254
ipmitool lan print 1
```

- Give it about a minute to activate. If it doesn't work reset the idrac.

```bash
ipmitool bmc reset cold
```
