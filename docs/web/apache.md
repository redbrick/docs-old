# Apache

Metharme, Redbrick's web server, is still using apache2.2 due to pubcookie. All other machines use
2.4.
See [Apache Modules](/web/apachemodules) for modules.

## User Vhost

We use a apache macro template for user vhosts.

``` apache
<Macro VHost $dir $user $group $vhost >
  <VirtualHost 136.206.15.61:80>
    ServerName $vhost.redbrick.dcu.ie
    ServerAlias www.$vhost.redbrick.dcu.ie
    RewriteEngine on
    RewriteCond %{SERVER_NAME} =$vhost.redbrick.dcu.ie [OR]
    RewriteCond %{SERVER_NAME} =www.$vhost.redbrick.dcu.ie
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [L,QSA,R=permanent]
  </VirtualHost>
  <VirtualHost 136.206.15.61:443>
    DocumentRoot $dir
    ServerName $vhost.redbrick.dcu.ie
    ServerAlias www.$vhost.redbrick.dcu.ie
    AddHandler cgi-script .cgi
    AddHandler cgi-script .py
    AddHandler cgi-script .sh
    AddHandler cgi-script .pl
    AddHandler x-httpd-php .php
    AddHandler x-httpd-php .php3
    SuExecUserGroup $user  $group
    AddType text/html .shtml
    AddHandler server-parsed .shtml
    AddHandler server-parsed .html
    # include the SSL settings for a user vhost
    Include /etc/apache2/user_vhost_ssl.conf
  </VirtualHost>
</Macro>

# Custom subdomains
#         dir                                           user            group           vhost
Use VHost /storage/webtree/a/associat                   associat        associat        asscociat
Use VHost /storage/webtree/c/club                       club            club            club
Use VHost /storage/webtree/e/events                     events          committe        events
Use VHost /storage/webtree/s/soc                        soc             society         soc
Use VHost /storage/webtree/d/dcu                        dcu             dcu             dcu
Use VHost /storage/webtree/m/member                     mamber          member          member
```

The vhost doesnt have to be the same as the user name this allows clubs, societies or dcu site to
have different vhosts to their username.
The reason the dir is specified is someusers have multiple likes in their
webspaces with different vhost.
