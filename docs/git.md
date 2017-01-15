# Git hosting

Redbrick git hosting has three big components:


*  Git itself (shockingly) - all of the commands that involve pushing/pulling to the server will run the git binaries on the server side too, via SSH.

*  SSH - pushing/pulling is done over SSH with keys, not HTTP(S) or git's own protocol.

*  Gitolite - A bunch of scripts that sit between SSH and git itself to enforce which users and keys are allowed to access which repositories. This used to be called Gitosis, but the name changed for some reason.

There's also a read-only web interface at http://git.redbrick.dcu.ie.

## Gitolite (formerly Gitosis)

Gitolite is available from https://github.com/sitaramc/gitolite

This was installed from source on morpheus. The git user was created manually via adduser, with its home directory under /storage/git (so that it would be included in backups). From here, as the git user, the gitolite install process was followed (check out latest source from Github, run install script, import administrator key and you're done). This all installed into the git user's home directory, so you're not crapping all over the system.

This created a repositories directory containing a default gitolite-admin.git repository, which you will use to administer things in a minute. It also created a (managed) .ssh/authorized_keys file to let the initial admin do stuff. This file will be kept up to date automatically, so you don't need to touch it, but its useful to know how it ties in to SSH.

Note that Gitolite has nothing at all to do with git-web. git-web and gitolite are simply configured to look for git-related-bits in the same place. If you want to prod at git-web, the apache vhost config and /etc/git-web.conf are good places to start.


## Creating a repository for a user

Things you need from a user:

*  The SSH public key(s) from the machines that they want to access their git repositories from.

*  The name of their project.

### Locally on your desktop/laptop

First, if your SSH public key isn't registered and set up with access to gitolite-admin.git, you'll need to get someone who has that access to do it for you. If it is, however:

Clone the gitolite-admin repo somewhere that you can read it locally:

    $ git clone git@git.redbrick.dcu.ie:gitolite-admin
    $ cd gitolite-admin

Yes, that's meant to be git in the user field, don't change it to your own username. Everything to do with this goes via the git user.

Continue on to the "Next step for everybody" section.

### On the git account on the web server

The admin directory has been pre-cloned to the web server (morpheus, at time of writing) for admins too lazy to add their own keys.

    $ su
    # su - git
    $ cd admin

Don't forget to pull the latest version of the repository to the working directory.

    $ git pull

### Next steps for everybody

Once you have the gitolite repo (either locally or on the web server), add the user's SSH key to the keys directory:

    $ cd keydir
    $ cp ~/wherever-the-users-public-key-is.pub username.pub

The .pub extension is important. It doesn't matter what you put in for "username", but the user's username is usually a good bet. If the user wants different devices to access different repos with different keys, maybe call it username-laptop.pub, or username-rb.pub, or whatever. Either way, remember the name you give it.

This is probably a no-brainer, but NEVER PUT A PRIVATE KEY HERE!! The gitolite-admin repository is publically readable.

Next, edit the gitolite.conf file in the conf folder:

    $ cd ../conf
    $ vim gitolite.conf

If you're adding a new repository, you probably want to create a new user group for it, even if there's only one user. A user group is a list of users that have RW access to a repository.

*NB - If you haven't guessed by now, a "user" to gitolite is synonymous with a public key file in keydir, not an actual Unix user.*

A sample user group (awesomegroup) that gives three users (awesomeuser1, awesomeuser2, awesomeuser3) (keyfiles) access to a project called awesomeproject.git is:

    @awesomegroup = awesomeuser1 awesomeuser2 awesomeuser3
    
    repo awesomeproject
      RW+ = @awesomegroup
    
There's lots more detail on the format of this file at the [gitolite github page](https///github.com/sitaramc/gitolite).

This means that machines with the private keys corresponding to the three SSH public keys in keydir (awesomeuser1.pub, awesomeuser2.pub and awesomeuser3.pub) now have read/write access to awesomeproject.git.

Once you've made those changes, add any keys you've added to git:

    git add keydir/whatever.pub

And then commit everything, and give a comment:

    git commit -a -m "Added alice and bob to awesomeproject"

Then push your changes:

    git push

That's all the admin has to do. One of those users now has to actually create the repository and push it, details on how to do this are listed on the main redbrick wiki.
