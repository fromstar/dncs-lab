# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/dustnic/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 399 and 381 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 349 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/dustnic/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'.
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design
All the commands I used, I insert them in script that I created for every machine. Except for someone of them (like these used for the installation of OpenVSwitch) these are not permanent, so I've modified the vagrantfile to execute them at every start of the virtual machines. For the switch and the host-c I created one more script for each one, that will be execute only at the first start and will insert the commands to install the software needed for the realization of the project.

To realize the project, the dncs-init script assigned me 3 address number, necessary for my 3 subnet:
- Host-a: 399 addresses
- Host-b: 381 addresses
- Hub: 344 adresses

So I created the three subnet using a /23 subnet mask so as to have 2^9=512 available adresses for each one.
Arbitrarily I set the network addresses in order:
- host-a: 172.16.0.0 (addresses from 172.16.0.0 to 172.16.1.255)
- host-b: 172.16.2.0 (addresses from 172.16.2.0 to 172.16.3.255)
- hub: 172.16.4.0 (addresses from 172.16.4.0 to 172.16.5.255)

The assignable addresses for the machines belonging to the first subnet are therefore included from 172.16.0.2 to 172.16.1.254(The first address "0.0" needs to identify the subnet, the second "0.1" is assigned to the gateway while the last one "1.255" is for the broadcast).
To do this, I assigned a static address to the enp0s8 interface of each machine choosen arbitrarily and I enabled them:
- host-a: 172.16.1.130
- host-b: 172.16.3.130
- host-c: 172.16.5.130

Once the addresses are assigned to the hosts I switched to routers and switch.
For the router-1/router and router-1/swtich connections I used two subnet with /30 subnet mask(it allows to have only two 2 assignable addesses plus one network address and one broadcast address):
- link switch<->router-1: 192.168.1.0 (addresses from 192.168.1.0 to 192.168.1.3)
- link router-1<->router-2: 192.168.1.4 (addresses from 192.168.1.4 to 192.168.1.7)

On router-2 I assigned to the enp0s8 interface the host-c subnet's gateway address so 172.16.4.1 while I used the enp0s9 interface to connect it to the router-1 and I assigned them the address 192.168.1.6
For the part of router-1 I used for the interface enp0s9 the address 192.168.0.5 to put them in the same subnet of router-2.
Instead, I used the interface enp0s8 for the link with the switch, and I've assigned the address 192.168.1.1.
In the switch, I used the interface enp0s8 for the link with router-1 and I gave them the address 192.168.1.2.
enp0s9 has the host-a subnet's gateway address, so 172.16.0.1, while enp0s10 has the same gateway's address for the subnet of the host-b, 172.16.2.1.

In the host-c I installed docker and I made a pull of the "nginx" image to create later a webserver.

To do the vlan between the host-a's subnet and host-b's subnet I made a bridge on the switch named "br0".
At this point I added as port it's interfaces plus one virtual and then I created a virtual interface on the host-a, host-b and router-1 and assigned the following addresses:
- host-a: enp0s8:0: 122.122.0.130
- host-b: enp0s8:0: 122.122.1.130
- router-1: enp0s8:0: 122.122.0.1

I have also inserted the router-1 in the vlan to avoid that the traffic is totally isolated and allow the host-a and host-b to reach the host-c.

After this part of work I changed the route tables of the various machines.
I deleted all the default routes and left only the router-1 route. I made this choice thinking of allowing traffic to external networks only through the router-1.
So I let go the new machine's default route through their subnet's gateway except for those belonging to the vlan where I put the one of the virtual and not physical subnet.
Le default route are so set in this way:
- host-a: via 122.122.0.1
- host-b: via 122.122.0.1
- switch: via 122.122.0.1
- router-2: via 192.168.1.5
- host-c: via 172.16.4.1

In router-1, since it is adjacent to router-2 and that belongs to the vlan, it was enough for me to just add a specific route for the host-c subnet via router-2 to address 192.168.1.6.
However the operations made until here are not enough to allow packet forwarding, in fact I had to enable also the ipv4 forwarding in the switch, in the router-1 and in the router-2 to make everything work.
To be sure that everything is ok I used the command "ping" to test the various connection.

Finally in the host-c I started the container with the image of nginx to start the web-server.
I tested that the web-server is online and reachable from the host-a via the "curl" command. The test was successful and the html of the default nginx index appeared in the host-a.
