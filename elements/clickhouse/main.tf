terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
  }
}

locals {
  host_path = "/mnt/${var.volume_name}/clickhouse/${var.name}"
}

resource "null_resource" "clickhouse_permissions" {
  connection {
    type     = "ssh"
    user     = "root"
    password = var.node_password
    host     = var.node_ip_address
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.host_path}",
      "chown -R 1000:1000 ${local.host_path}"
    ]
  }
}

resource "kubernetes_config_map_v1" "clickhouse_config" {
  metadata {
    name      = "${var.name}-config"
    namespace = var.namespace
  }
  data = {
    "clickhouse-config.xml"      = <<EOF
      <yandex>
          <logger>
              <level>warning</level>
              <console>true</console>
          </logger>
          <!-- Stop all the unnecessary logging -->
          <query_thread_log remove="remove"/>
          <query_log remove="remove"/>
          <text_log remove="remove"/>
          <trace_log remove="remove"/>
          <metric_log remove="remove"/>
          <asynchronous_metric_log remove="remove"/>
      </yandex>
    EOF
    "clickhouse-user-config.xml" = <<EOF
      <yandex>
        <profiles>
            <default>
                <log_queries>0</log_queries>
                <log_query_threads>0</log_query_threads>
            </default>
        </profiles>
      </yandex>
    EOF
  }
}

module "clickhouse_application" {
  source    = "../application"
  name      = var.name
  namespace = var.namespace
  ports     = [8123]
  node_name = var.node_name
  replicas  = 1
  image     = "yandex/clickhouse-server:latest"
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
}
