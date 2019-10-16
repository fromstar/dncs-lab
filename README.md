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
Per realizzare il progetto, lo script mi ha assegnato 3 numeri di indirizzi necessari per le 3 sottoreti:
- Host-a: 399 indirizzi
- Host-b: 381 indirizzi
- Hub: 344 indirizzi

Le ho create quindi utilizzando una sottomascher /23 così da avere 2^9=512 indirizzi disponibili per ognuna.
Arbitrariamente ho impostato gli indirizzi di rete in ordine:
- host-a: 172.16.0.0 (indirizzi da 172.16.0.0 a 172.16.1.255)
- host-b: 172.16.2.0 (indirizzi da 172.16.2.0 a 172.16.3.255)
- hub: 172.16.4.0 (indirizzi da 172.16.4.0 a 172.16.5.255)

Gli indirizzi assegnabili per le macchine appertenti alla prima rete dunque sono compresi tra 172.16.0.2 e 172.16.1.254(Il primo indirizzo "0.0" serve a identificare la rete, il secondo "0.1" è assegnato al gateway mentre l'ultimo "1.255" corrisponde all'indrizzo di broadcast).
Per fare ciò, una volta avviate le macchine virtuali, ho controllato il nome delle interfacce da modificare. host-a, host-b e host-c ne hanno solo una di nome enp0s8, quindi l'ho abilitata e ho assegnato un indirizzo statico arbitrario per ogni macchina:
- host-a: 172.16.1.130
- host-b: 172.16.3.130
- host-c: 172.16.5.130

Una volta assegnati gli indirizzi agli host sono passato ai router e allo switch.
Per il collegamento router-1/router-2 e quello router-1/swtich ho utilizzato due sottoreti con sottomaschera /30(permette di avere solo 2 indirizzi assegnabili più uno di rete e uno di broadcast):
- collegamento switch<->router-1: 192.168.1.0 (indirizzi da 192.168.1.0 a 192.168.1.3)
- collegamento router-1<->router-2: 192.168.1.4 (indirizzi da 192.168.1.4 a 192.168.1.7)

Sul router-2 ho assegnato all'interfaccia enp0s8 l'indirizzo di gateway per la sottorete dell'host-c quindi 172.16.4.1 mentre l'interfaccia enp0s9 l'ho usata per collegarla al router-1 e le ho assegnato l'indirizzo 192.168.1.6

Dalla parte del router-1 ho utilizzato per l'interfaccia enp0s9 l'indirizzo 192.168.0.5 così da metterla nella stessa sotto-rete del router-2. L'interfaccia enp0s8 invece l'ho usata per il collegamento con lo switch e ho assegnato l'indirizzo 192.168.1.1.

Nello switch l'interfaccia enp0s8 l'ho usata per il collegamente al router-1 e le ho dato l'indirizzo 192.168.1.2. enp0s9 ha l'indirizzo di gateway per la sottorete dell'host-a quindi 172.16.0.1 mentre enp0s10 ha l'indirizzo di gateway per la sottorete dell'host-b, ovvero 172.16.2.1.

Nell'host-c ho installato ho installato docker e ho fatto un pull dell'immagine "nginx" per creare in seguito un webserver.

Dopo aver assegnato tutti gli indirizzi ho dovuto modificare le tabelle di route per permettere la comunicazione tra le varie macchine messe in sottoreti diversi.

Per fare la vlan tra la sottorete dell'host-a e quella dell'host-b ho creato un bridge nello switch di nome br0.
A questo ho aggiunto le sue 3 interfacce più una virtuale. Considerando che in questa rete virtuale devo mettere insieme tutte le macchine delle due sottoreti ho bisogno di 299+381=780 indirizzi. Usare una sottorete con maschera /23 non mi permetterebbe di avere abbastanza indirizzi assegnabili, ho usato quindi il range 122.122.0.0/22 con l'indirizzo di rete scelto arbitrariamente.
La sottomaschera /22 mi permette di avere 2^10=1024(Quindi il range va da 122.122.0.0 a 122.122.3.255).
Successivamente ho creato un'interfaccia virtuale nell'host-a,host-b e router-1 e ho assegnato i seguenti indirizzi:

-host-a: enp0s8:0: 122.122.0.130
-host-b: enp0s8:0: 122.122.1.130
-router-1: enp0s8:0: 122.122.0.1

Ho inserito nella vlan anche il router-1 per evitare che il traffico sia completamente isolato e permettere all host-a e host-b di raggiungere l'host-c.

Finito questa parte di lavoro ho cambiato le route delle varie macchine.
Ho eliminato tutte le route di default e ho lasciato solo quella del router-1. Questa scelta l'ho fatta pensando di permettere il traffico diretto a reti esterne solo attraverso il router-1 per tutte le macchine.
Le nuove route di default quindi le ho fatte passare per il gateway della loro sottorete fatta eccezione per quelle appartanenti alla vlan dove ho messo direttamente quello della sottorete virtuale e non fisica.
Le route di default dunque sono così impostate:

-host-a: via 122.122.0.1
-host-b: via 122.122.0.1
-switch: via 122.122.0.1
-router-2: via 192.168.1.5
-host-c: via 172.16.4.1

Nel router-1 visto che è adiacente al router-2 e che appartiene alla vlan mi è bastato solo aggiungere una route specifica per la sottorete dell'host-c.
Le operazione fatte fino a questo punto non bastano però per permettere l'inoltro dei pacchetti, ho dovuto infatti abilitare anche l'ipv4 forwarding nello switch, nel router-1 e nel router-2 per far sì che tutto sia funzionante.
Per assicurarmi che tutto sia apposto ho usato il comando "ping" per testare le varie connessioni.

Infine nell'host-c ho avviato il container con l'immagine di nginx per avviare il web-server.
Ho testato che il web-server sia online e raggiungibile dall'host-a tramite il comando "curl". Il test è andato a buon fine e  nell'host-a mi è apparso l'html dell'index di default del web-server.
