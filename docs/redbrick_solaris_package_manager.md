# Redbrick Solaris Package Manager

## Overview
The Redbrick Solaris Package Manager (or RSPM, for short) is an attempt to simplify the task of keeping murphy (and any other Solaris machines we might end up with) up to date. It allows the automation of builds from source packages, and is able to automatically check for missing dependencies between packages and version updates.

It does **not** manage the installation and removal of packages (pkgadd and the other standard SVR4 tools are used for that), however it may call these tools to add packages once they're ready for installation.

## The packages.dat file

Information on packages is stored in packages.dat.

Each package will have it's own package section:
`<file>`--- package RBdummy ---
(package info goes here)
--- end package RBdummy ---`</file>`

In this case, RBdummy is the package identifier. Identifiers must be unique throughout the packaging system. 

Inside the package section, you can add single-line fields or multi-line fields. Single-line fields are in the following format:

`<file>`fieldname value`</file>`

Where fieldname is the name (key) of the field, and value is the value.

Multi-line fields are in the following format:

`<file>`--- fieldname ---
Values go
here
(multiline!)
--- end fieldname ---`</file>`

The following **single-line** fields are **required** for a package:


*  **title:** The human-friendly name of the package (e.g. "Redbrick dummy package").

*  **version_regex:** The version regex for the package. See the section below named "Versioning" for more information on this.

*  **version_rules:** The version rules for the package. See the section below named "Versioning" for more information on this.

*  **version_check_url:** The version check URL for the package. See the section below named "Versioning" for more information on this.

*  **version_check_regex:** The version check regex. See the section below named "Versioning" for more information on this.

*  **download_link_url:** The download link URL for a package. See the section below named "Downloading" for more information on this.

*  **download_link_regex:** The download link regex. See the section below named "Downloading" for more information on this.

*  **last_check:** The last time this package was checked for updates. For new packages, this may be set to 0. rspm will keep this field up to date automatically.

*  **basedir:** The base directory that this package will be installed to. This is a subdirectory of /usr/redbrick.

The following **single-line** fields are optional for a package:


*  **description:** A brief, human-readable description of a package.

*  **depends:** **Direct** dependencies of this package. Do not list indirect dependencies (i.e. dependencies of dependencies) here!

*  **compression:** the compression used on the source archive for this package (targz or tarbz2)

The following **multi-line** fields are **required** for a package:


*  **build:** A build script for a package. This will be executed from within the directory created by extracting a source archive, from within a chroot environment. Be sure to set PATH appropriately within this script. Be sure to return a nonzero return code if any fatal errors occur within the script, so the package manager knows to abort. Should also run make install (or the equivalent) prior to exiting.

The following **multi-line** fields are optional for a package:

*  **prebuild:** Runs immediately prior to the final build of the SVR4 package (after the build script has completed). Useful for moving any external files into the basedir. This is **not** run from within a chroot jail, but the current working directory is the basedir of the package.

*  **postinstall:** Runs after installation on the destination system, by the pkgadd utility.

*  **externals:** Used to keep track of any files or directories that are used by this package that are not under the basedir (for example, for configuration files under /etc). Each line should contain a single file or directory.

*  **preremove:** A script that runs before a package is removed (for example, before the old version of a package is removed before updating to a new version).

## The build process

As soon as the chroot environment has been created, the package tarball downloaded from the vendor site is extracted to a directory under the chroot's /tmp. The chroot is then entered and the script changes to the directory containing the package's source code.

This gives you an environment to run the usual configure, make and make install commands. For programs that use this process, it's usually appropriate to set --prefix=/usr/redbrick/[basedir] (as set in the basedir section) so that the software is installed cleanly to that location by make install. 

For programs that don't need to be compiled (or that use a different build process), make sure that by the time the build script has exited, the program exists in the chroot environment as it should be installed by pkgadd. This generally entails manually creating /usr/redbrick/[basedir], and copying any required files to it. You may also have to install any external configuration files to /etc, or similar.

