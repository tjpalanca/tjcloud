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
