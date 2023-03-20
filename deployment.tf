locals {
  hubspoke_config_ids = [for i in azurerm_network_manager_connectivity_configuration.hubspokes: i.id]
  mesh_config_ids = [for i in azurerm_network_manager_connectivity_configuration.global_mesh: i.id]
  deployment_config_ids = concat(local.hubspoke_config_ids, local.mesh_config_ids)
  locations = ["eastus", "westus", "eastus2", "westus2"] 
}

resource "null_resource" "deployment" {
  provisioner "local-exec" {
    command = <<-EOT
        az extension add --name virtual-network-manager
        az network manager post-commit \
            --network-manager-name ${azurerm_network_manager.this.name} \
            --commit-type "Connectivity" \
            --configuration-ids ${join(" ", local.deployment_config_ids)} \
            --target-locations ${join(" ", local.locations)} \
            --resource-group ${azurerm_resource_group.this.name}
    EOT
  }
}