Once the build script successfully finishes, the chroot is exited and the prebuild (as in pre-package-build) script is run. You can use this to move any external /etc entries to the /usr/redbrick/[basedir] directory so that pkgmk will pick them up and include them with the distribution. **Yes, I know this puts the package in a bad (non-runnable) state. This can be fixed later.** If you don't have any external bits, you can mostly ignore this section. Please bear in mind that **the prebuild script is not run from inside the chroot!** It's run relative to the actual root. The current working directory for this script is inside the basedir within the chroot (but you're not locked in, you could cd to / and actually break things).

Once this is done, the package is built from everything that's inside $location_of_chroot/usr/redbrick/[basedir]. 
The postinstall script specified in the postinstall section is also included. Pkgadd will run this after the installation has completed - this is where you get the chance to relocate any external files, such as /etc entries. I suggest doing tests to see if the file exists already, so that (for example) upgrading apache doesn't wipe out the existing configuration.

More advanced postinstall scripts could also be written to write out a redbrick standard configuration for a package, if you wanted.

## Versioning

Version control is the process of finding the latest version number of a particular application, and being able to tell whether or not that version number is greater than that of the currently installed package. As version numbers differ greatly in how they're formatted from project to project, a simple integer or string comparison operation won't cut it.

The process used by RSPM when checking the version of a new package is as follows:


*  Download the web page specified by **version_check_url**. Look for a version number using the regular expression specified in **version_check_regex**.

*  Split the version number found (for example, 1.4.13a) into its constituent parts using **version_regex**. For an application that used the versioning scheme shown in this example, the version regex might be something like (\d+)\.(\d+)\.(\d+)([a-z]*). The important parts to bear in mind are the groupings. The order in which these are evaluated is significant - version 1.5.9 is obviously newer then 1.4.13a, even though the latter has a letter component, and 13 is greater then 9. The order in which components should be evaluated is specified in **version_rules**. 

*  **version_rules** is specified as a set of integers. In the example given, the appropriate order would be simply "1 2 3 4". In most cases, this will be simply an ascending sequence of integers up until the number of regular expression groupings is reached. The algorithm for determining whether a version is greater or less than an existing version is as follows:

    new_groups = apply version_regex to new_version
    old_groups = apply version_regex to old_version
    
    for each entry e in version_rules
     if new_groups[e] > old_groups[e] then
        new_version is newer, we're done.
     else if old_groups[e] > new_groups[e] then
        old_groups[e] is newer, we're done.
     end if
    end for
    
    neither version appears to be newer, therefore they're the same.

The comparisons shown will treat both sides as an integer if neither side contains any non-numerical characters, otherwise a lexical comparison is carried out.

### Example version rules

**A project where the version scheme uses three integer numbers, separated by dots, with no lettering appended (e.g. 2.4.1 or 2.3.45).**

    version_regex (\d+)\.(\d+)\.(\d+)
    version_rules 1 2 3

The three numerical components go major-minor-subminor, so should be evaluated first to last. Therefore the version_rules setting is "1 2 3".

**A project where the version scheme uses three integer numbers, separated by dots, with an optional letter appended (e.g. 2.4.1 or 2.3.45c or 2.3.45f).**

    version_regex (\d+)\.(\d+)\.(\d+)([a-zA-Z]*)
    version_rules 1 2 3 4

The * operator in the regex means "zero or more", so the last component is optional. RSPM will ignore it if it's not there. 

**A project where the version scheme is a date in the format MM-DD-YYYY-NN, where NN is the release number for a given day. (e.g. the second release on a given day will have NN set to 02).**

    version_regex (\d\d)-(\d\d)-(\d\d\d\d)-(\d\d)
    version_rules 3 1 2 4

The version_rules setting here is more complex. The most important item to evaluate is the year (3). Followed by the month (1), then the day (2), and finally the sequence number (4).

## Overriding download links

Occasionally it may be required to override the download link for a specific source archive version. The original use case for this was when the PHP project released a dodgy package (5.2.10), where the date() function was broken on SPARC and PPC machines. Since this was a major bug, something had to be done. Downgrading wasn't an option (that'd open another security hole), and there was no official update on the 5.2 line. Our only option was to use the CVS snapshot.

This will cause RSPM to ignore the download_link_url and download_link_regex settings when locating and downloading the source archive. To use it, append --force-download-link packagename new_url to the rspm compile command. For example:

    rspm compile RBphp5 --force-download-link RBphp5 http://snaps.php.net/php5.2-200907010030.tar.bz2

When using this, ensure that the archive is in the same format that RSPM expected (see the **compression** package setting). (In the example case, this is tarbz2).

## RSPM wish list/issue tracking

### Bugs

*  The build chroots don't have access to networking. Doesn't affect any of our packages, yet (PHP snapshots seem to choke on it though).

### Wishlist

*  Integrity checking of source archives.

*  Improved user interaction. Users (well, admins) should have a better overview of what RSPM is doing. At the moment it spouts out a lot of unreadable garbage.

*  Unified /bin, /lib, /etc, etc. At the moment each package has its own basedir, this is a major headache for things like LD_LIBRARY_PATH and PATH settings. It would be nice if there was a single /usr/redbrick/bin, /usr/redbrick/lib, etc. This will require a lot of reworking of the way RSPM handles builds, and how it determines what files should be part of a specific package. Conflict checking will also have to be added.

*  Binary package archiving. When a package is built, it should be stored somewhere for future reference. This would allow for fast downgrades if an update broke something horribly.

*  Patch support. It would be nice if a quick patch could be applied to the build process. Maybe a --apply-patch switch. Would be useful for cases where a project releases an unstable version that is required for some reason (security maybe).
