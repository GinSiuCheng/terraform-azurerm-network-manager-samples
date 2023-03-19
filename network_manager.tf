data "azurerm_subscription" "current" {}

resource "azurerm_network_manager" "this" {
  name                = var.anm_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  scope {
    subscription_ids = [data.azurerm_subscription.current.id]
  }
  scope_accesses = ["Connectivity", "SecurityAdmin"]
  description    = "Example ANM"
}
