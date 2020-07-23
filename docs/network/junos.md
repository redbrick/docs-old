# Junos

Currently in Redbrick we are using a SRX 210 firewall. There is a router-on-a-stick setup between Sebastian and our SRX. This allows multiple VLANs to go over the link between Sebastian and the SRX. <br>The SRX is also our gateway whether that be 192.168.x.254/X or 136.206.15.254/24


## Junos Commands

Unlike Cisco you do not need to be in priviledge mode to view configuration. However as Junos runs FreeBSD you do need to have the correct priviledge level to access different hierachies of the Junos device.

### Login
If you log in as root you will be greeted with a UNIX cli this is denoted by the `%`. You will need to type `cli` in order to view any configuration.

```text
root% cli
root@SRX>
```

### View interfaces

To view any interfaces on a Junos device you can do the following command:
`show interface terse` This will output information as below:
```text
user@SRX> show interfaces terse
Interface               Admin Link Proto    Local                 Remote
ge-0/0/0                up    up
ge-0/0/0.0              up    up   inet     X.X.X.X/X
gr-0/0/0                up    up
ip-0/0/0                up    up
lsq-0/0/0               up    up
lt-0/0/0                up    up
mt-0/0/0                up    up
sp-0/0/0                up    up
sp-0/0/0.0              up    up   inet
                                   inet6
sp-0/0/0.16383          up    up   inet     10.0.0.1            --> 10.0.0.16
                                            10.0.0.6            --> 0/0
                                            128.0.0.1           --> 128.0.1.16
                                            128.0.0.6           --> 0/0
ge-0/0/1                up    up
ge-0/0/1.0              up    up
ge-0/0/1.1              up    up   inet     192.168.0.254/24
ge-0/0/1.2              up    up   inet     192.168.1.254/24
ge-0/0/1.16             up    up   inet     136.206.16.254/24
ge-0/0/1.20             up    up
```

The interface name in this case will be:<br>
`ge` which stands for gigabit ethernet-0/0/number of port


#### What do the points after the interface name mean?

They are the logical interfaces of that interface. 

### Enter Configuration Mode
Unlike Cisco IOS you do not need to type `conf t` you would instead type `edit` 

```text
user@SRX> edit
Entering configuration mode

[edit]
user@SRX#
```

In order to navigate around this mode you start your command with `edit`

### Saving Configuration
Before saving your changes it is recommeneded to do the following command `` show | compare`` this will show you any configuration changes that have been made.

Unlike Cisco when you edit the configuration. It is not running until you commit it. In order to commit, you need to type ``commit confirmed`` this command will automatically rollback to the previous configuration in the event that you lost access and cannot finalize the change by typing ``commit`` 

```text
[edit]
user@SRX# show | compare

[edit]
user@SRX#
```


#### Edit an interface
To edit an interface you will need to do the following command ```edit interfaces ge-x/x/x``` To edit a logical interface you would do the same command but you would include the logical number ```edit interfaces ge-x/x/x.x```

```text
[edit]
user@SRX# edit interfaces ge-0/0/1.1

[edit interfaces ge-0/0/1 unit 1]
user@SRX# show
family inet {
    address 192.168.0.254/24;
}

[edit interfaces ge-0/0/1 unit 1]
user@SRX#
```
#### Destination NAT
If you want to reach a service within Redbrick you will need destination NAT unless it is running on a ``136.206.15.X/24`` address already.

To do this you will need to do the following:<br>
1. Configure a NAT pool to the destination IP within Redbrick<br>
2. Create a NAT rule within the destination NAT ruleset

##### Create a NAT pool
To create a NAT pool you will need use the following commands:
``edit security nat destination``<br>
``set pool NAME_OF_POOL address X.X.X.X``
	
##### Create a NAT rule within the destination NAT ruleset
To create a rule within the destination NAT ruleset you need to use the following commands:<br>
``edit security nat destination ruleset NAME_OF_RULESET``<br>
``set rule NAME match source-address 136.206.X.X `` <br>
``set rule NAME match destination-port X `` <br>
``set rule NAME then destination-nat pool WHATEVERYOUCALLEDTHEPOOL``<br>

#### Source NAT
If you want to allow a specific machine to access the internet from within Redbrick you will need source NAT you will need to configure source NAT that will use a ``136.206.15.X/24`` address

To do this you will need to do the following:
- Configure a NAT pool to the external IP within Redbrick's 136.206.15.X subnet
- Create a NAT rule within the source NAT ruleset

##### Create a NAT pool
To create a NAT pool you will need to do the following commands:
``edit security nat source``<br>
``set pool NAME_OF_POOL address X.X.X.X``

##### Create a NAT rule within the source NAT ruleset 
To create a rule within the source NAT ruleset you need to use the following commands:<br>
``edit security nat source ruleset NAME_OF_RULESET``<br>
``set rule NAME match source-address X.X.X.X `` <br>
``set rule NAME match destination-port X `` <br>
``set rule NAME then source-nat pool WHATEVERYOUCALLEDTHEPOOL``
