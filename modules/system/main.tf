terraform {

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }

}

resource "kubernetes_namespace_v1" "system" {
  metadata {
    name = "system"
  }
}

resource "kubernetes_service_account_v1" "system" {
  metadata {
    name      = "system"
    namespace = kubernetes_namespace_v1.system.metadata.0.name
  }
}

resource "kubernetes_secret_v1" "kubernetes_dashboard_csrf" {
  metadata {
    name      = "kubernetes-dashboard-csrf"
    namespace = kubernetes_namespace_v1.system.metadata.0.name
  }
}

resource "kubernetes_secret_v1" "kubernetes_dashboard_key_holder" {
  metadata {
    name      = "kubernetes-dashboard-key-holder"
    namespace = kubernetes_namespace_v1.system.metadata.0.name
  }
}

resource "kubernetes_config_map_v1" "kubernetes_dashboard_settings" {
  metadata {
    name      = "kubernetes-dashboard-settings"
    namespace = kubernetes_namespace_v1.system.metadata.0.name
  }
}

resource "kubernetes_role_v1" "kubernetes_dashboard" {
  metadata {
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace_v1.system.metadata.0.name
  }
  # Allow Dashboard to get, update and delete Dashboard exclusive secrets.
  rule {
    api_groups     = [""]
    resources      = ["secrets"]
    resource_names = ["kubernetes-dashboard-key-holder", "kubernetes-dashboard-certs", "kubernetes-dashboard-csrf"]
    verbs          = ["get", "update", "delete"]
  }
  # Allow Dashboard to get and update 'kubernetes-dashboard-settings' config map.
  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["kubernetes-dashboard-settings"]
    verbs          = ["get", "update"]
  }
  # Allow Dashboard to get metrics.
  rule {
    api_groups     = [""]
    resources      = ["services"]
    resource_names = ["heapster", "dashboard-metrics-scraper"]
    verbs          = ["proxy"]
  }
  rule {
    api_groups     = [""]
    resources      = ["services/proxy"]
    resource_names = ["heapster", "http:heapster:", "https:heapster:", "dashboard-metrics-scraper", "http:dashboard-metrics-scraper"]
    verbs          = ["get"]
  }
}

resource "kubernetes_cluster_role_v1" "kubernetes_dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
  # Allow Metrics Scraper to get metrics from the Metrics server
  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding_v1" "kubernetes_dashboard" {
  metadata {
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace_v1.system.metadata.0.name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.kubernetes_dashboard.metadata.0.name
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account_v1.system.metadata.0.name
  }
}

resource "kubernetes_cluster_role_binding_v1" "kubernetes_dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.kubernetes_dashboard.metadata.0.name
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account_v1.system.metadata.0.name
  }
}
