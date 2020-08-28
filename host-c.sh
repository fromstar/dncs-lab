export DEBIAN_FRONTEND=noninteractive
# Startup commands go here

sudo ifconfig enp0s8 172.16.4.3 netmask 255.255.254.0
sudo ifconfig enp0s8 up

sudo docker restart webserver

sudo ip route del default
sudo ip route add default via 172.16.4.1
