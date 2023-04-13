#ToDo: Test this in a playground/sandbox
#resource "azapi_resource" "rule_collection_api" {
#  for_each  = var.api_rules
#  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections@2022-07-01"
#  name      = var.api_rules[each.key].name
#  parent_id = azapi_resource.security_admin_configurations.id
#
#  body      = jsonencode({
#    properties = {
#      appliesToGroups = [
#        {
#          networkGroupId = azapi_resource.network_manager.id,
#        },
#      ],
#      description = "The admin rule collection set to apply",
#    },
#  })
#}
#
#resource "azapi_resource" "rule_collection_api_rules" {
#  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules@2022-07-01"
#  parent_id = azapi_resource.security_admin_configurations.id
#  for_each  = var.api_rules
#
#body = jsonencode({
#    kind       = "Custom",
#    properties = {
#      priority                   = each.value.priority,
#      direction                  = each.value.direction,
#      access                     = each.value.access,
#      protocol                   = each.value.protocol,
#      sources = [
#          for key, value in var.vm_rules : {
#              addressPrefix = value.sources[0].addressPrefix
#              addressPrefixType = "IPv4"
#          }
#      ]
#      destinations = [
#          for key, value in var.vm_rules : {
#              addressPrefix = value.destinations[0].addressPrefix
#              addressPrefixType = "IPv4"
#          }
#      ]
#      sourcePortRanges           = [each.value.sourcePortRanges],
#      destinationPortRanges      = [each.value.destinationPortRanges],
#    },
#  })
#  name = each.key
#}
#
#resource "azapi_resource" "rule_collection_vm" {
#  for_each  = var.vm_rules
#  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections@2022-07-01"
#  name      = var.vm_rules[each.key].name
#  parent_id = azapi_resource.security_admin_configurations.id
#
#  body      = jsonencode({
#    properties = {
#      appliesToGroups = [
#        {
#          networkGroupId = azapi_resource.network_manager.id,
#        },
#      ],
#      description = "The admin rule collection set to apply",
#    },
#  })
#}
#
#resource "azapi_resource" "rule_collection_vm_rules" {
#  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules@2022-07-01"
#  parent_id = azapi_resource.security_admin_configurations.id
#  for_each  = var.vm_rules
#
#body = jsonencode({
#    kind       = "Custom",
#    properties = {
#      priority                   = each.value.priority,
#      direction                  = each.value.direction,
#      access                     = each.value.access,
#      protocol                   = each.value.protocol,
#      sources = [
#          for key, value in var.vm_rules : {
#              addressPrefix = value.sources[0].addressPrefix
#              addressPrefixType = "IPv4"
#          }
#      ]
#      destinations = [
#          for key, value in var.vm_rules : {
#              addressPrefix = value.destinations[0].addressPrefix
#              addressPrefixType = "IPv4"
#          }
#      ]
#      sourcePortRanges           = [each.value.sourcePortRanges],
#      destinationPortRanges      = [each.value.destinationPortRanges],
#    },
#  })
#  name = each.key
#}
#