# IRC

## RedBrick IRCd

This runs on paphos, irc.redbrick has it's own service address for this.

IRCd runs on ircd-hybrid build from the apt source package. It needs to be
compiled by us to have ssl support to peer with the network (and also to have
halfops, nicklength=9*, opme etc.). Because of this hybrid is pinned in apt
and should NEVER be automatically upgraded. Letting apt upgrade hybrid will
cause us to fall off the network, and things to asplode.

Most of the stuff in ircd.conf is fairly obvious. For adding new external users
etc. just copy and change one of the existing blocks. After changes are made to
the file /rehash as an oper, don't restart it with the init script.

Peers: It's important that autoconn is set to no, apparently due to endian
issues or something.

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
chan_is_opless(const struct Channel *const chptr) {
  const dlink_node *ptr = NULL;

  DLINK_FOREACH(ptr, chptr->members.head)
    if (((struct Membership *)ptr->data)->flags & CHFL_CHANOP)
      return(1);

  return(1);
}
```

## Redbrick Inspircd

In 2016/2017 we began work to move to inspircd. This was due to the the
complications in ircd-hybrid and how old it was. These complications stopped new
netsocs joinging us so we all agreeded to move irc.
We run inspircd on zeus inside docker. We build the container ourself locally,
the container pulls from git to build version 2.0.23.

### Installation

Dockerfile is as follows

``` Dockerfile
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
        build-essential\
        libssl-dev\
        libssl1.0.0\
        openssl\
        pkg-config\
        git &&\
        rm -fr /var/lib/apt/lists/*

RUN useradd -u 10000 -d /inspircd/ inspircd

ENV VERSION v2.0.23

RUN git clone https://github.com/inspircd/inspircd.git /usr/src/inspircd
WORKDIR /usr/src/inspircd
RUN git checkout $VERSION
RUN ./configure --disable-interactive --prefix=/inspircd/ --uid 10000 --enable-openssl
RUN make && make install

RUN apt-get purge -y build-essential && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 6667 6697
VOLUME ["/inspircd/conf"]

ENTRYPOINT ["/inspircd/bin/inspircd"]
CMD ["--runasroot", "--nofork"]
```

and the `docker-compose.yml` is as follows

``` yaml
version: '3'
services:
  irc:
    build: '.'
    container_name: 'irc'
    restart: 'always'
    ports:
      - 6697:6697
      - 7000:7000
      - 7005:7005
    volumes:
      - '/etc/inspircd:/inspircd/conf:ro'
      - '/etc/apache2/ssl:/ssl
```

### Configuration

`inspircd.conf` passwords and keys have been left blank.

``` xml
<config format="xml">
<define name="bindip" value="1.2.2.3">
<define name="localips" value="&bindip;/24">
<server name="irc.redbrick.dcu.ie" description="Redbrick IRC" network="Intersocs">
<admin nick="Admins" email="admins@redbrick.dcu,ie">
<bind address="" port="6697">
<bind address="" port="7000" type="clients" ssl="openssl">
<bind address="" port="7005" type="servers" ssl="openssl">
<power hash="sha256" diepass="" restartpass="">
<connect name="main" allow="136.206.15.*" hash="sha256" timeout="10" useident="no" fakelag="on" limit="5000" pingfreq="120" modes="+x" requiressl="on" port="7000">
<connect allow="136.206.15.*" hash="sha256" timeout="10" useident="no" fakelag="on" limit="5000" pingfreq="120" modes="+x" requiressl="off" port="6697">
<cidr ipv4clone="32" ipv6clone="128">
<include file="/inspircd/conf/opers.conf">
<include file="/inspircd/conf/links.conf">
<files motd="/inspircd/conf/motd.txt" rules="/inspircd/conf/rules.txt">
<channels users="80" opers="600">
<dns server="136.206.15.26" timeout="5">
<options prefixquit="Quit: " suffixquit="" prefixpart="&quot;" suffixpart="&quot;" #fixedquit="" #fixedpart="" syntaxhints="yes" cyclehosts="yes" cyclehostsfromuser="no" ircumsgprefix="no" announcets="yes" allowmismatch="no" defaultbind="auto" hostintopic="yes" pingwarning="15" serverpingfreq="60" defaultmodes="nt" moronbanner="You're banned! Email abuse@redbrick.dcu.ie if you feel this is wrongly justified" exemptchanops="nonick:v flood:o" invitebypassmodes="yes" nosnoticestack="no" welcomenotice="yes">
<performance netbuffersize="10240" somaxconn="128" limitsomaxconn="true" softlimit="12800" quietbursts="yes" nouserdns="no">
<security announceinvites="dynamic" hidemodes="eI" hideulines="no" flatlinks="no" hidewhois="" hidebans="no" hidekills="" hideulinekills="yes" hidesplits="no" maxtargets="20" customversion="" operspywhois="no" restrictbannedusers="yes" genericoper="no" userstats="Pu">
<limits maxnick="31" maxchan="64" maxmodes="20" maxident="11" maxquit="255" maxtopic="307" maxkick="255" maxgecos="128" maxaway="200">
<log method="file" type="* -USERINPUT -USEROUTPUT" level="default" target="logs/ircd.log">
<whowas groupsize="10" maxgroups="100000" maxkeep="3d">
<badnick nick="ChanServ" reason="Reserved For Services">
<badnick nick="NickServ" reason="Reserved For Services">
<badnick nick="OperServ" reason="Reserved For Services">
<badnick nick="MemoServ" reason="Reserved For Services">
<badhost host="root@*" reason="Don't IRC as root!">
<insane hostmasks="no" ipmasks="no" nickmasks="no" trigger="95.5">
<include file="/inspircd/conf/modules.conf">
```

`opers.conf` is standard the only modification will be the addition of each oper
account.

`links.conf` this is for peering and not yet set until we peer.

`modules.conf` needs to be the same across all peered server.

``` xml
<module name="m_sha256.so">
<alias text="NICKSERV" replace="PRIVMSG NickServ :$2-" requires="NickServ" uline="yes">
<alias text="CHANSERV" replace="PRIVMSG ChanServ :$2-" requires="ChanServ" uline="yes">
<alias text="OPERSERV" replace="PRIVMSG OperServ :$2-" requires="OperServ" uline="yes" operonly="yes">
<alias text="ID" format="#*" replace="PRIVMSG ChanServ :IDENTIFY $2 $3" requires="ChanServ" uline="yes">
<alias text="ID" replace="PRIVMSG NickServ :IDENTIFY $2" requires="NickServ" uline="yes">
<alias text="NICKSERV" format=":IDENTIFY *" replace="PRIVMSG NickServ :IDENTIFY $3-" requires="NickServ" uline="yes">
<alias text="CS" usercommand="no" channelcommand="yes" replace="PRIVMSG ChanServ :$1 $chan $2-" requires="ChanServ" uline="yes">
<module name="m_allowinvite.so">
<module name="m_alltime.so">
<module name="m_banexception.so">
<module name="m_banredirect.so">
<module name="m_chanhistory.so">
<chanhistory maxlines="20" notice="yes">
<module name="m_check.so">
<module name="m_chgident.so">
<module name="m_chgname.so">
<module name="m_close.so">
<module name="m_clones.so">
<module name="m_conn_join.so">
<autojoin channel="#lobby,#helpdesk">
<module name="m_cycle.so">
<module name="m_halfop.so">
<module name="m_operjoin.so">
<operjoin channel="#interadmin" override="no">
<module name="m_operlog.so">
<module name="m_operprefix.so">
<operprefix prefix="&">
<module name="m_passforward.so">
<passforward nick="NickServ" forwardmsg="NOTICE $nick :*** Forwarding PASS to $nickrequired" cmd="PRIVMSG $nickrequired :IDENTIFY $pass">
<module name="m_password_hash.so">
<module name="m_permchannels.so">
<permchanneldb filename="/inspircd/conf/data/permchannels.conf" listmodes="true">
<include file="/inspircd/conf/data/permchannels.conf">
<module name="m_muteban.so">
<module name="m_randquote.so">
<randquote file="/inspircd/conf/quotes.txt">
<module name="m_regex_glob.so">
<module name="m_regex_posix.so">
<module name="m_rline.so">
<module name="m_sajoin.so">
<module name="m_sakick.so">
<module name="m_samode.so">
<module name="m_sanick.so">
<module name="m_sapart.so">
<module name="m_saquit.so">
<module name="m_satopic.so">
<module name="m_serverban.so">
<module name="m_sslmodes.so">
<module name="m_ssl_openssl.so">
<openssl cafile="/ssl/RapidSSL_CA_bundle.pem" certfile="/ssl/redbrick.dcu.ie.crt" keyfile="/ssl/redbrick.dcu.ie.key" dhfile="/ssl/dhparam.pem" hash="sha1" sslv1="false" tlsv1="false" >
<module name="m_timedbans.so">
<module name="m_uninvite.so">
<module name="m_spanningtree.so">
```
