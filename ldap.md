
# LDAP

## Current Situation

*  Primary LDAP Runs on Morpheus.internal

*  Secondary LDAP Runs on Deathray.internal, slaving Morpheus

*  Linux User machines (Minerva, Morpheus, Carbon, Murphy) Configured to try both Servers
## Useful Methods for manipulating ldap

For more information on these commands see there man pages, but heres a how do I do something quickly with ldap overview

### ldapsearch

Dump out the database in ldif form (piping to less can be useful)
   ldapsearch -D cn=root,ou=ldap,o=redbrick -y /etc/ldap.secret -xLLL

Search for something in particular (In this case all users updated by johan)
   ldapsearch -D cn=root,ou=ldap,o=redbrick -y /etc/ldap.secret -xLLL "(updatedby=johan)"

Here it gets interesting, all members who were updated by johan:
   ldapsearch -D cn=root,ou=ldap,o=redbrick -y /etc/ldap.secret -xLLL "(&(updatedby=johan)(objectClass=member))"

These commands spit out everthing in the database for all the matching entries, if you are ownly looking for secific data, such as there uid, alternate email and home directory location you can abend these variables to the search query to only return this information, ie:
   ldapsearch -D cn=root,ou=ldap,o=redbrick -y /etc/ldap.secret -xLLL "(updatedby=johan)" altmail homeDirectory
(The dn which contains the uid will always be printed anyway :)

### ldapmodify

How to modify something in LDAP, like, oh, say, disusering somebody.

Create a file with something similar to this:

	
	dn: uid=username,ou=accounts,o=redbrick
	changetype: modify
	replace: loginShell
	loginShell: /usr/local/shells/disusered


Where: username is who you're editing\\
loginShell is the attribute\\
/usr/l... is the value

Then run ldapmodify like this:

    root@redbrick# ldapmodify -x -D cn=root,ou=ldap,o=redbrick -y /etc/ldap.secret -f modifyfile

Where modifyfile is what you created above.

### ldapadd

Occasionally you'll need to add people or things to ldap manually, such as a user you recreating from backups, or a reserved system name such as a new machine.

Put the information you would like to add into a file, or if its short or one entry you can use stdin, in the case of adding a reserved name the file should look something like this, replacing both instances of redbrick with the reserved name you would like to add:

	
	$cat update.reservered
	dn: uid=redbrick,ou=reserved,o=redbrick
	uid: redbrick
	description: DNS entry
	objectClass: reserved
	objectClass: top


Then run the following command:

    ldapadd -D cn=root,ou=ldap,o=redbrick -y /etc/ldap.secret -x -f update.resevered

Done, if you opted to use stdin, leave the -f off the end of the command, paste the data into your terminal after running the command and finish with a ctrl-d


## Installing Servers

### Setting up a LDAP Server - Ubuntu


*  Install open-ldap: #apt-get install slapd

*  Go to /etc/ldap remove schema folder

*  Copy the entire schema folder from current server or backup

*  Copy /etc/ldap/slapd.conf from current server or backup

*  Create directory for database files - currently /var/lib/ldap

*  Chown directory to ldap user/group - currently openldap

*  Import an ldif using slapadd -v -l `<location of ldif>`

*  Chown all files in /var/lib/ldap to openldap

*  Edit /etc/defaults/slapd to set hostname to ldap://Server.internal.ip.address:389/

*  Sacrifice lamb - start slapd
 
Check contents of ldap directory using: ldapsearch -xLLL -D cn=root,ou=ldap,o=redbrick -y /etc/ldap.secret -h Server.internal.ip.address | less
### Setting Up a Secondary Server - Replication

For detailed information on all this see  http://www.openldap.org/doc/admin24/replication.html



*  Install openldap as above, assuming a ubuntu server, otherwise hf.

*  The following ACLs (Access Control Lists) may need to be modified on the `<em>`primary`</em>` server to allow the replication user read the database, the last 2 lines are not ACL's, they set up the server to act as a provider, so just as important:

ACL's:

	
	access to dn.children="ou=2002,ou=accounts,o=redbrick"
	            by dn.regex="cn=root,ou=ldap,o=redbrick" write
	            by dn.regex="cn=slurpd,ou=ldap,o=redbrick" read
	            by * none
	
	access to dn.children="ou=accounts,o=redbrick" attrs=cn
	        by dn.regex="cn=root,ou=ldap,o=redbrick" write
	        by dn.regex="cn=slurpd,ou=ldap,o=redbrick" read
	            by self read
	            by * none
	
	access to attrs=yearsPaid,year,course,id,newbie,altmail
	        by dn.regex="cn=root,ou=ldap,o=redbrick" write
	        by dn.regex="cn=slurpd,ou=ldap,o=redbrick" read
	        by self read
	        by * none
	
	access to attrs=userPassword
	        by dn.regex="cn=root,ou=ldap,o=redbrick" write continue
	        by dn.regex="cn=slurpd,ou=ldap,o=redbrick" read
	        by self write
	            by anonymous auth
	            by * none
	
	access to attrs=gecos,loginShell
	        by dn.regex="cn=root,ou=ldap,o=redbrick" write continue
	        by dn.regex="cn=slurpd,ou=ldap,o=redbrick" read
	            by self write
	            by * read
	
	# Default ACL
	access to *
	         by * read
	
	overlay syncprov
	syncprov-checkpoint 100 10


* The following needs to be added to the slaves slapd.conf, to configure it as a slave, this assumes you've copied the primary's config, but removed the last 2 lines above and all above references to the slurpd user.

	
	syncrepl rid=000
	        provider=ldap://192.168.0.2:389
	        type=refreshAndPersist
	        retry="5 5 300 +"
	        attrs="*,+"
	        binddn="cn=slurpd,ou=ldap,o=redbrick"
	        bindmethod=simple
	        credentials=XXXXXXXXXXXXXXXXX
	        searchbase="o=redbrick"


*  You can use this on any secondary server to have it function in a method similar to the old slapd - slurpd configuration, for more possible configs see the above link, the rid must be a unique identifier for the slave server, so increment it if your adding additional slaves.

*  Starting the secondary server triggers an update and will transfer all the data

*  UPDATE USER machines to auth off new ldap

## Re-syncing Secondary LDAP Servers

In the event a secondary server becomes out of sync with the master, it can be synced by stopping the server, deleting its database files, Currently: 
`root@secondaryldapserver#: rm -rf /var/lib/ldap/*`
And then restarting the server, provided its configured as above this triggers a dump of the current state of the master

## Legacy Situation

If you would like to see some history of ldap on redbrick, including a discussion between dizer and ryaner, check out this page [ldapsetup](ldapsetup)

**__NB__ Nothing on the history page is accurate**
