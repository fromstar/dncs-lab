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
Per realizzare il progetto lo script mi ha assegnato per le 3 sotto-reti:
- Host-a: 399 indirizzi
- Host-b: 381 indirizzi
- Hub: 344 indirizzi

Per farle tutte e 3 quindi ho bisogno che la sottomaschera sia una /23 così da avere 2^9=512 indirizzi disponibili per ognuna.
Arbitrariamente ho impostato gli indirizzi di rete in ordine:
- host-a: 172.16.0.0
- host-b: 172.16.2.0
- hub: 172.16.4.0

Gli indirizzi assegnabili per le macchine appertenti alla prima rete dunque sono compresi tra 172.16.0.2 e 172.16.1.254(Il primo indirizzo "0.0" serve a identificare la rete, il secondo "0.1" è assegnato al gateway mentre l'ultimo "1.255" corrisponde all'indrizzo di broadcast).
Per fare ciò, una volta avviate le macchine virtuali, ho controllato il nome delle interfacce da modificare. host-a, host-b e host-c ne hanno solo una di nome enp0s8, quindi l'ho abilitata e le ho assegnato un indirizzo statico per ogni macchina:
- host-a: 172.16.1.130
- host-b: 172.16.3.130
- host-c: 172.16.4.130

Una volta assegnati gli indirizzi agli host l'ho fatto anche per i router e lo switch.
Per il collegamento router-1/router-2 e quello router-1/swtich ho utilizzato due sottoreti con sottomaschera /30(permette di avere solo 2 indirizzi assegnabili più uno di rete e uno di broadcast):
- collegamento switch<->router-1: 192.168.0.0
- collegamento router-1<->router-2: 192.168.0.4

Sul router-2 ho assegnato all'interfaccia enp0s8 l'indirizzo di gateway per la rete host-c quindi 172.16.4.1 mentre l'interfaccia enp0s9 l'ho usata per collegarla al router-1 e le ho assegnato l'indirizzo 192.168.0.6

Dalla parte del router-1 ho sempre assegnato all'interfaccia enp0s9 l'indirizzo 192.168.0.5 così da metterla nella stessa sotto-rete del router-2. L'interfaccia enp0s8 invece l'ho usata per il collegamento con lo switch e ho assegnato l'indirizzo 192.168.0.1.

Con lo switch ho fatto le stesse operazioni per i router solo che c'è un'interfacci in più. enp0s8 l'ho usata per il collegamente al router-1 e le ho dato l'indirizzo 192.168.0.2. enp0s9 ha l'indirizzo di gateway per la rete dell'host-a quindi 172.16.0.1 mentre enp0s10 ha l'indirizzo di gateway per la rete dell'host-b, ovvero 172.16.2.1.

Nell'host-c ho installato ho installato docker e ho fatto un pull dell'immagine "nginx" per avviare un webserver in seguito.

Dopo aver assegnato tutti gli indirizzi ho dovuto modificare le tabelle di route.
Per i vari host ho eliminato tutte le route le di default e le ho sostitue con delle nuove specificando che passassero per l'indirizzo di gateway della loro sotto-rete.
Per lo switch e il router-2 ho fatto la stessa identica cosa ma mettendo le route di default via router-1.

Nel router-1 invece ho lasciato la route di default perchè in questa simulazione vorrei che il traffico diretto per reti esterni sia reso disponibile solo da lui e dunque ho aggiunto 3 route specifiche per le 3 sotto-reti.
Infine ho abilitato l'ipv4 forwardig per permettere l'inoltro dei pacchetti nei due router e nello switch.
Per testare che tutto funzionasse correttamente ho usato il comando ping.

Come ultima cosa ho avviato il container e dall'host-a ho testato il funzionamento tramite il comando curl. Il test è andato a buon fine e mi è apparsa la pagina di benvenuto di default di nginx.



 VLAN host-a host-b

 Creo delle interfacce virtuali negli host da attaccare alle macchine.
 per le due reti sono 399+381=780. Mi servono 10bit. 2^10=1024indirizzi. /22
 122.122.0.0/22 ->rete
 122.122.3.255 ->broadcast
 122.122.0.130 ->host-a (sudo ifconfig enp0s8:0 122.122.0.130)
 122.122.1.130 ->host-b

 11111111.11111111.11111100.00000000

Creo un bridge nello switch
Aggiungo al bridge le schede di rete che mi servono

Creo una scheda di rete virtuale
Per crearala installo il package "uml-utilities"

Aggiungo questa scheda al bridge col tag
Assegno un indirizzo ip al bridge
