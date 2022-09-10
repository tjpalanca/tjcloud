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
