#ToDo: Test this in a playground/sandbox
#resource "azapi_resource" "network_manager" {
#  type = "Microsoft.Network/networkManagers@2022-07-01"
#  name = "vnm-hub-playground"
#  location = "Canada Central"
#  parent_id = "/subscriptions/cb1b52c0-3bc6-41ae-8635-9056c574f32c/resourceGroups/els-proxy-playground"
#  body = jsonencode({
#    properties = {
#      description = "vnm"
#      networkManagerScopeAccesses = [
#        "Connectivity",
#        "SecurityAdmin"
#      ]
#      networkManagerScopes = {
#        managementGroups = [
#        "/providers/Microsoft.Management/managementGroups/18093c3d-519d-4c93-a600-e357e8310471"
#        ]
#        subscriptions = ["cb1b52c0-3bc6-41ae-8635-9056c574f32c"]
#      }
#    }
#  })
#}
#
#resource "azapi_resource" "net_group" {
#  type      = "Microsoft.Network/networkManagers/networkGroups@2022-07-01"
#  name      = "vnm-net-group-playground"
#  parent_id = azapi_resource.network_manager.id
#
#  body = jsonencode({
#    properties = {
#      description = "vnm hub group"
#    }
#    })
#}
#
#resource "azapi_resource" "net_members_public" {
#  name      = "vnm-net-members-public-playground"
#  type      = "Microsoft.Network/networkManagers/networkGroups/staticMembers@2022-07-01"
#  parent_id  = azapi_resource.net_group.id
#  depends_on = [azapi_resource.net_group]
#
#  body = jsonencode({
#    properties = {
#      resourceId = "/subscriptions/cb1b52c0-3bc6-41ae-8635-9056c574f32c/resourceGroups/els-proxy-playground/providers/Microsoft.Network/virtualNetworks/vnet-els-proxy-playground/subnets/sn-els-proxy-playground-public"
#    }
#  })
#}
#
#resource "azapi_resource" "net_members_private" {
#  name      = "vnm-net-members-private-playground"
#  type      = "Microsoft.Network/networkManagers/networkGroups/staticMembers@2022-07-01"
#  parent_id  = azapi_resource.net_group.id
#  depends_on = [azapi_resource.net_group]
#
#  body = jsonencode({
#    properties = {
#      resourceId = "/subscriptions/cb1b52c0-3bc6-41ae-8635-9056c574f32c/resourceGroups/els-proxy-playground/providers/Microsoft.Network/virtualNetworks/vnet-els-proxy-playground/subnets/sn-els-proxy-playground-private"
#    }
#  })
#}
#
#resource "azapi_resource" "connectivity_groups" {
#  type = "Microsoft.Network/networkManagers/connectivityConfigurations@2022-07-01"
#  name = "vnm-connectivity-groups"
#  parent_id  = azapi_resource.net_group.id
#
#  body = jsonencode({
#    properties = {
#      description = "Vnet information"
#      connectivityTopology = "HubAndSpoke"
#      deleteExistingPeering = "false"
#      appliesToGroups = [
#        {
#          groupConnectivity = "DirectlyConnected"
#          isGlobal = "false"
#          networkGroupId = azapi_resource.net_members_public.id
#          useHubGateway = "true"
#        },
#        {
#          groupConnectivity = "DirectlyConnected"
#          isGlobal = "false"
#          networkGroupId = azapi_resource.net_members_private.id
#          useHubGateway = "true"
#        }
#      ]
#      hubs = [
#        {
#          resourceId = azapi_resource.net_group.id
#          resourceType = "Microsoft.Network/networkManagers/connectivityConfigurations@2022-07-01"
#        }
#      ]
#      isGlobal = "false"
#    }
#  })
#}
#
#resource "azapi_resource" "security_admin_configurations" {
#  type = "Microsoft.Network/networkManagers/securityAdminConfigurations@2022-07-01"
#  name = "els-proxy-playground-security-config"
#  parent_id = azapi_resource.network_manager.id
#  body = jsonencode({
#    properties = {
#      applyOnNetworkIntentPolicyBasedServices = [
#        "All"
#      ]
#      description = "A description of the security configuration"
#    }
#  })
#}
#