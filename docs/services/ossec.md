# What's OSSEC

OSSEC is a Host Intrustion Detection System. It's doing some log monitoring, and it check sums `/bin`,
`/sbin`, `/usr/bin/`, `/usr/sbin/`, and `/etc` on all the machines it runs on (currently minerva,
carbon, deathray, and sprout itself. I intend to add murphy in the near future, and severus as soon
as we get around to taking the OS disks off the RAID controller)

## What does it do

* email us based on a suspicous log entries
* run  a rootchecker, and email us based on that
* email us if any of the directories above change

## How does one install/update it?

* Download the version from [osses here](http://www.ossec.net/main/downloads/)
* Run install.sh
* tell it where our OSSEC lives (thats alwalys going to be `/usr/local/ossec`)
* say yes to upgrading

## What options did you enable in ossec

Everything except active response. As useful as it may be, I don't want this thing running commands
as root quite yet

## How do I add new agents

* Download ossec as above
* Run install.sh
* Choose agent when it asks you which version you want to install
* When it asks you where to install choose `/usr/local/ossec/`
* Enable everything except active response
* Run `/usr/local/ossec/bin/manage-agents` on sprout
* Add the agent in the dialoug
* Extract the key in the dialoug
* Run `/usr/local/ossec/bin/manage-agents` on the new agent
* Paste the key in
* Start ossec by running `/usr/local/ossec/bin/ossec-contrl start`

## Where can I find more docs?

[Their docs](http://www.ossec.net/main/manual/)

## This is a spammy piece of shit

Initially yes. There's a whole host of things that crop up on RB all the time that it feels the need
to email you about that you don't care about. I've got a list of rules to eliminate most of them in
`/usr/local/ossec/rules/local_rules.xml`. You'll probably need to add to this if you add a new
machine/service. Details on how to do this are [here](http://www.ossec.net/wiki/index.php/Know_How:Email_Alerts_below_7)
and regex docs for it (because it uses it's own shitty regex library are [here](http://www.ossec.net/wiki/index.php/Know_How:Regex_Readme).
You should probably read both before doing anything with this.
