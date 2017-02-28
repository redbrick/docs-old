# Daniel

### Creating a VM

Daniel /xen partition holds scripts disk images and iso's for the VMs

To create a VM use /xen/scripts/vmcreate.sh

This Script takes information provided to it by you and uses this information to create a Xen config for a VM as well as a Disk Image. In order to keep things simple all VMs will be created as full hvm machines with an ISO attached for the OS required.

symlings in /xen/isos need to point to the current ISO for a Distro, subsets of distros, such as hardy or intrepid can be handled, this is currently only set up for Debian and Ubuntu, needs to be completed for all OSs

The IP for a VM is set by reading the first IP from the /xen/scripts/freeips, this file can be updated using /xen/scripts/testfreeips.sh - this script needs to be modified to check against Xen Configs as well as using ping

In order for the User to be able to install there VM they will need to use a VNCViewer to access the console of there VM, this can be acomplised with port forwarding, it would be nice if we could find somenice java app or something that we could run on a Service VM to allow users access the console easier

The vmcreate script uses /xen/scripts/createdisk.sh to create a disk for the vm in /xen/disk

The config is moved to /etc/xen/configs after creation and symlinked to /etc/xen/auto which will cause the VM start with Xen in the event of a reboot

At the end is a list of Things that need to be done manually

These include:

*  Adding the VM to DNS in the form hostname.vm.redbrick.dcu.ie

*  Adding rules to cynic's /etc/pf.conf that only allow access from the VM to its VNC port


### Left to do on Daniel

    * Script to Delete / Disable VMs
    * ISOs /Symlinks for major OS's
    * Web Based VNC System? - if unsecure this should run on VM
    * vmcreate.sh needs to email user and more robust error checking would be nice too.
