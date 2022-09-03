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
