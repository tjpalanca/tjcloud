terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.17.1"
    }
  }
}

resource "postgresql_database" "plausible_postgres" {
  name = "plausible"
}

resource "kubernetes_namespace_v1" "plausible" {
  metadata {
    name = "plausible"
  }
}

module "plausible_clickhouse" {
  source      = "../../elements/clickhouse"
  name        = "plausible-events-db"
  namespace   = kubernetes_namespace_v1.plausible.metadata[0].name
  node_name   = var.node_name
  volume_name = var.volume_name
  database = {
    name     = "plausible"
    username = var.clickhouse.username
    password = var.clickhouse.password
  }
  node_ip_address = var.node_ip_address
  node_password   = var.node_password
}

# module "plausible_mail" {
#   source    = "../../elements/application"
#   name      = "plausible-smtp"
#   namespace = kubernetes_namespace_v1.plausible.metadata[0].name
#   ports     = [25]
#   image     = "bytemark/smtp:latest"

# }

# variable "env_vars" {
#   type        = map(string)
#   default     = {}
#   description = "Environment variables for the image"
# }

# variable "volumes" {
#   type = list(object({
#     volume_name = string
#     mount_path  = string
#     host_path   = string
#     mount_type  = string
#   }))
#   default     = []
#   description = "Volumes to be mounted into the container"
# }

# variable "config_maps" {
#   type = list(object({
#     config_map_name = string
#     mount_path      = string
#     sub_path        = string
#     read_only       = bool
#   }))
#   default     = []
#   description = "Config Maps to be mounted into the container"
# }

# variable "command" {
#   type        = list(string)
#   default     = null
#   description = "Command to run in the pod; same as entrypoint in Docker"
# }

# variable "command_args" {
#   type        = list(string)
#   default     = null
#   description = "Args against the command; same as command in Docker"
# }

# variable "readiness_probes" {
#   type = list(object({
#     path = string
#     port = number
#   }))
#   default     = []
#   description = "HTTP endpoints as readiness probes"
# }

# variable "liveness_probes" {
#   type = list(object({
#     path = string
#     port = number
#   }))
#   default     = []
#   description = "HTTP endpoints as liveness probes"
# }

# variable "privileged" {
#   type        = bool
#   default     = false
#   description = "Run the container in privileged mode"
# }

# variable "service_account_name" {
#   type        = string
#   default     = "default"
#   description = "Service account to use for the pods"
# }

# variable "run_as" {
#   type = object({
#     run_as_user  = number
#     run_as_group = number
#     fs_group     = number
#   })
#   default = {
#     run_as_user  = null
#     run_as_group = null
#     fs_group     = null
#   }
# }

# variable "restart_policy" {
#   type    = string
#   default = null
# }
