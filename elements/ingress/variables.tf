variable "service" {
  type = object({
    name      = string
    port      = number
    namespace = string
  })
  description = "Details of the service proxied"
}

variable "host" {
  type        = string
  default     = null
  description = "Host name to respond to"
}

variable "zone" {
  type        = string
  description = "Cloudflare zone, also the TLD"
}

variable "cname" {
  type        = string
  default     = null
  description = "CNAME value for cloudflare record, in case it is different from zone"
}

variable "path" {
  type        = string
  default     = "/"
  description = "Subpath to serve the ingress at"
}

variable "ingress_class_name" {
  type        = string
  default     = "nginx"
  description = "Class of the ingress to be provisioned"
}

variable "annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations to the ingress"
}
