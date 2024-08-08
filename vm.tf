
resource "azurerm_public_ip" "publicipconnect" {
  name                = "publicipconnect"
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
    private_ip_address            = "10.0.2.15"
  }
tags = var.common_tags  
}

resource "azurerm_network_interface" "connect" {
  name                = "rhelconnect-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${module.sub2.subnetid}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.11"
    public_ip_address_id          = azurerm_public_ip.publicipconnect.id  
  }
tags = var.common_tags  
}

resource "azurerm_linux_virtual_machine" "rhelapache" {
  name                = "vmrhel8ws"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.webserver.id
  ]
  disable_password_authentication = "false"
  admin_password = "test4me!!"
  custom_data    = base64encode(data.template_file.rhelapache-cloud-init.rendered)

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
depends_on = [azurerm_network_interface_nat_rule_association.web_lb_inbound_nat_rule_http_associate]
}

# Data template Bash bootstrapping file
data "template_file" "rhelapache-cloud-init" {
  template = file("rhelapache.sh")
}

resource "azurerm_linux_virtual_machine" "rhelconnect" {
  name                = "vmrhel8conn"
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

resource "azurerm_network_interface" "vmmember1" {
  name                = "rhelmbr1-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${module.sub1.subnetid}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.10"
  }
tags = var.common_tags  
}

resource "azurerm_network_interface" "vmmember2" {
  name                = "rhelmbr2-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${module.sub1.subnetid}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.11"
  }
tags = var.common_tags  
}

resource "azurerm_linux_virtual_machine" "rhelmbr1" {
  name                = "vmrhel8mbr1"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vmmember1.id
  ]
  availability_set_id = azurerm_availability_set.availability_set.id
  disable_password_authentication = "false"
  admin_password = "test4me!!"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 256
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "86-gen2"
    version   = "latest"
  }
tags = var.common_tags  
}

resource "azurerm_linux_virtual_machine" "rhelmbr2" {
  name                = "vmrhel8mbr2"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vmmember2.id
  ]
  availability_set_id = azurerm_availability_set.availability_set.id  
  disable_password_authentication = "false"
  admin_password = "test4me!!"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 256
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "86-gen2"
    version   = "latest"
  }
tags = var.common_tags  
}
