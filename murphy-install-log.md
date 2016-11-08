### murphy_config

	
	install_type    initial_install
	system_type     server
	
	#
	# Disk Partitions
	#
	partitioning    explicit
	filesys         mirror:d10      c1t0d0s0        c1t1d0s0        4000    /
	filesys         mirror:d20      c1t0d0s2        c1t1d0s2        50000   /local
	filesys         c1t0d0s3        2000    swap
	filesys         c1t1d0s3        2000    swap
	filesys         c1t0d0s4        free    /fuckingpos
	filesys         c1t1d0s4        free    /solarisaids
	metadb          c1t0d0s5        size 8192       count 2
	metadb          c1t1d0s5        size 8192       count 2
	
	#
	# Sun Packages
	#
	cluster         SUNWCall        add
	cluster         SUNWCapache     delete
	cluster         SUNWapch2       delete
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
	cluster         SUNWCmozdeveloper       delete
	cluster         SUNWCsmba       delete
	cluster         SUNWCstaroffice delete
	cluster         SUNWCtcat       delete
	cluster         SUNWCxorglibs   delete
	cluster         SUNWCxorgserver delete
	cluster         SUNWCxscreensaver       delete
	


### rules.ok

	
	any - -    murphy_profile  -
	# version=2 checksum=2254


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
	




