# Carbon reboot warning

Carbon doesn't seem to like reboots. In particular LDAP and INN always seem to go down badly, probably because they're in use right up until the reboot.

A symptom of the news problems can be seen by posting to redbrick.babble, press 'g' to refresh, notice the number of available posts increase, press 'g' again, notice it instantly decrease. See /local/admin/services/news.

For LDAP see /local/admin/service/ldapLDAP (the second solution).

If you're rebooting Carbon, considering stoppping exim on Deathray and Prodigy (it won't be able to deliver anyway!), since name service information may be lost at this time.
