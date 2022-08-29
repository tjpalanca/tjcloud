variable "database" {
  type = object({
    username = string
    password = string
    name     = string
    version  = string
  })
  description = "Database configuration"
}

variable "config" {
  type = object({
    name               = string
    namespace          = string
    volume_name        = string
    node_name          = string
    storage_size       = string
    storage_class_name = string
  })
  description = "General configuration"
}
