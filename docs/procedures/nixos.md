# NixOS

Familiarise yourself with the layout of the following. Bookmarking the page is also a good shout.
[NixOS documentation](https://nixos.org/nixos/manual/)

### Who is NixOS and what does he do

NixOS is a distribution of linux that is focused on having a config-first operating system to
run services. The advantages of such an approach are the following:

- Files dictate how an installation is set up, and as such, can be versoined and
  tracked in your favorite VCS.
- New configs can be tested, and safely rolled back.
- Can be used for both physical and virtual machines in the same way.

Further reading on this can be found on the [about page](https://nixos.org/nixos/about.html).

### Being an admin: NixOS and you

There's a couple of things you'll need to do before you get started with NixOS
First and foremost is to get set up to contribute to the [Redbrick nix-configs repo](https://github.com/redbrick/nix-configs).

Depending on the powers that be, some sort of normal pr contribution will be acceptable,
if you have access a branch is appropriate, in all other cases make a fork and pr back to
Redbrick's repo. This will be case by case for those of you reading.

Here's a quick hit list of stuff that's worthy of book marking also as you work with Nix:

- [NixOS Wiki](https://nixos.wiki/wiki/Main_Page)
- [NixOS Manual](https://nixos.org/nixos/manual/)
- [Nixpkgs index](https://nixos.org/nixos/packages.html?channel=nixpkgs-unstable)
  (unstable means changing, not buggy)
- [Grafana config options](https://nixos.org/nixos/options.html#services.grafana)
  (as an example of how to configure an individual service)

Nix is pretty small as an OS so setting yourself up a node, either as a home server, or as a VM
is a solid way to practice how stuff works in an actual environment and lets you work
independantly of Redbrick. A service you configure at home should be able to run on Redbrick,
and vice versa.

#### Getting set up to start deploying stuff

The first step is to navigate to the ssh service config in the nix-config repo
[here](https://github.com/redbrick/nix-configs/blob/master/services/ssh.nix).

Make a pull request asking to add the **PUBLIC KEY** of your ssh key pait to the config file.
The best thing to do is to copy the previous line and modify it to contain your details instead.
At time of writing, it is expected for you to generate a `ssh-ed25519` key. This is subject to
change with new cryprographic standards.

Once this is done, contact one of the currently set up users to pull and reload the given machines
and you'll have access right away using the accompanying key.
