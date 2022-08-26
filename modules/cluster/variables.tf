variable "cluster_name" {
  type = string
}

variable "main_cloudflare_zone" {
  type = string
}

variable "do_region" {
  type = string
}

variable "production" {
  type = object({
    node_count  = number
    volume_size = number
  })
}

variable "development" {
  type = object({
    node_count  = number
    volume_size = number
  })
}
