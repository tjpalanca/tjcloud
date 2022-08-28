variable "database" {
  type = object({
    username   = string
    password   = string
    db_name    = string
    db_version = string
  })
  description = "Database configuration"
}

variable "config" {
  type = object({
    name      = string
    namespace = string
    node      = string
    storage   = string
  })
  description = "General configuration"
}