### installer output

	
	
	System identification complete.
	Starting Solaris installation program...
	Searching for JumpStart directory...
	Using rules.ok from 136.206.15.23:/export/jumpstart/.
	Checking rules.ok file...
	Using profile: murphy_profile
	Executing JumpStart preinstall phase...
	Searching for SolStart directory...
	Checking rules.ok file...
	Using begin script: install_begin
	Using finish script: patch_finish
	Executing SolStart preinstall phase...
	Executing begin script "install_begin"...
	Begin script install_begin execution completed.
	Processing default locales
	        - Specifying default locale (en_IE.UTF-8)
	
	Processing profile
	        - Selecting cluster (SUNWCall)
	        - Deselecting cluster (SUNWCapache)
	WARNING: Unknown cluster ignored (SUNWapch2)
	        - Deselecting cluster (SUNWCbrowser)
	        - Deselecting cluster (SUNWCbrowserdev)
	        - Deselecting cluster (SUNWCdtrun)
	        - Deselecting cluster (SUNWCdtts)
	        - Deselecting cluster (SUNWCdtusr)
	        - Deselecting cluster (SUNWCgnapps)
	        - Deselecting cluster (SUNWCgnbaslib)
	        - Deselecting cluster (SUNWCgndev)
	        - Deselecting cluster (SUNWCgndevlib)
	        - Deselecting cluster (SUNWCgnrun)
	        - Deselecting cluster (SUNWCgnex)
	        - Deselecting cluster (SUNWCmoz)
	        - Deselecting cluster (SUNWCmozdeveloper)
	        - Deselecting cluster (SUNWCsmba)
	        - Deselecting cluster (SUNWCstaroffice)
	        - Deselecting cluster (SUNWCtcat)
	        - Deselecting cluster (SUNWCxorglibs)
	        - Deselecting cluster (SUNWCxorgserver)
	        - Deselecting cluster (SUNWCxscreensaver)
	WARNING: Selected package is already selected (SUNWsshr)
	WARNING: Selected package is already selected (SUNWsshu)
	WARNING: Selected package is already selected (SUNWsshdr)
	WARNING: Selected package is already selected (SUNWsshdu)
	WARNING: Selected package is already selected (SUNWsshcu)
	WARNING: Selected package is already selected (SUNWman)
	        - Selecting locale (en_IE.UTF-8)
	WARNING: SUNWtltk depends on SUNWdtdmr, which is not selected
	WARNING: SUNWtltkd depends on SUNWdtbas, which is not selected
	
	WARNING: SUNWtsg depends on SUNWdtbas, which is not selected
	WARNING: SUNWmcc depends on SUNWdtbas, which is not selected
	WARNING: SUNWmcon depends on SUNWtcatu, which is not selected
	WARNING: SUNWgnome-a11y-base-libs depends on SUNWgnome-base-libs, which is not selected
	WARNING: SUNWipplr depends on SUNWapchr, which is not selected
	WARNING: SUNWacroread-plugin depends on SUNWmozilla, which is not selected
	WARNING: SUNWxorg-client-programs depends on SUNWxorg-clientlibs, which is not selected
	WARNING: SUNWxorg-tsol-module depends on SUNWxorg-server, which is not selected
	WARNING: SUNWxvnc depends on SUNWxorg-server, which is not selected
	WARNING: SUNWxvnc depends on SUNWxorg-clientlibs, which is not selected
	WARNING: SUNWxvnc depends on SUNWxorg-xkb, which is not selected
	WARNING: SUNWdtab depends on SUNWdticn, which is not selected
	WARNING: SUNWdtab depends on SUNWdtdte, which is not selected
	WARNING: SUNWdtab depends on SUNWdtdmn, which is not selected
	WARNING: SUNWdtab depends on SUNWdtbas, which is not selected
	WARNING: SUNWxwfa depends on SUNWdtbas, which is not selected
	WARNING: SUNWjmf depends on SUNWdtjxt, which is not selected
	WARNING: SUNWpmowu depends on SUNWdtdst, which is not selected
	WARNING: SUNWswupcl depends on SUNWgnome-panel, which is not selected
	WARNING: SUNWjmfmp3 depends on SUNWdtjxt, which is not selected
	WARNING: SUNWjre-config depends on SUNWmozilla, which is not selected
	WARNING: SUNWiiimr depends on SUNWgnome-base-libs-root, which is not selected
	WARNING: SUNWdtct depends on SUNWdticn, which is not selected
	WARNING: SUNWdtct depends on SUNWdtdte, which is not selected
	WARNING: SUNWdtct depends on SUNWdtbas, which is not selected
	WARNING: SUNWdtdem depends on SUNWdticn, which is not selected
	WARNING: SUNWdtdem depends on SUNWdtdte, which is not selected
	WARNING: SUNWdtdem depends on SUNWdtdmn, which is not selected
	WARNING: SUNWdtdem depends on SUNWdtbas, which is not selected
	WARNING: SUNWdtmaz depends on SUNWdtezt, which is not selected
	WARNING: SUNWevolution-libs depends on SUNWgnome-print, which is not selected
	WARNING: SUNWevolution-libs depends on SUNWgnome-config, which is not selected
	WARNING: SUNWevolution-libs depends on SUNWgnome-base-libs, which is not selected
	WARNING: SUNWevolution depends on SUNWmozilla, which is not selected
	WARNING: SUNWlxml-python depends on SUNWPython, which is not selected
	WARNING: SUNWlxsl-python depends on SUNWPython, which is not selected
	WARNING: SUNWpmowm depends on SUNWdtdst, which is not selected
	WARNING: SUNWfsexam depends on SUNWgnome-file-mgr, which is not selected
	WARNING: SUNWfsexam depends on SUNWgnome-panel, which is not selected
	WARNING: SUNWfsexam depends on SUNWgnome-config, which is not selected
	WARNING: SUNWfsexam depends on SUNWgnome-base-libs, which is not selected
	WARNING: SUNWfsexam depends on SUNWgnome-libs, which is not selected
	WARNING: SUNWgnome-a11y-libs depends on SUNWgnome-panel, which is not selected
	WARNING: SUNWgnome-a11y-libs depends on SUNWgnome-libs, which is not selected
	WARNING: SUNWgnome-a11y-gok depends on SUNWgnome-panel, which is not selected
	WARNING: SUNWgnome-a11y-libs-devel depends on SUNWgnome-libs-devel, which is not selected
	WARNING: SUNWpgadmin3 depends on SUNWxorg-clientlibs, which is not selected
	WARNING: SUNWpgadmin3 depends on SUNWgnome-base-libs, which is not selected
	WARNING: SUNWpostgr-82-pl depends on SUNWPython, which is not selected
	WARNING: SUNWpostgr-pl depends on SUNWPython, which is not selected
	WARNING: SUNWgnome-pilot depends on SUNWgnome-panel, which is not selected
	WARNING: SUNWserweb depends on SUNWapchr, which is not selected
	WARNING: SUNWswupclr depends on SUNWgnome-panel, which is not selected
	        - Selecting all disks
	        - Configuring boot device
	        - Configuring SVM State Database Replica on  (c1t0d0s5)
	        - Configuring SVM State Database Replica on  (c1t1d0s5)
	        - Configuring SVM Mirror Volume d10 on / (c1t0d0s0)
	        - Configuring SVM Mirror Volume d10 on  (c1t1d0s0)
	        - Configuring SVM Mirror Volume d20 on /local (c1t0d0s2)
	        - Configuring SVM Mirror Volume d20 on  (c1t1d0s2)
	        - Configuring swap (c1t0d0s3)
	        - Configuring swap (c1t1d0s3)
	        - Configuring /fuckingpos (c1t0d0s4)
	        - Configuring /solarisaids (c1t1d0s4)
	
	Verifying disk configuration
	
	Verifying space allocation
	        - Total software size:  2681.96 Mbytes
	
	Preparing system for Solaris install
	
	Configuring disk (c1t0d0)
	        - Creating Solaris disk label (VTOC)
	
	Configuring disk (c1t1d0)
	        - Creating Solaris disk label (VTOC)
	
	Creating and checking UFS file systems
	        - Creating / (c1t0d0s0)
	        - Creating /local (c1t0d0s2)
	        - Creating /fuckingpos (c1t0d0s4)
	        - Creating  (c1t1d0s0)
	        - Creating  (c1t1d0s2)
	        - Creating /solarisaids (c1t1d0s4)
	
	Creating SVM Meta Devices. Please wait ...
	        - Creating SVM State Replica on disk c1t0d0s5
	        - metadb: murphy: network/rpc/meta:default: failed to enable/disable SVM service
	        - Creating SVM State Replica on disk c1t1d0s5
	        - metadb: waiting on /etc/lvm/lock
	        - Creating SVM Mirror Volume d10 (/)
	        - Creating SVM Mirror Volume d20 (/local)
	
	Beginning Solaris software installation
	
	Starting software installation
	
	 [ snip lots of stuff ]
	
	Completed software installation
	
	Solaris 10 software installation succeeded
	
	Customizing system files
	        - Mount points table (/etc/vfstab)
	        - Network host addresses (/etc/hosts)
	        - Environment variables (/etc/default/init)
	
	Cleaning devices
	
	Customizing system devices
	        - Physical devices (/devices)
	        - Logical devices (/dev)
	
	Installing boot information
	        - Installing boot blocks (c1t0d0s0)
	        - Installing boot blocks (/dev/rdsk/c1t0d0s0)
	        - Installing boot blocks (/dev/rdsk/c1t1d0s0)
	
	Installation log location
	        - /a/var/sadm/system/logs/install_log (before reboot)
	        - /var/sadm/system/logs/install_log (after reboot)
	
	Installation complete
	        - Making SVM Mirror Volume as boot device (/dev/md/dsk/d10)
	Executing SolStart postinstall phase...
	Executing finish script "patch_finish"...
	
	
	Finish script patch_finish execution completed.
	Executing JumpStart postinstall phase...
	
	The begin script log 'begin.log'
	is located in /var/sadm/system/logs after reboot.
	
	The finish script log 'finish.log'
	is located in /var/sadm/system/logs after reboot.
	
	
	



