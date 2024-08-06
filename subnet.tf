module "sub1" {
    source="./modules/subnet"
    subnetname="sub1"
    subnetcidr=["10.0.0.0/24"]    
    vnetname=azurerm_virtual_network.virtual_network.name
    resource_group_name=azurerm_resource_group.resource_group.name
}

module "sub2" {
    source="./modules/subnet"
    subnetname="sub2"
    subnetcidr=["10.0.1.0/24"]
    vnetname=azurerm_virtual_network.virtual_network.name
    resource_group_name=azurerm_resource_group.resource_group.name
}

module "sub3" {
    source="./modules/subnet"
    subnetname="sub3"
    subnetcidr=["10.0.2.0/24"]
    vnetname=azurerm_virtual_network.virtual_network.name
    resource_group_name=azurerm_resource_group.resource_group.name
}

module "sub4" {
    source="./modules/subnet"
    subnetname="sub4"
    subnetcidr=["10.0.3.0/24"]
    vnetname=azurerm_virtual_network.virtual_network.name
    resource_group_name=azurerm_resource_group.resource_group.name
}
