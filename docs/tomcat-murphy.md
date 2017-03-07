## Building Tomcat

Tomcat is build with [rspm](rspm). If there is an /etc/tomcat the config will be preserved, else /etc/tomcat will be created with with defaults.

### SVCADM

Tomcat is in svcadm. I wrote the files based on [this example](http://dubdubdub.co.uk/wiki/solaris/SMF). You should only have to touch these if you re-install murphy.
For obvious reasons the package will not go near these files.


	[root@murphy /lib/svc/method]# cat /lib/svc/method/tomcat
	#!/sbin/sh
	#
	#

	. /lib/svc/share/smf_include.sh

	TOMCAT_HOME=/usr/redbrick/tomcat
	TOMCAT_USER=tomcat
	
	case "$1" in
	start)
	        su - ${TOMCAT_USER} -c "${TOMCAT_HOME}/bin/startup.sh"
	        ;;
	stop)
	        su - ${TOMCAT_USER} -c "${TOMCAT_HOME}/bin/shutdown.sh"
	        ;;

	*)
	        echo "Usage: $0 {start|stop}"
	        exit 1
	        ;;
	esac


	[root@murphy /lib/svc/method]# cat /var/svc/manifest/site/tomcat.xml
	`<?xml version="1.0"?>`
	`<!DOCTYPE service_bundle SYSTEM "/usr/share/lib/xml/dtd/service_bundle.dtd.1">`
	<!--
	    Copyright 2004 Sun Microsystems, Inc.  All rights reserved.
	    Use is subject to license terms.

	    ident       "@(#)http-apache2.xml   1.2     04/11/11 SMI"
	-->

	`<service_bundle type='manifest' name='SUNWcsr:coreadm'>`
	<service
	        name='site/tomcat'
	        type='service'
	        version='1'>

	        <!--
	          Because we may have multiple instances of network/http
	          provided by different implementations, we keep dependencies
	          and methods within the instance.
	        -->

	        `<create_default_instance enabled='true' />`
	        `<single_instance />`

	        <dependency name='loopback'
	            grouping='require_all'
	            restart_on='error'
	            type='service'>
	                `<service_fmri value='svc:/network/loopback:default'/>`
	        `</dependency>`

	        <dependency name='physical'
	            grouping='optional_all'
	            restart_on='error'
	            type='service'>
	                `<service_fmri value='svc:/network/physical:default'/>`
	        `</dependency>`

	        <dependency name='filesystem'
	                grouping='require_all'
	                restart_on='none'
	                type='service'>
	                <service_fmri
	                        value='svc:/system/filesystem/local' />
	        `</dependency>`

	        <exec_method
	                type='method'
	                name='start'
	                exec='/lib/svc/method/tomcat6 start'
	                timeout_seconds='60' />

	        <exec_method
	                type='method'
	                name='stop'
	                exec='/lib/svc/method/tomcat6 stop'
	                timeout_seconds='60' />

	        `<stability value='Stable' />`

	        `<template>`
	                `<common_name>`
	                        `<loctext xml:lang='C'>`
	                                Tomcat v6.0 application server
	                        `</loctext>`
	                `</common_name>`
	        `</template>`
	`</service>`
	`</service_bundle>`
