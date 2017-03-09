## Jumpstart

#### sysidcfg

```
system_locale=en_IE.UTF-8
install_locale=en_IE.UTF-8
timezone=Eire
timeserver=localhost
terminal=vt100
name_service=none
security_policy=none
network_interface=qfe1 {
            primary
            hostname=cynic
            netmask=255.255.255.0
            protocol_ipv6=no
            default_route=136.206.15.254 }
network_interface=qfe0 {
            hostname=cynic-internal
            ip_address=192.168.0.23
            netmask=255.255.255.0
            protocol_ipv6=no }
```

Specifing the internal network here did nothing, i still had to set it up
manually.          

#### install_profile

```
install_type    initial_install
system_type     server

#
# Disk Partitions
#
partitioning    explicit
filesys         mirror:d10      c1t0d0s0        c1t1d0s0        30000   /
filesys         c1t0d0s1        2000    swap
filesys         c1t1d0s1        2000    swap

filesys         c1t0d0s2        free    /home
filesys         c1t1d0s2        free    /var/tmp

metadb          c1t0d0s3        size 8192       count 2
metadb          c1t1d0s3        size 8192       count 2

#
# Sun Packages
#
cluster         SUNWCall        add
cluster         SUNWCapache     delete
cluster         SUNWCapch2      delete
cluster         SUNWCbrowser    delete
cluster         SUNWCbrowserdev delete
cluster         SUNWCdtrun      delete
cluster         SUNWCdtts       delete
cluster         SUNWCdtusr      delete
cluster         SUNWCgnapps     delete
cluster         SUNWCgnbaslib   delete
cluster         SUNWCgndev      delete
cluster         SUNWCgndevlib   delete
cluster         SUNWCgnrun      delete
cluster         SUNWCgnex       delete
cluster         SUNWCmoz        delete
cluster         SUNWCmozdeveloper delete
cluster         SUNWCsmba       delete
cluster         SUNWCstaroffice delete
cluster         SUNWCtcat       delete
cluster         SUNWCxorglibs   delete
cluster         SUNWCxorgserver delete
cluster         SUNWCxscreensaver delete


# extra stuff monday
cluster         SUNWCevo        delete
cluster         SUNWCevodev     delete
#cluster                SUNWCaudd       delete
cluster         SUNWCbdb        delete
cluster         SUNWCdtdev      delete
cluster         SUNWCmlibdev    delete
cluster         SUNWCmlibusr    delete
cluster         SUNWCpostgr     delete
cluster         SUNWCpostgr-dev delete
cluster         SUNWCpostgr-82  delete
cluster         SUNWCpostgr-82-dev delete
cluster         SUNWCsppp       delete
cluster         SUNWCtltk       delete
cluster         SUNWCtltkp      delete
#cluster                SUNWCxwrte      delete
cluster         SUNWCxwdev      delete
cluster         SUNWCmozplugins delete
cluster         SUNWCgna11y     delete  
cluster         SUNWCgna11ydev  delete  

# adding stuff
package         SUNWPython-share add
package         SUNWPython      add

# adding for dependencies
#package                SUNWdtdmr       add

# removing for dependencies
package         SUNWpgadmin3    delete
package         SUNWxvnc        delete
package         SUNWfsexam delete
package         SUNWdtct delete
package         SUNWipplr delete
package         SUNWxorg-tsol-module delete
package         SUNWserweb delete
package         SUNWswupclr delete
package         SUNWpmowm delete
package         SUNWjre-config delete
package         SUNWjmfmp3 delete
package         SUNWswupcl delete
package         SUNWpmowu delete
package         SUNWjmf delete
package         SUNWmcos delete
package         SUNWzfsgu delete
package         SUNWmcosx delete
package         SUNWasac delete
package         SUNWmcon delete
package         SUNWmcex delete
package         SUNWlvmg delete
package         SUNWlvmr delete
package         SUNWmddr delete
package         SUNWlvma delete
package         SUNWpmgr delete
package         SUNWmgts delete
package         SUNWdclnt delete
package         SUNWtsmc delete
package         SUNWrmui delete
package         SUNWwbmc delete
package         SUNWmc delete
package         SUNWmcc delete
package         SUNWtsr delete
package         SUNWtsu delete
package         SUNWtsg delete
package         SUNWctlu delete
package         SUNWmp delete
package         SUNWlpmsg delete
package         SUNWmga delete
package         SUNWiiimr delete
package         SUNWolrte delete
package         SUNWxwfa delete
package         SUNWxwdem delete
package         SUNWxorg-client-programs delete
```

## Containers

### Pools
As cynic has only 2 cpus all zones are currently tied onto the default resource
pool, but this has been modified to use the Fair Sharing whatever setup.

```
[root@cynic-global /]# poolcfg -c 'modify pool pool_default (string pool.scheduler="FSS")'
```

The dns and ldap zones both have 5 shares. Any other zones that are created
should be given less than this to prioritize dns & ldap.

### Zones

#### dnshost

```
[root@cynic-global ~]# zonecfg -z dnshost
dnshost: No such zone configured
Use 'create' to begin configuring a new zone.
zonecfg:dnshost> create
zonecfg:dnshost> set zonepath=/local/zones/dbhost
zonecfg:dnshost> set autoboot=true
zonecfg:dnshost> add net
zonecfg:dnshost:net> set address=192.168.0.91
zonecfg:dnshost:net> set physical=qfe0
zonecfg:dnshost:net> end
zonecfg:dnshost> add net
zonecfg:dnshost:net> set address=136.206.15.91
zonecfg:dnshost:net> set physical=qfe1
zonecfg:dnshost:net> end
zonecfg:dnshost> add net
zonecfg:dnshost:net> set address=136.206.15.53
zonecfg:dnshost:net> set physical=qfe1
zonecfg:dnshost:net> end
zonecfg:dnshost> set pool=pool_default
zonecfg:dnshost> add rctl
zonecfg:dnshost:rctl> set name=zone.cpu-shares
zonecfg:dnshost:rctl> add value (priv=privileged,limit=5,action=none)
zonecfg:dnshost:rctl> end
zonecfg:dnshost> verify
zonecfg:dnshost> commit
zonecfg:dnshost> exit
```

#### ldaphost

```
[root@cynic-global ~]# zonecfg -z ldaphost
ldaphost: No such zone configured
Use 'create' to begin configuring a new zone.
zonecfg:ldaphost> create
zonecfg:ldaphost> set zonepath=/local/zones/ldaphost
zonecfg:ldaphost> set autoboot=true
zonecfg:ldaphost> add net
zonecfg:ldaphost:net> set address=192.168.0.92
zonecfg:ldaphost:net> set physical=qfe0
zonecfg:ldaphost:net> end
zonecfg:ldaphost> add net
zonecfg:ldaphost:net> set address=136.206.15.92
zonecfg:ldaphost:net> set physical=qfe1
zonecfg:ldaphost:net> end
zonecfg:ldaphost> set pool=pool_default
zonecfg:ldaphost> add rctl
zonecfg:ldaphost:rctl> set name=zone.cpu-shares
zonecfg:ldaphost:rctl> add value (priv=privileged,limit=5,action=none)
zonecfg:ldaphost:rctl> end
zonecfg:ldaphost> verify
zonecfg:ldaphost> commit
zonecfg:ldaphost> exit
```
