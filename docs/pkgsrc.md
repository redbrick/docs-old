# pkgsrc on Murphy

[pkgsrc](http://www.netbsd.org/docs/pkgsrc/) is the NetBSD ports collection. NetBSD being the portability-crazy project that it is made their ports collection compatible with a whole load of OSes, including Solaris. This may be a viable alternative to Blastwave.


*  Installed in /usr/pkgsrc. Binaries go to /usr/pkg. Set your path to /usr/pkg/bin:/usr/pkg/sbin:$PATH if you want to do anything or try anything out.

*  Always use bmake (BSD make) instead of make (Solaris make)!!!

*  GCC isn't installed from ports, it's installed from the Solaris DVD. Please don't install pkgsrc (BSD) GCC unless there's a good reason - it'll mean you'll have to recompile all packages once you do, as BSD gcc will suddenly be ahead of SUNW gcc in your path and there'll be various limbs flying all over the place.

*  A logwatch section that calls pkg_chk -u -q has been added to /etc/logwatch/scripts/services/blastwave

*  Cron calls /srv/admin/scripts/update_pkgsrc.sh every night at 1am to update the ports tree using cvs.

## Installing a port

For an example, we'll install vim.

Make sure your shell is set up properly, and pkgsrc is in your path (the following lines might be optional):

    export HTTP_PROXY=http://proxy.dcu.ie:8080
    export PATH=/usr/pkg/bin:/usr/pkg/sbin:$PATH

Install the port:

    cd /usr/pkgsrc/editors/vim
    bmake install
    bmake clean

Tada!

## Updating all ports

Make sure your shell is set up properly, and pkgsrc is in your path (the following lines might be optional):

    export HTTP_PROXY=http://proxy.dcu.ie:8080
    export CVS_RSH=ssh
    export PATH=/usr/pkg/bin:/usr/pkg/sbin:$PATH

Update the ports tree from CVS.

    cd /usr/pkgsrc
    tsocks cvs update -dP

Use pkg_chk to check required updates.

    pkg_chk -u -q

Use pkg_chk to install all updates (from source).

    pkg_chk -u -s


## Updating a single package

First, update the ports tree as above. Make sure HTTP_PROXY is set right. Then update the port. 

In this example, we'll update vim.

    cd /usr/pkgsrc/editors/vim
    bmake update
    bmake clean

Done!

There's another ninety or so ways of upgrading packages on pkgsrc. I find the above method the nicest. Others are described [here](http://wiki.netbsd.se/How_to_upgrade_packages) and you can find much more information at [the pkgsrc guide](http://www.netbsd.org/docs/pkgsrc/).
