variable "database" {
  type = object({
    name     = string
    username = string
    password = string
    version  = string
  })
}

variable "config" {
  type = object({
    name            = string
    namespace       = string
    node_name       = string
    volume_name     = string
    node_ip_address = string
    node_password   = string
  })
}
