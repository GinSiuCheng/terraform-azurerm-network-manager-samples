locals {
  landing_zone_name = var.landing_zone.name
  location          = var.landing_zone.location
  address_space     = var.landing_zone.address_space
  subnets           = var.landing_zone.subnets
  tags              = var.landing_zone.tags
  vm_username       = var.vm_username
  vm_password       = var.vm_password
  vm_size           = var.vm_size
  default_subnet_id = length([for subnet in azurerm_subnet.this : subnet.id if subnet.name == "default"]) > 0 ? [for subnet in azurerm_subnet.this : subnet.id if subnet.name == "default"][0] : null
  bastion_subnet_id = length([for subnet in azurerm_subnet.this : subnet.id if subnet.name == "AzureBastionSubnet"]) > 0 ? [for subnet in azurerm_subnet.this : subnet.id if subnet.name == "AzureBastionSubnet"][0] : null
  fw_subnet_id      = length([for subnet in azurerm_subnet.this : subnet.id if subnet.name == "AzureFirewallSubnet"]) > 0 ? [for subnet in azurerm_subnet.this : subnet.id if subnet.name == "AzureFirewallSubnet"][0] : null
}

resource "azurerm_virtual_network" "this" {
  name                = "${local.landing_zone_name}-vnet"
  address_space       = local.address_space
  location            = local.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

resource "azurerm_subnet" "this" {
  count                = length(local.subnets)
  name                 = local.subnets[count.index].name
  address_prefixes     = local.subnets[count.index].address_prefixes
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  depends_on = [
    azurerm_virtual_network.this
  ]
}

resource "azurerm_network_interface" "vm_nic" {
  count               = var.create_default_vm > 0 ? 1 : 0
  name                = "${local.landing_zone_name}-vm-nic"
  location            = local.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${local.landing_zone_name}-ipconfig1"
    subnet_id                     = local.default_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = local.tags
  depends_on = [
    azurerm_subnet.this
  ]
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                           = var.create_default_vm > 0 ? 1 : 0
  name                            = "${local.landing_zone_name}-vm"
  location                        = local.location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = [azurerm_network_interface.vm_nic[0].id]
  size                            = local.vm_size
  admin_username                  = local.vm_username
  admin_password                  = local.vm_password
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "${local.landing_zone_name}-vm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = local.tags
  depends_on = [
    azurerm_network_interface.vm_nic
  ]
}

resource "azurerm_public_ip" "bastion_public_ip" {
  count               = var.create_bastion > 0 ? 1 : 0
  name                = "${local.landing_zone_name}-bastion-pip"
  location            = local.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_bastion_host" "bastion" {
  count               = var.create_bastion > 0 ? 1 : 0
  name                = "${local.landing_zone_name}-bastion"
  location            = local.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                 = "${local.landing_zone_name}-bastion-ipconfig"
    public_ip_address_id = azurerm_public_ip.bastion_public_ip[0].id
    subnet_id            = local.bastion_subnet_id
  }
  tags = local.tags
  depends_on = [
    azurerm_virtual_network.this,
    azurerm_subnet.this
  ]
}

resource "azurerm_public_ip" "firewall_public_ip" {
  count               = var.create_firewall > 0 ? 1 : 0
  name                = "${local.landing_zone_name}-firewall-pip"
  location            = local.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_firewall" "firewall" {
  count               = var.create_firewall > 0 ? 1 : 0
  name                = "${local.landing_zone_name}-firewall"
  location            = local.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "${local.landing_zone_name}-firewall-ipconfig"
    subnet_id            = local.fw_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip[0].id
  }
  tags = local.tags
  
  depends_on = [
    azurerm_virtual_network.this,
    azurerm_subnet.this
  ]
}
