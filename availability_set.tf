resource "azurerm_availability_set" "availability_set" {
  name                = "aspoccfsbx"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  tags = var.common_tags
}