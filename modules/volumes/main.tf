terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

resource "kubernetes_namespace_v1" "volumes" {
  metadata {
    name = "volumes"
  }
}
