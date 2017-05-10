# Mastodon

Mastodon runs on zeus. Mastodon uses the latest build of mastodon from docker
hub, if it ever has issues switch to the latest tagged release.

## Docker compose
``` yaml
version: '3'
services:
  db:
    restart: always
    image: postgres:alpine
    volumes:
      - ./postgres:/var/lib/postgresql/data
  redis:
    restart: always
    image: redis:alpine
    volumes:
      - ./redis:/data
  web:
    image: gargron/mastodon
    restart: always
    env_file: .env.production
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    ports:
      - "3002:3000"
    depends_on:
      - db
      - redis
    volumes:
      - /webtree/vhosts/mastodon:/mastodon/public
      - /webtree/vhosts/mastodon/assets:/mastodon/public/assets
      - /webtree/vhosts/mastodon/packs:/mastodon/public/packs
      - /webtree/vhosts/mastodon/system:/mastodon/public/system
  streaming:
    image: gargron/mastodon
    restart: always
    env_file: .env.production
    command: npm run start
    ports:
      - "4000:4000"
    depends_on:
      - db
      - redis
  sidekiq:
    image: gargron/mastodon
    restart: always
    env_file: .env.production
    command: bundle exec sidekiq -q default -q mailers -q pull -q push
    depends_on:
      - db
      - redis
    volumes:
      - /webtree/vhosts/mastodon/system:/mastodon/public/system
```
## Apache
We Disable proxying for static assets to remove load from the server and avoid
random 404 on assets.
``` apacheconf
<VirtualHost mastodon.redbrick.dcu.ie:80>
        ServerName  mastodon.redbrick.dcu.ie
        ServerAlias social.redbrick.dcu.ie
        ServerAlias toot.redbrick.dcu.ie
        ServerAdmin webmaster@redbrick.dcu.ie
        DocumentRoot /etc/docker-compose/services/mastodon/public/
        RewriteEngine On
        RewriteCond %{HTTPS} off
        RewriteCond %{REQUEST_URI} !^/server-status
        RewriteRule ^(.*) https://%{HTTP_HOST}%{REQUEST_URI}
</VirtualHost>
<IfModule mod_ssl.c>
<VirtualHost mastodon.redbrick.dcu.ie:443>
        ServerName  mastodon.redbrick.dcu.ie
        ServerAlias social.redbrick.dcu.ie
        ServerAlias toot.redbrick.dcu.ie
        ServerAdmin webmaster@redbrick.dcu.ie

        DocumentRoot /webtree/vhosts/mastodon/
        Header add Strict-Transport-Security "max-age=31536000"
        Header always set Referrer-Policy "strict-origin-when-cross-origin"

        Include  /etc/apache2/ssl.conf
        <Location /assets>
              Header always set Cache-Control "public, max-age=31536000, immutable"
        </Location>

        ProxyPreserveHost On
        RequestHeader set X-Forwarded-Proto "https"
        ProxyPass /500.html !
        ProxyPass /oops.png !
        ProxyPass /avatars/original/missing.png !
        ProxyPass /headers/original/missing.png !
        ProxyPass /packs !
        ProxyPass /assets !
        ProxyPass /system !
        ProxyPass /emoji !
        ProxyPass /sounds !
        ProxyPass /api/v1/streaming/ ws://localhost:4000/
        ProxyPassReverse /api/v1/streaming/ ws://localhost:4000/
        ProxyPass / http://127.0.0.1:3002/
        ProxyPassReverse / http://127.0.0.1:3002/

        ErrorDocument 500 /500.html
        ErrorDocument 501 /500.html
        ErrorDocument 502 /500.html
        ErrorDocument 503 /500.html
        ErrorDocument 504 /500.html
</VirtualHost>
</IfModule>
```
## Configuration
All configuration is done in the `.env.production`. Get the latest build env
from
[Github](https://github.com/tootsuite/mastodon/blob/master/.env.production.sample)
the smtp, federation and secrets all need to be change.

## Updating
1. To update first pull latest build by running `docker-compose pull`.
2. `docker-compose run --rm web rake db:migrate` to perform database migrations. Does nothing if your database is up to date.
3. `docker-compose run --rm web rake assets:precompile` to compile new JS and CSS assets.
4. `docker-compose up -d` to re-create (restart) containers and pick up the changes.
