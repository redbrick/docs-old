# IRC

## Redbrick InspIRCd

In 2016/2017 we began work to move to InspIRCd. This was due to the
complications in ircd-hybrid and how old it was. These complications stopped new
netsocs joining us so we all agreed to move irc. \$ 4 years later after multiple
attempts we had not migrated. Until TCD decided to shutdown their server
breaking the network.

We run Inspircd v3 on Metharme. InspIRCd's docs can be found
[here](https://docs.inspircd.org/) for configuration specifics.

IRC is available at `irc.redbrick.dcu.ie` on port 6697. SSL is required for
connection, we do not support non-SSL.

When connecting from a redbrick server a user will be automatically logged in.
If connecting from an external server a user must pass their password on login.

For the purpose of external peering of other servers the port 7001 is expose as
well. Similarly to clients we only support SSL on this port

For docs on connecting and using an IRC client please refer to the
[wiki](https://wiki.redbrick.dcu.ie/index.php/IRC)

### Installation

InspIRCd is installed with Nix. There is no Nix package for InspIRCd so we
compile a specific git tag from source. See
[Nix package](https://github.com/redbrick/nix-configs/tree/master/packages/inspircd)
for details on how it is compiled.

Given we only support SSL and require LDAP, we need to enable both at compile
time.

### Configuration

InspIRCd's configuration is in Nix
[here](https://github.com/redbrick/nix-configs/blob/master/services/ircd/inspircd/conf.nix).
This config will be converted to xml on disc.

#### Important Configuration

_oper_ is a list of admin users on the irc server. Their `OPER` password will
need to be manually hashed with `hmac-sha256`, and placed in a secret on the
server to be read in by inspircd

_ldapwhitelist_ is a list of cidr addresses that do no require authentication.
The list consists of Redbrick public and private addresses as well as `oldsoc`

_link_ is a list of all servers we peer with including the anope services server
that runs on the same box.

### oldsoc.net

`oldsoc.net` is a server run by old TCD netsocers. All the users on it are the
remaining TCD associates following the shutdown of TCD IRCd. This server is
maintained by its own users and has explicit permission to join IRC without LDAP
auth.

## Anope

Redbrick runs Anope services for the entire network. As with inspircd we
[compile from source](https://github.com/redbrick/nix-configs/tree/master/packages/inspircd).
Refer to anopes [github docs](https://github.com/anope/anope/tree/2.0/docs) for
configuration specifics.

Our current Anope is configured with standard mods of chanserv, nickserv and
operserv. All config is in
[here](https://github.com/redbrick/nix-configs/tree/master/services/ircd/anope/confs)

Anope stores all info in a custom db file on disk.

## Discord

We run a [bridge](https://github.com/qaisjp/go-discord-irc) between Redbrick
discord and irc. The configuration for this is
[here](https://github.com/redbrick/nix-configs/tree/master/services/ircd/discord/conf.nix).

The bridge adds all users from discord with the suffix `_d2` and all irc
users appear as them self but tagged as a bot in discord. Not all discord
channels are on IRC, the config above contains a mapping of irc channels to
discord channels id's. This needs to be manually updated to add more channels.
