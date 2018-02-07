This template deploys a DataStax Enterprise (DSE) cluster to Azure running on Ubuntu virtual machines in a single datacenter.  The template can provision a cluster from 1 to 40 nodes.  

The template also provisions managed disks, virtual network and public IP addresses required by the installation.  The template will deploy to the location that the resourceGroup it is part of is located in. The template also sets up a vm to run DataStax OpsCenter.  The script opscenter.sh installs OpsCenter and performs basic cluster setup.

The button below will deploy this template to Azure.  The template will be dynamically linked directly from this github repository.  Given that, if you want to make changes to subtemplates or extensions, be sure to fork the repo and adjust the baseUrl.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fvdogan%2Fazure-resource-manager-dse%2Fmaster%2Fsingledc%2FmainTemplate.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

Alternatively, you can run clone this repo and run `deploy.sh`. This script takes the following optional arguments:

```
./deploy.sh -h
---------------------------------------------------
Usage:
deploy.sh [-h] [-g resource-group] [-l location] [-t]

Options:

 -h                 : display this message and exit
 -g resource-group  : name of resource group to create, default 'dse'
 -l location        : location for resource group, default 'eastus'
 -t                 : testing flag, sets baseUrl to dev branch

---------------------------------------------------

```
Note the `-t` flag is for *testing only* and is not for normal use.

The template expects the following parameters (examples of which are in `mainTemplateParameters.json`):

| Name   | Description |
|:--- |:---|
| nodeCount | Number of virtual machines to provision for the cluster |
| vmSize | Size of virtual machine to provision for the cluster |
| adminUsername  | Admin user name for the virtual machines |
| adminPassword  | Admin password for the virtual machines |
| DBPassword  | Password for default C* user 'cassandra' |
| OpsCPassword | Password for default OpsCenter user 'admin' |

Once the Azure VMs, virtual network and disks are deployed, the node instances call back to the OpsCenter instance using the LCM REST API.  When the last node registers this triggers an LCM job to install and configure DSE  These nodes are assigned both private and public dynamic IP addresses.

On completion, OpsCenter will be accessible on port 8443 (https, http connections to port 8888 will be redirected) of the public IP address of the OpsCenter node. OpsCenter uses a self-signed SSL certificate, so you will need to accept the certificate exception. After this you can log in with the user name 'admin' and the password you specified in the OpsCPassword parameter.
