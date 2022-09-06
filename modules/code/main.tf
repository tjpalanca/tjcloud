terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
  }
}

resource "kubernetes_namespace_v1" "code" {
  metadata {
    name = "code"
  }
}

resource "kubernetes_service_account_v1" "code_cluster_admin" {
  metadata {
    name      = "code-cluster-admin"
    namespace = kubernetes_namespace_v1.code.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding_v1" "code_cluster_admin" {
  metadata {
    name = "code-cluster-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.code_cluster_admin.metadata[0].name
    namespace = kubernetes_service_account_v1.code_cluster_admin.metadata[0].namespace
  }
}
