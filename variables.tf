variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vm_username" {
  type    = string
  default = "azureuser"
}

variable "vm_password" {
  type      = string
  sensitive = true
  default   = "Password123456!"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "hub_vnets" {
  type = map(object({
    name          = string
    location      = string
    address_space = list(string)
    subnets       = list(any)
    tags          = map(string)
  }))
}

variable "shared_vnets" {
  type = map(object({
    name          = string
    location      = string
    address_space = list(string)
    subnets       = list(any)
    tags          = map(string)
  }))
}

variable "core_vnets" {
  type = map(object({
    name          = string
    location      = string
    address_space = list(string)
    subnets       = list(any)
    tags          = map(string)
  }))
}

variable "client_vnets" {
  type = map(object({
    name          = string
    location      = string
    address_space = list(string)
    subnets       = list(any)
    tags          = map(string)
  }))
}