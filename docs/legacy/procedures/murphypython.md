# Python on Murphy

There are three copies of Python on Murphy:

*  Python 2.4, from the SUNW packages. This will be updated along with other Sun packages, etc, but it's quite old (2.4). It's not used for much.

*  Python 2.5, from the CSW (Blastwave) packages. Under /opt/csw. This is a bit shit, not a lot works. Blastwave is generally shit.

*  Python 2.6, from RSPM (redbrick packages). Under /usr/redbrick/python26. This is the "primary" instance, if you type python at the command prompt it's what will run. /bin/python is symlinked to /usr/redbrick/python26/bin/python.

To install a python package/addon, do one of the following things:

## Python eggs (.egg)

If you can download an egg, download the one that targets Python 2.6. To install it, run it like a script - for example:
    ./setuptools-something-py2.6.egg
This should install automagically.

## Tar.gz archives

If a package is distributed as an archive, unzip the archive, then try to install it by cd-ing into the extracted directory, and typing
    python setup.py
This should install it to the python 2.6 distribution.

Sometimes, setup.py will require external libraries to compile and run (for example, database connectors). Usually there's a setup.cfg or site.cfg file that you can edit to specify library paths/etc. Poke around for it. Then try installing again.

## Troubleshooting

### Halp, shared libraries not found when the module is run

This is a common problem when you install a module that required a library to compile (as described above). In order to run, the runtime linker needs to be able to find the shared library file, which won't be found unless it's under the library path. There are two ways of working around this:

*  Specify the path to the library in the LD_LIBRARY_PATH environment variable.

*  Use crle (on Solaris, different under Linux/etc) to add the path to the default library path. Use this with caution, NEVER put a user-accessible directory here, as it'd open a huge gaping security hole. man crle for more details. If you don't know the security implications of changing/adding stuff to the default library search path, don't do it, read up on it or ask someone else for advice (preferably both).

### Halp, module installed but still can't be found

This happened once or twice to me. It turned out to be a permissions problem. Check that the package installation (located under /usr/redbrick/python26/lib/python2.6/site-packages) has the correct permissions (world readable, etc).

-werdz
