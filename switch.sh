export DEBIAN_FRONTEND=noninteractive

sudo ifconfig enp0s8 192.168.1.2 netmask 255.255.255.252
sudo ifconfig enp0s9 172.16.0.1 netmask 255.255.254.0
sudo ifconfig enp0s10 172.16.2.1 netmask 255.255.254.0

sudo ifconfig enp0s8 up
sudo ifconfig enp0s9 up
sudo ifconfig enp0s10 up

sudo echo 1 > /proc/sys/net/ipv4/ip_forward

sudo tunctl -t tap0

sudo ifconfig br0 122.122.0.2 netmask 255.255.252.0

sudo ip route delete default
sudo ip route add default via 122.122.0.1
