#!/usr/bin/env bash

username=$1
password=$2
opscpw=$3
dbpasswd=$4
nodecount=$5

echo "Input to opsCenter.sh is:"
echo username $username
echo password XXXXXX
echo opscpw YYYYYY
echo dbpasswd ZZZZZZZ
echo nodecount $nodecount

cluster_name="xpi"

# repo creds
repouser='datastax@microsoft.com'
repopw='3A7vadPHbNT'

release="6.1.0"
wget https://github.com/DSPN/install-datastax-ubuntu/archive/$release.tar.gz
tar -xvf $release.tar.gz

cd install-datastax-ubuntu-$release/bin
# install extra packages
./os/extra_packages.sh

# Overide OpsC install default version if needed
export OPSC_VERSION='6.1.5'
ver='5.1.6'

./os/install_java.sh

#install opsc
./opscenter/install.sh 'azure'
# Turn on https, set pw for opsc user admin
./opscenter/set_opsc_pw_https.sh $opscpw
sleep 1m

echo "Calling setupCluster.py with the settings:"
echo opsc_ip 127.0.0.1
echo cluster_name $cluster_name
echo username $username
echo password XXXXXX
echo repouser $repouser
echo repopw XXXXXX

./lcm/setupCluster.py \
--opscpw $opscpw \
--clustername $cluster_name \
--repouser $repouser \
--repopw $repopw \
--dsever  $ver \
--user $username \
--password $password \
--datapath "/data/cassandra"

# trigger install
./lcm/triggerInstall.py \
--opscpw $opscpw \
--clustername $cluster_name \
--clustersize $nodecount \
--dclevel \
--dbpasswd $dbpasswd

# Block execution while waiting for jobs to
# exit RUNNING/PENDING status
./lcm/waitForJobs.py \
--opscpw $opscpw
# set keyspaces to NetworkTopology / RF 3
sleep 30s
./lcm/alterKeyspaces.py \
--opscpw $opscpw \
