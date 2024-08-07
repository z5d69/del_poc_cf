resource "azurerm_public_ip" "publiciplb" {
  name                = "iplbpoccf"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku = "Standard"
  tags = var.common_tags  
}

resource "azurerm_network_interface" "lbinternal" {
  name                = "lbinternal-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${module.sub3.subnetid}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.13"
  }
tags = var.common_tags  
}

# Associate Network Interface to the Backend Pool of the Load Balancer
resource "azurerm_network_interface_backend_address_pool_association" "nic_lb_pool" {
  network_interface_id    = azurerm_network_interface.lbinternal.id
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_pool_backend_address_pool.id
}

resource "azurerm_lb" "load_balancer" {
  name                = "lbpoccf"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tags = var.common_tags
  frontend_ip_configuration {
    name                 = "iplbpoccf"
    public_ip_address_id = azurerm_public_ip.publiciplb.id
  }
  sku = "Standard"
}

resource "azurerm_lb_backend_address_pool" "lb_pool_backend_address_pool" {
  loadbalancer_id      = azurerm_lb.load_balancer.id
  name                 = "lb-pool"
}


/* resource "azurerm_lb_probe" "my_lb_probe" {
  loadbalancer_id     = azurerm_lb.load_balancer.id
  name                = "lb-probe"
  port                = 80
} */

/* 
resource "azurerm_lb_rule" "lb_rule_80" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "test-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  disable_outbound_snat          = true
  frontend_ip_configuration_name = azurerm_public_ip.publiciplb.name
  probe_id                       = azurerm_lb_probe.my_lb_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_pool_backend_address_pool.id]
}
 */
##?
resource "azurerm_lb_nat_rule" "web_lb_inbound_nat_rule_http" {
  name                           = "httpinbound"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.load_balancer.frontend_ip_configuration[0].name  
  resource_group_name            = azurerm_resource_group.resource_group.name
  loadbalancer_id                = azurerm_lb.load_balancer.id
}

resource "azurerm_lb_nat_rule" "web_lb_inbound_nat_rule_ssh" {
  name                           = "sshinbound"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.load_balancer.frontend_ip_configuration[0].name  
  resource_group_name            = azurerm_resource_group.resource_group.name
  loadbalancer_id                = azurerm_lb.load_balancer.id
}

resource "azurerm_network_interface_nat_rule_association" "web_lb_inbound_nat_rule_http_associate" {
  network_interface_id  = azurerm_network_interface.webserver.id
  ip_configuration_name = azurerm_network_interface.webserver.ip_configuration[0].name
  nat_rule_id           = azurerm_lb_nat_rule.web_lb_inbound_nat_rule_http.id
}

resource "azurerm_network_interface_nat_rule_association" "web_lb_inbound_nat_rule_ssh_associate" {
  network_interface_id  = azurerm_network_interface.webserver.id
  ip_configuration_name = azurerm_network_interface.webserver.ip_configuration[0].name
  nat_rule_id           = azurerm_lb_nat_rule.web_lb_inbound_nat_rule_ssh.id
}

resource "azurerm_lb_outbound_rule" "lb_outbound_rule" {
  name                    = "lb_outbound_rule"
  loadbalancer_id         = azurerm_lb.load_balancer.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_pool_backend_address_pool.id

  frontend_ip_configuration {
    name = "iplbpoccf"
  }
}