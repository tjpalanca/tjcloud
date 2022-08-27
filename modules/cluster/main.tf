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
  node_count = 1
}

resource "linode_lke_cluster" "cluster" {
  label       = var.cluster_name
  k8s_version = "1.23"
  region      = var.linode_region
  pool {
    type  = "g6-standard-4"
    count = local.node_count
  }
}

data "linode_instances" "production_nodes" {
  count = local.node_count
  filter {
    name = "id"
    values = [
      linode_lke_cluster.cluster.pool.0.nodes[count.index].instance_id
    ]
  }
}

data "cloudflare_zone" "main" {
  name = var.main_cloudflare_zone
}

resource "cloudflare_record" "production_nodes" {
  count   = local.node_count
  zone_id = data.cloudflare_zone.main.zone_id
  name    = "@"
  value   = data.linode_instances.production_nodes[count.index].instances.0.ip_address
  type    = "A"
  proxied = true
  depends_on = [
    linode_lke_cluster.cluster
  ]
}
