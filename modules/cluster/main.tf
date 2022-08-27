terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.29.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

locals {
  production = {
    node_count  = 1
    volume_size = 10
  }
  development = {
    node_count  = 1
    volume_size = 40
  }
}

resource "linode_lke_cluster" "cluster" {
  label       = var.cluster_name
  k8s_version = "1.23"
  region      = var.linode_region
  tags        = [var.cluster_name]
  pool {
    type  = "g6-standard-4"
    count = 1
  }
}
