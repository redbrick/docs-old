# Pike

Pike is an 8 port IP-KVM purchased by johan from startech.com in 2009. As of May 7th 2009 it has 7
machines directly connected to it..

The machines are:

1. Morpheus
2. (unused)
3. Minerva
4. Thunder
5. Deathray
6. Daniel
7. Data
8. Carbon

## Access

Pike is on the management network - it's current ip is 192.168.1.240 - this is in the DHCP range,
and should be changed.

## Local Access

This works as you'd expect, with a keyboard and monitor. Press CTRL, CTRL to change server, and F7
for menu.

## Remote Access

The password for remote access is available in pwsafe.

### Web Interface

The web control interface is on https (port 443). You will need to open an ssh tunnel to access this:

``` bash
sudo ssh -L 443:192.168.1.240:443 username@halfpint.redbrick.dcu.ie
```

The web interface allows configuring settings. It also has some kind of java vnc thing I think, but
I wouldn't bother with that.

### VNC access

Also, requires an ssh tunnel....

``` bash
ssh -L 5900:192.168.1.240:5900 username@halfpint.redbrick.dcu.ie
```

Then point your VNC client at localhost.

### SSH access

You can ssh in with the admin password. Can't see why though, it doesn't seem to do very much.

## About the name

The day it arrived it was installed by receive & johan, who decided it needed a star trek name. Cian
wandered in at some point during the discussion and suggested it should be named pike... for some
unknown reason (Cian doesn't watch star trek). It was decided to keep the name, as a reference to
Christopher Pike of course, not whatever Cian was on about.
