variable "database" {
  type = object({
    username   = string
    password   = string
    db_name    = string
    db_version = string
    storage    = string
  })
  description = "Database configuration"
}

variable "config" {
  type = object({
    name        = string
    namespace   = string
    environment = string
  })
  description = "General configuration"
}
