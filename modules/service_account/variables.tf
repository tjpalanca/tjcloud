variable "namespace" {
  type        = string
  description = "Namespace"
}

variable "name" {
  type        = string
  description = "Name of the service account"
}

variable "cluster_roles" {
  type        = set(string)
  default     = []
  description = "Cluster roles to attach"
}
