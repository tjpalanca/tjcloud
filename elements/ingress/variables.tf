variable "name" {
  type        = string
  description = "Name of the ingress"
}

variable "host" {
  type        = string
  description = "Host name to respond to"
}

variable "zone" {
  type        = string
  description = "Cloudflare zone, also the TLD"
}

variable "path" {
  type        = string
  default     = "/"
  description = "Subpath to serve the ingress at"
}

variable "service" {
  type = object({
    name      = string
    port      = number
    namespace = string
  })
  description = "Details of the service proxied"
}

variable "ingress_class_name" {
  type        = string
  default     = "nginx"
  description = "Class of the ingress to be provisioned"
}

variable "tls_secret_name" {
  type        = string
  default     = null
  description = "Kubernetes secret holding the TLS certificate"
}

variable "annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations to the ingress"
}
