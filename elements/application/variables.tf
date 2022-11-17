variable "name" {
  type        = string
  description = "Name for the deployment and service"
}

variable "namespace" {
  type        = string
  description = "Namespace onto which K8s resources will be deployed"
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
  description = "Either purely internal (ClusterIP) or external (NodePort)"
}

variable "ports" {
  type        = list(number)
  description = "Ports on the container"
}

variable "host_ports" {
  type = list(object({
    name           = string
    container_port = number
    host_port      = number
    protocol       = string
  }))
  default     = []
  description = "Ports on the host"
}

variable "node_name" {
  type        = string
  default     = null
  description = "Node on which to run the pod, use when setting volumes"
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Number of pods to run"
}

variable "image" {
  type        = string
  description = "Image reference"
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Environment variables for the image"
}

variable "volumes" {
  type = list(object({
    volume_name = string
    mount_path  = string
    host_path   = string
    mount_type  = string
  }))
  default     = []
  description = "Volumes to be mounted into the container"
}

variable "config_maps" {
  type = list(object({
    config_map_name = string
    mount_path      = string
    sub_path        = string
    read_only       = bool
  }))
  default     = []
  description = "Config Maps to be mounted into the container"
}

variable "command" {
  type        = list(string)
  default     = null
  description = "Command to run in the pod; same as entrypoint in Docker"
}

variable "command_args" {
  type        = list(string)
  default     = null
  description = "Args against the command; same as command in Docker"
}

variable "readiness_probes" {
  type = list(object({
    path = string
    port = number
  }))
  default     = []
  description = "HTTP endpoints as readiness probes"
}

variable "liveness_probes" {
  type = list(object({
    path = string
    port = number
  }))
  default     = []
  description = "HTTP endpoints as liveness probes"
}

variable "privileged" {
  type        = bool
  default     = false
  description = "Run the container in privileged mode"
}

variable "service_account_name" {
  type        = string
  default     = "default"
  description = "Service account to use for the pods"
}

variable "run_as" {
  type = object({
    run_as_user  = number
    run_as_group = number
    fs_group     = number
  })
  default = null
}

variable "restart_policy" {
  type    = string
  default = null
}

variable "cpu_limit" {
  type    = string
  default = null
}

variable "mem_limit" {
  type    = string
  default = null
}

variable "cpu_request" {
  type    = string
  default = null
}

variable "mem_request" {
  type    = string
  default = null
}

variable "timeout" {
  type        = string
  default     = "30m"
  description = "Timeout for creation and updating"
}
