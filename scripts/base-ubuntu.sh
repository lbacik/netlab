#!/bin/bash
#
#	Preparation of the base system
#

PROVISION_FILE=/project/data/ubuntu-provisioning.lock

if [ ! -f $PROVISION_FILE ]; then

	aptitude update
	aptitude install -y lxc, iftop

	### dns
	echo '* dns...'
	echo 'nameserver 10.0.3.1' >> /etc/resolvconf/resolv.conf.d/head
	resolvconf -u

	### ssh key
	echo '* SSH keys...'
	cat /dev/zero | ssh-keygen -q -N ""

	echo '* Coping ssh key...'
	cp /root/.ssh/id_rsa /home/vagrant/.ssh/
	cp /root/.ssh/id_rsa.pub /home/vagrant/.ssh/
	chown vagrant.vagrant /home/vagrant/.ssh/id_*

	echo '* End of base file...'

	touch $PROVISION_FILE

	/project/scripts/lxc-bare-ubuntu.sh
	/project/scripts/project01.sh 

fi

