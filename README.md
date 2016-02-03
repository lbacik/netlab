# netlab
Small Networking Laboratory - you can use it on Linux, Windows, Mac or any other system supported by Vagrant and VirtualBox.

The environment used in tests - whole Small Networking Laboratory - has been built inside virtual machine managed by the VirtualBox. This base system is called "Host" (please note the uppercase letter, "host" is very often used word in IT), within it (within the Host) there are futher installed "Guest" systems (according to the test scenario). The lxc technology (Linux Containers) is used for isolating (virtualization) the Guest systems.  

* Linux Containers - LXC - https://linuxcontainers.org

As it has been indicated above - the number of the Guest and the way they are connected depends on the test's scenario, and such scenarios are scripts "projectXX.sh", where XX is a number, which you can find in "scripts" directory.

The script "project01.sh" is executed automatically during environment build process.

## Requirements

* Vagrant - https://www.vagrantup.com   
* VirtualBox - https://www.virtualbox.org (if you will have any problems using VirtualBox 5.0 with vagrant please downgrade VB to version 4.3 - https://www.virtualbox.org/wiki/Download_Old_Builds_4_3) 

## Usage 
Once repository is cloned / downloaded please go to the directory 

    vagrant/ubuntu1404

(the Ubuntu build is for the time being only one available) and start vagrant by

    vagrant up

First time it will take a while to build the virtual environment (unfortunately, in current version, the Ubuntu "image" will be downloaded twice - first time for VirtualBox, second for lxc. Once downloaded and built the lxc image is compressed and saved in "data" directory - it will speed up the build process after "vagrant destroy" command) 

When build process is complete please use

    vagrant ssh

to login into Host system! Unfortunately, on Windows the "vagrant ssh" may not work - please use putty or other ssh client to connect with VM (ip address:port will be visible in "vagrant ssh" command output, user is "vagrant", password "vagrant").


> **NOTE!** It is only short description of the Vagrant command, if you have never used it before please check the documentation available at https://www.vagrantup.com/docs/getting-started - it can be really usefull, and first of all, will give you a much better view of the Vagrant capabilities. 

## What next?

Please check doc/ directory to find test descriptions and... have fun! :) 
