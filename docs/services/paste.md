# Pastebin

Redbrick uses [hastebin](https://github.com/seejohnrun/haste-server) for pastes
- [Redbrick deployment](https://paste.redbrick.dcu.ie)

## Hastebin

The hastebin instance is run in docker on zeus and its configuration file is the
`config.js` file found in `/etc/docker-compose/services/hastebin`

See
[docker-sevices repo](https://github.com/redbrickCmt/docker-compose-services)
for configs.

The important things to note from these files are

- Redis runs in a separate container (as in the docker-compose)
- The port used is 5484
