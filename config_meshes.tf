locals {
  global_meshes = {
    "hub_mesh" = {
      name  = "hub-mesh"
      ng_id = azurerm_network_manager_network_group.hub.id
    },
    "core_mesh" = {
      name  = "core-mesh"
      ng_id = azurerm_network_manager_network_group.core.id
    },
    "shared-mesh" = {
      name  = "shared-mesh"
      ng_id = azurerm_network_manager_network_group.shared.id
    },
    "app1-mesh" = {
      name  = "app1-mesh"
      ng_id = azurerm_network_manager_network_group.app1.id
    },
    "app2-mesh" = {
      name  = "app2-mesh"
      ng_id = azurerm_network_manager_network_group.app2.id
    }
  }
}

resource "azurerm_network_manager_connectivity_configuration" "global_mesh" {
  for_each              = local.global_meshes
  name                  = each.value.name
  network_manager_id    = azurerm_network_manager.this.id
  connectivity_topology = "Mesh"
  applies_to_group {
    group_connectivity = "DirectlyConnected"
    network_group_id   = each.value.ng_id
  }
  global_mesh_enabled = true
}