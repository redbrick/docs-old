This page should contain details of redbrick scripts.

## rbquota

This is a python wrapper for quota. It is set to use quota with the -Q option, so it won't print errors for servers without rpc.quotad (usually the backup machine). This should be in /srv/bin, and gets executed from /etc/shell_cmd on login as long as there is no $HOME/.hushlogin

Packaged as [rbquota](redbrick-apt) on packages.redbrick.dcu.ie

## no(help|permwarn|forward)

Shell scripts for user dot-files.

Packaged as [redbrick-noscripts](redbrick-apt) on packages.redbrick.dcu.ie

## help

Another shell script, to be found in /srv/bin. Expects helpfiles to be available from /srv/help. The help files are just plain text files that are easily editable. These files should be editable by the helpdesk group.

Packaged as [redbrick-help](redbrick-apt) on packages.redbrick.dcu.ie

## news/usenet

These setup dot-files for slrn if they don't already exist. Users that run slrn without ever running news will get horrible errors.

Packaged as [redbrick-news](redbrick-apt) on packages.redbrick.dcu.ie

## Aliases

Things which are just aliases

### chat

    [receive@minerva ~]% which chat
    chat: aliased to irssi --config=/etc/irssi-chat.conf

### motd

    [receive@minerva ~]% which motd
    motd: aliased to cat -s /etc/motd

### rbmysql

    [receive@minerva ~]% which rbmysql
    rbmysql: aliased to /usr/bin/mysql -h mysql.internal -u receive -p receive
