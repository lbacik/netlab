# netlab
Small networking laboratory - you can use it on Linux, Windows, Mac or any other system supported by Vagrant and VirtualBox.

The environment used in tests is built inside virtual machine managed by the VirtualBox - it is the 'host' system within which there are installed 'guest' systems using lxc technology (linux containers - https://linuxcontainers.org). 

The number of the guests and the way they are connected depends on test scenario (scripts called "projectXX.sh", where XX is a number).

The script "project01.sh" is executed automatically during environment build process.

## Requirements

* Vagrant - https://www.vagrantup.com/   
* VirtualBox - https://www.virtualbox.org/ (if you will have any problems using VirtualBox 5.0 with vagrant please downgrade VB to version 4.3 - https://www.virtualbox.org/wiki/Download_Old_Builds_4_3) 

## Usage 
Once repository is cloned / downloaded please go to the directory 

    vagrant/ubuntu1404

(the Ubuntu build is for the time being only one available) and start vagrant by

    vagrant up

First time it will take some time to build the virtual environment (unfortunately, in current version, the Ubuntu image will be downloaded twice - first time for VirtualBox, second for lxc. Once downloaded and built the lxc image is compressed and saved in "data" directory - it will speed up the build process after "vagrant destroy" command) 

When build process is complete please use

    vagrant ssh

to login into "host" system! Unfortunately, on Windows the "vagrant ssh" may not work - please use putty or other ssh client to connect with VM (ip address:port will be visible in "vagrant ssh" command output, user is "vagrant", password "vagrant").

## What next?

Please check doc/ directory to find test descriptions and... have fun! :) 
