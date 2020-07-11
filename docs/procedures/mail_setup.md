# Admin Mail Setup

Hi there, fresh-faced young redbrick admin. I expect you've noticed that since
you became an admin you've been getting a lot more mail from members wanting
accounts renewed/logwatch telling you the status of the machines/Nigerian
princes offering you vast sums of money. This comes with the territory,
unfortunately. The following are config files that will allow you to manage
admin emails within mutt or webmail.

To set up mutt please refer to the
[wiki](https://wiki.redbrick.dcu.ie/index.php/Mutt)

Then to setup mail filters for all the email add the following to you
`.dovecot.sieve` in your home dir in redbrick

```sieve

require ["regex", "fileinto"];

if anyof(
    header :regex ["To", "CC", "Delivered-To", "BCC", "Sender"] ".*committee@(.*)?redbrick.dcu.ie",
    header :regex ["Subject"] ".*Re: .Committee.*",
)
{
    fileinto "committee";
    stop;
}

if anyof(
    header :regex ["To", "CC", "Delivered-To", "BCC", "Sender"] ".*admin(.*)@(.*)?redbrick.dcu.ie",
    header :regex ["To", "CC", "Delivered-To", "BCC", "Sender"] ".*root(.*)@(.*)?redbrick.dcu.ie",
    header :regex ["To", "CC", "Delivered-To", "BCC", "Sender"] ".*abuse@(.*)?redbrick.dcu.ie"
)
{
    fileinto "admin";
    stop;
}

if header :is ["To", "CC", "Delivered-To", "BCC", "From"] "admins+mailman@redbrick.dcu.ie"
{
    fileinto "admin/mailman";
    stop;
}

if anyof(
    header :regex ["To", "CC", "Delivered-To", "BCC", "From"] ".*webgroup@(.*)?redbrick.dcu.ie",
    header :regex ["To", "CC", "Delivered-To", "BCC", "From"] "webmaster@(.*)?redbrick.dcu.ie"
)
{
    fileinto "admin/webmaster";
    stop;
}

if anyof(
    header :regex ["To", "CC", "Delivered-To", "BCC", "Sender"] ".*admin-discuss@(.*)?redbrick.dcu.ie",
    header :regex ["To", "CC", "Delivered-To", "BCC", "Sender"] ".*nixos-discuss@(.*)?redbrick.dcu.ie"
)
{
    fileinto "admin/discuss";
    stop;
}

if anyof(
    header :regex ["To", "CC", "Delivered-To", "BCC", "From"] ".*accounts@(.*)?redbrick.dcu.ie",
    header :regex ["To", "CC", "Delivered-To", "BCC", "From"] ".*treasurer@(.*)?redbrick.dcu.ie\""
)
{
    fileinto "admin/accounts";
    stop;
}

if anyof(
    header :regex ["To", "CC", "Delivered-To", "BCC"] "dirvish@(.*)?dirvish.org",
    header :regex ["To", "CC", "Delivered-To", "BCC"] ".*system-reports@(.*)?redbrick.dcu.ie",
    header :regex ["To", "CC", "Delivered-To", "BCC"] ".*owner@lists.redbrick.dcu.ie",
    header :regex ["To", "CC", "Delivered-To", "BCC"] ".*full-disclosure@(.*)?lists.grok.org.uk",
    header :regex ["To", "CC", "Delivered-To", "BCC"] ".*security-reports@redbrick.dcu.ie",
    header :regex ["To", "CC", "Delivered-To", "BCC"] ".*ubuntu-security-announce@lists.ubuntu.com"
)
{
    fileinto "admin/reports";
    stop;
}

if header :regex ["To", "CC", "Delivered-To", "BCC"] ".*announce-redbrick@(.*)?redbrick.dcu.ie"
{
    fileinto "announces";
    stop;
}
```

Refer to [The rbwiki article on mutt](http://wiki.redbrick.dcu.ie/mw/Mutt) if
you have trouble or PM me (no idea who me is but its not the person git says it
is).
