provider "aws" {
  region  = "ca-central-1"
  profile = "Rapidsos-els-proxy-prod.SuperAdmin"

  default_tags { tags = local.tags }
}

provider "azurerm" {
  subscription_id = "d6ffd970-fb67-482a-928d-9e1cf7910e2e"
  features {}
}
