# Murphy suPHP setup

In the end I had to compile murphy's suphp manually. It turns out the ubuntu/debian developers were asleep and missed out on a couple of security patches over the last couple of..er..years.. (from reading the debian changelogs). We also need multiple docroot support so we can have the main Redbrick site on local disks, reducing the strain on minerva.

It's packaged using apt, using the original packaging scripts.

## Before you begin

Before you begin, and possibly break apache, you'll want the source of the currently installed version, and the build scripts. If this is still my own version, you can get them at:

http://www.redbrick.dcu.ie/~werdz/suphp_0.6.3-2redbrick1.tar.gz
http://www.redbrick.dcu.ie/~werdz/suphp_0.6.3-2redbrick1.dsc

If apache is already broken, you have my permission to manually cp ~werdz/public_html/suphp-0.6.3-2redbrick1.tar.gz, etc :)

## Compiling

*This is what I did. You'll need to use the source debs for my version if you're recompiling again.. or at least preserve the changelog entries and versioning). See "Before you begin" above.*

Downloaded the old source debs (for the build scripts)
 
    apt-get source libapache2-mod-suphp

Installed build deps

    apt-get build-deps libapache2-mod-suphp

Downloaded and extracted latest suphp (0.6.3 at time of writing).

Extract the tar file provided by apt-get source (0.6.1 at time of writing), cd into it.

    cd suphp-0.6.1

Copy the source code from the newer version in here, so you've got the new source and old build scripts.

    cp -r ../suphp-0.6.3/* .

Add an entry to the changelog.

    vim debian/changelog

Apply the multi docroot patch

    patch < multi-docroot.patch
    (enter src/Application.cpp)

Edit src/apache2/mod_suphp.c to allow config directives in the apache configs. Find the line that looks like:
    
    AP_INIT_ITERATE("suPHP_AddHandler", suphp_handle_cmd_add_handler, NULL, ACCESS_CONF, "Tells mod_suphp to handle these MIME-types"),

And change ACCESS_CONF to ACCESS_CONF | RSRC_CONF.

You might also want to change the line below it.

Build the package.

    dpkg-buildpackage -rfakeroot -uc -b

Install the packages (suphp-common and libapache2-mod-suphp) created. They'll be created in the folder above the current one. You'll get errors about dependencies (they depend on each other). Run apt-get install -f after running dpkg -i on **both of them** to fix this.

Reload apache. Cry over any errors you get for a while. Enjoy your new suPHP.

## References

ACCESS_CONF | RSRC_CONF thing:\\
http://lists.marsching.com/pipermail/suphp/2005-June/000876.html

Multi-docroot patch:\\
http://lists.marsching.com/pipermail/suphp/2006-June/001301.html

-werdz\\
20/04/08
