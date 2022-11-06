variable "name" {
  type        = string
  description = "Name for the deployment and service"
}

variable "namespace" {
  type        = string
  description = "Namespace onto which K8s resources will be deployed"
}

variable "timeout" {
  type        = string
  default     = "30m"
  description = "Timeout for creation and updating"
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Number of pods to run"
}

variable "restart_policy" {
  type    = string
  default = null
}

variable "service_account_name" {
  type        = string
  default     = "default"
  description = "Service account to use for the pods"
}

variable "node_name" {
  type        = string
  default     = null
  description = "Node on which to run the pod, use when setting volumes"
}

variable "image" {
  type        = string
  description = "Image reference"
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

variable "ports" {
  type        = list(number)
  default     = []
  description = "Ports on the container"
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Environment variables for the image"
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

variable "liveness_probes" {
  type = list(object({
    path = string
    port = number
  }))
  default     = []
  description = "HTTP endpoints as liveness probes"
}

variable "readiness_probes" {
  type = list(object({
    path = string
    port = number
  }))
  default     = []
  description = "HTTP endpoints as readiness probes"
}

variable "privileged" {
  type        = bool
  default     = false
  description = "Run the container in privileged mode"
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

variable "run_as" {
  type = object({
    run_as_user  = number
    run_as_group = number
    fs_group     = number
  })
  default = null
}