### sysidcfg


	system_locale=en_IE.UTF-8
	install_locale=en_IE.UTF-8
	timezone=Eire
	timeserver=localhost
	terminal=vt100
	name_service=NONE
	security_policy=NONE
	network_interface=e1000g0 { hostname=murphy
	                        netmask=255.255.255.0
	                        protocol_ipv6=no
	                        default_route=136.206.15.254 }




### rules.ok


	any - -    murphy_profile  -
	# version=2 checksum=2254



### murphy_profile


	install_type    initial_install
	system_type     server

	#
	# Disk Partitions
	#
	partitioning    explicit
	filesys         mirror:d10      c1t0d0s0        c1t1d0s0        6000    /
	filesys         mirror:d20      c1t0d0s1        c1t1d0s1        56000   /local
	filesys         c1t0d0s2        4000    swap
	filesys         c1t1d0s2        4000    swap

	filesys         c1t0d0s3        1500    /local/zones/noraid/webhost/vartmp
	filesys         c1t0d0s4        free    /tmp
	filesys         c1t0d0s5        500     /var/tmp


	filesys         c1t1d0s3        500     /local/zones/noraid/webhost/tmp
	filesys         c1t1d0s4        free    /local/zones/noraid/webhost/cache
	filesys         c1t1d0s5        500     /local/zones/noraid/dbbhost/vartmp
	filesys         c1t1d0s6        500     /local/zones/noraid/dbbhost/tmp


For the mad looking mounts, i just wanted to create the partitions during the install.

They've all been deleted, and the devices are added directly to the zone



	metadb          c1t0d0s6        size 8192       count 2
	metadb          c1t1d0s7        size 8192       count 2

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
	cluster         SUNWCevo        delete
	cluster         SUNWCevodev     delete
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
