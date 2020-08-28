export DEBIAN_FRONTEND=noninteractive
# Startup commands go here for router-1

sudo sysctl net.ipv4.ip_forward=1

sudo ip link add link enp0s8 name enp0s8.10 type vlan id 10
sudo ip link add link enp0s8 name enp0s8.20 type vlan id 20
sudo ifconfig enp0s8 up
sudo ifconfig enp0s9 up
sudo ifconfig enp0s8.10 up
sudo ifconfig enp0s8.20 up

sudo ifconfig enp0s8.10 172.16.0.1 netmask 255.255.254.0
sudo ifconfig enp0s8.20 172.16.2.1 netmask 255.255.254.0
sudo ifconfig enp0s9 192.168.1.1 netmask 255.255.255.252

sudo ip route add 172.16.4.0/23 via 192.168.1.2
