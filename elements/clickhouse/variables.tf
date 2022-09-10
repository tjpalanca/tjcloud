variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "node_name" {
  type = string
}

variable "volume_name" {
  type = string
}

variable "database" {
  type = object({
    name     = string
    username = string
    password = string
  })
}

variable "node_password" {
  type = string
}

variable "node_ip_address" {
  type = string
}
