# Dovecot

<img src="https://www.dovecot.org/typo3conf/ext/dvc_content/Resources/Public/Images/dovecot_logo_vector.svg" alt="dovecot" width="150" />

## Runbook

```bash
# Create /storage/mail
mkdir -p /storage/mail
chmod 3770 /storage/mail
# This next command will only work after
# running nixos-rebuild with dovecot enabled
chown root:vmail /storage/mail
# Create a user in LDAP if not done already, then
# create the dovecot_auth.conf
cat > /var/secrets/dovecot_bind.conf << EOF
dn = cn=dovecot,ou=reserved,o=redbrick
dnpass = dovecot_user_password
EOF
chmod 400 /var/secrets/dovecot_bind.conf
chown dovecot /var/secrets/dovecot_bind.conf
```

When you first start Dovecot, ensure that `/var/mail/redbrick.dcu.ie` is auto
created with the `vmail` group and `3770` permissions. If not then delete it,
make sure the steps above have been taken, and send another test mail.

## Administration

All mail for all users is stored in /var/mail.
The NFS share /storage/mail is mounted over this directory on Hardcase, for 2
reasons. One is so that user's disk quotas as reported by rbquota include their
mail storage usage. Secondly it is a more resilient backing filesystem than
the local disks on Hardcase. There is no quota system configured in Dovecot
itself.

## Troubleshooting

#### Users cannot authenticate

If you created the dovecot LDAP user from scratch, you might need to grant
them read access to the user's password field in the LDAP access config. This
is done for our regular dovecot user [here](https://github.com/redbrick/nix-configs/blob/master/services/ldap/default.nix#L73).

Beyond that, check the Dovecot logs with journalctl and ensure it is connecting
to LDAP successfully. Check the credentials in `/var/secrets/dovecot_bind.conf`
are correct (you could try using ldapsearch binding). If all this is good and
the user is still getting access denied, then they are typing their password
wrong.

#### Not accepting mail from Postfix

This should never happen. Postfix uses LDAP to verify that a user exists
before accepting mail. Try doing an `id` lookup of the problematic user,
and check the aliases file. If you are seeing errors on the Postfix side
and not on the Dovecot side then it may be a problem with the LMTP socket.
If the user can send mail then that confirms the SASL connection is OK.
