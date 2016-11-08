#  peepd 

[Peepd](http://code.google.com/p/peepd/) is a twitter/irc gateway (like bitlbee) written and maintained by atlas.

It runs on [morpheus](morpheus) and listens on peepd.internal. Since port 6667 is open to the internet this shouldn't be ran on the external network. 

	
	[receive@minerva ~]% host twitter
	twitter.redbrick.dcu.ie is an alias for peepd.redbrick.dcu.ie.
	peepd.redbrick.dcu.ie is an alias for peepd.internal.
	peepd.internal has address 192.168.0.79


The listen address is set via /etc/default/peepd

	
	[root@morpheus ~]# cat /etc/default/peepd
	#    -p, --port <port number     Specify the port number to listen on, default 6667
	#    -a, --address `<ip address>`  Specify the IP address to listen on, default 127.0.0.1
	#    -d, --no-daemon             Don't detach and run as a daemon
	#    -P, --pid-file              Specify a PID file to use
	
	# Put your own arguments here if required
	DAEMON_ARGS=" -a 192.168.0.79  "


The [peepd package](redbrick-apt) is in packages.redbrick, and maintained by receive.

## Dependencies

Peepd depends on python-twitter v0.6. Currently no version of python-twitter is available for hardy heron, v0.5 is in intrepid/jaunty, and v0.6 is in karmic.

	
	Package: python-twitter
	Version: 0.5.999
	Architecture: all
	Installed-Size: 264
	Depends: python, python-simplejson, python-support (>= 0.7.1)
	Homepage: http://code.google.com/p/python-twitter/
	Priority: optional
	Section: python
	Filename: pool/redbrick/p/python-twitter/python-twitter_0.5.999_all.deb
	Size: 30864
	SHA1: 215f26f1df6e2b4dfc382669e909fdc6478270d7
	MD5sum: 150b02bb7dd94d302ff9c00303ce8b74
	Description: Twitter API wrapper for Python
	 This library provides a pure Python interface for the Twitter API.
	 .
	 Twitter provides a service that allows people to connect via the web, IM, and
	 SMS. Twitter exposes a web services API (http://twitter.com/help/api) and this
	 library is intended to make it even easier for Python programmers to use.
	Original-Maintainer: Mauro Lizaur `<mauro@cacavoladora.org>`
	Python-Version: 2.4, 2.3, 2.5


This is actually version 0.6, which has been rebuilt from the karmic source package. I had to break the build dependencies to do this, but it seems to work just fine. The version number is set to 5.999 so that any release of 0.6 will be used in preference to this package.

I have [requested a backport](https///bugs.launchpad.net/hardy-backports/+bug/403791) of python-twitter for hardy. 

	
	Package: peepd
	Version: 0.13
	Architecture: all
	Depends: bash, python, python-twitter ( >= 0.5.999 )
	Source: peepd
	Priority: extra
	Section: redbrick
	Filename: pool/redbrick/p/peepd/peepd_0.13_all.deb
	Size: 8060
	SHA1: 1f17b8d0bbee60d8cf0282baeda8a3923ea51604
	MD5sum: 546473ee5d83f4d4914409e2e5503d44
	Description: Twitter IRC Gateway


The peepd package depends on my python-twitter package at a minimum. It just crashes horribly trying to run on python-twitter 0.5.

## Patches

These are only necessary if rebuilding a new version of the package from the google code source. Hopefully these will be integrated into a release of peepd in the recent future.

### Syslog

Peepd dumps lots of output to stdout/stderr, even in daemon mode. The init script uses ''start-stop-daemon --background'' so none of peepd's output is ever seen, but I've patched it for syslog so that the log can be used for debugging. 

http://code.google.com/p/peepd/issues/detail?id=6#c0

	
	--- peep.py     2009-07-22 02:51:37.000000000 +0100
	+++ peep-receive2.py    2009-07-24 02:04:50.467050922 +0100
	@@ -1,7 +1,7 @@
	 #!/usr/bin/python
	 # vim: noexpandtab
	
	-import socket, string, time, twitter, sys, getopt, os, logging, urllib2, traceback
	+import socket, string, time, twitter, sys, getopt, os, logging, urllib2, traceback, syslog
	 from threading import Thread
	
	 # Ubuntu/Debian sets the default character encoding as ascii, and then
	@@ -11,6 +11,12 @@
	 reload(sys)
	 sys.setdefaultencoding("utf-8")
	
	+# Patches from receive. We want all output going to syslog
	+class logerr:
	+    def write(self, data):
	+        syslog.syslog('%s' % data)
	+
	+
	 # Create a decorator for wrapping functions in try/except blocks
	 def trycatch(func):
	        def new_func(*args, **kwargs):
	@@ -359,8 +365,14 @@
	
	
	        if not NOFORK:
	+               syslog.openlog('peepd[%u]' % os.getpid() )
	+               sys.stderr=logerr()
	+               sys.stdout=logerr()
	                fork()
	
	+       sys.stderr.write("Starting in Debug Mode\n")
	+
	+
	        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	        try:


This output is fairly long, so syslog is setup to filter it out to it's own log. The peepd package doesn't handle the syslog configuration. Future versions of the peepd package will include a logrotate file though.

	
	#syslog-ng.conf
	destination df_peepd { file("/var/log/peepd.log" group("peepd")); };
	filter f_peepd { program("peepd"); };
	log {   
	        source(s_all);
	        filter(f_peepd);
	        destination(df_peepd);
	        #don't let this stuff get into any other logs.
	        flags(final);
	};



### PID File

The pid_file argument doesn't work yet. This causes problems.

http://code.google.com/p/peepd/issues/detail?id=7

	
	 def fork(pid_file = None):
	
	        if pid_file == None:
	-                pid_file = "/tmp/%s.lock" % sys.argv[0]
	+                pid_file = "/var/run/peepd/peepd.lock
	        try:
	 

