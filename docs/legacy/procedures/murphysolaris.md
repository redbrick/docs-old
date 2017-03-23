# Murphy and Solaris

## Reasoning for Solaris


*  We want a stable OS. Ubuntu/SPARC was unstable before we reinstalled things, and even moreso now. The total user base of Debian/Ubuntu/Gentoo on Niagara seems to be something you could count using one hand, so chances are it isn't going to be prioritised too much (as evidenced by the huge lack of activity relating to it on the Debian site, and Ubuntu dropping official support in 8.04). The guy who did the initial Niagara/Linux kernel work (Dave Miller) seems to be leaving it alone for the moment (the last sign of him doing anything on SPARC was to do with gdb).

*  Solaris supported it first, supports it now, and will support it for the lifespan of the machine. There is no question of that, whereas it's very questionable whether any linux distribution will support it this time next year (Even Gentoo, who seem the most enthusiastic about it at this point, are scaling back the architectures that they support in general. SPARC will probably be dropped soon enough.)

*  I'm not happy with Dapper's support as is. There were a few important security patches that Feisty/Gutsy/Hardy got that dapper didn't get (suPHP, etc). Also, there's a lot of silly bugs, like that mysql thing. It's also likely to mean we can't ever upgrade the ALOM - given the state of sun4v kernel development, I can't see them fixing the Invalid Instruction bug any time soon. (last note tacked on by werdz, it wasn't really brought up as a point at the meeting about this).

## Reasoning against Solaris


*  Updating the operating system and Sun-supplied software will be awkward at best, requiring about half an hour of downtime every few months.

*  Keeping non-sun packages (in our case, this will probably be the majority) will be an even bigger pain in the ass.
    * werdz suggests (I hate talking in the third person) putting together some scripts to keep things *somewhat* automated. It wouldn't exactly be apt, but something like a vastly simplified version of emerge. You create a description file which describes how to check for an update and how to compile updates, then the script checks for updates, downloads and compiles any updates it finds, emails the admins going HEY! Package x has updates that are ready to be installed. Here's the changelogs. Log into murphy and type installupdate x if you're ok with proceeding. I think this could be done relatively easily.
    * This is even more viable when you consider that we, in fact, have two production solaris machines
    * Having said all that, it could be a lot of work for no real benefit. We'll see.

*  We have to make sure that new admins aren't scared away from Solaris. If they do, murphy will become another deathray.

## Current steps

We're installing Solaris on murphy for the moment to see how it goes. Murphy is, for the time being, a testing/figureoutwhatthefucktodowithit machine, so we have a chance to test/play around with it, and find what works.

If it turns out to be disasterous/we break down crying half way/etc, we can always just go back to Ubuntu or try out other Linux distros (although, as outlined above, we're fairly convinced that they'll all be as dodgy as Ubuntu was, if not worse). Or even NetBSD or something.

## Next steps

Once murphy has a new OS, there are a few things to be done


*  For one thing, we all need to play around with it, because at the moment nobody is particularly comfortable with it.

*  We need to look into how apache is generally maintained on a system like this. As in, kept up to date. Is it just like it was on deathray before, or would it be a candidate for that update script thing that was mentioned earlier?

*  We need to figure out LDAP integration. There is talk, with good reason behind it, of moving our LDAP server to OpenDS, but that's an argument for another wiki page.

*  We need to figure out how user shells are going to work, since many people's .bashrc files will cause a Solaris shell to crap out or generally act stupid (missing switches on things, aliases setting ls=ls --color, etc)

*  Most importantly, we need to decide whether or not this is viable. Bearing in mind that realistically, Solaris seems to the only way to have a stable murphy that isn't at risk of having OS support pulled from under it's feet.
