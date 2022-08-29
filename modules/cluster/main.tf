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

resource "linode_lke_cluster" "cluster" {
  label       = var.cluster_name
  k8s_version = "1.23"
  region      = var.linode_region
  pool {
    type  = "g6-standard-4"
    count = var.num_main_nodes
  }
}

resource "time_sleep" "cluster_created" {
  depends_on      = [linode_lke_cluster.cluster]
  create_duration = "10s"
}

data "linode_instances" "main_nodes" {
  filter {
    name   = "id"
    values = [for node in linode_lke_cluster.cluster.pool.0.nodes : node.instance_id]
  }
  depends_on = [
    time_sleep.cluster_created
  ]
}
