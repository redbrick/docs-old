# Monitoring

## Tools Used

- [`node-exporter`](#node-exporter)
- [`prometheus`](#prometheus)
- [`promtail`](#promtail)
- [`loki`](#loki)
- [`grafana`](#grafana)

### [node-exporter](https://prometheus.io/docs/guides/node-exporter/)

Currently all nixos boxes are installed with node-exporter to expose system
metrics on port 9100. node-exporter is installed with various plugins to gather
system metrics.

node-exporter is configured by nixos
[here](https://github.com/redbrick/nix-configs/blob/master/common/sysconfig.nix)

### [Prometheus](https://prometheus.io/docs/introduction/overview/)

Prometheus is configured to scrape metrics from various sources. Prometheus is
currently deployed with static scrape configs pointing to DNS entries of
servers.

All servers need to be added
[here](https://github.com/redbrick/nix-configs/blob/master/services/prometheus.nix)
to ensure they are scraped by prometheus for metrics.

By default prometheus scrapes every `15s`, this may need to be reduced to `30s`
or `1m` later on. All data is retained for 15 days by default. Redbrick
currently has no use cases for long term data. But if required an influx or
graphite database should be used as a remote_write for Prometheus.

### [promtail](https://github.com/grafana/loki/tree/master/docs/clients/promtail)

Promtail is used as a syslog endpoint. `log.internal:514` is the logs endpoint.
Promtail is configured to parse fields syslog fields and add them as tags in
loki. Promtail will to send logs to Loki on behind `log.internal:3100`.

### [Loki](https://github.com/grafana/loki/tree/master/docs)

Loki is grafana's logging solution. Loki is query able in grafana. All Logs
should be configured to send to it. Loki supports multiple ways to receive logs,
redbrick uses promtail and docker logging driver.

To send logs to Loki using a Loki client point logs to `log.internal:3100`

### [Grafana](https://grafana.com/docs/grafana/latest/)

Grafana is a graphing front end. Grafana has a large number of dashboards for
reviewing metrics and logs from every node. Alerts should be configured in
grafana to alert admins and root holders when events occur based on the metrics
or log events.
