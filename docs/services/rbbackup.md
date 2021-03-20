# Redbrick Backup

## Overview

Redbrick backup is a custom script run as a Systemd service on
configured NixOS machines which rsyncs files over to [Albus](../hardware/albus).
It is managed by a few custom NixOS options (`redbrick.rbbackup`)
defined in our [nix-configs](https://github.com/redbrick/nix-configs/blob/master/common/options.nix#L75)
repo.

## How backups work

- The rbbackup.service's preStart script runs, creating any
  files which need to be backed up (e.g. running mysqldump) in
  the current working directory.
- The service's start script will rsync those files to
  `rbbackup@albus.internal:/zbackup/generic/${HOSTNAME}`,
  _overwriting the last backup's files_.
- Albus creates regular ZFS snapshots of zbackup/generic,
  which can be mounted + used to restore files when necessary.
- When the backup is completed, the current working directory
  is deleted by the postStart script.

## Notes

- Configured backup source files should have a static name between
  runs and override what is already backed up. This allows ZFS snapshotting
  on Albus to manage backup rotation and cleanup.
- Due to the nature of Nix, `redbrick.rbbackup` parameters will
  be merged together if they are defined in multiple places, which
  means you don't need to worry about interfering with other configured
  backups on the same system.
- If the system you are backing up uses ZFS, and you are considering
  rsync'ing an entire dataset, please use [znapzend](./znapsend) instead.
- `zbackup/generic` already has ZFS compression (zstd-5) configured, so
  there's no real need to compress your backups unless it makes a significant
  time saving during the rsync (e.g. SQL dumps compress really well).

## System setup

Setting up of RBBackup isn't completely automatic - you must
create an SSH key for root on the source host and add it to
the rbbackup user's authorised keys. These are the same steps
taken when preparing to use ZnapZend on a machine, so follow
the steps [there](./znapzend#adding-another-backup).

## Configuring a new backup

Backups should be configured in the relevant service's config
rather than on a per-host basis. This means that backups will be
automatically configured for any system running the given service.
The below example is based on our existing LDAP backup configuration.

1. Start by configuring `redbrick.rbbackup.commands` to create any
   backup files, setting secure permissions at the same time:

```nix
  redbrick.rbbackup.commands = ''
    ldapsearch -b o=redbrick -xLLL -D ${slurpdDN} -y ${slurpdpwFile} > ldap.ldif
    chmod 400 ldap.ldif
  '';
```

2. Configure `redbrick.rbbackup.extraPackages` to include any commands
   required for your custom commands.

```nix
# ldapsearch is contained within pkgs.openldap
  redbrick.rbbackup.extraPackages = with pkgs; [ openldap ];
```

3. Configure the backup sources which will be rsync'ed to Albus. Relative and
   absolute paths are supported.

```bash
  redbrick.rbbackup.sources = [ "ldap.ldif.gz" ];
```

4. Apply your configuration and test the backup by starting the service with
   `systemctl start redbrick-backup.service`

That's it! You can check `redbrick-backup.timer` to see when it will next run.

## Debugging

Rbbackup runs every hour with a 20 minute skew to avoid DDOSing Albus.
You can check when the next run is by
looking at `systemctl status redbrick-backup.timer`.

You can watch the progress with `journalctl -fu redbrick-backup.service`.
Failures are usually caused by incorrect SSH configuration, so make
sure that passwordless auth using the sending host's root SSH key is working.

## Recovering a backup

If you need to get a file back from the backups, the process is very simple:

1. Find the snapshot you want to take the backup from on Albus with
   `zfs list -t snapshot zbackup/generic`.
2. Mount the backup with `mount -t zfs zbackup/generic@snapshottag ~/mnt`. You
   may need to `mkdir ~/mnt`.
3. Copy the files you need wherever you need them with rsync.
4. Unmount the folder again with `umount ~/mnt`.

It is **VERY** important that you unmount the snapshot again otherwise the
snapshot auto cycling will not work and it will hang around for longer than it
should, potentially using lots of storage.
