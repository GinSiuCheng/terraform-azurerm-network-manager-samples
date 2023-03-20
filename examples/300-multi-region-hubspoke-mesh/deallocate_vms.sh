#!/bin/bash

# Set the subscription and resource group variables
subscriptionId="your subscription id"
resourceGroup="your resource group name"

# Get a list of all virtual machines in the resource group
vm_list=$(az vm list -g $resourceGroup --subscription $subscriptionId --query "[].name" -o tsv)

# Check if the list of virtual machines is empty
if [[ -z "$vm_list" ]]; then
    echo "No virtual machines found in resource group $resourceGroup."
    exit 1
fi

# Shut down each virtual machine in the list
for vm in $vm_list; do
    az vm deallocate --name $vm --resource-group $resourceGroup --subscription $subscriptionId --no-wait
done

echo "All virtual machines in resource group $resourceGroup have been deallocated."