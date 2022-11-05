terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

module "redis" {
  source       = "../application"
  name         = var.name
  namespace    = var.namespace
  service_type = "ClusterIP"
  ports        = 6379
  node_name    = var.node_name
  replicas     = 1
  image        = "redis:${var.redis_version}"
  command = [
    "redis-server",
    "--save", tostring(var.save_frequency), tostring(var.min_writes_for_save),
    "--loglevel", "warning"
  ]
  volumes = [{
    volume_name = var.name
    mount_path  = "/data"
    host_path   = "/mnt/${var.volume_name}/redis/${var.name}"
    mount_type  = "DirectoryOrCreate"
  }]
}
