# Committee Changeovers

## Introduction

This is a dummies guide and checklist for the admins outlining what needs to be
done during the changeover from one committee to the next.

## The Changeover

### Committee Group

All members of the committee should be added to the committee (`committe` - yes,
there is only meant to be one e in it) group. This will allow them to read and
edit the committee-owned documents.

```bash
$ useradm convert
RETURN: use [default] given  TAB: answer completion  EOF: give empty answer

Enter username
[no default] >> $new_committee_member

Conversion usertype must be specified. List of valid usertypes:
  member       Normal member
  associat     Graduate/associate member
  staff        DCU staff member
  committe     Committee member or a position account
  society      DCU society
  club         DCU club
  dcu          DCU related account
  projects     RedBrick/DCU/Course project account
  redbrick     RedBrick related account
  intersoc     Account for society from another college
  guest        Guest account

Special committee positions (usertype is 'committe'):
  admin        Elected admin
  helpdesk     Elected helpdesk
  webmaster    Elected webmaster

Enter conversion usertype
(hints) [no default] >> committe

Enter who updated this user (give Unix username)
[root] >> atlas

User converted: $new_committee_member -> committe
Account converted: $new_committee_member -> committe
Subscribed: $new_committee_member@redbrick.dcu.ie
```

This changes the `gidNumber` of the user in `LDAP` to `100` (the `committee`
group). It also subscribes the user to the committee mailing list. Do this for
each of the new committee members.

### IRC

#### #rbcommittee

Add each user to the `#rbcommittee` access list, with an access level of `40`.

```text
/msg chanserv access #rbcommittee add *!$new_committee_member@redbrick.dcu.ie 40
```

#### #lobby

Add each user to the #lobby access list, with a level of `10` (or `40` for
admins).

```text
/msg chanserv access #lobby add *!$new_committee_member@redbrick.dcu.ie 10
```

Also remove each outgoing member from both lists.

### Wiki

#### Committee wiki

Add the new committee members to `/webtree/redbrick/htdocs/cmt/.htaccess`

### Webmaster

Add the webmaster to the LDAP `webgroup`

```bash
$ ldapmodify -D cn=root,ou=ldap,o=redbrick -x -y /etc/ldap.secret
  dn: cn=webgroup,ou=groups,o=redbrick
  changetype: modify
  add: memberUid
  memberUid: $new_webmaster

  modifying entry “cn=helpdesk,ou=groups,o=redbrick”
```

Add the webmaster to the webmaster mailing list
(webmaster@lists.redbrick.dcu.ie) on
[lists](https://lists.redbrick.dcu.ie/mailman/admin/webmaster/)

### Helpdesk

Add each member to the `helpdesk` mailing lists (TODO, list all lists).

Add each member to the LDAP helpdesk group:

```bash
$ ldapmodify -D cn=root,ou=ldap,o=redbrick -x -y /etc/ldap.secret
  dn: cn=helpdesk,ou=groups,o=redbrick
  changetype: modify
  add: memberUid
  memberUid: $new_helpdesk_member1
  memberUid: $new_helpdesk_member2
  memberUid: $new_helpdesk_member3
  modifying entry "cn=helpdesk,ou=groups,o=redbrick"
```

### Admins

The tricky ones...

- Add each member to the admin mailing lists (rb-admins and elected-admins).
- Add each member to the LDAP root group:

```bash
$ ldapmodify -D cn=root,ou=ldap,o=redbrick -x -y /etc/ldap.secret
  dn: cn=root,ou=groups,o=redbrick
  changetype: modify
  add: memberUid
  memberUid: $new_admin_member1
  memberUid: $new_admin_member2
  memberUid: $new_admin_member3**
  modifying entry "cn=root,ou=groups,o=redbrick"
```

- Give each new admin a local account (in `/etc/passwd`) on each machine

-Atlas - 12 Apr 07
