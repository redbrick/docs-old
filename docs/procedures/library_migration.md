**Minimun number of servers needed**

 | Server    | U size | OS           | Service                                            |
 | ------    | ------ | --           | -------                                            |
 | azazel    | 2      | Ubuntu 14.04 | Login, physical mount for /home                    |
 | metharme  | 2      | Ubuntu 12.04 | Web, IRC                                           |
 | paphos    | 2      | Ubuntu 14.04 | Mail, Lists, LDAP,INN2, MYSQL,DNS,NTPD,Spamassasin |
 | pygmalion | 2      | Ubuntu 14.04 | Dev server                                         |
 | halfpint  | 1 1/2S | FreeBSD 9.3  | Admin box                                          |
 | Worf      | 2      | N/a          | /home                                              |


**Things we need to do**

 1. investigate statuspage
 2. Lists
 3. Mail Server
 4. AWS account for IRC.
 5. replace/fix useradm
 6. Migrate Redbrick package


Dependency Chain:
WebAuth (LDAP linked) -> Apache2.2 -> 16.04
IRCd-Hybrid->inspIRCd -> 16.04
