terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
  }
}

resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = var.name
  }
}
