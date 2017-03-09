I would suggest moving these straight to hardy. Moving to anything else when
there's an LTS of the OS we use on all our other machines seems silly

also, the free space on deathray is currently being used for /fast-storage.
I would suggest possibly moving databases on to the space in carbon? Is there
anything else that need particularly fast disk access?

----

werdz> Alright, I agree on the move to Hardy. Re databases, would it not make
more sense to put them both on murphy? Once we get that stupid local disk space
issue sorted.  /fast-storage is on deathray. We can put LDAP on murphy for the
moment too, since dapper has the version we need, although this issue needs to
be sorted out in the long term.

Eventually, maybe the following service layout:

| Minerva | Murphy | Carbon | Deathray | Cynic |
| ------- | ------ | ------ | -------- | ----- |
| Login   | P web  | LDAP 2 | LDAP 3   | DNS 3 |
| LDAP 1  | MySQL  | DNS 1  | DNS 2    | S web |
|         | PgSQL  | Mail 2 | Mail 1   |       |
|         |        | Boards | Squid ch |       |

*Edit(voy): This is the presumed table, the original was not well preserved.
`Squid ch` is `Squid Cache`*

*Note - Sec(ondary) web isn't a full fledged copy of what we're running on
Murphy right now. Rather, it would be a place for the random little tidbits
that really shouldn't go down when the important machines go down (ie. the kind
of crap we're running on obelisk right now - these docs, anyterm, irc proxy,
etc). Obelisk is a heap of junk compared to cynic.*

Once the twins are done, we should look into the least painful way to upgrade
minerva and severus (severus being the far easier one) to Hardy.
