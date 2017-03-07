# Webchat qircd


Werdz has created a redbrick version of qwebirc. This can be cloned from https://hg.redbrick.dcu.ie/redbrick-qwebirc/

## Install Proccess

### Dependencies

The following packages need to be installed

    python
    python-twisted
    sun-java6-jdk or sun-java6-jdr (some java interpreter)

### Qwebirc user

Qwebirc runs with its own system user and group called qwebirc with home directory /opt/redbrick-qwebirc which will need to be created.


### Clone HG Rep

Clone the redbrick version of qwebirc from redbrick's mercurial repository to it's home directory /opt/redbrick-qwebirc

    hg clone https://hg.redbrick.dcu.ie/redbrick-qwebirc

It needs to be compiled once it has been cloned. There is a compile script in the root of redbrick-qwebirc

    python compile.py

### Config file

There is a config.py.example file in the root directory, it's well documented and prefilled for redbrick setup.
When you're happy copy/rename to config.py.

### Upstart Script

Qwebirc doesn't like being started from outside its directory, presumably it uses relative paths to load stuff, so the chdir directive is important to make the upstart script work.

Upstart script /etc/init/webchat.conf
    # qwebirc
    #
    # Customised version of qwebirc powering Redbrick webchat
    # http://bitbucket.org/werdz/redbrick-qwebirc

    #description     "webchat daemon"
    #author          "Andrew Martin `<werdz@redbrick.dcu.ie>`"

    start on runlevel [2]
    stop on runlevel [16]

    chdir /opt/redbrick-qwebirc

    exec run.py -n -i 136.206.15.74

    respawn
