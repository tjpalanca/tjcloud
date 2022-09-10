variable "node_name" {
  type = string
}

variable "volume_name" {
  type = string
}

variable "clickhouse" {
  type = object({
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
