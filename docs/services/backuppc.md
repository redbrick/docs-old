Backuppc is currently installed on albus and can be accessed from albus.redbrick.dcu.ie/backuppc login details are in the pw safe

Before a host will be backed up a few things need to be done
  * The machine tobe backed up needs to have its sshd config changed to the following `PermitRootLogin forced-commands-only`
  * Then the ssh key must been added to the the authorizedkey file in roots .ssh dir. The ssh key can be found in roots .ssh directory on albus. The first part of the file must contain the following ` command="/usr/bin/rsync --server --sender --numeric-ids --perms --owner --group -D --links --hard-links --times --block-size=2048 --recursive --ignore-times . /",no-port-forwarding,no-x11-forwarding,no-agent-forwarding` This may changedepending onthe location of rsync on the server.
  * You should test that you can ssh as root from albus to what ever server you are backing up.
  * Once this has been done the host must be addded from backuppc. Click on edit host and and add the hostname with the user of backuppc.

More Docs can be found [here](https://albus.redbrick.dcu.ie/backuppc/index.cgi?action=view&type=docs "Backuppc documentation on albus")

