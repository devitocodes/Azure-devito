# Instructions to setup batch-shipyard to run/test/benchmark [Devito](https://github.com/devitocodes/devito "Link to Devito github repo") on Microsoft Azure

## Step 0 : This Readme.md assumes an already existing batch account accompanied by a storage account. If not, - Go to your resource portal on Azure and create a batch account and a storage account. Batch and storage account should be under the same resource group.

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

Note: batch-shipyard installer is not going to create by default an executable in `usr/local/bin/`
so you probably need to execute it  through the installation folder
unless changed as shown before.

## Step 2 : Clone the current github repositiory in a different folder
```
git clone https://github.com/devitocodes/Azure-devito.git
```

## Step 3 : Run Devito on Azure

- Edit the `shipyard-config/credentials.yaml` file with your corresponding access keys.
The keys can be found on the Azure portal, under 'Keys' tab for each of your account.
- To create a pool, run:
```($INST_PATH/batch-shipyard/)shipyard pool add --credentials $PATH-TO-CREDENTIALS/credentials.yaml```

The `pool.yaml` file contains specs for the `vm_configuration` such as platform image, VMs etc..

- To run a job
```($INST_PATH/batch-shipyard/)shipyard jobs add --credentials $PATH-TO-CREDENTIALS/credentials.yaml```

The `jobs.yaml` file contains among others definition of ENV_VARIABLES as well as the command(s) to be executed.

### Useful links
- https://batch-shipyard.readthedocs.io/en/latest/02-batch-shipyard-quickstart/
- https://batch-shipyard.readthedocs.io/en/latest/05-batch-shipyard-from-scratch-step-by-step/
- https://docs.microsoft.com/en-us/learn/paths/azure-fundamentals/
- https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-hpc