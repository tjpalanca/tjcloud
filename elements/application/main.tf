terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

resource "kubernetes_service_v1" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    type = var.service_type
    selector = {
      app = var.name
    }
    dynamic "port" {
      for_each = var.ports
      content {
        name        = "port-${port.value}"
        port        = port.value
        target_port = port.value
      }
    }
  }
}

module "deployment" {
  source               = "../../elements/deployment"
  name                 = var.name
  namespace            = var.namespace
  timeout              = var.timeout
  replicas             = var.replicas
  restart_policy       = var.restart_policy
  service_account_name = var.service_account_name
  node_name            = var.node_name
  image                = var.image
  command              = var.command
  command_args         = var.command_args
  ports                = var.ports
  env_vars             = var.env_vars
  config_maps          = var.config_maps
  liveness_probes      = var.liveness_probes
  readiness_probes     = var.readiness_probes
  privileged           = var.privileged
  cpu_limit            = var.cpu_limit
  mem_limit            = var.mem_limit
  cpu_request          = var.cpu_request
  mem_request          = var.mem_request
  volumes              = var.volumes
  run_as               = var.run_as
}
