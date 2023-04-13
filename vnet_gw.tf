# Create the gateway subnet for the global virtual network gateway & the virtual network gateway as a global resource
resource "azurerm_virtual_network_gateway" "telus_snat_gateway" {
  #  count               = 2 # 2 for HA
  name                = "vpn-vnet-gateway"
  location            = data.azurerm_resource_group.networking.location
  resource_group_name = data.azurerm_resource_group.networking.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  sku = "VpnGw2AZ"

  ip_configuration {
    name                          = "vnet-gateway-config"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = lookup(module.vnet_vpn.vnet_subnets_name_id, "GatewaySubnet")
    #public_ip_address_id          = azurerm_public_ip.els_proxy_vpn_gateway[0].id
    public_ip_address_id          = azurerm_public_ip.els_proxy_vpn_gateway.id
  }

  enable_bgp    = true
  active_active = false # Set to true for HA

  bgp_settings {
    asn         = 64513
    peer_weight = 0
  }

  tags = local.global_tags
}

resource "azurerm_virtual_network_gateway" "telus_private_gateway" {
  #  count               = 2 # 2 for HA
  name                = "express-route-vnet-gateway"
  location            = data.azurerm_resource_group.networking.location
  resource_group_name = data.azurerm_resource_group.networking.name

  type     = "ExpressRoute"
  vpn_type = "RouteBased"

  sku = "ErGw2AZ"

  active_active = false # Set to true for HA

  ip_configuration {
    name                          = "express-route-gateway-config"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = lookup(module.vnet_er.vnet_subnets_name_id, "GatewaySubnet")
    #public_ip_address_id          = azurerm_public_ip.els_proxy_expressroute_gateway[0].id
    public_ip_address_id          = azurerm_public_ip.els_proxy_expressroute_gateway.id
  }

  tags = local.global_tags
}

resource "azurerm_virtual_network_gateway_nat_rule" "public_to_telus" {
  name                       = "public_to_telus"
  resource_group_name        = data.azurerm_resource_group.networking.name
  virtual_network_gateway_id = azurerm_virtual_network_gateway.telus_snat_gateway.id
  mode                       = "EgressSnat"
  type                       = "Dynamic"
  #  ip_configuration_id        = "/subscriptions/d6ffd970-fb67-482a-928d-9e1cf7910e2e/resourceGroups/els-proxy-prod-networking/providers/Microsoft.Network/virtualNetworkGateways/vnet-gateway/ipConfigurations/vnet-gateway-config"
  ip_configuration_id = local.ip_configuration_id

  external_mapping {
    address_space = "${azurerm_public_ip.els_proxy_vpn_gateway.ip_address}/32"
  }

  internal_mapping {
    #  address_space = "10.148.0.0/26"
    address_space = "10.148.2.0/23"
  }
}

# New configuration for authorization and connection
resource "azurerm_express_route_circuit_authorization" "express_route_acceptor" {
  name                       = "telus-auth"
  resource_group_name        = data.azurerm_resource_group.networking.name
  express_route_circuit_name = azurerm_express_route_circuit.els_proxy_prod_to_telus.name
}

resource "azurerm_virtual_network_gateway_connection" "telus_route_connection" {
  name                = "vnet_gw_express_route_connection"
  location            = data.azurerm_resource_group.networking.location
  resource_group_name = data.azurerm_resource_group.networking.name

  type                       = "ExpressRoute"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.telus_private_gateway.id
  express_route_circuit_id   = azurerm_express_route_circuit.els_proxy_prod_to_telus.id
  authorization_key          = azurerm_express_route_circuit_authorization.express_route_acceptor.authorization_key
  enable_bgp                 = true
}

