#ToDo: Test this in a playground/sandbox
#variable "api_rules" {
#  type = map(object({
#    name                  = string
#    priority              = number
#    direction             = string
#    access                = string
#    protocol              = string
#    sourcePortRanges      = string
#    destinationPortRanges = string
#    sources               = list(object({
#      addressPrefix       = string
#      addressPrefixType   = string
#    }))
#    destinations          = list(object({
#      addressPrefix       = string
#      addressPrefixType   = string
#    }))
#  }))
#  default = {
#    rule1 = {
#      name                  = "APIClientIN"
#      priority              = 200
#      direction             = "Inbound"
#      access                = "Allow"
#      protocol              = "Tcp"
#      sourcePortRanges      = "*"
#      destinationPortRanges = "443"
#      sources               = [
#        {
#          addressPrefix     = "Internet"
#          addressPrefixType = "ipv4"
#        }
#      ]
#      destinations = [
#        {
#          addressPrefix     = "VirtualNetwork"
#          addressPrefixType = "ipv4"
#        }
#      ]
#    },
#    rule2 = {
#      name                  = "PortalManagementIn"
#      priority              = 210
#      direction             = "Inbound"
#      access                = "Allow"
#      protocol              = "Tcp"
#      sourcePortRanges      = "*"
#      destinationPortRanges = "3443"
#      sources               = [
#        {
#          addressPrefix     = "ApiManagement"
#          addressPrefixType = "ipv4"
#        }
#      ]
#      destinations = [
#        {
#          addressPrefix     = "VirtualNetwork"
#          addressPrefixType = "ipv4"
#        }
#      ]
#    },
#    rule3 = {
#      name                  = "InFromLB"
#      priority              = 220
#      direction             = "Inbound"
#      access                = "Allow"
#      protocol              = "Tcp"
#      sourcePortRanges      = "*"
#      destinationPortRanges = "6390"
#      sources               = [
#        {
#          addressPrefix     = "AzureLoadBalancer"
#          addressPrefixType = "ipv4"
#        }
#      ]
#      destinations = [
#        {
#          addressPrefix     = "VirtualNetwork"
#          addressPrefixType = "ipv4"
#        }
#      ]
#    },
#    rule4 = {
#      name                  = "OutToStorage"
#      priority              = 230
#      direction             = "Outbound"
#      access                = "Allow"
#      protocol              = "Tcp"
#      sourcePortRanges      = "*"
#      destinationPortRanges = "443"
#      sources               = [
#        {
#          addressPrefix     = "VirtualNetwork"
#          addressPrefixType = "ipv4"
#        }
#      ]
#      destinations = [
#        {
#          addressPrefix     = "Storage"
#          addressPrefixType = "ipv4"
#        }
#      ]
#    },
#    rule5 = {
#      name                  = "OutToSQL"
#      priority              = 240
#      direction             = "Outbound"
#      access                = "Allow"
#      protocol              = "Tcp"
#      sourcePortRanges      = "*"
#      destinationPortRanges = "1443"
#      sources               = [
#        {
#          addressPrefix     = "VirtualNetwork"
#          addressPrefixType = "ipv4"
#        }
#      ]
#      destinations = [
#        {
#          addressPrefix     = "SQL"
#          addressPrefixType = "ipv4"
#        }
#      ]
#    },
#    rule6 = {
#      name                  = "OutToKeyVault"
#      priority              = 250
#      direction             = "Outbound"
#      access                = "Allow"
#      protocol              = "Tcp"
#      sourcePortRanges      = "*"
#      destinationPortRanges = "443"
#      sources               = [
#        {
#          addressPrefix     = "Internet"
#          addressPrefixType = "ipv4"
#        }
#      ]
#      destinations = [
#        {
#          addressPrefix     = "AzureKeyVault"
#          addressPrefixType = "ipv4"
#        }
#      ]
#    }
#  }
#}
#
#variable "vm_rules" {
#  type = map(object({
#    name                  = string
#    priority              = number
#    direction             = string
#    access                = string
#    protocol              = string
#    sourcePortRanges      = string
#    destinationPortRanges = string
#    sources               = list(object({
#      addressPrefix       = string
#      addressPrefixType   = string
#    }))
#    destinations          = list(object({
#      addressPrefix       = string
#      addressPrefixType   = string
#    }))
#  }))
#  default = {
#    rule1 = {
#      name                  = "VMRuleTest"
#      priority              = 200
#      direction             = "Inbound"
#      access                = "Allow"
#      protocol              = "Tcp"
#      sourcePortRanges      = "*"
#      destinationPortRanges = "443"
#      sources               = [
#        {
#          addressPrefix     = "Internet"
#          addressPrefixType = "ipv4"
#        }
#      ]
#      destinations = [
#        {
#          addressPrefix     = "VirtualNetwork"
#          addressPrefixType = "ipv4"
#        }
#      ]
#    }
#  }
#}
#