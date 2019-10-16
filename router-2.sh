export DEBIAN_FRONTEND=noninteractive

sudo ifconfig enp0s8 172.16.4.1 netmask 255.255.254.0
sudo ifconfig enp0s9 192.168.1.6 netmask 255.255.255.252

sudo ifconfig enp0s8 up
sudo ifconfig enp0s9 up

sudo ip route delete default
sudo ip route add default via 192.168.1.5

sudo echo 1 > /proc/sys/net/ipv4/ip_forward
