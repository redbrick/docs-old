# UPS

UPS master is set to carbon for the moment

All others should be slaves

to start ups services, run on carbon (in order)

''upsdrvctl\\
upsd''

Obviously that will run OK  >:D

Then on carbon/deathray\\
''upsc rbups@carbon.internal (check status = 0L)\\
upsmon''

The config syntax has changed, so i quickly edited what was there to the new syntax.

All cfg files are in /etc/nut.

There might be some caveats in there or security problems that should be looked at in more detail

I didnt investigate the non-linux machines (but these arnt _really_ that important anyway ;)

-mickeyd
