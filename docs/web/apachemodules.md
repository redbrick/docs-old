# suPHP configuration

### Building

First, modify `mod_suphp.c` to allow certain configuration directives from
within the Apache configuration.

[A usenet post](http://lists.marsching.com/pipermail/suphp/2005-June/000876.html)
explains:

> Edit `src/apache/mod_suphp.c` and change line `252` so it reads
> `RSRC_CONF|ACCESS_CONF` instead of just `ACCESS_CONF`. You may also want to
> edit line 254 in the same way.

We're using apache2, so you need to edit `src/apache2/mod_suphp.c`, and the line
numbers as of version 0.6.3 are `324` and `325`.

When you're done, cd back to top, and configure:

```bash
./configure \
  -with-apxs=/usr/local/apache2/bin/apxs \
  -with-apache-username=webservd \
  -prefix=/usr/local/apache2/suphp \
  -with-setid-mode=owner \
  -with-apr=/usr/local/apache2/bin/apr-1-config
```

Once that finishes, you can build it with `dmake -j 4`. Then `dmake install` -
there seems to be a weird bug with the build system, the script used for
`dmake install` is `chmod 600`. So, before running `make install`, run
`chmod 755 config/install-sh`.

Build and install it in the zone murphy-global.

### Setup

Configuration file at `/usr/local/apache2/suphp/etc/suphp.conf`.

Log files go to `/var/log/apache2/suphp_log`.

### Note

- suPHP seems to dislike threaded MPMs. At this point (v0.6.3), prefork is the
  only one that seems to work.
