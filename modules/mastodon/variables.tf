variable "cloudflare_zone_id" {
  type = string
}

variable "cloudflare_zone_name" {
  type = string
}

variable "main_cloudflare_zone_id" {
  type = string
}

variable "main_cloudflare_zone_name" {
  type = string
}

variable "secret_key_base" {
  type = string
}

variable "otp_secret" {
  type = string
}

variable "vapid_private_key" {
  type = string
}

variable "vapid_public_key" {
  type = string
}

variable "smtp_server" {
  type = string
}

variable "smtp_port" {
  type = number
}

variable "postgres_host" {
  type = string
}

variable "postgres_user" {
  type = string
}

variable "postgres_pass" {
  type = string
}

variable "postgres_port" {
  type = number
}

variable "redis_host" {
  type = string
}

variable "redis_port" {
  type = number
}

variable "volume_name" {
  type = string
}

variable "node_name" {
  type = string
}

variable "node_ip" {
  type = string
}

variable "node_password" {
  type = string
}

variable "mastodon_version" {
  type = string
}

variable "skip_post_deployment" {
  type    = bool
  default = false
}

variable "s3_bucket" {}

variable "s3_access_key" {
  type = string
}

variable "s3_secret_key" {
  type = string
}
