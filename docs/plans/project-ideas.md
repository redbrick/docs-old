# Project Ideas

The point of this page is to dump ideas which could be cool/useful/interesting, so not all the stuff
here needs to get done. The idea is that someone who has too much free time, or looking to learn
more about the subject can go work on it. Please leave your name beside your suggestions, so that
people can like ask you about them.

Most of these projects don't require being an admin to work on, in any case, you can drop a message
to whoever suggested the project to talk about it. If you would like to suggest a project just
create a PR on [Github](https://github.com/redbrick/docs/pulls)

## Small Scripts

* You've just installed a new machine. However, redbrick's ldap groups (member, associat, and so on)
  are on gids already used by stupid ubuntu system ids. Script something to go through the groups in
  ldap, and make sure there's no conflicts. If there are, you need to change the gid of the group in
  `/etc/group`, and then chown all the files owned by that group to the new gid. For extra credit,
  you should then insert the ldap groups into `/etc/group`, and sort it by gid.
  * [Eoghan Cotter](mailto:johan@redbrick.dcu.ie) 2009/05/16 16:28 Working on this, see
    [here](https://github.com/redbrick/admin-scripts/blob/master/check_fix_gids.sh)

## Larger Projects

* Web hey/huh interface
  * I may look into this over the summer - creadak
* Improvement of web boards interface to appeal to newbies (David)
  * If you're doing this, you should hang around boards through one of the old fashioned interface
    for a while first (slrn/tin/thunderbird/whatever. An actual client). A lot of the stuff that's
    different from normal forum systems is to do with nntp being fundamentally different from web
    forums, stuff that if you change, you may as well just move to real web forums, and leave INN2
    running in the background. Also, isn't this primarly a webmaster thing? Anyway, just my 2c.- lil_cain
  * [MuffinReader](https://github.com/Chewie/MuffinReader)
* Motd system with database/web stuff so everyone can use it (receive)
* Re-write rbusers, and hey in python/perl/ruby, and restore the admin/helpdesk categories that
  used to exist. (receive)
  * rbusers is done and, on hg.redbrick.dcu.ie (in python). If someone annoys me, I might even
    package it - lil_cain
  * I'm gonna work on this over the summer, and maybe add in some "hey helpdesk" that heys all
    helpdesk members. If I do it, it'll be in python - creadak
* rewrite useradm to be sane. See [Github Repo](https://github.com/redbrick/useradm/)
* ticketing system (lil_cain)
* meta dependencies - the [packages](/procedures/redbrick-apt) system is pretty much setup, but the
  meta packages could do with a whole bunch more dependencies added. Involves someone working out
  what's installed where, and what should be installed in various locations by default.
* Write apparmor profiles for all the daemons we run (lil_cain)
  * we can actually probably steal most of these from lucid
* Some kind of log management thingy. Logwatch is grand, but 10 mails/day is really pushing it's
  limits as far as people actually reading them properly is likely to go. It's worth taking a look
  into something else (OSSEC-HIDS, or prelude-IDS, or SEC, or some other log aggregator/reporting
  tool I have yet to hear about) to replace all of these with a single daily mail/alert based
  system/some combination of the two. This isn't really a priority, but if we're going to be talking
  about adding windows boxes, and with IP tables, I'd expect to see far more logs, and the system we
  currently have is designed for small, rather than large numbers of servers. (lil_cain)
* get rid of the internal network. We should be able to replicate all the benefits we get from it
  with a firewall (or just packet filter on hadron).
* openID.redbrick.dcu.ie - this should be possible with shiboleth
* Post Install Script for ubuntu to automaticaly fix security and other bugs, may also automatically
  install certain packages see [New Installs Page](/procedures/newinstalls) for list of common bugs
  to be fixed
  * something like 'apt-get install redbrick-server'? The only thing this doesn't do, iirc, is
    change the config on sshd to prevent root logins
