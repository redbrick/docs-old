# Fast storage space for users

We decided to offer users a small amount of space on deathray's disk array, as it's far faster than minerva's. This is useful for people who, for example, use redbrick email extensively, and don't want to wait an epoch for mutt to load. 

It's mounted as /fast-storage on all machines, and we're starting off by offering 300MB per user (of course they can ask if they want more).

## Adding fast storage for a user

If a user requests access to this array, run ''/srv/admin/scripts/faststorage_add.pl username''. It will confirm everything it's about to do with you, and then run if you approve. To specify a starting quota, use an extra command line argument.. e.g. to give 600MB, run ''/local/admin/scripts/faststorage_add.pl username 600000''. To specify a block limit, use another command line argument on top of the first.. e.g. to give 16,000,000 blocks, run ''/srv/admin/scripts/faststorage_add.pl username 300000 16000000''.

The user directory will be created in /fast-storage/users/u/username, and will be chmod 700.


## TODO

Set up backups for this array. <- Done - lil_cain



