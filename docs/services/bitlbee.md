## Bitlbee on RedBrick
This is set up on zeus

bitlbee is run from a docker contaier we build locally on zeus. It mostly uses
default bitlbee settings. Its settings can be found in
`/etc/docker-compose/services/bitlbee`

#### Dockerfile

``` Dockerfile
FROM debian:jessie

ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN echo 'deb http://code.bitlbee.org/debian/master/jessie/amd64/ ./' > /etc/apt/sources.list.d/bitlbee.list
RUN echo 'deb http://download.opensuse.org/repositories/home:/jgeboski/Debian_8.0 ./' > /etc/apt/sources.list.d/jgeboski.list

RUN apt-key adv --fetch-keys http://code.bitlbee.org/debian/release.key
RUN apt-key adv --fetch-keys http://jgeboski.github.io/obs.key

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get upgrade -y
RUN apt-get install -y bitlbee bitlbee-facebook

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY bitlbee.conf /etc/bitlbee/bitlbee.conf

EXPOSE 6667
VOLUME ["/var/lib/bitlbee/"]
CMD ["/usr/sbin/bitlbee", "-D", "-n"]
```

#### docker-compose.yml
```yaml
version: '3'
services:
  bitlbee:
    build: '.'
    container_name: 'bitlbee'
    hostname: bitlbee.redbrick.dcu.ie
    restart: 'always'
    ports:
      - 6667:6667
    volumes:
      - '/var/lib/bitlbee:/var/lib/bitlbee:rw'
```

`bitlbee.conf` is fairly standard, no authentication or anything.

```
[settings]
HostName = bitlbee.redbrick.dcu.ie
RunMode = ForkDaemon
User = bitlbee
DaemonInterface = 136.206.15.0
DaemonPort = 6667
MotdFile = /etc/bitlbee/motd.txt
```
The rest of the conf will be generated after the container is built

### Update

To update the easiest way is to rebuild the container. Run `docker-compose
build` and then `docker-compose up -d`

### Migration

User details are stored in `/var/lib/bitlbee` as xml data. It should be possible
to migrate the user data just by copying the xml files.

Run `docker-compose up -d` to build and start the container
