## Pools

#### ldap pool


	[root@murphy ~]# poolcfg -c 'create pset ldap-pset (uint pset.min=4; uint pset.max=4)'

The cpus here refer to vCPUs, of which murphy has 32 (8/4)


	[root@murphy ~]# poolcfg -c 'create pool ldap-pool'
	[root@murphy ~]# poolcfg -c 'associate pool ldap-pool (pset ldap-pset)'
	[root@murphy ~]# pooladm -c



#### web/db pool


	[root@murphy /local/zones]# poolcfg -c 'create pool webdb-pool'
	[root@murphy /local/zones]# poolcfg -c 'create pset webdb-pset (uint pset.min=4; uint pset.max=4)'
	[root@murphy /local/zones]# poolcfg -c 'associate pool webdb-pool (pset webdb-pset)'
	[root@murphy /local/zones]# poolcfg -c 'modify pool webdb-pool (string pool.scheduler="FSS")'
	[root@murphy ~]# pooladm -c








## Zones

#### web zone


	[root@murphy /local/zones]# zonecfg -z webhost
	webhost: No such zone configured
	Use 'create' to begin configuring a new zone.
	zonecfg:webhost> create
	zonecfg:webhost> set zonepath=/local/zones/webhost
	zonecfg:webhost> set autoboot=true
	zonecfg:webhost> add net
	zonecfg:webhost:net> set address=136.206.15.31
	zonecfg:webhost:net> set physical=e1000g0
	zonecfg:webhost:net> end

Repeat the last 4 lines for each address to be assigned


	zonecfg:webhost> set pool=webdb-pool
	zonecfg:webhost> add rctl
	zonecfg:webhost:rctl> set name=zone.cpu-shares
	zonecfg:webhost:rctl> add value (priv=privileged,limit=5,action=none)
	zonecfg:webhost:rctl> end
	zonecfg:webhost> add fs
	zonecfg:webhost:fs> set dir=/var/tmp
	zonecfg:webhost:fs> set special=/local/zones/webhost/vartmp
	zonecfg:webhost:fs> set type=lofs
	zonecfg:webhost:fs> end
	zonecfg:webhost> add fs
	zonecfg:webhost:fs> set dir=/var/log
	zonecfg:webhost:fs> set special=/local/zones/webhost/varlog
	zonecfg:webhost:fs> set type=lofs
	zonecfg:webhost:fs> end
	zonecfg:webhost> verify
	zonecfg:webhost> commit
	zonecfg:webhost> exit


#### db zone


	[root@murphy ~]# zonecfg -z dbhost
	dbhost: No such zone configured
	Use 'create' to begin configuring a new zone.
	zonecfg:dbhost> create
	zonecfg:dbhost> set zonepath=/local/zones/dbhost
	zonecfg:dbhost> set autoboot=true
	zonecfg:dbhost> add net
	zonecfg:dbhost:net> set address=136.206.15.32
	zonecfg:dbhost:net> set physical=e1000g0
	zonecfg:dbhost:net> end
	zonecfg:dbhost> set pool=webdb-pool
	zonecfg:dbhost> add rctl
	zonecfg:dbhost:rctl> set name=zone.cpu-shares
	zonecfg:dbhost:rctl> add value (priv=privileged,limit=2,action=none)
	zonecfg:dbhost:rctl> end
	zonecfg:dbhost> add fs
	zonecfg:dbhost:fs> set dir=/var/log
	zonecfg:dbhost:fs> set special=/local/zones/dbhost/varlog
	zonecfg:dbhost:fs> set type=lofs
	zonecfg:dbhost:fs> end
	zonecfg:dbhost> verify
	zonecfg:dbhost> commit
	zonecfg:dbhost> exit


#### ldap zone


	zonecfg:ldaphost> create
	zonecfg:ldaphost> set zonepath=/local/zones/ldaphost
	zonecfg:ldaphost> set autoboot=true
	zonecfg:ldaphost> add net
	zonecfg:ldaphost:net> set address=136.206.15.33
	zonecfg:ldaphost:net> set physical=e1000g0
	zonecfg:ldaphost:net> end
	zonecfg:ldaphost> add fs
	zonecfg:ldaphost:fs> set dir=/var/log
	zonecfg:ldaphost:fs> set special=/local/zones/ldaphost/varlog
	zonecfg:ldaphost:fs> set type=lofs
	zonecfg:ldaphost:fs> end
	zonecfg:ldaphost> set pool=ldap-pool
	zonecfg:ldaphost> verify
	zonecfg:ldaphost> commit
	zonecfg:ldaphost> exit
