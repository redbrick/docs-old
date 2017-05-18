# NB THIS IS A LEGACY PAGE KEPT FOR POSTERITY. THIS IS NOT AN ACCURATE REPRESENTATION OF THE Current Ldap Setup

# Current Ldap Setup

Ldap is running on Morpheus. The secondary ldap should be setup on deathray as
soon as it is re-installed, and setup as a slave.

## The ldap schema

Our ldap schema isn't compatible with the current openldap schema. To get
around this I tried to use the old ones from ubuntu 6.06 carbon, but this failed
miserably. In the end we told ldap to run with our schema + it's default schema,
started slapd in debug mode making changes (read: deleted bits) to the schema
files until it would actually start. This took *ages*.

The new modified schema files are in /etc/ldap/schema/redbrick. Common, system
and userdb are redbrick written schema files. I've no idea where solaris.schema
or DUAConfigProfile.schema came from, or if we even really need it. The rest are
butchered versions of the ones supplied with openldap.

# History
**This dates from a few years ago, and doesn't reflect the current setup in
__any__ way.** Useful to read though.

#### Current to do list

* Change slurpd user to be someone other than root
* Secure tunnel the slurpd requests
* Double check normal write access gets rejected on deathray
* Update the init.d script on carbon to be newer version (like dr's)
* setup some script to notify admins when ldap goes down on either server

#### Setup

> Primary: carbon.internal [192.168.0.1]

> Seconday: prodigy.internal [192.168.0.2]

Carbon uses itself for ldap querys with no fallover defined.

Dizer: I setup replication between the two hosts, but slurpd is really really
bad. The replication went out of sync somewhere. I'm hoping this has improved
in newer versions of OpenLDAP. This is why we should upgrade.

Deathray uses prodigy with no fallover defined.

Dizer: Deathray should use Carbon, not Prodigy.

Prodigy is set to use carbon and fallover to itself if carbon goes down. As
deathray is using prodigy as it's main server, all its requests get auto
forwarded to carbon and then back through prodigy to itself.
(deathray request -> prodigy ->(auto forward) carbon (carbon replies) ->
prodigy -> deathray) The fallover line is currently commented out on prodigy
due to the issue with slurpd not sync'd the two db meaning if carbon goes down,
ldap goes down for rb.

#### Questions

1. How is deathray working since prodigy's ldap is currently down? It doesnt
   have a fallover to carbon defined and ldapsearch doesnt work.

Dizer: Where do you see it defined on Deathray that it uses prodigy as the main
server?

```
deathray:/etc# egrep '^host' libnss-ldap.conf\\
host 192.168.0.1\\
deathray:/etc# egrep '^host' pam_ldap.conf\\
host 192.168.0.1 192.168.0.2
```

That is, it uses Carbon. We should join the ldap.confs into one file and symlink
from those locations to avoid them going out of sync like this.

Ryaner: ldap conf?

```
deathray [/etc/ldap] # cat ldap.conf | grep HOST\\
HOST    192.168.0.2
```

changing the host lets ldap search work and the manual said that was the main
config for the ldap libraries. Didnt know you could set the stuff in the other
configs.

As you said, centralising this may be an good idea. There is an idea about a
central ldap server floating about. Comments on that? (see bottom of the doc)

Dizer: In Debian `/etc/ldap/ldap.conf` is only used by the ldap* commands. The
system itself uses `/etc/libnss-ldap.conf` and `/etc/pam_ldap.conf`. The joys
of using a fully packaged system eh?

Ryaner: Yeah that does actually make sense. Prob be worth our while setting up
a single config and referencing things from the other configs on that.

Dizer: Yes

2. Why is no fallover defined on either deathray? Understand that prodigy
will auto fallover so it's not needed but it'd wouldnt hurt to have it defined?
Or would it?

No, won't hurt, but didn't seem to really help either. I'm not sure what timeout
it uses or how many times it retries, but the failover to secondary never
worked, basically. Every single ldap request was attempted against the primary,
then supposed it's supposed to failover to the secondary, but there was either
too many requests coming in and the timeout was too large, or this feature is
as badly broken as the rest of ldap...

Ryaner: ldap's timout seem weird. If it connects but doesnt get a response it
seems to just sit there waiting and waiting. I've yet to find a proper timeout
anywhere in the configs which is a bit of a problem. But if the ldap host goes
down, ldap *shouldnt* be able to connect and then pass to it's fallover.
I think :)

Actually after looking though the two files you showed me above, there is idle
timeouts it them so they might be an idea to enable them. Testing them
would involved have the backup running and killing ldap on carbon which could
be messy.

