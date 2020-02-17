# Monitoring

Prometheus scrapes collectd, grafana gets it's metrics from prometheus. These
are what we currently and hope to monitor in the future.

## Tools Used

- [`node-exporter`](#node-exporter)
- [`prometheus`](#prometheus)
- [`fluentd`](#fluentd)
- [`loki`](#loki)
- [`grafana`](#grafana)

### node-exporter

Currenlty all nixos boxes are installed with node-exporter to expose system
metrics on port 9100. node-exporter is installed with various plugins to gather
system metrics.

node-exporter is configured by nixos
[here](https://github.com/redbrick/nix-configs/blob/master/common/sysconfig.nix)

### Prometheus

Prometheus is configured to scrape metrics from various sources. Prometheus is
currently deployed with static scrape configs pointing to dns entries of
servers.

All servers need to be added
[here](https://github.com/redbrick/nix-configs/blob/master/services/prometheus.nix)
to ensure they are scraped by prometheus for metrics.

By default prometheus scrapes every 15s, this may need to be reduced to 30s or
1m later on. All data is retained for 15 days by default. Redbrick currently has
no use cases for long term data. But if required an influx or graphite db should
be used as a remote_write for Prometheus.

### fluentd

fluentd is used as a syslog endpoint. logging.internal:514 is the logs endpoint.
fluentd can be configured to parse and tag logs. Manual parsing of should be
avoided in fluentd in favour of loki and fluentd plugins.

fluentd is configured to send logs to loki on the same host it is running on.

### Loki

Loki is grafanas logging solution. Loki is querieable in grafana. All Logs
should be configured to send to it. Loki supports multiple ways to recieve logs,
redbrick uses fluentd and docker logging driver.

To send logs to loki using a loki client point logs to logging.internal:3100

### Grafana

Grafana is a graphing frontend. Grafana has a large number of dashboards for
reviewing metrics and logs from every node. Alerts should be configured in
grafana to alert admins and root holders when events occur based on the metrics
or log events.
