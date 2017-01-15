# Pubcookie

This page document's [murphy](murphy)'s pubcookie setup. This has changed a little since RSPM took over.


## How it was compiled

RSPM manages the pubcookie build. This is the build script:

    #!/bin/bash
    
    # Fix configure script
    sed 's/ln -sf/ln -s/' configure > configure.solaris
    mv configure configure.gnuln
    mv configure.solaris configure
    chmod 755 configure
    
    ./configure \
   --prefix=/usr/redbrick/pubcookie \
   --enable-login \
   --enable-ldap \
   --with-ldap-dir=/usr/redbrick/openldap24 \
   --enable-apache \
   --with-apxs=/usr/redbrick/apache2/bin/apxs \
   --with-ssl=/usr/sfw
    
    make
    make install
    
    cp -Prp /usr/redbrick/apache2/modules/mod_pubcookie.so /usr/redbrick/pubcookie/



Things to note:

*  The configure script is incompatible with Solaris's ln utility. The sed and mv's at the start replace every occurence of "ln -sf" with "ln -s". This seems to work just fine.

*  We use LDAP libraries (also managed by RSPM) to auth users. LDAP settings are configured under the pubcookie config file.


## Configuration

Pubcookie requires its own SSL cert for the authentication server (the thing triggered by inetd running on port 2222). We use a self-signed cert for this.


## Adding inet service entry

Solaris 10 is awkward and doesn't use inetd anymore, but there is a utility to convert inetd.conf entries to SMF.
First, add the following line to /etc/inet/services:

    pubcookie 2222/tcp

Then add the following to /etc/inet/inetd.conf (yes, it's read only. Use w! in vim to make it ignore this).

    pubcookie stream tcp nowait root /usr/wherever/pubcookie/keyserver keyserver

Then run:

    inetconv

The SMF thingy should then be created.

Documentation for the exact format of inetd.conf is at http://docs.sun.com/app/docs/doc/816-5174/inetd.conf-4?l=en&a=view&q=inetd.conf+solaris+10


