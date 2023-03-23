variable "subdomain" {
  type        = string
  description = "Subdomain"
}

variable "zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "zone_name" {
  type        = string
  description = "Cloudflare Zone Name"
}

variable "cname_zone_name" {
  type        = string
  default     = null
  description = "Cloudflare Zone Name"
}

variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "service_namespace" {
  type        = string
  description = "Namespace of the service"
}

variable "service_port" {
  type        = number
  description = "Port of the service"
}

variable "annotations" {
  type        = map(string)
  description = "Additional annotations on the ingress"
}
