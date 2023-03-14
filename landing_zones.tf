locals {
  landing_zone = merge(var.hub_vnets, var.shared_vnets, var.core_vnets, var.client_vnets)
}

module "azurerm_landing_zone" {
  source              = "./modules/landing_zone"
  for_each            = local.landing_zone
  resource_group_name = azurerm_resource_group.this.name
  landing_zone        = each.value
  vm_username         = var.vm_username
  vm_password         = var.vm_password
  vm_size             = var.vm_size
  create_default_vm   = contains([for subnet in each.value.subnets : subnet.name if subnet.name == "default"], "default") ? 1 : 0
  create_bastion      = contains([for subnet in each.value.subnets : subnet.name if subnet.name == "AzureBastionSubnet"], "AzureBastionSubnet") ? 1 : 0
  create_firewall     = contains([for subnet in each.value.subnets : subnet.name if subnet.name == "AzureFirewallSubnet"], "AzureFirewallSubnet") ? 1 : 0
}