# Docker Services

Redbrick runs a few services in Docker on the following servers:

- zeus

All Docker files will be `/etc/docker-compose/services/$SERVICE_NAME`. Config
files will be in either in the folder with the docker files or mapped to the
traditional location such as `/etc/$SERIVCE_NAME` or `/var/lib/$SERVICE_NAME`

## Adding Service

To Add a service first check the git repo is in a clean state and all changes
are committed. Then create a folder for the new service. It should either be the
services name or purpose, eg `elk` or `logging`.

Add the `docker-compose.yml`, and `Dockerfile` if it is a custom image.

### Web access

Redbrick uses [traefik](https://docs.traefik.io/) for ingress to containers. To
allow a container to be added accessed over https first add the following
network to `docker-compose.yml`

```yaml
networks:
  web:
    external: true
```

`web` is a docker network which should already exist on the host. Then add the
network to the container you want to expose over https.

```yaml
networks:
  - web
  - default
```

Then Label the container so traefik can route to the right port

```yaml
labels:
  - 'traefik.backend=my-awesome-app'
  - 'traefik.docker.network=web'
  - 'traefik.frontend.rule=Host:my-awesome-app.zeus.redbrick.dcu.ie'
  - 'traefik.enable=true'
  - 'traefik.port=3000'
```

This exposes the port 3000 on the container at the domain. `traefik.backend`
must be the containers name. The network is the name of the external network we
specified above. The frontend rule is the domain we want to serve it at, you can
serve it from any subdomain of zeus or add a cname to bind to point to zeus and
`traefik.frontend.rule` to be that cname.

### Logging

Redbrick Uses Loki for collecting logs. Thankfully docker makes it very easy to
add a logging provider. To use Loki as a provider add the following to each
service

```yaml
logging:
  driver: loki
  options:
    loki-url: 'http://log.internal:3100/loki/api/v1/push'
```

### Volumes

USE VOLUMES. I cant say this enough use a volume if you want your data to
persist across service restarts. It is beyond recommended to use a named volume,
this avoids the volume getting lost by a stray service outage and makes
restoring from backups much easier. You can also write to a folder on disk for
your volumes. This isn't the best for databases but works for logs, configs or
assets.

### Finished Product

So once all put together a docker compose would look like

```yaml
version: '3'
services:
  redis:
    image: 'redis:alpine'
    restart: always
    volumes:
      - redis:/data
    logging:
      driver: loki
      options:
        loki-url: 'http://log.internal:3100/loki/api/v1/push'

  haste:
    build: .
    image: redbrick/haste
    container_name: hastebin
    depends_on:
      - redis
    networks:
      - web
      - default
    labels:
      - 'traefik.backend=hastebin'
      - 'traefik.docker.network=web'
      - 'traefik.frontend.rule=Host:paste.redbrick.dcu.ie'
      - 'traefik.enable=true'
      - 'traefik.port=7777'
    logging:
      driver: loki
      options:
        loki-url: 'http://log.internal:3100/loki/api/v1/push'

networks:
  web:
    external: true

volumes: redis:
```
