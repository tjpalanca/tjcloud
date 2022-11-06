variable "cloudflare_origin_ca" {
  type = object({
    private_key  = string
    common_name  = string
    organization = string
  })
}

variable "cloudflare_zone_name" {
  type = string
}

variable "server_snippets" {
  type    = list(string)
  default = []
}
