Note: As of January 2009 we are running packaged exim from blastwave. While useful, the stuff below doesn't reflect what's currently in use.


### Exim on Solaris

There's a tarball of this built in /srv/admin/src. Just "make install"

The default config file is placed in /etc/exim.conf if it does not exist. This fine should be fairly sane. It's here in src/configure_default. The vanilla config is in the doc/ directory (as are the exim readme stuff)

The script for smf will automagically be copied to the exim bin directory if one does not already exist there.

When install has completed sucessfully run "svccfg import exim-smf.xml" to import it.

This relies on the sendmail user existing as it does normally. Obviously you should disable sendmail.
