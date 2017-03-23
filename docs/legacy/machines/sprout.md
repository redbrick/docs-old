## Sprout

Sprout runs OpenBSD. We like OpenBSD. Sprout is the new fap, welmar & obelisk all rolled into a nice dell case.

Other things you should know about sprout:

*  It's a dual Xeon poweredge 1600 with 1gb of ram.

*  We bought it for €200 on adverts.ie

*  It's scsi controller seems botched, it uses two ide disks that used to be in fap.

*  It has two CD drives, one works, and the other is to fill up the blank space.

*  The floppy drive would work, but johan disconnected the cable.

*  The network cards came from asplodey (the only good part of aspolodey). Of course this meant some "custimzation" was required to make them actually fit.

## Things which sprout does

### Syslog-ng

Sprout is the loghost. /var/log is an entire 200gb ide disk. It is expected that this will be full in about 2020, long after I'm gone.

### Docs.redbrick

Runs on sprout apache. Doesn't use any databases.

### Nagios

Documented [here](/services/nagios) (kinda)

### Console Server

Documented [here](/legacy/procedures/sprout-serial)

## In Progress

*  Console server

*  Runs an [OSSEC](OSSEC) [website here](http://www.ossec.net)server, that gets reports of log analysis and file integrity checking from all the machines.
