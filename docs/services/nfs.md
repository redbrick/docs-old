# Current NFS setup

Do, **PLEASE, try to keep this up-to-date!**

[Azazel](/hardware/azazel) is the main storage server.

All other machines mount `/storage` over NFS. On each machine, `/home` and `/webtree` is then
symlinked to `/storage/home` and `/storage/webtree`, respectively. This allows us to have unified
quotas, without breaking things.

[Albus](/hardware/albus) is the local backup server. It can mount all nfs points readonly, read the
[backuppc](/services/backuppc) docs for more about this.

To be able to setquota on `/storage` remotely add `RPCRQUOTADOPTS='--setquota'` to
`/etc/default/quota` (on DebUntu) on the machine hosting NFS.
