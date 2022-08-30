variable "database" {
  type = object({
    username      = string
    password      = string
    internal_name = string
    internal_port = string
  })
}
