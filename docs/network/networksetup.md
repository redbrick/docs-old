# Redbrick Network Setup

Redbrick's network comprises three VLANs all of which are present on Hadron.

The three VLANs are:

- Internal
- External
- Management

Other notible networks in Redbrick are:

- RBVM Subnet
- Severus VPN

## Internal VLAN

**Subnet:** 192.168.0.0/24

The internal network is used for internally hosted services that should not be
accessible from the outside. eg NFS, LDAP, MySQL etc.

Blue or grey cables are used when connecting a server to this network.

## External VLAN

**Subnet:** 136.206.15.0/24

The external network is used for publically hosted services eg. SSH, Webhosting,
DNS etc.

Red cables are used when connecting a server to this network.

The External VLAN spans the Redbrick server room and the library, allowing
Serverus to be mapped onto the External VLAN.

## Management VLAN

**Subnet:** 192.168.1.0/24

The management network is used solely for management cards. The only server
(non-management card) connected to this network is halfpint.

Yellow cables are used when connecting a server to this network.

## RBVM Subnet

**Subnet:** 136.206.16.0/24

The RBVM Subnet is a whole /24 used solely for user VMs provided by RBVM. The
RBVM subnet is firewalled by data.

A green cable is connected directly from data to daniel.

## Severus VPN

**Subnet:** 192.168.3.0/24

The Severus VPN is used as a means of connecting Severus to the internal network
over the External VLAN. Static routes are created to route traffic for the
internal VLAN subnet (192.168.0.0/24) over the VPN.

The VPN is hosted on halfpint with a packet forwarding enabled and a basic pf
setup.

## Network diagram (2017)

Colours represent the networks each server is connected to.

- Red: External VLAN
- Blue: Internal VLAN
- Yellow: Management VLAN
- Green: RBVM Subnet crossover

```graphviz
digraph redbrick {
    # Style
    nodesep=1.0;
    node [color=green,fontname=Courier,shape=Mrecord,style=filled];
    edge [color=Blue, style=dashed];

    # Variables
    heanet[label="HEAnet" color=lightblue shape=box];
    dcu [label="DCU Firewall" color=lightblue shape=box];
    power [label="Main Power" shape=triangle color=yellow];
    cerberus [label="{ srx220 | <bold>Cerberus | junos | Firwall}" color=purple]
    hadron [label="{ <bold> Hadron | cisco | Internal Switch}" color=purple]
    higgs [label ="{<bold> Higgs | junos | Internal network }" color=purple]
    kvm [label="{IP KVM}" color= lightskyblue];
    worf[label="{<bold> Worf | DAS }" color=tan]
    pdu1[label="" style=filled color=orange]
    pdu2[label="" style=filled color=orange]
    manage[label="{Management Network | junos}" color=purple]

    # Machines
    azazel[label="{R515 | <bold> azazel | Ubuntu 14.04.5 | 12 cores | 16GB memory | Login}"]
    paphos[label="{R710 | <bold> paphos | Ubuntu 14.04.5 | 16 cores | 16GB memory | IRC | Mail | LDAP}"]
    albus[label="{R515 | <bold> albus | Ubuntu 16.04.2 | 16 cores | 32GB memory | Backups}"]
    clyde[label="{R210 | <bold> clyde | Ubuntu 12.04.4 | 8 cores | 8GB memory | GameSoc}"]
    meth[label="{R710 | <bold> metharme | Ubuntu 12.04.5 | 16 cores | 16GB memory | MySQL | Apache}"]
    pyg[label="{R710 | <bold> Pygmalion | Ubuntu 16.04.2 | 16 cores | 16GB memory | Development}"]
    zeus[label="{R410 | <bold> zeus | Ubuntu 16.04.2 | 16 cores | 32GB memory | Git | Bitlbee | Monitoring | Docker Services}"]
    halfpint[label="{R710 | <bold> halfpint | freeBSD 9 | 4 cores | 8gb memory | PWSafe Docs}"]

    # Connections
    heanet -> dcu [label="2x100Gb" color=grey style=solid];
    dcu -> cerberus [label="1x1Gb" color=grey style=solid];
    cerberus->hadron;
    hadron -> { azazel paphos albus clyde meth pyg zeus halfpint } [color=red];
    azazel -> higgs;
    paphos -> higgs;
    albus -> higgs;
    clyde -> higgs;
    meth -> higgs;
    pyg -> higgs;
    zeus -> higgs;
    halfpint -> higgs;
    higgs -> kvm [color=goldenrod];
    higgs -> manage [label="VPN" color=goldenrod];
    kvm -> manage [color=goldenrod];
    manage -> { pdu1, pdu2} [label="IP PDU"];
    pdu1 -> power;
    pdu2 -> power;
    azazel -> worf [label="Fiber line" color=grey style=bold];

    # Rank
    {rank=same; heanet dcu };
    {rank=same; azazel paphos albus clyde meth pyg zeus halfpint };
}
```

![Network Diagram](/img/network-diagram20171904.png)
