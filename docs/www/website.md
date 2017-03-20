# Static-Site
The Code is hosted on github [here](https://github.com/redbrick/static-site)

The site is Statically generated with [hexo](https://hexo.io/) using a theme
based off [icarus](https://github.com/redbrick/hexo-theme-icarus)

## Requirements
1. **Node** : v6.9(LTS)  Download [Node](https://nodejs.org/download/)

## Setup
To set up run:
  - `yarn` this will install all the dependencies

You will also need to create three files:
  - `mailing_list` a newline-separated list of email addresses
  - `email_update_log` a newline-separated reverse-chronological list of times email updates were sent
  - `.env` by copying `.env.example` and **modifying values (*important*)**

`mailing_list` and `email_update_log` can be left blank, though updates for every post in history will be sent if no previous send date is specified.
Add the `docker-compose.yml` from [github](https://github.com/redbrick/static-site/blob/master/docker-compose.yml) to `/etc/docker-compose/services/website`
Set the log and output folder and all Enviroment variables

Add a service for website to `/etc/systemd/system/website.service`
```
[Unit]
Description=Redbrick Website
After=network.target
[Service]
ExecStart=/usr/local/bin/docker-compose up -d
User=root
Group=webgroup
WorkingDirectory=/etc/docker-compose/services/website
[Install]
WantedBy=multi-user.target
```

## Generate
- To start the site run `systemctl start website`. This will generate the site and store the files in `/webtree/redbrick/htdocs` which are served by apache
It also creates a server that runs on localhost:3000. This Service dynamic pages such as the contact form and the api and is proxied by apache

## Regenerate via API
- While the server is live, a visit to `http://[sitehost]/api/regenerate?token=your_secret_token` will pull the most up todate version and run `hexo generate` and send emails for any new posts so long as that process is not already underway.

### CSS and Templates
- You can edit the css for the theme in themes/redbrick-theme/source/css
- You can edit the templates in themes/redbrick-theme/layout
* This should be done through github NEVER modify the production copy *

### Google analytics
Analytics can be enabled by adding your analytics key to _config.yaml as
```
plugins:
  google_analytics: $key
```
