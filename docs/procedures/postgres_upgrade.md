# Upgrading postgres from X to Y

Some time in the future when you try to do a Nixos-rebuild switch,
Postgres might get updated and fail to start with an error similar to
this:

```bash
systemd[1]: Starting PostgreSQL Server...
cisc5xwrxf4217aygzjl82k0qm3gpky3-unit-script-postgresql-start[24950]: 2020-04-05 14:33:24.324 GMT [24950] FATAL:  database files are incompatible with server
cisc5xwrxf4217aygzjl82k0qm3gpky3-unit-script-postgresql-start[24950]: 2020-04-05 14:33:24.324 GMT [24950] DETAIL:  The data directory was initialized by PostgreSQL version 9.6, which is not compatible with this version 11.7.
systemd[1]: postgresql.service: Main process exited, code=exited, status=1/FAILURE
systemd[1]: postgresql.service: Failed with result 'exit-code'.
systemd[1]: Failed to start PostgreSQL Server.
```

This document explains how to upgrade postgres in this scenario

```bash
# Install the old version of postgres into your local env
nix-env -iA nixos.postgresql_9_6
# Get the path to the old version
dirname $(readlink $(which postgres))
export OLDPG=...
# Get the path to the new version from the PATH env var in the service
systemctl cat postgresql | grep PATH
export NEWPG=...
# Update the postgresql data dir in the Nix config to somewhere else
# (e.g. /var/db/postgresnew) then do..
nixos-rebuild switch
# Stop new postgres
systemctl stop postgresql
# Run the upgrade (with the paths you got above)
cd /tmp
su postgres -c 'pg_upgrade -b $OLDPG/bin -B $NEWPG/bin -d /var/db/postgres -D /var/db/postgres11 -j4'
# Start and analyse new db
systemctl start postgresql
sudo su postgres -c '/tmp/analyze_new_cluster.sh'
# Stop new db again
systemctl stop postgresql
# Move new files into correct place and revert nixos changes
mv /var/db/postgres{,_old}
mv /var/db/postgres{new,}
nixos-rebuild switch
```
