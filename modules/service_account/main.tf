terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.18.1"
    }
  }
}

resource "kubernetes_service_account_v1" "service_account" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role_binding_v1" "cluster_role_binding" {
  for_each = var.cluster_roles
  metadata {
    name = "${kubernetes_service_account_v1.service_account.metadata[0].name}-${each.value}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.value
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.service_account.metadata[0].name
    namespace = kubernetes_service_account_v1.service_account.metadata[0].namespace
  }
}
