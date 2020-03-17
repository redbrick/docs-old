# RB Scripts

This page should contain details of redbrick scripts.

## RBquota

This is a python script to query ZFS on NFS.

Server Code is in
[Nixos repo](https://github.com/redbrick/nix-configs/blob/6ad93bee1498223bab700d08fd8febe64b3e445d/services/zfsquota/default.nix#L33)

Client code is on [Github](https://github.com/redbrick/rbquota)

This should be in `/srv/bin`, and gets executed from `/etc/shell_cmd` on login
as long as there is no `$HOME/.hushlogin`

## no(help|permwarn|forward)

Shell scripts for user dot-files.

## Help

Another shell script, to be found in `/srv/bin`. Expects helpfiles to be
available from `/srv/help`. The help files are just plain text files that are
easily editable. These files should be editable by the helpdesk group.

## News/usenet

These setup dot-files for slrn if they don't already exist. Users that run slrn
without ever running news will get horrible errors.

## Aliases

Things which are just aliases

### chat

```bash
$ which chat
chat: aliased to irssi --config=/etc/irssi-chat.conf
```

### motd

```bash
$ which motd
motd: aliased to cat -s /etc/motd
```

### rbmysql

```bash
$ which rbmysql
rbmysql: aliased to /usr/bin/mysql -h mysql.internal -u receive -p receive
```
