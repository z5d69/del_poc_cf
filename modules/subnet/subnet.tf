variable "subnetname" {}
variable "subnetcidr" {}
variable "vnetname" {}
variable "resource_group_name" {}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnetname
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnetname
  address_prefixes     = var.subnetcidr
  service_endpoints = ["Microsoft.Storage"]  
}
output "subnetid" {
  value = azurerm_subnet.subnet.id
}