#!/bin/bash
#	
#
#	host01 (h1) -- lxcbr0 -- host02 (h2)
#
#

BARENAME=bare

echo '* Preparing host01...'
lxc-clone $BARENAME host01
lxc-start -d -n host01

echo '* Preparing host02...'
lxc-clone $BARENAME host02
lxc-start -d -n host02

### aliases
sudo -u vagrant bash -c "echo 'alias h1=\"ssh -o StrictHostKeyChecking=no -t ubuntu@host01\"' >> /home/vagrant/.bashrc"
sudo -u vagrant bash -c "echo 'alias h2=\"ssh -o StrictHostKeyChecking=no -t ubuntu@host02\"' >> /home/vagrant/.bashrc"


