# Nixos

Familiarise yourself with the layout of the following. Bookmarking the page is also a good shout.
[nixos documentation](https://nixos.org/nixos/manual/)


### Who is nixos and what does he do
Nixos is a distribution of linux that is focused on having a config-first operating system to run services. The advantages of such an approach are the following:
 - Files dictate how an installation is set up, and as such, can be versoined and tracked in your favorite VCS.
 - New configs can be tested, and safely rolled back.
 - Can be used for both physical and virtual machines in the same way.
Further reading on this can be found at https://nixos.org/nixos/about.html


### Being an admin: Nixos and you
There's a couple of things you'll need to do before you get started with nixos
First and foremost is to get set up to contribute to the redbrick nix-configs repo

 - https://github.com/redbrick/nix-configs
 
Depending on the powers that be, some sort of normal pr contribution will be acceptable, if you have access a branch is appropriate, in all other cases make a fork and pr back to redbricks repo. This will be case by case for those of you reading

Here's a quick hitlist of stuff that's worthy of book marking also as you work with nix
 - https://nixos.wiki/wiki/Main_Page
 - https://nixos.org/nixos/manual/
 - https://nixos.org/nixos/packages.html?channel=nixpkgs-unstable (not that unstable is good but just for an idea)
 - https://nixos.org/nixos/options.html#services.grafana (as an example of how to configure an individual service)
 
Nix is pretty small as an OS so setting yourself up a node, either as a home server, or as a VM is a solid way to practice how stuff works in an actual environment and lets you work independantly of redbrick. A service you configure at home should be able to run on redbrick, and vice versa.

#### Getting set up to start deploying stuff


