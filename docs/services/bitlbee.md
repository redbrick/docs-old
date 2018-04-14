# Bitlbee on RedBrick

This is set up on zeus

bitlbee is run from a docker contaier we build locally on zeus. It mostly uses
default bitlbee settings. Its settings can be found in
`/etc/docker-compose/services/bitlbee`, see
[docker-sevices repo](https://github.com/redbrickCmt/docker-compose-services)
for configs.

### Update

To update the easiest way is to rebuild the container. Run
`docker-compose build --no-cache` and then `docker-compose up -d`

### Migration

User details are stored in `/var/lib/bitlbee` as xml data. It should be possible
to migrate the user data just by copying the xml files.

Run `docker-compose up -d` to build and start the container
