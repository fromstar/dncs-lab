export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
sudo apt-get update

sudo snap install docker
sudo apt-get -y upgrade

sudo docker pull nginx
sudo docker run --name webserver -p 80:80 -d nginx
