# Plan for Worf

Page for discussing the pending move of /storage from minerva to worf on 6th/7th Feb

### Before Down Time

*  <del>Announce Down time -- Lotta sending initial notice today or tomorrow, more information next week</del>

*  Rsync /storage to worf mounted on Ceiling Cat

*  Migrate disk quotas to worf (see below)

### During Down Time

*  Before turning off minerva, comment out the /storage lines in /etc/fstab. When minerva comes up with the controller, the new array may be sda by default, we don't know.

*  Install Dell Controller into Minerva

*  Final Rsync to worf

*  Unmount Minerva's Array

*  Mount worf as /storage

### Post Down Time

*  Work out stratagy for using minerva's array for backups

### Quota migration script

This needs to do the same as we did for the carbon/deathray -> minerva move (slightly less complicated, last time we were coming from two separate arrays, this time we've only got one to worry about)

    new_quota = 2GB (or something)
    for each user:
     old_quota = (use quota command to find their quotas)
     if user quota < new_quota:
         use setquota on worf to set the user's quota to new_quota
     else:
         use setquota on worf to set the user's quota to old_quota
