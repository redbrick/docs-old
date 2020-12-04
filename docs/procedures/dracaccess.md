# DRAC access

## Overview

Most of our servers are Dell, and feature an integrated Dell
Remote Access Controller (AKA iDRAC). This allows us to perform
hard and soft reboots of the servers, get VNC access* to the host.

The iDRAC can be accessed in 3 ways. The most convenient is usually
over the web GUI. `ipmitool` can also be used on the host's OS to
connect to its respective iDRAC. You can also use `ipmitool` to connect
to remote iDRACs. In all cases, the username is root and the password
is in the password safe.

\* Not all of our hosts have iDRAC enterprise licences, and those
which do may require a java applet to run the VNC client (use icedtea
to run it).

## Networking

All iDRACs are on the management VLAN (2) with IPs in the subnet
192.168.1.0/24. See [the configuration procedure](../idrac-setup) for
more info.

## Remote Console Access

ylmcc found a piece of software for connecting to the idrac.
It has been configured and uploaded to a Google Drive folder [here](https://drive.google.com/folderview?id=1Q2qgqcWYgQ3rAVJx-n2uqF0xo4qQ97fk).
You will need to use your DCU email address to access it.
