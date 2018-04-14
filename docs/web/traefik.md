# Traefik

Traefik is used for http traffic on all docker hosts rather then apache because

- its easier to configure for docker
- we don't have to expose ports on the host for container
- its simple to remove and add services
- don't have to restart for config changes or addition or removal of services

See [docker-services](/procedures/docker-service) to see how to configure and
individual container. See [Traefik-docs](http://docs.traefik.io) for
configuration specifics.

- Traefik is configured to route all http traffik to https.
- Write access logs to `/var/log/traefik-access.log`
- service prometheus metrics on port 8080 of the host
- have its dashboard accessible from `traefik.$HOST.redbrick.dcu.ie`
- Generate lets encrypt certs for all containers and store them in acme.json

See
[docker-sevices repo](https://github.com/redbrickCmt/docker-compose-services)
for configs.
