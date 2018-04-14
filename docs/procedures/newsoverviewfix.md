# News fix

## Problem

New posts are not appearing on the boards at all or are only appearing on some
boards. (The low traffic ones, .test for example).

This is due to the crash badly affecting the overview information, the overview
information thinks that certain filenames are free, the server can't write new
posts since the physical files already exist.

To verify this is the problem the server is experiencing tail the log file
`/var/log/news/news.err` and check for entries like this:

```text
Feb 11 15:24:41 carbon innd: SERVER cant store article: File exists
Feb 11 15:24:55 carbon innd: tradspool: could not open /var/spool/news/articles/redbrick/help/4707 File exists
```

## Solution

Rebuild the overview information and renumber the active file to takethe new
numbers into account.

```bash
/etc/init.d/inn2 stop
cd /var/spool/news
/usr/lib/news/bin/makehistory -O -x -F
chown -R news:news overview
/etc/init.d/inn2 start
ctlinnd renumber ''
```
