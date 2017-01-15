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

#Generate lcm ssh key
cd ~/.ssh/
ssh-keygen -t rsa -N '' -f lcm.pem
chown ubuntu:ubuntu lcm.pem*
chmod 600 lcm.pem*
echo 'Generated lcm.pem and lcm.pem.pub'
