# Redbrick VM management software

## Feature list

*  The ability for admins to create VMs of set capabilities (RAM, disk space, etc) via command line tools. **Done**

*  The ability for admins to be able to create new users easily via command line tools. **Done**

*  The ability for users to be able to switch their VMs on/off via a web interface. **Done**

*  The ability for users to be able to access their VM's VNC interface, if they want, via SSH forwarding, with a VNC port and password disclosed (and regenerated each time the VM is started with VNC enabled) once via the web interface. **Done**

*  The ability for users to be able to choose ISOs to mount on their VMs. There should be a selection of ISOs in a library available for users to choose from (all common OSes, etc).  **Done**

*  The ability to hard reset a VM. **Done**

*  Installable/upgradable via apt, in the [Redbrick apt](redbrick-apt) repo. **Done**

In future releases, it would be nice if:

*  Users could access their serial consoles. This would be doable via the /dev/pts interface exposed by qemu-kvm.
     * The system currently connects VM serial ports to /dev/pts/X and keeps track of which VM owns which pt. This could be implemented relatively easily.

*  Resource/CPU usage/memory usage stats, etc, were available to privileged users via the web interface
     * a user group system is already in place to determine privileged users from regular users, just need to write some pretty stats software.

## Administration

All of the administrative functions, for simplicity, are done via the command line as root on daniel.

To add a new user:
    # rbvm-createuser -u username -e username@redbrick.dcu.ie
This will generate a random password and mail it to the user.

To add a new VM on behalf of a user:
    # rbvm-createvm -u username -i 136.206.16.101
This will create a VM with default settings and the IP address specified, there is currently no automatic assignment of IPs.
This will complain loudly if that IP has already been assigned to a VM. There's currently no support for "reserved" IPs, so make sure you don't assign .254 or .1. IP assignment is done on the basis of trust - we trust them to use the IP they've been given. If a user goes and intentionally breaks stuff by setting their VM's IP to 136.206.16.254, they lose any access to the VM system.
    # rbvm-createvm -u username -i 136.206.16.101 -m 512 -d 16000
This will create a vm with 512MB RAM and a 16000MB disk image.

MAC addresses can be specified manually (-a), or will be generated automatically if not specified.

rbvmwebd is the script that runs the CherryPy HTTP server containing the VM interface. This doesn't take any parameters at the moment. Upstart mostly manages this, you don't have to worry too much under normal circumstances (to tell upstart to start rbvm, type "start rbvm", to stop it, "stop rbvm", to restart it "restart rbvm" - you get the idea).

## HG access

The mercurial repository for the rbvm software is at http://hg.redbrick.dcu.ie/rbvm. Read-only access is free. Ask an admin for write access if you want to help.

##  Known Bugs

The software is only new, so it has some bugs. The bug list is hosted [here](http://wiki.redbrick.dcu.ie/mw/RBVM_Bugs) on the main Redbrick wiki to allow members to add or comment on bugs.

## sudo

To get around restrictions in the linux kernel regarding creating tap devices, the following should be added to sudoers:

    Defaults:username !requiretty
    Cmnd_Alias RBVM = /sbin/ifconfig, /usr/sbin/brctl, /usr/sbin/tunctl
    username ALL=NOPASSWD:RBVM

The debian installer package create /etc/rbvm-qemu-ifup/down scripts that use sudo appropriately to allocate/deallocate network interfaces.
