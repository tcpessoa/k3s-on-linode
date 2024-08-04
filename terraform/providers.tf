terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.25"
    }
  }
}

provider "linode" {
  token = var.linode_token
}
