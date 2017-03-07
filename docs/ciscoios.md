# Cisco IOS

IOS is the OS running on the Cisco switches. It can be terrifying, because one wrong move and you've kicked <del>redbrick</del> DCU off the internet. It's also very different to anything running on any of the servers.

## A Quick Walkthrough

**Be careful, don't break it**

When you log in first, you might have a prompt looking something like "hadron>". This indicates you're in user mode. To change stuff, you'll want to go to privileged mode. Type "enable" and hit enter. Enter the root password. Then hit enter again.
    hadron>enable
    Password:
    hadron#
Wowsers, your shell prompt has changed. The # indicates root, like on a Unix system. You can also break things from this point on. So again, please don't break anything.

Let's look at some information about the switch. Type "sh ver":

    hadron#sh ver
    Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 12.2(50)SE3, RELEASE SOFTWARE (fc1)
    Technical Support: http://www.cisco.com/techsupport
    Copyright (c) 1986-2009 by Cisco Systems, Inc.
    Compiled Wed 22-Jul-09 06:41 by prod_rel_team
    Image text-base: 0x01000000, data-base: 0x02D00000

    (...lots more information...)
    hadron#

Now examine the running config. Type "sh running":
    Current configuration : 6889 bytes
    !
    version 12.2
    no service pad
    service timestamps debug uptime
    service timestamps log uptime
    service password-encryption

    (...lots more information, until you get to...)

    interface GigabitEthernet0/1
   description link to enzyme
   switchport access vlan 122
   no cdp enable
    !
    interface GigabitEthernet0/2
   description currently unused
   switchport access vlan 122
   no cdp enable
    !
    interface GigabitEthernet0/3
   description blinky
   switchport access vlan 122
   no cdp enable
    !         
    interface GigabitEthernet0/4
   description Carbon.external
   switchport access vlan 122
   no cdp enable
    !         
    (...You can guess what these are... Lots more of these... and a bit of stuff at the end...)
    hadron#

Now let's change something. Something I had to do today was to change the description on port 45, because I'd plugged something new in. Go into config mode with "conf t":
    hadron#conf t
    hadron(config)#
Your prompt has changed! You're now in config mode. Now you can **really** fuck things up. You want to configure an interface, so type "interface" followed by the name of the interface you want to feck with. The full name is shown when you do that "sh running" thing you did earlier - in our case, GigabitEthernet0/45:
    hadron(config)#interface GigabitEthernet0/45
    hadron(config-if)#
Prompt change again! Now that you're set to play with this interface only, you're a little safer again - if you break it, it'll probably only break that one interface. Probably. Maybe. Unless it's the uplink port, in which case, please please please be careful. So, we wanted to change the description. Fairly simple. Just type "description" followed by the new description.
    hadron(config-if)#description b4 mgmt
Done! There's lots of other things you can poke at from here, like turning a port on/off, playing with VLANs, etc. If in doubt, ask for help, and/or read a book, and/or take a course in advanced networking, and/or sacrifice a goat for good luck. You still need to get out of config mode and save your config. Type "end" (your prompt will change) followed by "write" to save your changes.
    hadron(config-if)#end
    hadron#write

Tada! Type "disable" if you want to drop to user mode (no, it won't disable the switch...I think). Type "logout" to get back to the sane world and close your IOS SSH session completely.
    hadron#logout
    Connection to hadron.mgmt closed.
    werdz@sprout:~$

## Resources

http://eirik.sier.no/cisco-ios-cheat-sheet/ - Where I learned everything I know about IOS. Which isn't a lot.\\
http://www.pantz.org/software/ios/ioscommands.html - Some IOS commands.
