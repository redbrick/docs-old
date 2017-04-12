# Current NFS setup

**Please try to keep this up-to-date!**

[Azazel](/hardware/azazel) is the main storage server.

Carbon, morpheus and murphy mount /storage over NFS. On each machine, /home and /webtree is then symlinked to /storage/home and /storage/webtree, respectively. This allows us to have unified quotas, without breaking things.

[Thunder](/legacy/machines/thunder) is the local backup server. It can mount all nfs points readonly, read the [dirvish](/legacy/procedures/dirvish) docs for more about this. /backup is local on thunder, and should be mounted readonly on minerva so people can get files from backups. It is not mounted automatically on any other machine.

<del>Deathray, murphy, morpheus and minerva all mount /fast-storage from carbon. /srv is should be a symlink to /fast-storage/srv</del> RIP /fast-storage

To be able to setquota on /storage remotely add RPCRQUOTADOPTS='--setquota' (that's 2 dashes, fuck you, dokuwiki) to /etc/default/quota (on DebUntu) on the the machine hosting NFS.
