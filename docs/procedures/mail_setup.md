# Mail Setup

Hi there, fresh-faced young redbrick admin. I expect you've noticed that since
you became an admin you've been getting a lot more mail from members wanting
accounts renewed/logwatch telling you the status of the machines/Nigerian
princes offering you vast sums of money. This comes with the territory,
unfortunately. The following are config files that will allow you to manage
admin emails within mutt or webmail.

```bash
$ cat .muttrc
  ## General options
  set copy

  ## Redbrick Settings
  set imap_user     = `echo $USER@redbrick.dcu.ie`
  set from          = "$imap_user"
  set use_from      = yes
  set ssl_use_sslv3 = yes
  set folder        = "imaps://mail.redbrick.dcu.ie:993"
  set smtp_url      = "smtp://$imap_user@mail.redbrick.dcu.ie:587"
  set spoolfile     = +INBOX
  mailboxes         = +INBOX
  set record        = +Sent
  set postponed     = +Drafts
  set ssl_force_tls = yes
  set ssl_starttls  = yes
```

```bash
$ cat .dovecot.sieve

require ["fileinto","regex","envelope","vacation"];

if header :comparator "i;octet" :contains "X-Spam-Status" "Yes" {
  fileinto ".spam/";
}

if header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC|Sender)" ".*announce-redbrick@(.*)?redbrick.dcu.ie" {
  fileinto ".announce/";
}

if anyof(
  header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC|Sender)" ".*admin(.*)@(.*)?redbrick.dcu.ie",
  header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC|Sender)" ".*root@(.*)?redbrick.dcu.ie",
  header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC)" ".*abuse@(.*)?redbrick.dcu.ie"
) {
  fileinto ".admin/";
} elsif anyof(
  header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC)" "dirvish@(.*)?dirvish.org",
  header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC)" ".*system-reports@(.*)?redbrick.dcu.ie",
  header :regex :comparator "i;octet"  "(To)" ".*owner@lists.redbrick.dcu.ie",
  header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC|Sender)" ".*full-disclosure@(.*)?lists.grok.org.uk",
  header :regex :comparator "i;octet"  "(To)" ".*security-reports@redbrick.dcu.ie",
  header :regex :comparator "i;octet"  "(To)" ".*ubuntu-security-announce@lists.ubuntu.com"
) {
  fileinto ".admin.reports/";
} elsif header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC|Sender)" ".*admin-discuss@(.*)?redbrick.dcu.ie" {
  fileinto ".admin.discuss/";
} elsif anyof(
  header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC)" ".*accounts@(.*)?redbrick.dcu.ie",
  header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC)" ".*treasurer@(.*)?redbrick.dcu.ie"
) {
  fileinto ".admin.accouts/";
} elsif anyof(
  header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC)" ".*webgroup@(.*)?redbrick.dcu.ie",
  header :regex :comparator "i;octet"  "(To|From)" "webmaster@(.*)?redbrick.dcu.ie"
) {
  fileinto ".admin.webmaster/";
}
if anyof(
  header :regex :comparator "i;octet"  "(To|CC|Delivered-To|BCC)" ".*committee@(.*)?redbrick.dcu.ie",
  header :regex :comparator "i;octet"  "Subject" ".*Re: .committee.*"
) {
  fileinto ".committee";
}
```

Refer to [The rbwiki article on mutt](https://wiki.redbrick.dcu.ie/mw/Mutt) if
you have trouble or PM me (no idea who me is but its not the person git says it
is\_).
