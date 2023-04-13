data "azurerm_resource_group" "networking" {
  name = data.terraform_remote_state.rg_els_proxy_aks_ca_central_1.outputs.rg_networking_name
}

data "azurerm_public_ip_prefix" "els_proxy_prod" {
  name                = "els-proxy-prod-prefix"
  resource_group_name = data.azurerm_resource_group.networking.name
}

data "azurerm_resource_group" "els_proxy_aks" {
  name = "rg-aks-els-proxy-prod"
}

data "azurerm_virtual_network" "aks" {
  name                = "vnet-els-proxy-aks-canadacentral-prod"
  resource_group_name = "rg-aks-els-proxy-prod"
}

data "azurerm_subnet" "aks_subnet" {
  name                 = "sn-els-proxy-aks-canadacentral-prod"
  virtual_network_name = data.azurerm_virtual_network.aks.name
  resource_group_name  = data.azurerm_virtual_network.aks.resource_group_name
}

data "azurerm_subscription" "current" {}
