terraform {

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }

}

resource "kubernetes_namespace_v1" "database" {
  metadata {
    name = "database"
  }
}
