locals {

  # We have to build this value because the azurerm_virtual_network_gateway resource does not have an `id` attribute for
  # the ip_configuration block.
  ip_configuration_id = format(
    "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworkGateways/%s/ipConfigurations/%s",
    data.azurerm_subscription.current.subscription_id,
    data.azurerm_resource_group.networking.name,
    azurerm_virtual_network_gateway.telus_snat_gateway.name,
    "vnet-gateway-config"
  )

  env_name     = "els-proxy-prod"
  project_path = lookup(regex("(?:^.*rapidsos-aws-infra/)(?P<project_path>.*)", abspath(path.module)), "project_path")
  tags         = merge(local.global_tags, { terraform_path = local.project_path })

  global_tags = {
    "Project"        = "els-proxy"
    "Owner"          = "RapidSOS"
    "ManagedBy"      = "Terraform"
    "Team"           = "InfraDev"
    "Environment"    = local.env_name
    "terraform_path" = local.project_path
  }
}

