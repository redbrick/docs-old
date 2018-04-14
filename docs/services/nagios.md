# Redbrick's nagios setup

## Hosts

These should all be physical machines, and are all found in
`/usr/local/etc/nagios/objects/Redbrick/machines/` on halfpint (One config file
per host). Service IPs should not be setup as a seperate host but as a service
on the correct host.

## Services

nrpe is installed on all of the machines, and is checking load and hard disk
space at a minimum. On morpheus, it's also checking ircd, and on severus, it's
checking that the two mysqls are in sync. All of the service checks are in
`/usr/local/etc/nagios/objects/Redbrick/services/services.cfg` on halfpint. For
things which have service ips, define a command to check the service ip (in
`/usr/local/etc/nagios/objects/Redbrick/commands/commands.cfg`) and add it as a
service under the host it runs on.

## Adding a new machine

If you're adding a new machine, then add it to
`/etc/nagios/objects/Redbrick/machines/`, and make it a member of
redbrick-login, redbrick-routers or redbrick-services as appropriate. This will
add ping, disk, and load checking (you'll need to set up disk and load checking
with nrpe on the host side first of course). It won't set up ping checks on the
external interface however, you'll have to do that seperately, as well as any
services that the machine runs.

## After updating anything

After making your changes/additions you'll want to have nagios verify the config
files are error-free with: `nagios -v /etc/nagios/nagios.cfg`

Assuming nothing went horribly wrong you can restart nagios,the rc script is of
course in `/usr/local/etc/rc.d` instead of `/etc/rc.d` because of superior
FreeBSD file layout or whatever.
