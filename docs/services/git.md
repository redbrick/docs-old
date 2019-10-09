# Git

Redbrick uses [Gitea](https://gitea.io/en-US/) a community driven fork of
[Gogs](https://gogs.io/) for Git hosting.

- [Gitea docs](https://docs.gitea.io/en-us/)
- [Gogs docs](https://gogs.io/docs) - though you shouldn't need these

## Gitea

We run Gitea on daedalus which runs NixOS. The config can be found [here](https://git.redbrick.dcu.ie/m1cr0man/nix-configs-rb/src/branch/master/services/gitea.nix). 
We run a postgres database for storage of users and repo information.

### LDAP Login

We use ldap auth to login to gitea, the settings are as follows,
![Gitea ldap settings](/img/gitea-ldap.png)
