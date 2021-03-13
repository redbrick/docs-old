# ZnapZend

## Overview

[ZnapZend](https://www.znapzend.org) is used to back up the NFS
ZFS dataset from our NFS server to Albus. It can also be used
to back up other ZFS datasets on other hosts, but at the time of
writing NFS is the only thing being backed up this way.

ZnapZend runs on the client and sends backups to Albus
over SSH using `zfs send | zfs receive` piping.

The backup strategy can be viewed in the
[NixOS configuration](https://github.com/redbrick/nix-configs/blob/5ddaf2097a3267b871368fea73a530e399381b4a/services/znapzend.nix)

## Adding another backup

There is not much manual configuration to add a host to
the ZnapZend backups.

1. Create an SSH key for the root user with no password on
   the host you want to send the backups from. Use
   `ssh-keygen -t ed25519`.
2. Add this new SSH public key to the rbbackup user's authorized
   keys [on Albus](https://github.com/redbrick/nix-configs/blob/5ddaf2097a3267b871368fea73a530e399381b4a/hosts/albus/configuration.nix#L32).
3. Try sshing to `rbbackup@albus.internal` to load the host key and
   test the passwordless authentication.
4. Import the [znapzend service config](https://github.com/redbrick/nix-configs/blob/5ddaf2097a3267b871368fea73a530e399381b4a/services/znapzend.nix)
   on the sending host and configure `redbrick.znapzendSourceDataset`
   and `redbrick.znapzendDestDataset`. Then apply the config. **NOTE:**
   The DestDataset must be unique across all configured backups/servers.

## Debugging

Znapzend runs at the top of every hour to make backups. You can watch
the progress with `journalctl -fu znapzend.service`. Failures are usually
caused by incorrect SSH configuration, so make sure that passwordless
auth using the sending host's root SSH key is working.

## Rolling back NFS

If the NFS server is online and functional, you do not need to involve
Albus to roll back changes, as all the snapshots are kept on Icarus too.

1. Find the snapshot you want to restore with `zfs list -t snapshot`.
2. Run `zfs rollback $snapshotname`.

That's it! These instructions obviously work for backups other than NFS
too, should any ever exist.

## Restoring NFS from a backup

If the NFS server has died or you are creating a copy of it, here's how
to pull the dataset from Albus

1. On Albus, find the snapshot you want to restore with `zfs list -t snapshot`.
2. Open a screen/tmux, and copy the snapshot to a dataset in your target ZFS
   pool with `ssh albus zfs send -vRLec $snapshotname | zfs receive $newpool/$datasetname`.
