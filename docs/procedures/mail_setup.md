# Mail Setup

Hi there, fresh-faced young redbrick admin. I expect you've noticed that since you became an admin
you've been getting a lot more mail from members wanting accounts renewed/logwatch telling you the
status of the machines/Nigerian princes offering you vast sums of money. This comes with the
territory, unfortunately. The following are config files that will allow you to manage admin emails
within mutt.

To make these configs work, you need to go to your `~/Maildir` and run `mdmake <mailbox_name>`,
where mailbox_name is the name of each mailbox in the mailboxes line of the below `.muttrc`.
e.g. `mdmake committee`

``` bash
$ cat .muttrc
  alias ealist Elected-Admins `<elected-admins@redbrick.dcu.ie>`
  alias rbcmte Redbrick Committee `<committee@redbrick.dcu.ie>`
  alias rbaccts Redbrick Accounts `<accounts@redbrick.dcu.ie>`
  alias rbadmins Redbrick Admins `<admins@redbrick.dcu.ie>`

  set reverse_name=yes
  set from=gw@redbrick.dcu.ie

  set folder="~/Maildir"
  mailboxes =.inbox =.spam =.sent =.committee =.helpdesk =.admin.reports =.admin
  set copy
  set record=+.sent
```

``` bash
$ cat .procmailrc
  # Fecked this config off of haus.

  USER=`<your username here>`
  MAILDIR=$HOME/Maildir
  SHELL=/usr/local/shells/zsh
  LOGFILE=~/procmaillog
  VERBOSE=ON

  #dcu already scan spam, if they've marked it as spam, it's probably spam.

  :0:

  * ^X-Spam-Status: Yes
  .spam/

  :0fw: spamassassin.lock

  * < 256000
  | spamassassin

  :0: admin.reports.lock

     *^(To|CC|Delivered-To|BCC): dirvish@(.*)?dirvish.org
     .admin.reports/

  :0: admin.reports.lock

     *^(To|CC|Delivered-To|BCC): .*system-reports@(.*)?redbrick.dcu.ie
     .admin.reports/

  :0: admin.reports.lock

     *^(To): .*owner@lists.redbrick.dcu.ie
     .admin.reports/

  #:0: admin-discuss.lock
  #   *^(To|CC|Delivered-To|BCC|Sender): .*admin-discuss@(.*)?redbrick.dcu.ie
  #   .admin-discuss/

  #:0: admin-discuss.lock
  #   *^(To|CC|Delivered-To|BCC|Sender): .*trainee-admins@(.*)?redbrick.dcu.ie
  #   .admin-discuss/

  :0: admin.reports.lock

     *^(To|CC|Delivered-To|BCC|Sender): .*full-disclosure@(.*)?lists.grok.org.uk
     .admin.reports/

  :0: admin.reports.lock

     *^(To): .*security-reports@redbrick.dcu.ie
     .admin.reports/

  :0: admin.reports.lock

     *^(To): .*ubuntu-security-announce@lists.ubuntu.com
     .admin.reports/

  :0: admin.lock

     *^(To|CC|Delivered-To|BCC|Sender): .*admin(.*)@(.*)?redbrick.dcu.ie
     .admin/

  :0: admin.lock

     *^(To|CC|Delivered-To|BCC|Sender): .*root@(.*)?redbrick.dcu.ie
     .admin/

  :0: admin.lock

     *^(To|CC|Delivered-To|BCC): .*abuse@(.*)?redbrick.dcu.ie
     .admin/

  :0: admin.lock

     *^(To|CC|Delivered-To|BCC): .*webgroup@(.*)?redbrick.dcu.ie
     .admin/

  :0: admin.accounts.lock

      *^(To|CC|Delivered-To|BCC): .*accounts@(.*)?redbrick.dcu.ie
      .admin.accounts/

  :0: admin.accounts.lock

      *^(To|CC|Delivered-To|BCC): .*treasurer@(.*)?redbrick.dcu.ie
      .admin.accouts/

  :0: committee.lock

     *^(To|CC|Delivered-To|BCC): .*committee@(.*)?redbrick.dcu.ie
     .committee/

  :0: admin.lock

    *^(From): webmaster@(.*)?redbrick.dcu.ie
    .admin/

  # catch all replies for committee folder
  :0: committee.lock

     *^Subject: .*Re: .Committee.*
     .committee/

  :0:
    .inbox/
```

Refer to [The rbwiki article on mutt](http://wiki.redbrick.dcu.ie/mw/Mutt) if you have trouble or PM
me (no idea who me is but its not the person git says it is_).
