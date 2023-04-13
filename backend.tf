terraform {
  backend "s3" {
    profile = "Rapidsos-els-proxy-prod.SuperAdmin"
    bucket  = "rapidsos-els-proxy-prod-terraform-state"
    key     = "vnets/vnet-els-proxy-prod-gateway/terraform.tfstate"
    # All terraform states are stored in one region.
    region            = "ca-central-1"
    encrypt           = true
    dynamodb_endpoint = "https://dynamodb.ca-central-1.amazonaws.com"
    dynamodb_table    = "terraform-state-lock"
  }
}

data "terraform_remote_state" "rg_els_proxy_aks_ca_central_1" {
  backend = "s3"
  config = {
    profile = "Rapidsos-els-proxy-prod.SuperAdmin"
    bucket  = "rapidsos-els-proxy-prod-terraform-state"
    key     = "resource_groups/terraform.tfstate"
    region  = "ca-central-1"
  }
}
