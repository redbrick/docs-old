# Hackmd

Hackmd lives at [md.rb](https://md.redbrick.dcu.ie) on zeus

Hackmd is built locally and is based on
[hackmd-docker](https://github.com/hackmdio/docker-hackmd)

Clone the repo and modify `.sequlize`, `Dockerfile` and `config.json` so
anywhere it said `hackmdPostgres` it now says `hackmd_db_1.hackmd_default`
assuming this is all done in the hackmd folder.

Hackmd auths against ldap and its configuration is controlled from
docker-compose. See
[docker-sevices repo](https://github.com/redbrickCmt/docker-compose-services)
for configs.

See hackmd
[github](https://github.com/hackmdio/hackmd/#environment-variables-will-overwrite-other-server-configs)
for more info on configuration. The important points are disabling anonymus
users and the ldap settings.
