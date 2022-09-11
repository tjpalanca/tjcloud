terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
  }
}

locals {
  host_path = "/mnt/${var.config.volume_name}/clickhouse/${var.config.name}"
}

module "clickhouse_permissions" {
  source          = "../permissions"
  node_password   = var.config.node_password
  node_ip_address = var.config.node_ip_address
  node_path       = local.host_path
  uid             = 101
}

resource "kubernetes_config_map_v1" "clickhouse_config" {
  metadata {
    name      = "${var.config.name}-config"
    namespace = var.config.namespace
  }
  data = {
    "clickhouse-config.xml"      = file("${path.module}/clickhouse-config.xml")
    "clickhouse-user-config.xml" = file("${path.module}/clickhouse-user-config.xml")
  }
}

module "clickhouse_application" {
  source    = "../application"
  name      = var.config.name
  namespace = var.config.namespace
  ports     = [8123]
  node_name = var.config.node_name
  replicas  = 1
  image     = "yandex/clickhouse-server:${var.database.version}"
  env_vars = {
    CLICKHOUSE_DB       = var.database.name
    CLICKHOUSE_USER     = var.database.username
    CLICKHOUSE_PASSWORD = var.database.password
  }
  volumes = [{
    volume_name = "data"
    mount_path  = "/var/lib/clickhouse"
    host_path   = local.host_path
    mount_type  = "DirectoryOrCreate"
  }]
  config_maps = [
    {
      config_map_name = kubernetes_config_map_v1.clickhouse_config.metadata[0].name
      mount_path      = "/etc/clickhouse-server/config.d/logging.xml"
      sub_path        = "clickhouse-config.xml"
      read_only       = true
    },
    {
      config_map_name = kubernetes_config_map_v1.clickhouse_config.metadata[0].name
      mount_path      = "/etc/clickhouse-server/users.d/logging.xml"
      sub_path        = "clickhouse-user-config.xml"
      read_only       = true
    }
  ]
  restart_policy = "Always"
  readiness_probes = [{
    path                  = "/ping"
    port                  = 8123
    initial_delay_seconds = 20
    failure_threshold     = 6
    period_seconds        = 10
  }]
  liveness_probes = [{
    path                  = "/ping"
    port                  = 8123
    initial_delay_seconds = 30
    failure_threshold     = 3
    period_seconds        = 10
  }]
  run_as = {
    run_as_user  = 101
    run_as_group = 101
    fs_group     = 101
  }
  depends_on = [
    module.clickhouse_permissions
  ]
}
