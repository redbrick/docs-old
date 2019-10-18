# Pubcookie

We use LDAP to authenticate users. LDAP settings are configured under the pubcookie config file at `/usr/local/pubcookie/config`.

The service is triggered by x.inetd (`/etc/xinetd.d/keyserver`) running on port 2222.

Pubcookie requires its own SSL cert for the authentication server. We use a self-signed cert for this.
