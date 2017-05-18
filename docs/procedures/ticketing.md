# Redbrick needs a ticketing system

This is a list of stuff that would be nice to have - if someone already has a ticket system half in
place that doesn't do half of these things, ignore it :)

## Overview

* Incident/bug tracking
* Change tracking
* Privacy (when someone submits a security bug, we don't want everyone else to be able to see it)
* LDAP auth. It'd be nice to let users see/add to their own tickets (this isn't necessary though,
  it's firmly in the nice to have section) - lil_cain

## Incident/bug tracking

* User opens ticket. First step of ticket requests the category and shows a quick list of other open
  tickets in this category. If any found, user can add their name to this. Else user can open a new
  ticket. Choose severity, choose security issue (true/false), enter description. User is subscribed
  to incident, so all replies are forwarded to them.
  * Optional - User may reply to posts via email (to, for example, bug+12345@redbrick.dcu.ie).
* Admins mailed all new bugs, and subscribed to all bug threads.
* Optional - Some sort of nagios integration.. perhaps unnecessary, nagios already whines enough
  without having the bug tracker do it too. (I think this'd be nice, simply so that if something
  went up and down again, someone'd have to look into it to some degree, rather than just pretending
  it didn't happen - lil_cain)

## Change tracking

* Admins can schedule downtime and large changes. The type of thing that requires an announcement
  to users.
* Ideally, all non-trivial changes would be ticketed, and diffs of changes/things done added to
  them. This'll probably get honoured more in breach than observance though - lil_cain
* Admins can choose whether or not to have change mailed to users, whether or not to have a bot in
  #lobby set the topic, whether or not to set the motd, post to the announce boards etc, via check
  boxes. All this would be automatically done.
* Status of change may be viewed (during downtime) by users (assuming that the downtime doesn't
  affect the bug tracking server).

Perhaps some way to maintain two running copies of this system, in sync.

-werdz\\
7/4/08
