variable "name" {
  type        = string
  description = "Name for the deployment"
}

variable "namespace" {
  type        = string
  description = "Namespace onto which K8s resources will be deployed"
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

variable "command" {
  type        = list(string)
  default     = null
  description = "Command to run in the pod; same as entrypoint in Docker"
}

variable "args" {
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

variable "service_account_name" {
  type        = string
  default     = null
  description = "Service account for the pods"
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

variable "cpu_limit" {
  type        = string
  default     = null
  description = "Maximum CPU allowed"
}

variable "mem_limit" {
  type        = string
  default     = null
  description = "Maximum memory allowed"
}

variable "cpu_request" {
  type        = string
  default     = null
  description = "Minimum CPU required"
}

variable "mem_request" {
  type        = string
  default     = null
  description = "Minimum memory required"
}

variable "create_timeout" {
  type        = string
  default     = "5m"
  description = "Timeout for creation"
}

variable "update_timeout" {
  type        = string
  default     = "5m"
  description = "Timeout for updating"
}
