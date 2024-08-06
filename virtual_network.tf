resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnetname
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  tags = var.common_tags
}