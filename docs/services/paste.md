# Pastebin

Redbrick uses [hastebin](https://github.com/seejohnrun/haste-server) for pastes

## Hastebin

The hastebin instance is run in docker on zeus.

The `Dockerfile` is as follows

```Dockerfile
FROM node:boron-alpine

WORKDIR /opt/haste
RUN apk add --no-cache git &&\
    git clone https://github.com/seejohnrun/haste-server.git /opt/haste && \
    yarn

ADD ./config.js /opt/haste/config.js

EXPOSE 7777
CMD [ "yarn", "start" ]
```

the `docker-compose.yml` is

```yaml
version: '3'
services:
  hastebinredis:
    image: "redis:alpine"
  haste:
    build: .
    image: "redbrick/paste"
    ports:
     - "5484:7777"
    depends_on:
     - hastebinredis
```

and its configuration file is the `config.js` file found in
`/etc/docker-compose/services/hastebin`

its contents are

```json
{

  "host": "0.0.0.0",
  "port": 7777,

  "keyLength": 10,

  "maxLength": 400000,

  "staticMaxAge": 86400,

  "recompressStaticAssets": true,

  "logging": [
    {
      "level": "verbose",
      "type": "Console",
      "colorize": true
    }
  ],

  "keyGenerator": {
    "type": "phonetic"
  },

  "rateLimits": {
    "categories": {
      "normal": {
        "totalRequests": 500,
        "every": 60000
      }
    }
  },

  "storage": {
    "type": "redis",
    "host": "hastebinredis",
    "port": 6379,
    "db": 2,
    "expire": 2592000
  },

  "documents": {
    "about": "./about.md"
  }

}
```

The important things to note from these files are

* Redis runs in a separate container (as in the docker-compose)
* The port used is 5484

