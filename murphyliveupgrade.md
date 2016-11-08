This Mostly works

### Settup the 3rd Disk

You need to set up the disk to have similar sized partitions to the / and /var partitions

Something like this:

 
    ascii name  = `<SUN72G cyl 14087 alt 2 hd 24 sec 424>`
   pcyl        = 14089
   ncyl        = 14087
   acyl        =    2
   nhead       =   24
   nsect       =  424
   Part      Tag    Flag     Cylinders         Size            Blocks
    0       root    wm       0 -  1611        7.82GB    (1612/0/0)   16403712
    1        var    wm    1612 - 12882       54.69GB    (11271/0/0) 114693696
    2       swap    wu       0 - 14086       68.35GB    (14087/0/0) 143349312
    3 unassigned    wm   12883 - 13286        1.96GB    (404/0/0)     4111104
    4 unassigned    wm   13287 - 14086        3.88GB    (800/0/0)     8140800
    5 unassigned    wu       0                0         (0/0/0)             0
    6 unassigned    wu       0                0         (0/0/0)             0
    7 unassigned    wu       0                0         (0/0/0)             0


### Create LU Boot Environment on 3rd Disk

     lucreate -c raid_partition -m /:/dev/dsk/c1t2d0s0:ufs -m /var:/dev/dsk/c1t2d0s1:ufs -n noraid

Where

*  Unordered List Item
raid_partiton is the name of the Current Boot Environment
noraid is the name of the new Boot Environment

### Upgrade the noraid partition

Get a copy of the solaris you want to upgrade to and mount it somewhere. https://docs.redbrick.dcu.ie/lofiadm

     luupgrade -u -n noraid -s /mnt/

where /mnt is where you mounted the DVD

### Activate and Reboot

     luactivate noraid
     init 6

### In the event of boot meltdown

In case of a failure while booting to the target BE, the following process 
needs to be followed to fallback to the currently working boot environment:

1. Enter the PROM monitor (ok prompt).

2. Change the boot device back to the original boot environment by typing:

     setenv boot-device  
     /pci@7c0/pci@0/pci@1/pci@0,2/LSILogic,sas@2/disk@0,0:a

3. Boot to the original boot environment by typing:

     boot


### Fixing LDAP


ldap breaks: Fix it using:

	
	# ldapclient -v manual \
	  -a domainName=redbrick.dcu.ie \
	  -a defaultSearchBase=o=redbrick \
	  -a serviceSearchDescriptor=passwd:ou=accounts,o=redbrick \
	  -a serviceSearchDescriptor=group:ou=groups,o=redbrick \
	  -a attributeMap=group:userpassword=userPassword \
	  -a attributeMap=group:memberuid=memberUid \
	  -a attributeMap=group:gidnumber=gidNumber \
	  -a attributeMap=passwd:gecos=cn \
	  -a attributeMap=passwd:gidnumber=gidNumber \
	  -a attributeMap=passwd:uidnumber=uidNumber \
	  -a attributeMap=passwd:homedirectory=homeDirectory \
	  -a attributeMap=passwd:loginshell=loginShell \
	  -a attributeMap=shadow:shadowflag=shadowLastChange \
	  -a attributeMap=shadow:userpassword=userPassword \
	  -a objectClassMap=group:posixGroup=posixGroup \
	  -a objectClassMap=passwd:posixAccount=posixAccount \
	  -a objectClassMap=shadow:shadowAccount=shadowAccount \
	  -a searchTimeLimit=60 \
	  -a authenticationMethod=simple \
	  -a credentialLevel=proxy \
	  -a proxyDN=cn=root,ou=ldap,o=redbrick \
	  -a proxyPassword=LDAP_ROOT_PASSWORD \
	  IP.OF.LDAP.SERVER



### Fixing DNS

No one has told sun that it's the 21st century and we all use dns now. You need to edit /etc/nsswitch.conf so that the files line reads:

	
	hosts: files dns


