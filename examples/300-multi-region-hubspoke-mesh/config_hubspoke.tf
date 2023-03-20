locals {
  hub_ng_ids = {
    eastus  = azurerm_network_manager_network_group.east.id,
    westus  = azurerm_network_manager_network_group.west.id,
    eastus2 = azurerm_network_manager_network_group.east2.id,
    westus2 = azurerm_network_manager_network_group.west2.id
  }
  hub_hubspoke_config = [
    for i in local.hub_vnets : merge(i, { ng_id = local.hub_ng_ids[i.location] }) if contains(keys(local.hub_ng_ids), i.location)
  ]
  core_hubspoke_config = [
    for i in local.core_vnets : merge(i, { ng_id = azurerm_network_manager_network_group.apps.id })
  ]
  shared_hubspoke_config = [
    for i in local.shared_vnets : merge(i, { ng_id = azurerm_network_manager_network_group.apps.id })
  ]
  hubspoke_configs = concat(local.hub_hubspoke_config, local.core_hubspoke_config, local.shared_hubspoke_config)
}

# hub - all regional vnets connect to hub in each region
resource "azurerm_network_manager_connectivity_configuration" "hubspokes" {
  for_each              = { for vnet in local.hubspoke_configs : vnet.name => vnet }
  name                  = "${each.value.name}-hubspoke-config"
  network_manager_id    = azurerm_network_manager.this.id
  connectivity_topology = "HubAndSpoke"
  applies_to_group {
    group_connectivity = "None"
    network_group_id   = each.value.ng_id
  }
  hub {
    resource_id   = each.value.id
    resource_type = "Microsoft.Network/virtualNetworks"
  }
}

# # core - all client vnets connect to core in each region 
# resource "azurerm_network_manager_connectivity_configuration" "core_hubspokes" {
#   for_each              = { for vnet in local.core_vnets : vnet.name => vnet }
#   name                  = "${each.value.name}-hubspoke-config"
#   network_manager_id    = azurerm_network_manager.this.id
#   connectivity_topology = "HubAndSpoke"
#   applies_to_group {
#     group_connectivity = "None"
#     network_group_id   = azurerm_network_manager_network_group.apps.id
#   }
#   hub {
#     resource_id   = each.value.id
#     resource_type = "Microsoft.Network/virtualNetworks"
#   }
# }

# # shared - all clients connect to shared in each region
# resource "azurerm_network_manager_connectivity_configuration" "shared_hubspokes" {
#   for_each              = { for vnet in local.shared_vnets : vnet.name => vnet }
#   name                  = "${each.value.name}-hubspoke-config"
#   network_manager_id    = azurerm_network_manager.this.id
#   connectivity_topology = "HubAndSpoke"
#   applies_to_group {
#     group_connectivity = "None"
#     network_group_id   = azurerm_network_manager_network_group.apps.id
#   }
#   hub {
#     resource_id   = each.value.id
#     resource_type = "Microsoft.Network/virtualNetworks"
#   }
# }
