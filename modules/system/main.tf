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