Dizer: We could quite easily have a little testbed setup in which to fiddle with
these settings. We can easily run two ldap servers on the one machine ...

Ryaner: We do have umls now to play with so :)

Dizer: I didn't even think of that. You can just run slapd on a different port..

3. Why is no fallover defined on carbon? Wouldnt a fallover help stop the
huge load jump on carbon is ldap shits itself?

See previous answer. It made no difference.

4. Prodigy's fallover is removed because of the lcak of sync'ing between
the two databases right? If I'm wrong then why is it?

The failovers were all the same to begin with, but as things broke they were
commented out or deleted to just make things work in the short term and never
put back.

5. Any ideas why the sync between carbon and prodigy isnt working properly?
And would a simple clearing of prodigy's db and reindexing using a dump from
carbon help fix it? For the short term?

Well. In the short term it'd probably help, but in the long term there's an
issue there somewhere. The problems seems to be with the ACLs set on slapd on
Prodigy (the slave). Every so often an LDAP update just fails with an ACL
violation. If you take the same update and run it through slurpd again (-o
on slurp is a oneshot mode which you can use to repeat failed queries in a
manual way) they work fine. Bizarre. If you read any of the OpenLDAP forums
you'll learn that slurpd was basically tacked on as something that's needed NOW,
but was never planned and no one particularly cares about it. As a result it's
not tested, it's buggy and generally horrific to work with. For example, there's
no way to say 'Try all failed updates again', you have to go in making temporary
directories and running slurpd manually, bla bla, it's awful.

Again, this is why we need to upgrade to see if these issues have been fixed.
If we do upgrade it's pretty important that the version we use on all our
machines be precisely the same. I had lots of nasty issues when the versions
weren't the same but replication was attempted between them.

Ryaner: I've seen some of the issues with it. Nice corrupt db being talked
about. I didnt however see the acl issue. All I have gotten was just a simple
sitting there doing nothing or it spitting out that it was ignoring all the
missing entries on prodigy. Thats why I'd thought of a reindex. Doing the
reindex now shouldnt cause any issues should it? It'd allow ldap backup to be
up for short term which *could* help thing. Although crash other day looked
like nfs caused it.

As for idea of central server above, the idea is that ldap would run on a
central box that just does ldap and no login stuff. All queries go to that
system and modification ONLY take place on that db. If it goes down, the
machines fallback to their own local, readonly database (presuming a readonly
one is possible?) and no changes can be made until the central server comes
back online. With the central server, upgrades to ldap would be alot easier
to do and there wouldnt be any really nasty issues with sync's (hopefully).

Dizer: Yup. It's all been said before and it's a good idea. Only issues are that
any tool that uses modifications needs one ldap.conf, anything that just reads
needs another. This isn't as easy as you might think. That said, I'm sure there
are ways around it, but it'd certainly need some work. I'd be all for having:

* Deathray  (Master server)
* Carbon    (Local slave)
* Prodigy   (Local slave)

This not only ensures better performance, reduced latency but added data
redunadancy. I'm not sure why you say it'll make it easier for upgrades though?
(Unless you mean just because we'll have more servers we can failover to). My
experience has lead me to believe that the versions must be exactly synchronised
on all machines for this sort of setup to work. Upgrading the master could well
break all the replication to the slaves, which would mean a reindex on each of
them.

WRT the reindex of Prodigy now, I agree, it might help, but I think you're
looking at a consequence of the problem here, not the cause. That is, are you
sure ldap is actually the cause of the problems we've been having? LDAP has
never ever caused a complete system crash for us... there've been a few nasty
hangs and some uids messes, but never a total lock out that I can remember.

Ryaner: Well the idea on ldap would be to have it totally seperate from any
login box. That way it wouldnt be down for any maintaince etc due to other
packages needing upgrading. It wouldnt generate much load either so a lowish
spec machine *should* do the job.

---

Dizer: Well. It doesn't make much difference does it? Your dedicated LDAP box
might crash too? If Deathray goes down, you lose the LDAP master, but you still
have your slaves, no updates can happen. But if you lose your dedicated LDAP
master, the same applies.. The added advantage of using Deathray is our LDAP
master is on a machine with a guarantee and that has quality hardware. You don't
want to put something this important on a piece of crap :)

Ryaner: That is a good point. The thought was that a dedicated machine would go
alot less then deathray. But I suppose the added benifit of having nice hardware
would outweight that.

