variable "namespace" {
  type        = string
  description = "Namespace"
}

variable "name" {
  type        = string
  description = "Name of the service account"
}

variable "deployment" {
  type        = string
  description = "Name of the deployment targeted"
}

variable "ports" {
  type        = list(number)
  description = "List of ports to expose"
}
