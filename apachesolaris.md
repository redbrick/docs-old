## Compile options

Yick, this was out of date.

Our Apache is managed by RSPM. The package name is RBapache22.

The build script is as follows:

    export PATH=/usr/bin:/usr/sbin:/bin:/usr/ccs/bin:/usr/sfw/bin
    ./configure \
   --prefix=/usr/redbrick/apache2 \
   --sysconfdir=/etc/apache2 \
   --enable-rewrite=shared \
   --enable-headers=shared \
   --enable-proxy=shared \
   --enable-proxy-http=shared \
   --enable-ssl=static \
   --with-mpm=prefork \
   --enable-suexec \
   --with-suexec-docroot=/storage/webtree \
   --with-suexec-logfile=/var/log/apache2/suexec.log \
   --with-suexec-caller=webservd

(this is in /usr/redbrick/rspm/packages.dat).

## Notes


*  mod_ssl is compiled statically to ensure that libssl.so loads before pubcookie does; pubcookie doesn't like waking up with no SSL library loaded.

*  Using the prefork mpm - suphp appears to run into threading issues with the worker mpm.

*  Suexec needs the calling username (apache's username - webservd) to be set as a compile-time option. If this ever changes, the compile option needs to change.

## Configuration files

The configuration files in ''/etc/apache2'' have been replaced with the old deathray (debian layout) files, and ''apache2.conf'' was simply ''Include''d from ''httpd.conf''. We're still using the ''mods-available'' and ''sites-available'' system for enabling and disabling shared modules and vhosts. I used a quick and dirty perl script to fix path errors in the mods-available/*.load files. 

Apache is running under the ''webservd'' user and group on Solaris.

//[RedBrick Admin Team](admins@redbrick.dcu.ie) 2009/06/05 02:13//
