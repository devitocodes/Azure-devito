# Azure-devito
Azure setup for benchmarking Devito


## Step 1 : Download batch shipyard 

Linux installation: https://batch-shipyard.readthedocs.io/en/latest/01-batch-shipyard-installation/#linux-install

```
# Clone the repo
git clone https://github.com/Azure/batch-shipyard.git
# Change dir
cd batch-shipyard
# Install
./install.sh
# [Optional] Add a link for shipyard executable
sudo  ln -s $INST_PATH/batch-shipyard/shipyard  /usr/local/bin/shipyard
```

It is not going to create by default an executable in `/bin`
so you probably need to run through the installation folder
unless changed.

## Step 2 : Clone the current github repositiory
```
 git clone https://github.com/devitocodes/Azure-devito.git
```

## Step 3 : Run Devito on Azure

- Go to your resource portal on Azure and create a batch account.
- Go to your resource portal on Azure and create a storage account.
Batch and storage account should be under the same resource group.
- Edit the `credentials.yaml`  file with your corresponding keys.
The keys can be found on the Azure portal, under 'Keys' tab
for each of your account.
- To create a pool, run:
```($INST_PATH/batch-shipyard/)shipyard pool add --credentials $PATH-TO-CREDENTIALS/credentials.yaml```

The `pool.yaml` file contains specs for the vm_configuration such as platform image, VMs etc..

- To run a job
```($INST_PATH/batch-shipyard/)shipyard jobs add --credentials $PATH-TO-CREDENTIALS/credentials.yaml```

The `jobs.yaml` file contains among others definition of ENV_VARIABLES as well as the commands to be executed.


### Useful links
- https://batch-shipyard.readthedocs.io/en/latest/02-batch-shipyard-quickstart/
- https://batch-shipyard.readthedocs.io/en/latest/05-batch-shipyard-from-scratch-step-by-step/
- https://docs.microsoft.com/en-us/learn/paths/azure-fundamentals/
- https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-hpc