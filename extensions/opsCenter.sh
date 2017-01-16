#!/usr/bin/env bash

cloud_type="azure"
seed_node_location=$1
unique_string=$2

echo "Input to node.sh is:"
echo cloud_type $cloud_type
echo seed_node_location $seed_node_location
echo unique_string $unique_string

seed_node_dns_name="dc0vm0$unique_string.$seed_node_location.cloudapp.azure.com"

echo "Calling opscenter.sh with the settings:"
echo cloud_type $cloud_type
echo seed_node_dns_name $seed_node_dns_name

apt-get -y install unzip

#Get install scripts and start OpsC
cd ~/
wget https://github.com/DSPN/install-datastax-ubuntu/archive/lcm.zip
unzip lcm.zip
cd install-datastax-ubuntu-lcm/bin
./os/install_java.sh
./opscenter/install.sh $cloud_type
./opscenter/start.sh

pip install requests
#pubip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

./lcm/setupCluster.py \
--opsc-ip $pubip \
--clustername \
--user \
--password
