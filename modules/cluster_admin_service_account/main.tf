terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.18.1"
    }
  }
}

resource "kubernetes_service_account_v1" "cluster_admin" {
  metadata {
    name      = "${var.namespace}-cluster-admin"
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role_binding_v1" "code_cluster_admin" {
  metadata {
    name = kubernetes_service_account_v1.cluster_admin.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.cluster_admin.metadata[0].name
    namespace = kubernetes_service_account_v1.cluster_admin.metadata[0].namespace
  }
}
