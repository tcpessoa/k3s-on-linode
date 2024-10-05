terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.29"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.43"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
