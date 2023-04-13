resource "azurerm_route_table" "aks_rt" {
  name                = "aks-route-table"
  location            = data.azurerm_resource_group.els_proxy_aks.location
  resource_group_name = data.azurerm_resource_group.els_proxy_aks.name
}

resource "azurerm_route_table" "els_proxy_prod_vnet_gw_rt" {
  name                = "vnet-route-table"
  location            = data.azurerm_resource_group.networking.location
  resource_group_name = data.azurerm_resource_group.networking.name
}

resource "azurerm_subnet_route_table_association" "aks_route_table_association" {
  subnet_id      = data.azurerm_subnet.aks_subnet.id
  route_table_id = azurerm_route_table.aks_rt.id
}

resource "azurerm_subnet_route_table_association" "els_proxy_prod_rt_association" {
  subnet_id      = lookup(module.vnet_vpn.vnet_subnets_name_id, "GatewaySubnet")
  route_table_id = azurerm_route_table.els_proxy_prod_vnet_gw_rt.id
}

resource "azurerm_route" "route_to_gw_subnet" {
  name                = "route-to-gateway-subnet"
  resource_group_name = data.azurerm_resource_group.els_proxy_aks.name
  route_table_name    = azurerm_route_table.aks_rt.name
  address_prefix      = "10.148.0.0/27"
  next_hop_type       = "VirtualNetworkGateway"
}
