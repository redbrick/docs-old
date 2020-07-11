# Collectd

- Full man page for collectd with full descriptions and configs:
    - ![Collectd.conf(5)](https://collectd.org/documentation/manpages/collectd.conf.5.shtml)
- Collectd is installed on ubuntu and bsd machines
    - Metrics are written to `zeus.internal` and then scrped by prometheus

## How to install collectd

### Ubuntu Systems

```shell
apt-get install collectd
```

### FreeBSD Port

```shell
pkg_add -r collectd
```

##### To install the port (source package)

```shell
cd /usr/ports/net-mgmt/collectd
make clean install
```

## How to configure collectd

- Config lies in `/etc/collectd/collectd.conf`

### Load Plugins

#### Plugins that Redbrick currently use

| Plugin Name | Type  |              Description               |
| :---------: | :---: | :------------------------------------: |
|     CPU     | input |           Collects CPU usage           |
|   Memory    | input |         Collects memory usage          |
|  Interface  | input | Collects traffic of network interfaces |
|   Apache    | input |     Collects metrics about apache      |
| write_http  | ouput |       Writes data to be scraped        |
|     df      | input | How much of the disk/partition is free |
|    disk     | input |        Usage of physical disks         |
|  interface  | input | Gives the interface traffic in and out |
|    load     | input |   Gives system load and utilisation    |
|  processes  | input |  Give processes running on a machine   |
|    users    | input |      Users loged on to a machine       |

|

## How configure the collectd apache plugin correctly

### Configure that apache webserver

- We need the plugin mod_status enabled
- ExtendedStatus directive needs to be enabled
- This goes in the apache config

```config
ExtendedStatus on
<IfModule mod_status.c>
  <Location /mod_status>
    SetHandler server-status
  </Location>
</IfModule>
```

- We also need to add this to the `/etc/apache2/ports.conf`
    - **This may break things in /etc/apache2/sites-enabled/**

```config
# mod_status
NameVirtualHost 127.0.0.1
Listen 127.0.0.1:8081
Listen 127.0.0.1:80
```

- In `/etc/collectd/collectd.conf` we need to configure the apache module as so

```config
<Plugin apache>
    <Instance "Machine_Name">
        URL "http://localhost/server-status/?auto"
        Server "apache"
    </Instance>
</Plugin>
```

### Trouble shooting apache

- Try curl from the machine you are on
- Try curl from the machine doing the scraping
- If that works then looks like apache is working right
- ensure you are using internal addresses
