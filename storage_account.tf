resource "azurerm_storage_account" storage_account_name {
  name                     = "strgpoccfsbx"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = var.azstrgaccounttier
  account_replication_type = var.azstrgreplicationtype
  public_network_access_enabled = "true"
  is_hns_enabled = "true"
  tags = var.common_tags
}

resource "azurerm_storage_account_network_rules" "azurerm_storage_account_network_rules" {
  storage_account_id = azurerm_storage_account.storage_account_name.id
  default_action = "Deny"
  virtual_network_subnet_ids = [
    "${module.sub1.subnetid}",
    "${module.sub2.subnetid}", 
    "${module.sub3.subnetid}",
    "${module.sub4.subnetid}"   ]
}
