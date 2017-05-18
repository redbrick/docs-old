# Changing a local Password

You need to change a local password but passwd is giving you some bolix that looks like its trying
to change an ldap password

1. comment the entry with `pam_ldap.so` in it out of `/etc/pam.d/common-password`
2. change password
3. fix `/etc/pam.d/common-password`
