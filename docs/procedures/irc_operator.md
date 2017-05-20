# IRC Ops

This is a mirror of: [Redbrick cmt Wiki entry](https://www.redbrick.dcu.ie/cmt/wiki/index.php?title=IRC_Op_Guide)

##### Channel Modes

It's easy to bugger up the channel with the MODE command, so here's a nice
copied and pasted summary of how to use it:

* `/mode {channel} +b {nick|address}` - ban somebody by nickname or address
  mask (nick!account@host)
* `/mode {channel} +i` - channel is invite-only
* `/mode {channel} +l {number}` - channel is limited, with {number} users
  allowed maximal
* `/mode {channel} +m` - channel is moderated, only chanops and others with
  'voice' can `talk/mode {channel} +n` external `/MSG`s to channel are not
  allowed.
* `/mode {channel} +p` - channel is private
* `/mode {channel} +s` - channel is secret
* `/mode {channel} +t topic` - limited, only chanops may change it
* `/mode {channel} +o {nick}` - makes `{nick}` a channel operator
* `/mode {channel} +v {nick}` - gives `{nick}` a voice

##### Other Commands

Basically what you'll be using is:

* To kick someone: `/kick username`
* To ban someone: `/mode #lobby +b username`
* To set the topic: `/topic #lobby whatever`
* To op someone: `/mode #lobby +o someone`
* To op two people: `/mode #lobby +oo someone someone_else`

Or:

* To kick someone: `/k username`
* To ban someone: `/ban username`
* To unban someone: `/unban username`
* To set the topic: `/t whatever`
* To op someone: `/op someone`
* To op two people: `/op someone someone_else`
* To deop someone: `/deop someone`

##### Sysop specific commands

These commands can only be run by sysops (i.e. admins in the ircd config file).

* Enter BOFH mode (required for all sysop commands): `/oper`
* Peer to another server*: `/sconnect <node name>`
* Drop a peer with another server: `/squit <node name>`
* Force op yourself (**do not abuse**): `/quote opme <channel name>`
* Barge into a channel uninvited (**again, do not abuse**):
  `/quote ojoin #channel`
* Barge into a channel uninvited with ops (**same again**):
  `/quote ojoin @#channel`
* Force someone to join a channel: `/quote forcejoin nick #channel`
* Kill someone: /kill `<username>` `<smartassed kill messsage>`
* Ban someone from this server: `/kline <username>`
  (there may be more params on this)
* Ban someone from the entire network: `/gline <username>` (there may be more
  params on this)

(thanks to atlas for the quick overview)

* Don't try connect to intersocs. Due to crazy endian issues or something they
  have to connect to us.

##### Bots

It has now become a slight problem with so many bots 'littering' #lobby that
anyone wishing to add a new bot to the channel must request permission from the
Committee. The main feature wanted is a time limit on bot commands.

##### Services

The IRC services run by Trinity for all the netsocs. The two services are
`NickServ` and `ChanServ`.

* `/msg NickServ HELP`
* `/msg ChanServ HELP`

for more details.
