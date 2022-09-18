terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
  }
}

resource "kubernetes_namespace_v1" "dashboard" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account_v1" "dashboard" {
  metadata {
    labels = {
      "k8s-app" = "kubernetes-dashboard"
    }
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
}

locals {
  labels = {
    "k8s-app" = "kubernetes-dashboard"
  }
  scraper_labels = {
    "k8s-app" = "dashboard-metrics-scraper"
  }
}

resource "kubernetes_secret_v1" "dashboard_certs" {
  metadata {
    labels    = local.labels
    name      = "kubernetes-dashboard-certs"
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
  type = "Opaque"
}

resource "kubernetes_secret_v1" "dashboard_csrf" {
  metadata {
    labels    = local.labels
    name      = "kubernetes-dashboard-csrf"
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
  type = "Opaque"
  data = {
    csrf = ""
  }
}

resource "kubernetes_secret_v1" "dashboard_key_holder" {
  metadata {
    labels    = local.labels
    name      = "kubernetes-dashboard-key-holder"
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
  type = "Opaque"
}

resource "kubernetes_config_map_v1" "dashboard_settings" {
  metadata {
    labels    = local.labels
    name      = "kubernetes-dashboard-settings"
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
}

resource "kubernetes_role_v1" "dashboard" {
  metadata {
    labels    = local.labels
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
  # Allow Dashboard to get, update and delete Dashboard exclusive secrets.
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    resource_names = [
      kubernetes_secret_v1.dashboard_key_holder.metadata[0].name,
      kubernetes_secret_v1.dashboard_certs.metadata[0].name,
      kubernetes_secret_v1.dashboard_csrf.metadata[0].name
    ]
    verbs = ["get", "update", "delete"]
  }
  # Allow Dashboard to get and update 'kubernetes-dashboard-settings' config map.
  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = [kubernetes_config_map_v1.dashboard_settings.metadata[0].name]
    verbs          = ["get", "update"]
  }
  # Allow Dashboard to get metrics.
  rule {
    api_groups = [""]
    resources  = ["services"]
    resource_names = [
      "heapster",
      kubernetes_service_v1.dashboard_metrics_scraper.metadata[0].name
    ]
    verbs = ["proxy"]
  }
  rule {
    api_groups = [""]
    resources  = ["services/proxy"]
    resource_names = [
      "heapster",
      "http:heapster:",
      "https:heapster:",
      "dashboard-metrics-scraper",
      "http:dashboard-metrics-scraper"
    ]
    verbs = ["get"]
  }
}

resource "kubernetes_cluster_role_v1" "dashboard" {
  metadata {
    labels = local.labels
    name   = "kubernetes-dashboard"
  }
  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding_v1" "dashboard" {
  metadata {
    labels    = local.labels
    name      = "kubernetes-dashboard"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.dashboard.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.dashboard.metadata[0].name
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding_v1" "dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.dashboard.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.dashboard.metadata[0].name
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
}

resource "kubernetes_service_v1" "dashboard" {
  metadata {
    labels    = local.labels
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
  spec {
    port {
      port        = 443
      target_port = 8443
    }
    selector = local.labels
  }
}

resource "kubernetes_deployment_v1" "dashboard" {
  metadata {
    labels    = local.labels
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
  spec {
    replicas               = 1
    revision_history_limit = 10
    selector {
      match_labels = local.labels
    }
    template {
      metadata {
        labels = local.labels
      }
      spec {
        security_context {
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        container {
          name              = "kubernetes-dashboard"
          image             = "kubernetesui/dashboard:v2.6.1"
          image_pull_policy = "Always"
          port {
            container_port = 8443
            protocol       = "TCP"
          }
          args = [
            "--insecure-bind-address=0.0.0.0",
            "--bind-address=0.0.0.0",
            "--enable-skip-login",
            "--disable-settings-authorizer",
            "--sidecar-host=http://${kubernetes_service_v1.dashboard_metrics_scraper.metadata[0].name}:${kubernetes_service_v1.dashboard_metrics_scraper.spec[0].port[0].port}",
            "--namespace=${kubernetes_namespace_v1.dashboard.metadata[0].name}"
          ]
          volume_mount {
            name       = "kubernetes-dashboard-certs"
            mount_path = "/certs"
          }
          volume_mount {
            name       = "tmp-volume"
            mount_path = "/tmp"
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 8443
            }
            initial_delay_seconds = 30
            timeout_seconds       = 30
          }
          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            run_as_user                = 1001
            run_as_group               = 2001
          }
        }
        volume {
          name = "kubernetes-dashboard-certs"
          secret {
            secret_name = "kubernetes-dashboard-certs"
          }
        }
        volume {
          name = "tmp-volume"
          empty_dir {}
        }
        service_account_name = kubernetes_service_account_v1.dashboard.metadata[0].name
      }
    }
  }
}

resource "kubernetes_service_v1" "dashboard_metrics_scraper" {
  metadata {
    labels    = local.scraper_labels
    name      = "dashboard-metrics-scraper"
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
  spec {
    selector = local.scraper_labels
    port {
      port        = 8000
      target_port = 8000
    }
  }
}

resource "kubernetes_deployment_v1" "dashboard_metrics_scraper" {
  metadata {
    labels    = local.scraper_labels
    name      = "dashboard-metrics-scraper"
    namespace = kubernetes_namespace_v1.dashboard.metadata[0].name
  }
  spec {
    replicas               = 1
    revision_history_limit = 10
    selector {
      match_labels = local.scraper_labels
    }
    template {
      metadata {
        labels = local.scraper_labels
      }
      spec {
        security_context {
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        container {
          name  = "dashboard-metrics-scraper"
          image = "kubernetesui/metrics-scraper:v1.0.8"
          port {
            container_port = 8000
            protocol       = "TCP"
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 8000
            }
            initial_delay_seconds = 30
            timeout_seconds       = 30
          }
          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-volume"
          }
          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            run_as_user                = 1001
            run_as_group               = 2001
          }
        }
        service_account_name = kubernetes_service_account_v1.dashboard.metadata[0].name
        volume {
          name = "tmp-volume"
          empty_dir {}
        }
      }
    }
  }
}
