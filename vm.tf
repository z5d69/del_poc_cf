
resource "azurerm_public_ip" "publicip" {
  name                = "publicip"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  allocation_method   = "Static"

  tags = var.common_tags
}

resource "azurerm_network_interface" "webserver" {
  name                = "rhelapache-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${module.sub3.subnetid}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.10"
  }
tags = var.common_tags  
}

resource "azurerm_network_interface" "connect" {
  name                = "rhelconnect-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${module.sub3.subnetid}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.11"
    public_ip_address_id          = azurerm_public_ip.publicip.id    
  }
tags = var.common_tags  
}

resource "azurerm_linux_virtual_machine" "rhelapache" {
  name                = "rhel8ws"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.webserver.id
  ]
  disable_password_authentication = "false"
  admin_password = "test4me!!"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 64
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "86-gen2"
    version   = "latest"
  }
tags = var.common_tags  
}

resource "azurerm_linux_virtual_machine" "rhelconnect" {
  name                = "rhel8conn"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.connect.id
  ]
  disable_password_authentication = "false"
  admin_password = "test4me!!"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 64
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "86-gen2"
    version   = "latest"
  }
tags = var.common_tags  
}