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
    name      = string
    namespace = string
  })
  description = "General configuration"
}

variable "pvc_volume_name" {
  type        = string
  description = "Volume name for the persistent volume claim"
}
