# Project 01 - Easy Case

In this scenario we have two nodes connected to one switch

* host01 - node 1
* host02 - node 2
* lxcbr0 - switch (bridge exactly ;))

host01 and host02 names should be resolved by local dns, please check:

    ping host01
    ping host02
    
To run a command on particular node you don't have to login to it, there have been added aliases in host system allowing you to run commands as:

    h1 ping host02

- It means: run command "ping host02" on h1 (host01)
Now, using second console (i recommend to use screen - https://www.gnu.org/software/screen/manual/screen.html which is already installed in host system), please check the results on host02:

    h2 sudo tcpdump -i eth0 icmp

Are there any packets visible?

[TODO] Arp tricks...
 
 