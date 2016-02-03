# Project 01 - Easy Case

In this scenario, we have two nodes connected to one switch


    |host01 (lxc)|---<lxcbr0>---|host02 (lxc)|
                        |
                        |
                   |*vagrant*|  


* host01 - Guest
* host02 - Guest
* lxcbr0 - switch (bridge exactly ;))

Names host01 and host02 should be resolved by local dns, please check (from Host):

    ping host01
    ping host02
    
To run a command on the Guest system you don't have to log on it,  special aliases added in Host system allow to run commands as:

    h1 ping host02

Where "h1" is an alias defined as: 

    alias h1="ssh -o StrictHostKeyChecking=no -t ubuntu@host01"

(You can find this definition, and other, in ``scripts/project01.sh`` file) 

All commands following after "alias" are executed on pointed by this "alias" Guest's system.

Aliases defined in this scenario:

* h1 - alias for host01 Guest system
* h2 - alias for host02 Guest system


Now, using second console (i recommend to use screen - https://www.gnu.org/software/screen/manual/screen.html which is already installed on the Host system), please check the results on host02:

    h2 sudo tcpdump -i eth0 icmp

Are there any packets visible?

## IP - Layer 3

This scenario is not focused on this "layer", so i will only say that i.e. popular "pings" realized through the icmp protocol have place in so called "layer 3" - I will be returning to this subject in futher scenarios, for the time being let's put a dot at this point.

(Maybe i should add here something... smarter?..)

## ARP - Layer 2
 
Arp protocol is the key to understand how the ethernet network exactly works (I think so). It is the lowest working protocol of the TCP/IP stack (below which only physics left). Let's familiarize a little bit with it - the basic command is:

    arp
   
For instance to check the arp table at host01 please type (on Host):

    h1 arp

Result may looks similar to:

    Address                  HWtype  HWaddress           Flags Mask            Iface
    host02                   ether   00:16:3e:30:e7:76   C                     eth0
    10.0.3.1                 ether   fe:20:ba:87:d3:89   C                     eth0

The most important thing here is that if you try to communicate with some host which is not on this list, your OS will use ARP protocol to find it (in the simplest situation when all hosts are using the same ip address class). But if searched host will be present on the list - OS will not communicate with anyone - it will use data directly from this list.

ARP table is just a cache table used by your OS - the data are exparing after some time (usually 5 minutes). 

The example - pinging nonexistent host:

    h1 ping 10.0.3.99

Network (dumped by tcpdump)

    18:44:30.221403 ARP, Request who-has 10.0.3.99 tell host01, length 28
    18:44:31.222196 ARP, Request who-has 10.0.3.99 tell host01, length 28
     
...and because 10.0.3.99 doesn't exist the result should look like:

    PING 10.0.3.99 (10.0.3.99) 56(84) bytes of data.
    From 10.0.3.92 icmp_seq=1 Destination Host Unreachable
    From 10.0.3.92 icmp_seq=2 Destination Host Unreachable

OK, now let's try to cheat our OS! We add a fake address to our ARP table:

    h1 sudo arp -s 10.0.3.99 00:16:3e:30:e7:76
    h1 arp
    Address                  HWtype  HWaddress           Flags Mask            Iface
    host02                   ether   00:16:3e:30:e7:76   C                     eth0
    10.0.3.99                ether   00:16:3e:30:e7:76   CM                    eth0
    10.0.3.1                 ether   fe:20:ba:87:d3:89   C                     eth0

And now, after 'h1 ping 10.0.3.99', we can see on the network:

    18:50:24.648625 IP host01 > 10.0.3.99: ICMP echo request, id 4754, seq 1, length 64
    18:50:24.648907 ARP, Request who-has 10.0.3.99 tell host02, length 28
    18:50:25.649086 ARP, Request who-has 10.0.3.99 tell host02, length 28
    18:50:25.649271 IP host01 > 10.0.3.99: ICMP echo request, id 4754, seq 2, length 64
    18:50:25.649336 IP host02 > host01: ICMP redirect 10.0.3.99 to host    10.0.3.99, length 92

Please take a closer look... yep, our host - host01 - is not using ARP protocol now, it is sending packets directly to the 10.0.3.99 because it exactly knows what is the MAC address of host with such ip address (it can find it in its ARP table). But the host02 (1) has no 10.0.3.99 ip address assigned to any of his interfaces (so it doesn't consider itself as a destination of this packed) and (2) doesn't know MAC address of 10.0.3.99 host - it is why it tries to find MAC address of the 10.0.3.99 via ARP protocol. Of course it can't successed as there is no such host on the net, so eventually host02 replies to host01 with "redirect" msg. It is not the point now why the host02 tries to find 10.0.3.99 or why just the "redirect" packet was sended back to the host01 - it can be a subject of further searchings...

The most important thing now is that a connection (communication) was made! And it can cause some security problems, but don't panic! :)

Interesting thing is that ARP can give us much more accurate information about hosts available on given subnet than icmp ("ping") - it is because the icmp can be easy blocked by host firewall, and for ARP it is not so simple thing (if any communication with given host should be at all possible).

Arp-scan can help us to find your neighbours on the net, please try:

    h1 sudo arp-scan -l   

And 'arping' can be useful too:

    h1 sudo arping host02
    ARPING 10.0.3.10
    42 bytes from 00:16:3e:30:e7:76 (10.0.3.10): index=0 time=1.001 sec
    42 bytes from 00:16:3e:30:e7:76 (10.0.3.10): index=1 time=1.002 sec

arping looks little different on the network than icmp "ping" ;) :

    (vagrant)$sudo tcpdump -i lxcbr0 port not 22
    19:11:53.685258 ARP, Request who-has host02 tell host01, length 28
    19:11:53.685308 ARP, Reply host02 is-at 00:16:3e:30:e7:76 (oui Unknown), length 28
    19:11:54.689459 ARP, Request who-has host02 tell host01, length 28
    19:11:54.689513 ARP, Reply host02 is-at 00:16:3e:30:e7:76 (oui Unknown), length 28

It looks little different but works the same :) Of course "the scope" of the ARP protocol is limited only to the network(s) directly connected to given host - so these arp tricks can't be widely used and arping cannot be treated as a replacement for icmp in the "Internet wide scope", but... it's good to know them!

Yep, only two hosts, the simplest protocol and so many interesting things :) 

There is a lot to test yet - have fun and let me know if you find something interesting!

