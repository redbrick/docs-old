# Murphy MySQL client bug

**Note: This has been fixed in modern libc (or at least, the libc that comes with Debian Lenny).**

There exists a bug in the mysql client library distributed with ubuntu for SPARC platforms. It causes a bus error if you specify the server name by a hostname that must be resolved. 

Launchpad bug report is available at [https://bugs.launchpad.net/ubuntu/+source/mysql-dfsg-5.0/+bug/179905](https///bugs.launchpad.net/ubuntu/+source/mysql-dfsg-5.0/+bug/179905).

## Solution

### Get the source code

Download the package source code, along with all of the Debian and Ubuntu patches (doesn't have to be run as root).

''apt-get source libmysqlclient15off\\
cd mysql-dfsg-5.0-(whatever version)''

### Modify build options

Open ''debian/rules'' in a text editor.

Find the lines that specify CFLAGS and CXXFLAGS, and add ''-DUNDEF_HAVE_GETHOSTBYNAME_R'' to both of them. Example:

''CFLAGS=$${MYSQL_BUILD_CFLAGS:-"-DBIG_JOINS=1 **-DUNDEF_HAVE_GETHOSTBYNAME_R** -O2"} \ \\
CXX=$${MYSQL_BUILD_CXX:-g++} \ \\
CXXFLAGS=$${MYSQL_BUILD_CXXFLAGS:-"-DBIG_JOINS=1 -felide-constructors -fno-rtti **-DUNDEF_HAVE_GETHOSTBYNAME_R** -O2"} \ ''

(don't copy and paste this from here, as dokuwiki adds weird characters. Also, future package versions may have more options by default).

If you want, to speed up compilation, you might want to specify the MAKE_J value (to specify the number of jobs that will run at once. Usually set to the number of system cores + 1), as for some reason the bit of script provied doesn't automatically detect it.

''MAKE_J = "-j9" # Make things go faster''

Save it, and make sure you're in the root of the directory that was created by apt-get source.

### Build the packages

Run the following (doesn't have to be as root):

''dpkg-buildpackage -rfakeroot -uc -b''

This will take a while. Might want to go make tea or take a nap or write a novel while you're waiting.

When it's done, there should be a bunch of debs in the parent folder (..). The one we're interested in is libmysqlclient15off, as this provides the routines that were buggy in the repo version.

Install it with dpkg -i packagename, as you normally would.

## Notes

libmysqlclient15off is in a hold state in the dpkg database. This is so apt-get update won't update over it (a bug and the fix was submitted to launchpad, but I'm not sure how long until they apply it), however it also means we won't receive important security updates. It is very important that the package stays up to date, so keep an eye on the binary in repos. Every time it updates, re-download the source and follow the directions here.

If they ever do fix it, release it from dpkg hold by executing:

''echo "libmysqclient15off install" | dpkg --set-selection''

(again, don't copy and paste, as dokuwiki screws up formatting).


werdz\\
19 Jan 2008
