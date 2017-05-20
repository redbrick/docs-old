# Mailman

Mailman runs on `mailhost.redbrick.dcu.ie`. Currently this is paphos

## Mailman Scripts

These are in `/usr/lib/mailman/bin`. In particular the newlist command is here. Most other things
can be done easily from the web interface.

## Installing Mailman

Mailman is installed straight from apt. It should always be generally be installed on the primary
mail server. Mail to mailing lists is sent to mailman from the `exim conf`.

``` text
  mailman:
    domains = lists.redbrick.dcu.ie
    driver = accept
    require_files = /var/lib/mailman/lists/$local_part/config.pck
    local_part_suffix_optional
    local_part_suffix = -bounces : -bounces+* : \
                        -confirm+* : -join : -leave : \
                        -owner : -request : -admin
    transport = mailman_transport
    no_more
```

All mailman installs should have those damn monthly reminders disabled. This can only be done by
commenting out the entry in `/etc/cron.d/mailman`

## Mailman Apache Configuration

Below is the apache conf for mailman. Getting this wrong will horribly break stuff like archives.
This config is based pretty closely on the default one in the package.

``` apache
<VirtualHost 136.206.15.57:443>
  ServerName lists.redbrick.dcu.ie
  DocumentRoot /var/www
  Include /etc/apache2/ssl.conf
  <Directory /var/lib/mailman/archives/>
      Options Indexes FollowSymLinks
      AllowOverride None
  </Directory>

  RewriteEngine On
  RewriteCond %{HTTP_HOST}   !^lists\.redbrick\.dcu\.ie [NC]
  RewriteRule ^/(.*)         https://lists.redbrick.dcu.ie/mailman/listinfo [L,R]

  Alias /pipermail/ /var/lib/mailman/archives/public/
  Alias /images/mailman/ /usr/share/images/mailman/
  ScriptAlias /admin /usr/lib/cgi-bin/mailman/admin
  ScriptAlias /admindb /usr/lib/cgi-bin/mailman/admindb
  ScriptAlias /confirm /usr/lib/cgi-bin/mailman/confirm
  ScriptAlias /create /usr/lib/cgi-bin/mailman/create
  ScriptAlias /edithtml /usr/lib/cgi-bin/mailman/edithtml
  ScriptAlias /listinfo /usr/lib/cgi-bin/mailman/listinfo
  ScriptAlias /options /usr/lib/cgi-bin/mailman/options
  ScriptAlias /private /usr/lib/cgi-bin/mailman/private
  ScriptAlias /rmlist /usr/lib/cgi-bin/mailman/rmlist
  ScriptAlias /roster /usr/lib/cgi-bin/mailman/roster
  ScriptAlias /subscribe /usr/lib/cgi-bin/mailman/subscribe
  ScriptAlias /mailman/ /usr/lib/cgi-bin/mailman/
  ScriptAlias / /usr/lib/cgi-bin/mailman/listinfo
</VirtualHost>
```

Changes may need to be made to `/etc/mailman/mm_cfg.py` if the directory structure is changed. The
options that match this apache config are:

``` text
  #-------------------------------------------------------------
  # If you change these, you have to configure your http server
  # accordingly (Alias and ScriptAlias directives in most httpds)
  #DEFAULT_URL_PATTERN = 'http://%s/cgi-bin/mailman/'
  DEFAULT_URL_PATTERN = 'http://%s/'
  PRIVATE_ARCHIVE_URL = '/private'

  # Images - Put redbrick_icon.ico in /usr/share/mailman/images!
  SHORTCUT_ICON = 'redbrick_icon.ico'
  IMAGE_LOGOS         = '/images/mailman/'

  #-------------------------------------------------------------
  # Default domain for email addresses of newly created MLs
  DEFAULT_EMAIL_HOST = 'lists.redbrick.dcu.ie'
  #-------------------------------------------------------------
  # Default host for web interface of newly created MLs
  DEFAULT_URL_HOST   = 'lists.redbrick.dcu.ie'
  #-------------------------------------------------------------
  # Required when setting any of its arguments.
  add_virtualhost(DEFAULT_URL_HOST, DEFAULT_EMAIL_HOST)
```

## Mailman Migration

Eh, this is what I did:

* apt-get install mailman
* copy `/var/lib/mailman` and `/etc/mailman` from the old location
* copy `/etc/apache2/sites-enabled/lists`
* move the service ip
* disable the shitty monthly reminders in `/etc/cron.d/mailman`
* put the redbrick favicon in `/usr/share/mailman/images`
