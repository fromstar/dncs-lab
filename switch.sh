export DEBIAN_FRONTEND=noninteractive

# Startup commands for switch go here
sudo ovs-vsctl add-br switch
sudo ifconfig enp0s8 up
sudo ifconfig enp0s9 up
sudo ifconfig enp0s10 up
sudo ifconfig ovs-system up
sudo ifconfig switch up

#access ports
sudo ovs-vsctl --may-exist add-port switch enp0s9 tag=10
sudo ovs-vsctl --may-exist add-port switch enp0s10 tag=20

#trunk link
sudo ovs-vsctl --may-exist add-port switch enp0s8
