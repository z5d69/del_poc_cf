resource "azurerm_network_security_group" "nsgpoccfsub1" {
  name                = "nsgpoccfsub1"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = var.resource_group_name
  tags = var.common_tags

  security_rule {
    name                        = "allowssh"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    }

  security_rule {
    name                        = "blockall"
    priority                    = 200
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    }
}

resource "azurerm_network_security_group" "nsgpoccfsub3" {
  name                = "nsgpoccfsub3"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = var.resource_group_name
  tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "nsgasub1" {
  subnet_id                 = "${module.sub1.subnetid}"
  network_security_group_id = azurerm_network_security_group.nsgpoccfsub1.id
}

resource "azurerm_subnet_network_security_group_association" "nsgasub3" {
  subnet_id                 = "${module.sub3.subnetid}"
  network_security_group_id = azurerm_network_security_group.nsgpoccfsub3.id
}