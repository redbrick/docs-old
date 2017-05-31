# Hackmd

Hackmd lives at [md.rb](https://md.redbrick.dcu.ie) on zeus

Hackmd is built locally and is based on
[hackmd-docker](https://github.com/hackmdio/docker-hackmd)

Clone the repo and modify `.sequlize`, `Dockerfile` and `config.json` so
anywhere it said `hackmdPostgres` it now says `hackmd_db_1.hackmd_default`
assuming this is all done in the hackmd folder.

Hackmd auths against ldap and its configuration is controlled from
docker-compose.

```yaml
version: '3'
services:
  db:
    image: postgres
    environment:
      - POSTGRES_USER=hackmd
      - POSTGRES_PASSWORD=hackmdpass
      - POSTGRES_DB=hackmd

  hackmd:
    build: .
    image: hackmd
    container_name: hackmd
    ports:
      - '3003:443'
    environment:
      - POSTGRES_USER=hackmd
      - POSTGRES_PASSWORD=hackmdpass
      - HMD_PORT=443
      - HMD_DOMAIN=md.redbrick.dcu.ie
      - HMD_PROTOCOL_USESSL=true
      - HMD_URL_ADDPORT=true
      - HMD_ALLOW_ANONYMOUS=false
      - HMD_ALLOW_ORIGIN=www.redbrick.dcu.ie,md.redbrick.dcu.ie
      - HMD_ALLOW_EMAIL_REGISTER=false
      - HMD_EMAIL=false
      - HMD_ALLOW_FREEURL=true
      - HMD_IMGUR_CLIENTID=
      - HMD_IMGUR_CLIENTSECRET=
      - HMD_IMAGE_UPLOAD_TYPE=imgur
      - HMD_LDAP_URL=ldap://ldap.internal
      - HMD_LDAP_BINDDN=cn=root,ou=ldap,o=redbrick
      - HMD_LDAP_BINDCREDENTIALS=
      - HMD_LDAP_SEARCHBASE=ou=accounts,o=redbrick
      - HMD_LDAP_SEARCHFILTER=(uid={{username}})
      - HMD_LDAP_PROVIDERNAME=Redbrick
    depends_on:
      - db
```

See hackmd
[github](https://github.com/hackmdio/hackmd/#environment-variables-will-overwrite-other-server-configs)
for more info on configuration. The important points are disabling anonymus
users and the ldap settings.
