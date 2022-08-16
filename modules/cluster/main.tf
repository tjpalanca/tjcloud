terraform {

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

}

data "digitalocean_kubernetes_versions" "versions" {
  version_prefix = "1.23."
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = var.cluster_name
  region  = "sgp1"
  version = data.digitalocean_kubernetes_versions.versions.latest_version
  node_pool {
    name       = "worker-pool"
    size       = "s-4vcpu-8gb"
    node_count = 1
  }
}

data "digitalocean_kubernetes_cluster" "cluster" {
  name = var.cluster_name
}
