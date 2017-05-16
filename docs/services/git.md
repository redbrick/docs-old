# Git

Redbrick uses [Gitea](https://gitea.io/en-US/) a community driven fork of
[Gogs](https://gogs.io/) for Git hosting.

 - [Gitea docs](https://docs.gitea.io/en-us/)
 - [Gogs docs](https://gogs.io/docs) - though you shouldn't need these

# Gitea

We run Gitea in Docker on zeus. The `docker-compose.yml` is as follows

```yaml
version: '3'
services:
  gitea:
    container_name: gitea
    image: gitea/gitea:latest
    restart: always
    ports:
      - '10022:10022'
      - '10080:3000'
    volumes:
      - /var/git:/data
    dns: 136.206.15.26
    depends_on:
      - db

  db:
    image: postgres:alpine
    restart: always
    environment:
      POSTGRES_PASSWORD: PASSWORD
      POSTGRES_DB: gitea
      POSTGRES_USER: gitea
```

We run a postgres database in a second container for storage of users
and repo information.

Gitea stores its main conf in `/var/git/gitea/app.ini`

```
APP_NAME = Redbrick
RUN_USER = git
RUN_MODE = prod

[repository]
ROOT = /data/git/repositories

[repository.upload]
TEMP_PATH = /data/gitea/uploads

[server]
APP_DATA_PATH    = /data/gitea
SSH_DOMAIN       = git.redbrick.dcu.ie
HTTP_PORT        = 3000
ROOT_URL         = https://git.redbrick.dcu.ie/
DISABLE_SSH      = false
SSH_PORT         = 10022
LFS_START_SERVER = false
OFFLINE_MODE     = false
DOMAIN           = redbrick.dcu.ie

[database]
HOST     =  gitea_db_1.gitea_default:5432
PATH     = /data/gitea/gitea.db
DB_TYPE  = postgres
NAME     = gitea
USER     = gitea
PASSWD   = $DBPASSWD
SSL_MODE = disable

[session]
PROVIDER_CONFIG = /data/gitea/sessions
PROVIDER        = file

[picture]
AVATAR_UPLOAD_PATH      = /data/gitea/avatars
DISABLE_GRAVATAR        = false
ENABLE_FEDERATED_AVATAR = false

[attachment]
PATH = /data/gitea/attachments

[log]
ROOT_PATH = /data/gitea/log
MODE      = file
LEVEL     = Trace

[mailer]
ENABLED = false

[service]
REGISTER_EMAIL_CONFIRM     = false
ENABLE_NOTIFY_MAIL         = false
DISABLE_REGISTRATION       = true
ENABLE_CAPTCHA             = false
REQUIRE_SIGNIN_VIEW        = false
DEFAULT_KEEP_EMAIL_PRIVATE = false
NO_REPLY_ADDRESS           = noreply.redbrick.dcu.ie

[security]
INSTALL_LOCK   = true
SECRET_KEY     = $KEY
INTERNAL_TOKEN = $TOKEN

[openid]
ENABLE_OPENID_SIGNUP = false
ENABLE_OPENID_SIGNIN = false
```

The Main points of this conf the SSH ports and login.
SSH is set to port `10022` due to ssh on zeus using port `22`.
We disable openid login and user registration to stop none redbrick users
joining.

# LDAP Login

We use ldap auth to login to gitea, the settings are as follows,
![Gitea ldap settings](/img/gitea-ldap.png)
