#!/bin/bash
set -e
# Global Ubuntu things
cloud-init status --wait
sudo apt-get update 
sudo apt-get upgrade -y 
sudo apt-get install  unzip htop  apt-transport-https ca-certificates curl software-properties-common -y
### Docker 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce -y
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock
sudo useradd -m -s /bin/bash -G docker yc-user
### Node exporter
sudo mv /tmp/node_exporter.service /lib/systemd/system/node_exporter.service
sudo systemctl enable node_exporter.service 
