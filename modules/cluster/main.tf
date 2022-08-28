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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

locals {
  node_count = 1
  main_nodes = data.linode_instances.main_nodes.instances
  main_node  = local.main_nodes.0
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

data "linode_instances" "main_nodes" {
  filter {
    name = "id"
    values = [
      for node in linode_lke_cluster.cluster.pool.0.nodes :
      node.instance_id
    ]
  }
}
