variable "user_name" {
  type        = string
  description = "Linux username"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token"
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare Account ID"
}

variable "cloudflare_origin_ca_key" {
  type        = string
  description = "For Origin Certificates"
}

variable "dev_zone_id" {
  type        = string
  description = "Development Zone ID"
}

variable "dev_zone_name" {
  type        = string
  description = "Development TLD"
}

variable "com_zone_id" {
  type        = string
  description = "Public Zone ID"
}

variable "com_zone_name" {
  type        = string
  description = "Public TLD"
}

variable "code_font" {
  type        = string
  default     = "JuliaMono"
  description = "Font Family for code"
}

variable "body_font" {
  type        = string
  default     = "IBMPlexSans"
  description = "Font Family for body"
}

variable "extensions_gallery_json" {
  type        = string
  description = "Extensions gallery APIs"
}

variable "r2_access_key" {
  type        = string
  description = "Cloudflare R2 access key"
}

variable "r2_secret_key" {
  type        = string
  description = "Cloudflare R2 secret key"
}
