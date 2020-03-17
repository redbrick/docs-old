# Unified MOTD

## Current Setup

The motd is now part of the redbrick-motd package. The package includes a cron
script to reset it via cron.daily, and an init script to reset it on boot. It
also includes the `/etc/motd.*` files needed for the motd, and
`/usr/bin/update_motd`. `/etc/motd.footer` and `/etc/motd.dat` are marked as
conffiles in the package, and won't be overwritten, for obvious reasons.

## Future Suggestions

I planned to do this sometime, but never quite got around to it :(

Anyway, what i'd do is to keep all the current stuff, but to put up a php/mysql
thing to enter motd items. The cron scripts could then generate motd.dat by
reading directly from the database. If the database isn't accessable then the
script could just fail, leaving the old motd.dat in place, and thus not making a
mess.
