export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common

# Startup commands for switch go here
sudo apt-get install uml-utilities

sudo tunctl -t tap0
sudo ovs-vsctl add-br br0
sudo ovs-vsctl add-port br0 enp0s9
sudo ovs-vsctl add-port br0 enp0s10
sudo ovs-vsctl add-port br0 enp0s8
sudo ovs-vsctl add-port br0 tap0 tag=9
