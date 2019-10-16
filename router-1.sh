export DEBIAN_FRONTEND=noninteractive

sudo ifconfig enp0s8 192.168.1.1 netmask 255.255.255.252
sudo ifconfig enp0s9 192.168.1.5 netmask 255.255.255.252

sudo ifconfig enp0s8 up
sudo ifconfig enp0s9 up

#sudo ip route add 172.16.0.0/23 via 192.168.1.2
#sudo ip route add 172.16.2.0/23 via 192.168.1.2
sudo ip route add 172.16.4.0/23 via 192.168.1.6

sudo echo 1 > /proc/sys/net/ipv4/ip_forward

sudo ifconfig enp0s8:0 122.122.0.1 netmask 255.255.252.0
