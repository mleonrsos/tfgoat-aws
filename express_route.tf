resource "azurerm_express_route_circuit" "els_proxy_prod_to_telus" {
  name                  = "els-proxy-prod-expressroute-to-telus"
  resource_group_name   = data.azurerm_resource_group.networking.name
  location              = data.azurerm_resource_group.networking.location
  service_provider_name = "Telus"
  peering_location      = "Toronto"
  bandwidth_in_mbps     = 1000

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }
  tags = local.global_tags
}

resource "azurerm_express_route_circuit_peering" "telus-acceptor" {
  express_route_circuit_name    = azurerm_express_route_circuit.els_proxy_prod_to_telus.name
  resource_group_name           = data.azurerm_resource_group.networking.name
  peer_asn                      = 852
  primary_peer_address_prefix   = "10.143.124.40/30"
  secondary_peer_address_prefix = "10.159.118.252/30"
  vlan_id                       = 2000
  peering_type                  = "AzurePrivatePeering"

  #  ipv6 {
  #    enabled = false
  #    microsoft_peering {}
  #    primary_peer_address_prefix   = ""
  #    secondary_peer_address_prefix = ""
  #  }
}
