Backuppc is currently installed on albus and can be accessed from
[albus.redbrick.dcu.ie/backuppc](https://albus.redbrick.dcu.ie/backuppc).
Login details are in the pw safe

Before a host will be backed up a few things need to be done

- The machine to be backed up needs to have its `sshd` config changed to the
  following `PermitRootLogin forced-commands-only`
- Then the ssh key must been added to the the authorizedkey file in roots
  `.ssh` dir. The ssh key can be found in root's `.ssh` directory on albus.
  The first part of the file must contain the following
  ```
  command="/usr/bin/rsync --server --sender --numeric-ids --perms --owner --group\
  -D --links --hard-links --times --block-size=2048 --recursive\
  --ignore-times . /",no-port-forwarding,no-x11-forwarding,no-agent-forwarding
  ```
  This may change depending on the location of rsync on the server.
- You should test that you can ssh as root from albus to whatever server
  you are backing up.
- Once this has been done the host must be addded from backuppc. Click on
  edit host and and add the hostname with the user of backuppc.

More Docs can be found at [Backuppc documentation](https://albus.redbrick.dcu.ie/backuppc/index.cgi?action=view&type=docs)
on albus.
