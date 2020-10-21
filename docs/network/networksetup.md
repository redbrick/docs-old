# Redbrick Network Setup

Redbrick's network comprises three VLANs all of which are present on Sebastian and Steve.

The three VLANs are:

- Internal
- External
- Management

## Internal VLAN

**Subnet:** 192.168.0.0/24

The internal network is used for internally hosted services that should not be
accessible from the outside. eg NFS, LDAP, MySQL etc.

## External VLAN

**Subnet:** 136.206.15.0/24

The external network is used for publically hosted services eg. SSH, Web hosting,
DNS etc.

**Note:** The subnet 136.206.16.0/24 was also allocated to Redbrick at one point but unfortunately we are unable to use it. This will need to be looked into.

## Management VLAN

**Subnet:** 192.168.1.0/24

The internal network is used for managing our serversthat should not be
accessible from the outside.
