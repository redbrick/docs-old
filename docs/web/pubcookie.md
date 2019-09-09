# Pubcookie

## How it was compiled

RSPM manages the pubcookie build. This is the build script:

```bash
#!/bin/bash

# Fix configure script
sed 's/ln -sf/ln -s/' configure > configure.solaris
mv configure configure.gnuln
mv configure.solaris configure
chmod 755 configure

./configure \
--prefix=/usr/redbrick/pubcookie \
--enable-login \
--enable-ldap \
--with-ldap-dir=/usr/redbrick/openldap24 \
--enable-apache \
--with-apxs=/usr/redbrick/apache2/bin/apxs \
--with-ssl=/usr/sfw

make
make install

cp -Prp /usr/redbrick/apache2/modules/mod_pubcookie.so /usr/redbrick/pubcookie/
```

Things to note:

- We use LDAP libraries (also managed by RSPM) to auth users. LDAP settings are
  configured under the pubcookie config file.

## Configuration

Pubcookie requires its own SSL cert for the authentication server (the thing
triggered by inetd running on port 2222). We use a self-signed cert for this.
