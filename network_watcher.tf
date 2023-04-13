data "azurerm_network_watcher" "NetworkWatcher_canadacentral" {
  name                = "NetworkWatcher_canadacentral"
  resource_group_name = "NetworkWatcherRG"
}

#resource "azurerm_network_connection_monitor" "els_proxy_prod" {
#  name               = "ELS-Proxy-Connection-Monitor"
#  network_watcher_id = data.azurerm_network_watcher.NetworkWatcher_canadacentral.id
#  location           = data.azurerm_resource_group.networking.location
#
#  endpoint {
#    name               = "source"
#    target_resource_id = azurerm_virtual_machine.els-proxy-net-test.id # Update this to the desired source address
#
#    filter {
#      item {
#        address = azurerm_virtual_network_gateway.telus_snat_gateway.id # Update this to the include hops
#        type = "AgentAddress"
#      }
#
#      type = "Include"
#    }
#  }
#
#  endpoint {
#    name = "destination"
#    address = azurerm_virtual_network_gateway.telus_private_gateway.id # Update this to the desired destination address
#  }
#
#  test_configuration {
#    name                      = "tcpName"
#    protocol                  = "Tcp"
#    test_frequency_in_seconds = 60
#
#    tcp_configuration {
#      port = 443 # Update this to the desired destination port
#    }
#  }
#
#  test_group {
#    name                     = "Connection-Monitor-Test-Group"
#    destination_endpoints    = ["destination"]
#    source_endpoints         = ["source"]
#    test_configuration_names = ["tcpName"]
#  }
#  tags = local.global_tags
#}

resource "azurerm_log_analytics_workspace" "els_proxy_prod" {
  name                = "ELS-Proxy-Prod-Net-Log-Analytics-Workspace"
  location            = data.azurerm_resource_group.networking.location
  resource_group_name = data.azurerm_resource_group.networking.name
  sku                 = "PerGB2018"

  tags = local.global_tags
}

resource "azurerm_network_watcher_flow_log" "els_proxy_prod" {
  name                      = "ELS-Proxy-Prod-Flow-Logs-Analytics"
  network_watcher_name      = data.azurerm_network_watcher.NetworkWatcher_canadacentral.name
  resource_group_name       = data.azurerm_network_watcher.NetworkWatcher_canadacentral.resource_group_name
  network_security_group_id = azurerm_network_security_group.vnet_gateways_nsg.id

  storage_account_id = azurerm_storage_account.production_network_storage.id
  enabled            = true
  retention_policy {
    enabled = true
    days    = 90
  }

  traffic_analytics {
    enabled               = true
    interval_in_minutes   = 10
    workspace_id          = azurerm_log_analytics_workspace.els_proxy_prod.workspace_id
    workspace_region      = data.azurerm_resource_group.networking.location
    workspace_resource_id = azurerm_log_analytics_workspace.els_proxy_prod.id
  }
  tags = local.global_tags
}

resource "azurerm_storage_account" "production_network_storage" {
  name                      = "prodnetflowstorage"
  resource_group_name       = data.azurerm_resource_group.networking.name
  location                  = data.azurerm_resource_group.networking.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true

  network_rules {
    default_action = "Deny"
  }
  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      retention_policy_days = 90
      version               = "1.0"
    }
  }
  tags = local.global_tags
}

resource "azurerm_network_security_group" "vnet_gateways_nsg" {
  name                = "Network-Watcher-NSG"
  location            = data.azurerm_resource_group.networking.location
  resource_group_name = data.azurerm_resource_group.networking.name

  tags = local.global_tags
}

output "log_analytics_workspace" {
  value = {
    workspace_id  = azurerm_log_analytics_workspace.els_proxy_prod.workspace_id
    workspace_key = azurerm_log_analytics_workspace.els_proxy_prod.primary_shared_key
  }
  sensitive = true
}
