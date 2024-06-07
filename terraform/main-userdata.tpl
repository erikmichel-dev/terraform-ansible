#!/bin/bash
sudo hostnamectl set-hostname ${new_hostname} &&
sudo apt-get install -y apt-transport-https software-properties-common wget &&
wget -q -O - https://apt.grafana.com/gpg.key | sudo apt-key add - &&
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list &&
sudo apt-get update -y  &&
sudo apt-get install grafana -y &&
sudo systemctl start grafana-server &&
sudo systemctl enable grafana-server.service