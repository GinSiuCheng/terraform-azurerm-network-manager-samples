resource "azurerm_network_manager_connectivity_configuration" "hub-mesh" {
  name = "hub-mesh"
  network_manager_id = azurerm_network_manager.this.id
  connectivity_topology = "Mesh"
  applies_to_group {
    group_connectivity = "DirectlyConnected"
    network_group_id = azurerm_network_manager_network_group.hub.id
    global_mesh_enabled = true 
  }
}

resource "azurerm_network_manager_connectivity_configuration" "core-mesh" {
  name = "core-mesh"
  network_manager_id = azurerm_network_manager.this.id
  connectivity_topology = "Mesh"
  applies_to_group {
    group_connectivity = "DirectlyConnected"
    network_group_id = azurerm_network_manager_network_group.core.id
    global_mesh_enabled = true 
  }
}

resource "azurerm_network_manager_connectivity_configuration" "shared-mesh" {
  name = "shared-mesh"
  network_manager_id = azurerm_network_manager.this.id
  connectivity_topology = "Mesh"
  applies_to_group {
    group_connectivity = "DirectlyConnected"
    network_group_id = azurerm_network_manager_network_group.shared.id
    global_mesh_enabled = true 
  }
}

resource "azurerm_network_manager_connectivity_configuration" "app1-mesh" {
  name = "app1-mesh"
  network_manager_id = azurerm_network_manager.this.id
  connectivity_topology = "Mesh"
  applies_to_group {
    group_connectivity = "DirectlyConnected"
    network_group_id = azurerm_network_manager_network_group.app1.id
    global_mesh_enabled = true 
  }
}

resource "azurerm_network_manager_connectivity_configuration" "app2-mesh" {
  name = "app2-mesh"
  network_manager_id = azurerm_network_manager.this.id
  connectivity_topology = "Mesh"
  applies_to_group {
    group_connectivity = "DirectlyConnected"
    network_group_id = azurerm_network_manager_network_group.app2.id
    global_mesh_enabled = true 
  }
}