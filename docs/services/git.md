# Git

Redbrick uses [Gitea](https://gitea.io/en-US/) a community driven fork of
[Gogs](https://gogs.io/) for Git hosting.

- [Gitea docs](https://docs.gitea.io/en-us/)
- [Gogs docs](https://gogs.io/docs) - though you shouldn't need these
- [Redbrick Deployment](https://git.redbrick.dcu.ie)
## Gitea

We run Gitea in Docker on zeus. We run a postgres database in a second container
for storage of users and repo information. Gitea stores its main conf in
`/var/git/gitea/app.ini` in a volume.

See
[docker-sevices repo](https://github.com/redbrickCmt/docker-compose-services)
for configs. The Main points of this conf the SSH ports and login. SSH is set to
port `10022` due to ssh on zeus using port `22`. We disable openid login and
user registration to stop none redbrick users joining.

### LDAP Login

We use ldap auth to login to gitea, the settings are as follows,
![Gitea ldap settings](/img/gitea-ldap.png)
