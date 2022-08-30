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