### big shit we should get rid of

	
	SUNWmlib         mediaLib shared libraries 
	SUNWacroread     Acrobat Reader for PDF files 



### monday install-1

	
	
	Processing default locales
		- Specifying default locale (en_IE.UTF-8)
	
	Processing profile
		- Selecting cluster (SUNWCall)
		- Deselecting cluster (SUNWCapache)
		- Deselecting cluster (SUNWCapch2)
		- Deselecting cluster (SUNWCbrowser)
		- Deselecting cluster (SUNWCbrowserdev)
		- Deselecting cluster (SUNWCdtrun)
		- Deselecting cluster (SUNWCdtts)
		- Deselecting cluster (SUNWCdtusr)
		- Deselecting cluster (SUNWCgnapps)
		- Deselecting cluster (SUNWCgnbaslib)
		- Deselecting cluster (SUNWCgndev)
		- Deselecting cluster (SUNWCgndevlib)
		- Deselecting cluster (SUNWCgnrun)
		- Deselecting cluster (SUNWCgnex)
		- Deselecting cluster (SUNWCmoz)
		- Deselecting cluster (SUNWCmozdeveloper)
		- Deselecting cluster (SUNWCsmba)
		- Deselecting cluster (SUNWCstaroffice)
		- Deselecting cluster (SUNWCtcat)
		- Deselecting cluster (SUNWCxorglibs)
		- Deselecting cluster (SUNWCxorgserver)
		- Deselecting cluster (SUNWCxscreensaver)
		- Deselecting cluster (SUNWCevo)
		- Deselecting cluster (SUNWCevodev)
		- Deselecting cluster (SUNWCaudd)
		- Deselecting cluster (SUNWCbdb)
		- Deselecting cluster (SUNWCdtdev)
		- Deselecting cluster (SUNWCmlibdev)
		- Deselecting cluster (SUNWCmlibusr)
		- Deselecting cluster (SUNWCpostgr)
		- Deselecting cluster (SUNWCpostgr-dev)
		- Deselecting cluster (SUNWCpostgr-82)
		- Deselecting cluster (SUNWCpostgr-82-dev)
		- Deselecting cluster (SUNWCsppp)
		- Deselecting cluster (SUNWCtltk)
		- Deselecting cluster (SUNWCtltkp)
		- Deselecting cluster (SUNWCxwrte)
		- Deselecting cluster (SUNWCxwdev)
		- Deselecting cluster (SUNWCmozplugins)
		- Deselecting cluster (SUNWCgna11y)
		- Deselecting cluster (SUNWCgna11ydev)
	WARNING: Deselected package is already deselected (SUNWacroread-plugin)
	WARNING: Deselected package is already deselected (SUNWacroread)
	WARNING: Deselected package is already deselected (SUNWmlibt)
	WARNING: Deselected package is already deselected (SUNWmlib)
		- Selecting package (SUNWPython-share)
		- Selecting package (SUNWPython)
		- Deselecting package (SUNWpgadmin3)
		- Deselecting package (SUNWxvnc)
	WARNING: Deselected package is already deselected (SUNWdtab)
	WARNING: Deselected package is already deselected (SUNWdtdem)
		- Deselecting package (SUNWfsexam)
	WARNING: Deselected package is already deselected (SUNWgnome-pilot)
		- Deselecting package (SUNWdtct)
	WARNING: Unknown package ignored (SUNWiiimr)
		- Deselecting package (SUNWipplr)
		- Deselecting package (SUNWxorg-tsol-module)
	WARNING: Deselected package is already deselected (SUNWxorg-client-programs)
		- Deselecting package (SUNWserweb)
		- Deselecting package (SUNWswupclr)
		- Deselecting package (SUNWpmowm)
	WARNING: Deselected package is already deselected (SUNWdtmaz)
		- Deselecting package (SUNWjre-config)
		- Deselecting package (SUNWjmfmp3)
		- Deselecting package (SUNWswupcl)
		- Deselecting package (SUNWpmowu)
		- Deselecting package (SUNWjmf)
	WARNING: Deselected package is already deselected (SUNWxwfa)
		- Deselecting package (SUNWmcos)
		- Deselecting package (SUNWzfsgu)
		- Deselecting package (SUNWmcosx)
		- Deselecting package (SUNWasac)
		- Deselecting package (SUNWmcon)
		- Deselecting package (SUNWmcex)
		- Deselecting package (SUNWlvmg)
		- Deselecting package (SUNWlvmr)
		- Deselecting package (SUNWmddr)
		- Deselecting package (SUNWlvma)
		- Deselecting package (SUNWpmgr)
		- Deselecting package (SUNWmgts)
		- Deselecting package (SUNWdclnt)
		- Deselecting package (SUNWtsmc)
		- Deselecting package (SUNWrmui)
		- Deselecting package (SUNWwbmc)
		- Deselecting package (SUNWmc)
		- Deselecting package (SUNWmcc)
		- Deselecting package (SUNWtsr)
		- Deselecting package (SUNWtsu)
		- Deselecting package (SUNWtsg)
	WARNING: Deselected package is already deselected (SUNWtltkd)
		- Selecting locale (en_IE.UTF-8)
	WARNING: SUNWxwcft depends on SUNWxwplt, which is not selected
	WARNING: SUNWglrt depends on SUNWxwplt, which is not selected
	WARNING: FJSVglrt depends on SUNWxwplt, which is not selected
	WARNING: SUNWj3rt depends on SUNWxwplt, which is not selected
	WARNING: SUNWj3rt depends on SUNWxwice, which is not selected
	WARNING: SUNWj3rt depends on SUNWxwrtl, which is not selected
	WARNING: SUNWj5rt depends on SUNWxwplt, which is not selected
	WARNING: SUNWj5rt depends on SUNWxwice, which is not selected
	WARNING: SUNWj5rt depends on SUNWxwrtl, which is not selected
	WARNING: SUNWmga depends on SUNWwbmc, which is not selected
	WARNING: SUNWusb depends on SUNWaudd, which is not selected
	WARNING: SUNWTk depends on SUNWxwrtl, which is not selected
	WARNING: SUNWTk depends on SUNWxwplt, which is not selected
	WARNING: SUNWPython depends on SUNWxwplt, which is not selected
	WARNING: SUNWifbw depends on SUNWxwplt, which is not selected
	WARNING: SUNWimagick depends on SUNWxwplt, which is not selected
	WARNING: SUNWimagick depends on SUNWxwrtl, which is not selected
	WARNING: SUNWuxlcf depends on SUNWxim, which is not selected
	WARNING: SUNWuxlcf depends on SUNWxi18n, which is not selected
	WARNING: SUNWuxlcf depends on SUNWxwplt, which is not selected
	WARNING: SUNWvncviewer depends on SUNWxwplt, which is not selected
	WARNING: SUNWvtsts depends on SUNWxwplt, which is not selected
	WARNING: SUNWvtsts depends on SUNWxwrtl, which is not selected
	WARNING: SUNWxwman depends on SUNWxwplt, which is not selected
	WARNING: SUNWxwts depends on SUNWxwplt, which is not selected
	WARNING: SUNWxwfs depends on SUNWxwplr, which is not selected
	WARNING: SUNWxwoft depends on SUNWxwplt, which is not selected
	WARNING: SUNWfdl depends on SUNWxwplt, which is not selected
	WARNING: SUNWxwxft depends on SUNWxwxst, which is not selected
	WARNING: SUNWxwxft depends on SUNWxwplt, which is not selected
	WARNING: SUNWolrte depends on SUNWxwplt, which is not selected
	WARNING: SUNWolrte depends on SUNWtltk, which is not selected
	WARNING: SUNWjfbw depends on SUNWxwplt, which is not selected
	WARNING: SUNWowbcp depends on SUNWxwplt, which is not selected
	WARNING: SUNWi1cs depends on SUNWxwplt, which is not selected
	WARNING: SUNWlpmsg depends on SUNWtltk, which is not selected
	WARNING: SUNWeuodf depends on SUNWxwacx, which is not selected
	WARNING: SUNWeuodf depends on SUNWxwplt, which is not selected
	WARNING: SUNWeuxwe depends on SUNWxim, which is not selected
	WARNING: SUNWeuxwe depends on SUNWxi18n, which is not selected
	WARNING: SUNWeuxwe depends on SUNWxwplt, which is not selected
	WARNING: SUNWgldoc depends on SUNWxwplt, which is not selected
	WARNING: SUNWglh depends on SUNWxwplt, which is not selected
	WARNING: SUNWnfbcf depends on SUNWxwrtl, which is not selected
	WARNING: SUNWnfbcf depends on SUNWxwplt, which is not selected
	WARNING: SUNWnfbw depends on SUNWxwplt, which is not selected
	WARNING: SUNWpfbw depends on SUNWxwplt, which is not selected
	WARNING: SUNWplow depends on SUNWxi18n, which is not selected
	WARNING: SUNWplow1 depends on SUNWxi18n, which is not selected
	WARNING: SUNWi1of depends on SUNWxwplt, which is not selected
		- Selecting all disks
		- Configuring boot device
		- Configuring SVM State Database Replica on  (c1t0d0s5)
		- Configuring SVM State Database Replica on  (c1t1d0s5)
		- Configuring SVM Mirror Volume d10 on / (c1t0d0s0)
		- Configuring SVM Mirror Volume d10 on  (c1t1d0s0)
		- Configuring SVM Mirror Volume d20 on /local (c1t0d0s2)
		- Configuring SVM Mirror Volume d20 on  (c1t1d0s2)
		- Configuring swap (c1t0d0s3)
		- Configuring swap (c1t1d0s3)
		- Configuring /fuckingpos (c1t0d0s4)
		- Configuring /solarisaids (c1t1d0s4)
	


