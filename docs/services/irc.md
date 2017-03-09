# RedBrick IRCd
This runs on morpheus, irc.redbrick has it's own service address for this.

IRCD runs on ircd-hybrid build from the apt source package. It needs to be
compiled by us to have ssl support to peer with the network (and also to have
halfops, nicklength=9*, opme etc.). Because of this hybrid is pinned in apt
and should NEVER be automatically upgraded. Letting apt upgrade hybrid will
cause us to fall off the network, and things to asplode.

Most of the stuff in ircd.conf is fairly obvious. For adding new external users
etc. just copy and change one of the existing blocks. After changes are made to
the file /rehash as an oper, don't restart it with the init script.

Peers: It's important that autoconn is set to no, apparently due to endian issues or something.

* The limit on the network is 9 character nicks, allowing our server to do more
  than this will result in our server letting people set long nicks, but they'll
	immediately be kicked off the network. This gets old pretty quick.

#### Compiling

```bash
$ cd /tmp; mkdir build; cd build

# may want to delete the other files that you get with it for clarity
$ apt-get source ircd-hybrid 					
$ cd ircd-hybrid-7.2.2.dfsg.2
# edit debian/rules and add export USE_OPENSSL=1 and change nicklen=9
# (Optional)Patch m_opme.c to allow it to always give you ops, see below
# run fakeroot debian/rules binary
$ cd ..
$ dpkg -i ___.deb # generated .deb (not the hybrid-dev one, you can ignore/delete that)
# Copy appropriate configuration files
# Add block to /etc/network/interfaces
$ /etc/init.d/ircd-hybrid (re)start
```

#### Admin tools
1. Go to `/usr/lib/ircd-hybrid/modules`
2. Copy `m_force.so` (forcejoin and forcepart) `m_ojoin.so` (OJOIN) and
   `m_opme.so`(OPME) to `autoload/`
3. Make sure that these are chmoded so that they are world readable, or at least
   readable to `ircd`

##### m_opme
OPME is no fun if you can't use it to take over any channel you want, patch
`contrib/m_opme.c` before compiling to make the function `chan_is_opless`
always `return 1`:

```c
chan_is_opless(const struct Channel *const chptr)
{
  const dlink_node *ptr = NULL;

  DLINK_FOREACH(ptr, chptr->members.head)
    if (((struct Membership *)ptr->data)->flags & CHFL_CHANOP)
      return(1);

  return(1);
}
```
