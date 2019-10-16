export DEBIAN_FRONTEND=noninteractive

sudo ifconfig enp0s8 172.16.5.130 netmask 255.255.254.0
sudo ifconfig enp0s8 up

sudo ip route delete default
sudo ip route add default via 172.16.4.1

sudo docker restart webserver
