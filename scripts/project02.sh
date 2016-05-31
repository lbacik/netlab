#!/bin/bash
#	
#

BARENAME=bare
LXCDIR=/var/lib/lxc

echo '* Preparing host10...'
lxc-clone $BARENAME host10

cat <<EOT >> $LXCDIR/host10/config
lxc.network.type = veth
lxc.network.name = eth1
lxc.network.link = br02
lxc.network.flags = up
EOT

cat <<EOT >> $LXCDIR/host10/rootfs/etc/network/interfaces
auto eth1
iface eth1 inet static
	address 10.10.10.1
	netmask	10.10.10.255
	
EOT

echo '* Preparing host11...'
lxc-clone $BARENAME host11

sed '' $LXCDIR/host11/rootfs/etc/network/interfaces
cat <<EOT >> $LXCDIR/host11/rootfs/etc/network/interfaces
	address 10.10.10.10
	netmask 10.10.10.255
	gateway 10.10.10.1
EOT

brctl addbr br02

lxc-start -d -n host10
lxc-start -d -n host11

# iptables
