module "vnet_vpn" {
  source              = "Azure/vnet/azurerm"
  version             = "4.0.0"
  resource_group_name = data.azurerm_resource_group.networking.name
  vnet_location       = data.azurerm_resource_group.networking.location
  use_for_each        = true
  vnet_name           = "vnet-els-proxy-prod-gateway-vpn"
  address_space       = ["10.148.0.0/26"]
  subnet_names        = ["GatewaySubnet"]
  subnet_prefixes     = ["10.148.0.0/27"]

  tags = local.global_tags
}

module "vnet_er" {
  source              = "Azure/vnet/azurerm"
  version             = "4.0.0"
  resource_group_name = data.azurerm_resource_group.networking.name
  vnet_location       = data.azurerm_resource_group.networking.location
  use_for_each        = true
  vnet_name           = "vnet-els-proxy-prod-gateway-er"
  address_space       = ["10.148.0.64/26"]
  subnet_names        = ["GatewaySubnet"]
  subnet_prefixes     = ["10.148.0.64/27"]

  tags = local.global_tags
}

resource "azurerm_public_ip" "els_proxy_vpn_gateway" {
  #  for_each = toset(["0", "1"])
  #  name                = "els-proxy-prod-vnet-gateway-public-ip-${each.key}"

  name                = "els-proxy-prod-vnet-gateway-public-ip"
  location            = data.azurerm_resource_group.networking.location
  resource_group_name = data.azurerm_resource_group.networking.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  public_ip_prefix_id = data.azurerm_public_ip_prefix.els_proxy_prod.id

  tags = local.global_tags
}

resource "azurerm_public_ip" "els_proxy_expressroute_gateway" {
  #  for_each = toset(["0", "1"])
  #  name                = "els-proxy-prod-expressroute-gateway-public-ip-${each.key}"
  #
  name                = "els-proxy-prod-expressroute-gateway-public-ip"
  location            = data.azurerm_resource_group.networking.location
  resource_group_name = data.azurerm_resource_group.networking.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  public_ip_prefix_id = data.azurerm_public_ip_prefix.els_proxy_prod.id

  tags = local.global_tags
}

resource "azurerm_virtual_network_gateway_connection" "snat_gateway_connection" {
  name                            = "test-opposite-direction"
  location                        = data.azurerm_resource_group.networking.location
  resource_group_name             = data.azurerm_resource_group.networking.name
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.telus_snat_gateway.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.telus_private_gateway.id

  type       = "Vnet2Vnet"
  shared_key = "somesecretkey"
}

resource "azurerm_virtual_network_gateway_connection" "private_gateway_connection" {
  name                            = "test"
  location                        = data.azurerm_resource_group.networking.location
  resource_group_name             = data.azurerm_resource_group.networking.name
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.telus_private_gateway.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.telus_snat_gateway.id

  type       = "Vnet2Vnet"
  shared_key = "somesecretkey"
  enable_bgp = true
}

resource "azurerm_local_network_gateway" "er_gateway_lg" {
  name                = "er-gateway-local-network-gateway"
  location            = data.azurerm_resource_group.networking.location
  resource_group_name = data.azurerm_resource_group.networking.name

  gateway_address     = "10.148.1.1/32"
  address_space       = ["10.148.0.64/26"]
}

resource "azurerm_virtual_network_peering" "gateway_to_aks" {
  name                         = "vpn-vnet-to-aks-peering"
  resource_group_name          = data.azurerm_resource_group.networking.name
  virtual_network_name         = module.vnet_vpn.vnet_name
  remote_virtual_network_id    = data.azurerm_virtual_network.aks.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "aks_to_gateway" {
  name                         = "aks-to-vpn-vnet-peering"
  resource_group_name          = data.terraform_remote_state.rg_els_proxy_aks_ca_central_1.outputs.rg_els_proxy_aks_name
  virtual_network_name         = data.azurerm_virtual_network.aks.name
  remote_virtual_network_id    = module.vnet_vpn.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "gateway_er_to_vpn" {
  name                         = "gateway-er-to-vpn-peering"
  resource_group_name          = data.azurerm_resource_group.networking.name
  virtual_network_name         = module.vnet_er.vnet_name
  remote_virtual_network_id    = module.vnet_vpn.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = true
}

resource "azurerm_virtual_network_peering" "gateway_vpn_to_er" {
  name                         = "gateway-vpn-to-er-peering"
  resource_group_name          = data.azurerm_resource_group.networking.name
  virtual_network_name         = module.vnet_vpn.vnet_name
  remote_virtual_network_id    = module.vnet_er.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}