# Updating the imap ssl cert
Important files (all on deathray)

```
Cert File:      /etc/courier/imapd.pem
Script:         /local/admin/scripts/imap/updatecert.sh
Expect File:    /local/admin/scripts/imap/script.exp
```

# How-To

* Run /local/admin/scripts/imap/runMe.sh on deathray
* If things dont work first try it manually. Then try updating the `privkey.pem`
	file which I grabbed from the webmail folder.
* If people complain about an invalid cert with the same serial number,
	(people = zyox), tell them to remove the old stored cert from the program.
* In Thunderbird: `Tools` -> `Options` -> `Advanced` -> `Certificates` ->
	`Manage Certificates` ::: `Remove old imap cert`.

# How-To ::: Manually
Simply run `updatecert.sh` and enter the following information when requested

```
Enter PEM pass phrase:                            imapcert
Verifying password - Enter PEM pass phrase:       imapcert
Country Name (2 letter code) [AU]:                IE
State or Province Name (full name) [Some-State]:  Leinster
Locality Name (eg, city) []:                      Dublin
Organization Name (eg, company) [Internet Widgits Pty Ltf]:	RedBrick SSL IMAP
Organizational Unit Name (eg, section) []:        Dublin City University Networking Society
Common Name (eg, YOUR name) []:                   imap.redbrick.dcu.ie
Email Address []:                                 admins@redbrick.dcu.ie
A challenge password []:                            <leave blank>
An optional company name []:                        <leave blank>
Enter PEM pass phrase:                            imapcert
```
