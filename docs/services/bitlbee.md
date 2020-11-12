# Bitlbee on RedBrick

This is set up on Metharme.

bitlbee is run using the nixos bitlbee service, see
[here](https://search.nixos.org/options?query=services.bitlbee) for config
options.

We use the default bitlbee settings. Its settings can be found in
[nixos repo](https://github.com/redbrick/nix-configs/blob/master/services/bitlbee.nix).

`bitlbee.redbrick.dcu.ie` is not exposed externally. It is available at
`bitlbee.internal`. For legacy support `bitlbee.redbrick.dcu.ie` is added to the
host files of all boxes to point to the internal address.

We add 2 plugins to bitlbee:

- discord
- facebook

## Data Migration

User details are stored in `/var/lib/bitlbee` as xml data. It is possible to
migrate the user data just by copying the xml files.
