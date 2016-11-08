Eventually in your special assignment as RedBrick System Administrator you will have to install some new hardware. This is a list of things you should know (and, I'd know, I installed a lot of these damn machines)

## Starter For 10


*  Have you installed Ubuntu?
    * Excellent, now for gods sake fix the gids for Redbrick groups before you do anything else

*  Have you installed OpenBSD?

*  If not why not?


# Debian/Ubuntu

###  Partioning 

Everything that !root can write to should be on its own partition. For a user machine, this is /var, and /tmp. You probably want /var/tmp on its own partition too. These should all be mounted *at least* no suid.

### GIDs

The default dynamically allocated GIDs overlap with the RedBrick ldap GIDs. You should place the RedBrick GIDs in /etc/group and resolve and conflicts as soon as the install is complete, and resolve any conflicts.

### Packages

2015-Ubuntu 14.04-These are now defunct.

As of July 2009 most of the basic setup can be handled by the [redbrick packages](redbrick-apt). For login servers, install redbrick-login-server, otherwise just install redbrick-server.

### MOTD Amusement

The motd on login machines is handled by the redbrick-motd package, which is a dependency of redbrick-login-server. This will provide the script and all necessary files. All you need to do is set the machine name in /etc/motd.footer. Running the `/etc/init.d/motd script`  will ensure the permissions are correct (committee need write access). This script will update the motd when the machine starts. Daily updates will be ran by /etc/cron.daily/000updatemotd

It is RedBrick policy that all non LDAP machines should have stupid ascii art motd messages. Since you're doing the install, you get to pick the art. Putting useful information in the motd is completely optional. It will however, wipe your motd on boot. Telling it not to do this seems to, em, do nothing. Simple fix is to make a backup and restore it from /etc/rc.local

Since karmic, Ubuntu has decided to do crazy shit with the motd. This is not desired. Comment out pam_motd in /etc/pam.d/ssh and /etc/pam.d/login

### Nagios NRPE

This is configured by the package install (redbrick-nagios-nrpe), and shouldn't need any additional configuration. In the case of new machines you will need to add them to the nagios host (currently halfpint).


#### Adding hosts to nagios

Add it as a host to /usr/local/etc/nagios/servers/hosts.cfg (with it's internal IP address), and add it to the relevant hostgroup (by OS) in /usr/local/etc/nagios/servers/host_groups.cfg. You'll also have to add something like this to get it to check the external interface as well.

	
	define service{
	        use                             redbrick-service                ; Name of service template to use   
	        host_name                       `<New Machine Host Name>`
	        normal_check_interval            5
	        service_description             External PING
	        check_command                   check_secondary_ping!`<new machine external address>`!100.0,20%!500.0,60%
	        notes                           This is pinging Carbon's external interface, 136.206.15.1
	        }


### Check /root permissions

The default ubuntu does this:

    % ls -ld /root
    drwxr-xr-x 4 root root 4.0K 2009-01-02 02:33 /root

The redbrick-root-env package will reset these permissions, all you have to do is check.



### exim, and how to make it "just work" (tm)

Lucky you. Despite debian's best efforts to make configuring exim a massive pain your job is fairly easy. Just dkpg-reconfigure exim-config and tell it that you have a smarthost which is mailhost.redbrick.dcu.ie. Unless of course the machine you're installing is mailhost.redbrick.dcu.ie, in which case you should refer to the previous exim.conf.

To ensure that the exim doesn't try deliver to hostname.redbrick.dcu.ie (which, won't be accepted), set the fqdn in the section of 'other hosts to accept mail for'. This will ensure it gets redirected to @redbrick.dcu.ie when sent. Don't ask me how this works, the config thing is complicated.

The dpkg set options are stored in /etc/update-exim4.conf.conf. You shouldn't edit this, but you can compare it against other machines to see if it's right.

### Logwatch

This is installed and configured by the redbrick-logwatch package. 

You can add your own scripts etc. to logwatch. Just put them in /etc/logwatch/scripts/services and then put a config file in /etc/logwatch/conf/services (or add them to the package if they're to be deployed everywhere). If this is going to be on more than one machines then the existing logwatch packages can be easily used as templates to build a new one. 

If this is a big login box you'll probably want to hack the users logging in via ssh out of the ssh script, or you'll get a load of crap you don't want. 


### fail2ban

This will annoy anyone who tries to brute force ssh you. The defaults are fairly fine. Generally we whitelist redbrick ip addresses to stop one person accidentaly blocking access to a machine from a machine.

	
	[root@cn /etc/fail2ban]# cat jail.local 
	[DEFAULT]
	
	ignoreip = 136.206.15.0/24 192.168.0.0/24 127.0.0.1


Fail2ban is automatically installed as a redbrick-server dependency.


### Backups

Apparently these are important. Read the [dirvish](dirvish) docs for how to set this up.

### syslog-ng

All machines should have syslog-ng running to do remote logging to halfpint. This is nicely packaged on debian/openbsd systems, and installing it does almost all of the config you need.

Syslog-ng is installed by redbrick-server, but it doesn't lend itself well to handling the config file via the package system, so that's still done manually.

#### Remote logging

To setup remote logging add this to the bottom of /etc/syslog-ng/syslog.ng.conf

	
	##################################################
	############### LOG to remote host ###############
	##################################################
	destination loghost {
	        tcp("log.internal" port(514));
	};
	
	log { 
	        source(s_src); 
	        destination(loghost); 
	};


You should also add log.internal to /etc/hosts

### cron.log

Syslog-ng has settings to put cron stuff into it's own log, but these are commented out. You can use this to stop users cronjobs cluttering syslog.

	
	# this is commented out in the default syslog.conf
	# cron.*                         /var/log/cron.log
	#log {
	#        source(s_all);
	#        filter(f_cron);
	#        destination(df_cron);
	#};   


Simple enough, uncomment this.

Next you'll need to edit the syslog filter, or they'll just appear in both locations. Make your syslog filter look like this:

	
	# all messages except from the auth and authpriv & cron facilities
	filter f_syslog { not facility(auth, authpriv, cron); };


### snoopy

If the system is running snoopy then set it so that those logs are only sent to b4 and not kept locally.

The use of the final flag means that **order matters**. The final flag is no good if you've already sent the data to a local file (authpriv, in this case at least) somewhere further up in the config. 

	
	filter f_snoopy {
	        program("snoopy");
	};
	--
	log {   
	        source(s_all);
	        filter(f_snoopy);
	        destination(loghost);
	        #don't let this stuff get into any other logs.
	        flags(final);
	};


### OpenNTPD

NTP is cool. Openntpd should be installed everywhere (unless you manually installed something else), just set the server to time.dcu.ie


### LDAP config

If you want users to login you'll need to setup the machine to auth off ldap. To do this, you first need to install libpam_ldap, libnss_ldap and ldap-utils. Go through DPKG configure, and set root as the local admin, set the base dn to o=redbrick and the root dn to cn=root,ou=ldap,o=redbrick. Once you've got this done, edit /etc/ldap/ldap.conf to add the correct ldap server, ensure /etc/ldap/ldap.conf has similar ldap servers, and edit /etc/nsswitch.conf to add ldap to group, shadow and passwd. Also, add the ldap root password in /etc/ldap.secret, and **check it's chmoded so no one but root can read it**

Ensure that "pam_password exop" is set in /etc/ldap.conf (or /etc/pam_ldap.conf on debian) or bad things will happen when people change their password. You should also set pam_min_uid to 1. in the same file.

### sshd

Root ssh should be disabled in /etc/ssh/sshd_config. You have to set this option.


### Munin

Set the host and allow lines in munin-node.conf. If this is a new machine it will need to be added to the munin server. 


# Other systems

Mostly, do the same as debuntu...

### /bin/sh is melting my brain

If you have installed Solaris (my apologies if you have), you'll have noticed that sh is a pile of shite, and that su --shell isn't supported. Luckily you can script your way out of this horrid mess.

    [root@murphy ~]# cat .profile

	:::bash
	  logname=`tail -1 /var/adm/sulog|awk -F"-" '{print $1}'|awk '{print $6}'`
	  /usr/bin/echo "Enter Logname [$logname] \c"
	  read logname2
	  if [ -n "$logname2" ]; then
	        logname=$logname2
	  fi       
	  LOGNAME=$logname
	  export LOGNAME
	  if [ -f /root/.zshrc.$logname ]; then
	        exec zsh
	  else
	        exec bash
	  fi


Then just "su -" and you'll get a sensible shell, and your logname will be preserved.

On ubuntu, this is handled by redbrick-root-env.


### Exim

   * Install Exim from somewhere. 
   * Go through the config file and fill out primary_hostname & qualify_domain (should be redbrick.dcu.ie) along with whatever else takes your fancy.
   * Unless you know what you're doing don't touch the acl section.
   * Delete the Routers & Transports section 
   * Put this in it's place:

	
	######################################################################
	#                      ROUTERS CONFIGURATION                         #
	#               Specifies how addresses are handled                  #
	######################################################################
	
	begin routers
	
	send_to_gateway:
	  driver = manualroute
	  domains = !+local_domains
	  transport = remote_smtp
	  route_list = "* mailhost.ipv4.redbrick.dcu.ie "
	  fallback_hosts =  mailhost2.ipv4.redbrick.dcu.ie : mailhost.ipv6.redbrick.dcu.ie : mailhost2.ipv6.redbrick.dcu.ie 
	
	#
	# Just send all mail to a proper mailhost. Don't do any local delivery shite.
	#
	######################################################################
	#                      TRANSPORTS CONFIGURATION                      #
	######################################################################
	#                       ORDER DOES NOT MATTER                        #
	#     Only one appropriate transport is called for each delivery.    #
	######################################################################
	# A transport is used only when referenced from a router that successfully
	# handles an address.
	begin transports
	# This transport is used for delivering messages over SMTP connections.
	remote_smtp:
	  driver = smtp

    

    * Don't touch anything else, unless you want to ;)
    * If you're scripting this to run as a service the options you probably want are:
    /path/to/exim -bd -q10m

On OpenBSD it's nicely packaged, on Solaris it's not. You can get one from blastwave (it's in use on murphy at the time of writing), or you could build your own. I build 4.69 for murphy, there's a tar with instructions in /srv/admin/src (unless someone deleted it)


### bug in fail2ban init script

This has been fixed in debian/ubuntu, but still appears in freeBSD (py26-fail2ban-0.8.4)

--


If /usr/local/etc/rc.d/fail2ban on FREEBSD hangs after:

	
	2010-05-10 17:49:04,561 fail2ban.server : INFO   Starting in daemon mode


Then simply create /var/run/fail2ban and run the init script again.

--

Below is the old fix for ubuntu/debian fail2ban init script

	:::bash
	do_start()
	{
	        #Add this at top of do_start
	        do_status && return 1
	
	        # hack by receive, jul 08
	        if [ ! -d /var/run/fail2ban ]
	        then
	                mkdir /var/run/fail2ban
	        fi
	        
	        #Rest of the original do_start code should be kept as is
	}



### Automated Mails

All automated mail (logwatch equivelents etc.) should be sent to system-reports@, preferably around 12.30am

