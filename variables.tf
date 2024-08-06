variable "vnetname" {
    type=string
    description = "this is the vnet name for this deployment"
    default = "vnetpoccf"
}

variable "azregion" {
  type=string
  description = "This is the region for resources to deploy in"
  default = "CentralUS"
}

variable "resource_group_name" {
    type=string
    description = "This is the resource group for resources to deploy in"
    default = "rgpoccf"
}

variable "keyvaultname" {
    type=string
    description = "this is the keyvault for this deployment"
    default = "kvpoccf"
}

variable "azstrgaccounttier" {
    type=string
    description = "this is the access tier for this storage"
    default = "Standard"
}

variable "azstrgreplicationtype" {
    type=string
    description = "this is the replication type for this storage"
    default = "LRS"
}

variable "common_tags" {
  type = map(string)
  default = {
    environment = "sandbox"
    shortenvironment = "sbx"
    project  = "poccf"
  }
}