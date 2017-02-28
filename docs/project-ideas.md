# Project Ideas

The point of this page is to dump ideas which could be cool/useful/interesting, so not all the stuff here needs to get done. The idea is that someone who has too much free time, or looking to learn more about the subject can go work on it. Please leave your name beside your suggestions, so that people can like ask you about them.

Most of these projects don't require being an admin to work on, in any case, you can drop a message to whoever suggested the project to talk about it. If you would like to suggest a project, but don't have a docs account, just message one of the admins.

##  Small Scripts 


*  You've just installed a new machine. However, redbrick's ldap groups (member, associat, and so on) are on gids already used by stupid ubuntu system ids. Script something to go through the groups in ldap, and make sure there's no conflicts. If there are, you need to change the gid of the group in /etc/group, and then chown all the files owned by that group to the new gid. for extra credit, you should then insert the ldap groups into /etc/group, and sort it by gid.  --- //[Eoghan Cotter](johan@redbrick.dcu.ie) 2009/05/16 16:28// Working on this, see /srv/admin/scripts/check_fix_gids.sh
## Larger Projects

*  Web hey/huh interface
    * *I may look into this over the summer - creadak*

*  Windows Server (we have data for this)

*  Improvement of web boards interface to appeal to newbies (David)
     *//If you're doing this, you should hang around boards through one of the old fashioned interface for a while first (slrn/tin/thunderbird/whatever. An actual client). A lot of the stuff that's different from normal forum systems is to do with nntp being fundamentally different from web forums, stuff that if you change, you may as well just move to real web forums, and leave INN2 running in the background. Also, isn't this primarly a webmaster hing? Anyway, just my 2c.- Cian//
     * *web-news (someone put a link here, I can't find it) is lovely, and extremely easy to expand/integrate with pubcookie. It would need a good security poking-around though. --- *[Andrew Martin](werdz@redbrick.dcu.ie) 2009/09/08 00:00// //
     * // http://web-news.sourceforge.net/ <--link. Should we be worried that it's written in a no longer supported version of php? [Cian](lil_cain@redbrick.dcu.ie)//

*  Motd system with database/web stuff so everyone can use it (receive)

*  Multimaster mysql (receive)
     * *receive now claims this is a terrible idea, because of split brain problems. I'm inclined to agree - lil_cain*

*  Better webmail - it's terrible. (receive)
    * *I've been thinking about this for the last year and a half, have a few ideas on how to achieve it. If anyone wants to go down the write-your-own road, let me know so we can go through it. I'd still love to give it a try myself, but can't see it happening any time soon. -werdz*
      * *If someone has a suggestion over SquirrelMail, hooray. But given that it's GPLv2, would it not make sense for us to just make it better? - David*
         * // Using squirrel mail means you have to A: Learn the codebase and then B: write new code. If what we want to do is sufficiently different (and it probably is), than we can reasonably jut do B if we write from scratch, without B being a whole lot bigger. - Cian  //
         * // I had a look at doing this (extending Squirrelmail) last year. The words "kill it with fire" jump to mind.  --- //[Andrew Martin](werdz@redbrick.dcu.ie) 2009/09/08 00:00// //

*  Jabber based hey (receive)

*  re-write rbusers, and hey in python/perl/ruby, and restore the admin/helpdesk categories that used to exist. (receive)
        * rbusers is done and, on hg.redbrick.dcu.ie (in python). If someone annoys me, I might even package it - lil_cain
        * *I'm gonna work on this over the summer, and maybe add in some "hey helpdesk" that heys all helpdesk members. If I do it, it'll be in python - creadak*

*  rewrite useradm to be sane. I might actually do this one myself if I have time (lil_cain)

*  look at some kind of automated install. Slack looks reasonable for this (http://code.google.com/p/slack/) (lil_cain) (actually, andrew has this pretty much done with packages)

*  ticketing system (lil_cain)
     *//I know werdz is playing around with some custom code, but this may be worth looking at as well http://www.gnu.org/software/gnats/#introduction - Cian//
     *//we should just install bugzilla. It doesn't look that difficult.//

*  meta dependencies - the [packages](redbrick-apt) system is pretty much setup, but the meta packages could do with a whole bunch more dependencies added. Involves someone working out what's installed where, and what should be installed in various locations by default.

*  Write apparmor profiles for all the daemons we run (lil_cain)
       *//we can actually probably steal most of these from lucid//

*  Some kind of log management thingy. Logwatch is grand, but 10 mails/day is really pushing it's limits as far as people actually reading them properly is likely to go. It's worth taking a look into something else (OSSEC-HIDS, or prelude-IDS, or SEC, or some other log aggregator/reporting tool I have yet to hear about) to replace all of these with a single daily mail/alert based system/some combination of the two. This isn't really a priority, but if we're going to be talking about adding windows boxes, and with IP tables, I'd expect to see far more logs, and the system we currently have is designed for small, rather than large numbers of servers. (lil_cain)
     *//Anyone mind if I install OSSEC somewhere, and play around with it a bit w/r to this? - Cian//

*  get rid of the internal network. We should be able to replicate all the benefits we get from it with a firewall (or just packet filter on hadron).

*  openID.redbrick.dcu.ie

*  Work Out something to do with minerva's disks. Possible Suggestions:
     * Hack something together to turn them into backups
       * could you use some sort of VM for this? give it access to the device?
       * you could mount them rw on a mount point that was chmoded 700, and then remount them somewhere else ro that users can actually read. Hack, but it'll work.
     * Mount and offer to members as slow-storage for large files

*  Post Install Script for ubuntu to automaticaly fix security and other bugs, may also automatically install certain packages see [ New Installs Page](newinstalls) for list of common bugs to be fixed 
 1. -something like 'apt-get install redbrick-server'? The only thing this doesn't do, iirc, is change the config on sshd to prevent root logins
    
