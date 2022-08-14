terraform {

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

}

resource "digitalocean_kubernetes_cluster" "tjcloud" {
  name    = "tjcloud"
  region  = "sgp1"
  version = "1.23.9-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "c-2"
    node_count = 1
  }
}
