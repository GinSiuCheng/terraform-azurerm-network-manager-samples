# Hub Network Group and Memberships
resource "azurerm_network_manager_network_group" "hub" {
  name               = "hub-static-ng"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_network_manager_static_member" "hub" {
  for_each                  = { for i in local.hub_vnets : i.name => i }
  name                      = each.value.name
  network_group_id          = azurerm_network_manager_network_group.hub.id
  target_virtual_network_id = each.value.id
}

# Shared Network Group and Memberships
resource "azurerm_network_manager_network_group" "shared" {
  name               = "shared-static-ng"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_network_manager_static_member" "shared" {
  for_each                  = { for i in local.shared_vnets : i.name => i }
  name                      = each.value.name
  network_group_id          = azurerm_network_manager_network_group.shared.id
  target_virtual_network_id = each.value.id
}

# Core Network Group and Memberships
resource "azurerm_network_manager_network_group" "core" {
  name               = "core-static-ng"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_network_manager_static_member" "core" {
  for_each                  = { for i in local.core_vnets : i.name => i }
  name                      = each.value.name
  network_group_id          = azurerm_network_manager_network_group.core.id
  target_virtual_network_id = each.value.id
}

# App1 Network Group and Memberships
# To do: use for-each loop to create app spoke network groups and memberships 
resource "azurerm_network_manager_network_group" "app1" {
  name               = "app1-static-ng"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_network_manager_static_member" "app1" {
  for_each                  = { for i in local.app1_vnets : i.name => i }
  name                      = each.value.name
  network_group_id          = azurerm_network_manager_network_group.app1.id
  target_virtual_network_id = each.value.id
}

# App2 Network Group and Memberships
resource "azurerm_network_manager_network_group" "app2" {
  name               = "app2-static-ng"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_network_manager_static_member" "app2" {
  for_each                  = { for i in local.app2_vnets : i.name => i }
  name                      = each.value.name
  network_group_id          = azurerm_network_manager_network_group.app2.id
  target_virtual_network_id = each.value.id
}