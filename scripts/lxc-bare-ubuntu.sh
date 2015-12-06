#!/bin/bash
#
#	Preparation of the base (bare) container
#

BARENAME=bare
BAREARCHIVE=/project/data/lxcbare_ubuntu.tar.gz

if [ -f $BAREARCHIVE ]; then

	echo '* Unpacking the bare...'
	tar xzf $BAREARCHIVE -C /var/lib/lxc	

else

	echo '* No compressed bare file found - downloading system image...'
	lxc-create -n $BARENAME -t ubuntu -- --packages "tcpdump"
	### user ubuntu/ubuntu

	mkdir /var/lib/lxc/$BARENAME/rootfs/home/ubuntu/.ssh

	### sudo
	echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /var/lib/lxc/$BARENAME/rootfs/etc/sudoers.d/ubuntu 

	echo '* Compressing bare lxc...'

	tar czf $BAREARCHIVE -C /var/lib/lxc $BARENAME

	echo '* OK'
fi

cat ~/.ssh/id_rsa.pub > /var/lib/lxc/$BARENAME/rootfs/home/ubuntu/.ssh/authorized_keys
