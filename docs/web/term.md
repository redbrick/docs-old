# Web terminal

Redbrick runs [wetty](#wetty) as a web terminal.

## Wetty

I like this best because it actually looks good and runs from a container.

Running at [term.redbrick.dcu.ie](https://term.redbrick.dcu.ie/)

### Source

When installing butlerx got sick of the lack of development on the project and
decided to fork it and pull in changes from contributors such as mobile support
and reconnect button. As well as make it better for running from a container and
better ssh support.

His fork is on [github](https://github.com/butlerx/wetty)

### Setup

Specify the host to ssh to and the port to run on in the docker-compose file
then just run

```bash
docker-compose up -d
```

Then just use apache to proxy to the port.
