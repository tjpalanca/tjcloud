variable "name" {
  type        = string
  description = "name of the access application"
}

variable "zone_id" {
  type        = string
  description = "cloudflare zone id to protect"
}

variable "domain" {
  type        = string
  description = "domains and/or paths to protect"
}

variable "allowed_groups" {
  type        = list(string)
  description = "allowed groups"
}
