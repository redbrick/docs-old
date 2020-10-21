# Cisco IOS

IOS is the OS running on the Cisco switches. If you do not know what you're doing you can cause an outage or lose connectivity within Redbrick's network.


When you first login, you might have a prompt looking something like `Steve>`.
This indicates you're in user mode. To view information about the switch, you'll want to go to
privileged mode. Type "enable" and hit enter. Enter the enable password. Then hit
enter again.

## Enable Mode

```text
Steve>enable
Password:
Steve#
```

The # indicates enable mode, this allows you to use privileged commands. 


To view the running configuration of the switch type `show run`:

```text
Current configuration : 6889 bytes
!
version 12.2
no service pad
service timestamps debug uptime
service timestamps log uptime
service password-encryption 

(...lots more information, until you get to...)

interface GigabitEthernet0/1

!
interface GigabitEthernet0/2
switchport access vlan 122
!
interface GigabitEthernet0/3
switchport access vlan 122
!
interface GigabitEthernet0/4
switchport access vlan 122
!
(...You can guess what these are... Lots more of these... and a bit of stuff at the end...)
hadron#
```
This is the running configuration of the switch at that very moment. If the switch lost power the running configuration will be lost. To save your configuration type `copy running-config start` or you can do `wr` which is short for `write memory`

## Global Configuration Mode

```text
Steve#conf t
Steve(config)#
```

You're in config mode. Now you can modify interfaces on the switch. You want to configure an interface, so type `interface` followed by
the name of the interface you want to modify. The full name is shown when you do that `show run` thing you did earlier - in our case, `GigabitEthernet0/1`:

```text
Steve(config)#interface GigabitEthernet0/1
Steve(config-if)#
```

Notice that the prompt changed again! Now you can configure that interface if you shut it down that port is only down unless you shutdown the interface connects back to DCU's core. 

### To shutdown the interface
```text
Steve(config-if)# shutdown
```
### To bring an interface up
```text
Steve(config-if)# no shutdown
```

### To put an interface in a vlan

```text
Steve(config-if)# switchport mode access
Steve(config-if)# switchport access vlan X
```
`X` being the number of the vlan you want the interface. 

### To remove an interface from a vlan

```text
Steve(config-if)# no switchport access vlan X
```
`X` being the number of the vlan you want the interface. 


Type `end` if you want to drop to user mode.<br>
Type `logout` to exit your IOS SSH session completely.

```text
Steve# exit
Connection to Steve closed by remote host.

```

### Configuring LACP on a range of interfaces
```text
Steve(config)# interface range gig0/X - x
Steve(config-if-range)# switchport mode trunk
Steve(config-if-range)# switchport trunk encapsulation dot1q
Steve(config-if-range)# channel-group X mode active
Steve(config-if-range)# channel-protocol lacp

```
## Questions

### What is switchport mode trunk?
	This tells the switch to allow tagged vlans to go across the link.

### What is switchport mode access?
	This tells the switch to tag the interface with a vlan id.


## Resources

- [Basic switch configuration](https://www.youtube.com/watch?v=IJWFwFL5Vzw).
