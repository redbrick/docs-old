### Changing web interface passwords

I keep meaning to write a script that does this automagically, but until then you're stuck with this procedure I've found works.

''sqlite3 /var/lib/rbvm/rbvm.db''

You will now have the lovely sqlite prompt. I hate it.

''sqlite> select * from user_table''

That will give you the users and the password salts. Get the password hash by

''sha256sum''

''passwordSalt''

Then ^D^D. You will now have the new hash \o/

Insert it into the database by doing a simple:

''sqlite> update user_table set password="llllooooonnnnngggggghhhhaaaaasssssshhhhhh" where username="username"''

.quit and gtfo there.
