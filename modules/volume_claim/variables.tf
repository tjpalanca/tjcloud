variable "name" {
  type        = string
  description = "Name for the deployment"
}

variable "namespace" {
  type        = string
  description = "Namespace onto which K8s resources will be deployed"
}

variable "size" {
  type        = number
  description = "Size in Gi"
}
