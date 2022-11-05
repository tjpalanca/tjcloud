variable "name" {
  type        = string
  description = "Name of the redis application"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace to deploy the redis isntance"
}

variable "node_name" {
  type        = string
  description = "Node name in which to deploy the redis instance"
}

variable "volume_name" {
  type        = string
  description = "Mounted volume name to use for the redis instance"
}

variable "version" {
  type        = string
  default     = "latest"
  description = "version of redis to deploy"
}

variable "save_frequency" {
  type        = number
  default     = 60
  description = "number of seconds between each save"
}

variable "min_writes_for_save" {
  type        = number
  default     = 1
  description = "number of writes needed in order to trigger a save"
}
