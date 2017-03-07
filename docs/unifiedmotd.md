# Current Setup

The motd is now part of the [redbrick-motd](redbrick-apt) package. The package includes a cron script to reset it via cron.daily, and an init script to reset it on boot. It also includes the /etc/motd.* files needed for the motd, and /usr/bin/update_motd. /etc/motd.footer and /etc/motd.dat are marked as conffiles in the package, and won't be overwritten, for obvious reasons.

#  Future Suggestions

I planned to do this sometime, but never quite got around to it :(

Anyway, what i'd do is to keep all the current stuff, but to put up a php/mysql thing to enter motd items. The cron scripts could then generate motd.dat by reading directly from the database. If the database isn't accessable then the script could just fail, leaving the old motd.dat in place, and thus not making a mess.

# Old Stuff

## May 2008 - July 2009

As of July 2008 there is no unified motd setup.

The "redbrick" motd is only setup on carbon/minerva. On these machines it is updated nightly from /etc/cron.daily/000motd

## Pre Great hack of '08

I'm responsible for this horrid hack, so i suppose i'll document it as it currently stands.
- receive 2008/04/05 17:17

#### Justification

When minerva started being used we had three machines that people logged into, and the motd's were being very inconsistent

#### update_motd_global

On Minerva there is a copy of the old update_motd called update_motd_global. This processes the local /etc/motd.dat but saves it to /storage/redbrick/motd. On minerva, murphy and carbon /etc/motd is symlinked to this file. Deathray remains unchanged.

#### Nightly Updates

update_mord_global runs from chair's crontab on minerva

#### hacks

Note: This is a horrible hack. The motd system will be changed when i have time to write one.
