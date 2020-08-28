export DEBIAN_FRONTEND=noninteractive
# Startup commands go here

sudo ifconfig enp0s8 172.16.4.1 netmask 255.255.254.0
sudo ifconfig enp0s8 up

sudo ifconfig enp0s9 192.168.1.2 netmask 255.255.255.252
sudo ifconfig enp0s9 up

sudo ip route delete default
sudo ip route add default via 192.168.1.1

sudo sysctl net.ipv4.ip_forward=1
