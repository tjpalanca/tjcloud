variable "service" {
  type = object({
    name      = string
    port      = number
    namespace = string
  })
  description = "Details of the service proxied"
}

variable "name" {
  type        = string
  default     = null
  description = "Name of the ingress"
}

variable "host" {
  type        = string
  default     = null
  description = "Host name to respond to"
}

variable "zone_id" {
  type        = string
  description = "Cloudflare zone ID"
}

variable "zone_name" {
  type        = string
  description = "Cloudflare zone name"
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

variable "authenticated_origin_pull" {
  type        = bool
  default     = true
  description = "Whether or not to verify the client certificate"
}

variable "add_record" {
  type        = bool
  default     = true
  description = "Whether or not to add a Cloudflare record"
}
