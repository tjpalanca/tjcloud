
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
  }
}

locals {
  labels = {
    "k8s-app" = "metrics-server"
  }
  namespace = "kube-system"
}

resource "kubernetes_service_account_v1" "metrics_server" {
  metadata {
    labels    = local.labels
    name      = "metrics-server"
    namespace = local.namespace
  }
}

resource "kubernetes_cluster_role_v1" "aggregated_metrics_reader" {
  metadata {
    labels = merge(local.labels, {
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
      "rbac.authorization.k8s.io/aggregate-to-edit"  = "true"
      "rbac.authorization.k8s.io/aggregate-to-view"  = "true"
    })
    name = "system:aggregated-metrics-reader"
  }
  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_v1" "metrics_server" {
  metadata {
    labels = local.labels
    name   = "system:metrics-server"
  }
  rule {
    api_groups = [""]
    resources  = ["nodes/metrics"]
    verbs      = ["get"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding_v1" "metrics_server_auth_reader" {
  metadata {
    labels    = local.labels
    name      = "metrics-server-auth-reader"
    namespace = local.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "extension-apiserver-authentication-reader"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.metrics_server.metadata[0].name
    namespace = kubernetes_service_account_v1.metrics_server.metadata[0].namespace
  }
}

resource "kubernetes_cluster_role_binding_v1" "metrics_server_system_auth_delegator" {
  metadata {
    labels = local.labels
    name   = "metrics-server:system:auth-delegator"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.metrics_server.metadata[0].name
    namespace = kubernetes_service_account_v1.metrics_server.metadata[0].namespace
  }
}

resource "kubernetes_cluster_role_binding_v1" "metrics_server" {
  metadata {
    labels = local.labels
    name   = "system:metrics-server"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.metrics_server.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.metrics_server.metadata[0].name
    namespace = kubernetes_service_account_v1.metrics_server.metadata[0].namespace
  }
}

resource "kubernetes_service_v1" "metrics_server" {
  metadata {
    labels    = local.labels
    name      = "metrics-server"
    namespace = local.namespace
  }
  spec {
    port {
      name        = "https"
      port        = 443
      protocol    = "TCP"
      target_port = "https"
    }
    selector = local.labels
  }
}

resource "kubernetes_deployment_v1" "metrics_server" {
  metadata {
    labels    = local.labels
    name      = "metrics-server"
    namespace = local.namespace
  }
  spec {
    selector {
      match_labels = local.labels
    }
    strategy {
      rolling_update {
        max_unavailable = 0
      }
    }
    template {
      metadata {
        labels = local.labels
      }
      spec {
        container {
          args = [
            "--kubelet-insecure-tls",
            "--cert-dir=/tmp",
            "--secure-port=4443",
            "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
            "--kubelet-use-node-status-port",
            "--metric-resolution=15s",
            "--authorization-always-allow-paths=/livez,/readyz"
          ]
          image             = "k8s.gcr.io/metrics-server/metrics-server:v0.6.2"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            http_get {
              path   = "/livez"
              port   = "https"
              scheme = "HTTPS"
            }
            failure_threshold = 3
            period_seconds    = 10
          }
          name = "metrics-server"
          port {
            container_port = 4443
            name           = "https"
            protocol       = "TCP"
          }
          readiness_probe {
            http_get {
              path   = "/readyz"
              port   = "https"
              scheme = "HTTPS"
            }
            failure_threshold     = 3
            initial_delay_seconds = 20
            period_seconds        = 10
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "200Mi"
            }
          }
          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            run_as_non_root            = true
            run_as_user                = 1000
          }
          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-dir"
          }
        }
        host_network         = true
        priority_class_name  = "system-cluster-critical"
        service_account_name = "metrics-server"
        volume {
          name = "tmp-dir"
          empty_dir {}
        }
      }

    }
  }
}

resource "kubernetes_api_service_v1" "metrics_server" {
  metadata {
    labels = local.labels
    name   = "v1beta1.metrics.k8s.io"
  }
  spec {
    group                    = "metrics.k8s.io"
    group_priority_minimum   = 100
    insecure_skip_tls_verify = true
    service {
      name      = kubernetes_service_v1.metrics_server.metadata[0].name
      namespace = kubernetes_service_v1.metrics_server.metadata[0].namespace
    }
    version          = "v1beta1"
    version_priority = 100
  }
}
