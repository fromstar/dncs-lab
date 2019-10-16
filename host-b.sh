export DEBIAN_FRONTEND=noninteractive

sudo ifconfig enp0s8 172.16.3.130 netmask 255.255.254.0
sudo ifconfig enp0s8 up

sudo ifconfig enp0s8:0 122.122.1.130 netmask 255.255.252.0

sudo ip route delete default
sudo ip route add default via 122.122.0.1
