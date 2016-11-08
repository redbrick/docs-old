**rbvmctl is the rbvm command line utility. It is located on daniel. Any of the following subcommands
will work**:

    changeip        Changes the IP assigned to a VM.
    changename      Changes the name of a VM.
    listusers       Displays a list of users.
    listvms         Displays a list of virtual machines.
    showvm          Displays detailed information on a virtual machine.
    resetpw         Allows a user's password to be reset.
    help            Displays help information.

To get more information on a specific item, run 'rbvmctl help topicname',
where topicname is one of the commands listed above.

maK has created an rbvm-delvm script in python.

This allows for the management of rbvm resources on Daniel.

These include

	
	  -h, --help  show this help message and exit
	  -l          List all users
	  -u USER     list specified users vms
	  -dba        List database layout!
	  -d DUMP     dump a specified table
	  -rm VMID    STEP1: Choose a vm by id to remove & remove Image
	  -f DBFORCE  STEP2: Force vmid removal from DB
	  -free       List free vm IPs


The Syntax for each command is as follows: 

`rbvm-delvm -l`
>Lists each user with an account on rbvm in the format 
>username - uid
`rbvm-delvm -u USER`
>Lists all VMs owned by a given USER (name assigned at rbvm-createuser) returns format
> User|VM_Name|VM_ID|PID|Last_launch|IP|MAC
`rbvm-delvm -dba`
>Outputs the Schema of the SQLITE DB for the VMs
`rbvm-delvm -d DUMP`
>Dumps a Table $DUMP from the SQLITE DB for the VMs
`rbvm-delvm -rm VM_ID`
>Removes the image for a given VM_ID referenced in the DB
`rbvm-delvm -f VM_ID`
>Removes the entry corresponding to this VM_ID from the Table of VMs
`rbvm-delvm -free `
>Lists all remaining available ip addresses in  the 136.206.16.0/24 subnet for allocation