Dizer: Heh. Deathray should *never* go down. It's up to us to make that so :)

---

In regards upgrades, if there is a central server, upgrades would only need to
be applied to it to have a 'working' ldap setup. For slurpd to work we then
bring back the other local db's one by one after their upgrades. Any problem
with the master upgrade would be hidden / kinda. Prob no advantage over the
setup you suggested above except that deathray wouldnt be used as the main
server. Deathray does go down for upgrades etc at times so it would be better
not to use it I think.

WRT? Dunno what that means :) And as for the index, it'd mainly be a temp
solution just to get ldap back up and running on prodigy until we've decided
exactly whats going to be done in regards the 'ldap overhaul'. As for it being
the problem on the crash, it wasnt. NFS on enigma was and I'm currently working
on that. Carbon and deathray have to be checked too. Mickeyd has offered to help
with upgrading mount on those once we are sure it's def that. More to follow
next week on that.

WRT = With regard to.

---

Okay, makes some sense. I wouldn't invest too much time in it though, there's
no reason the 'overhaul' can't happen semi-immediately as far as I'm concerned.

---

Ryaner: Concern has been expressed that the other admins havent being told
exactly whats happening with the whole thing. Maybe do up same little plan and
mail the admins list with whats gonna happen that then once replies come just
do the setup.

Just to clarify what your planning
Primary:        Deathray
Secondary:      Carbon
sSecondary:     Prodigy

Dizer: Yes. Assuming we get replication working flawlessly, any box that uses
LDAP should probably run a local slapd. (Unless the box doesn't really matter).

Timeouts
Bind:   120
query:  10              (low but each login is it's own query)

---

NFS -> Oh yeah? What was the problem? Incompatible mount versions?

Mount gets an error message on boot about being older than kernel version or
something like that. Not sure if thats related to the nfs is. When carbon and
dr down the other night, the logs showed bad blocks on the nfs mounts. Nfs has
died on enigma at that point giving the same block errors in the logs.  fsck
showed the disk were grand. NFS has since died a few times so I've removed the
/backup mounts from carbon till I've looked into it more.

#### Email

All

Over the last while I've been spending some time going over the ldap setup on
rb. With the help of dizer (a lot of help I may add), have come up with the
following setup. Questions, comments, criticisms are all welcome and advised.
I'm a newbie in regards to ldap but no one else seems to wanna touch it so.

Anyway, the setup.

Primary:        Deathray
Secondary:      Carbon
sSecondary:     Prodigy

And provided that replication between db's is finally fixed completely, each
system would run their own, readonly, ldap server. Anytime that deathray goes
down the other machines will still be able to auth but just not able to change
and information. This is mainly to stop things getting out of sync.

```
Timeouts (seconds):
bind:           120
query:          10      [each seperate login counts as a query, after 10 seconds, ldap

                        *should* move onto the next host in it's fallback list so no
                        one should really notice any ldap downtime, only longer login
                        times.]\\
search:         30
```

#### Ldap versions
Carbon is currently running 2.0.23 while prodigy is running 2.1.22. There issues
with different versions of slapd sync'in which *may* have led to the recent
problems with prodigy being very much out of data compared to carbon. Ldap is
being stuck into debug to output some logs over the next few days so we can try
and work out where the problem actually is. Dizer has pointed to acl's on
prodigy being the issue.

If anyone has noticed anything else please add it in.

So thats pretty much all I have to say for now. If you've read this far then
well done.

Thanks again to dizer for his help lately too.

#### ldap.setup.new


1. install `ldap-utils`, `libnss-ldap`, `libpam-ldap`
2. create symlinks for all the shells in `/usr/local/shells`
   **DON'T FORGET THIS ONE!!!!**
3. add the following line to `/etc/ldap/ldap.conf`, `libnss-ldap.conf`,
	 and `pam_ldap.conf`
	```
	BASE    o=redbrick
	URI     ldap://192.168.0.1      ldap://192.168.0.3
	```
4. change the time to `10`.
5. add the following line to the `/etc/pam.d/common-auth`
	```
	auth    sufficient      pam_ldap.so
	```
6. add the following line to `/etc/pam.d/common-password`
	```
	password        sufficient      pam_ldap.so
	```
7. add the following line to `/etc/pam.d/common-account`
	```
	account         sufficient      pam_ldap.so
	```
8. add the following line to /etc/pam.d/common-session
	```
	session         sufficient      pam_ldap.so
	```
9. Finally add the word ldap to the lines beginning `passwd`:, `shadow:`, and
   `group:` in `nsswitch.conf`
