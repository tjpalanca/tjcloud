variable "name" {
  type        = string
  description = "Name of the build"
}

variable "namespace" {
  type        = string
  default     = "default"
  description = "Namespace for the build"
}

variable "build_context" {
  type        = string
  description = "Local path to the build context"
}

variable "dockerfile_path" {
  type        = string
  default     = "Dockerfile"
  description = "Path to the dockerfile within the context"
}

variable "destination" {
  type        = string
  description = "Registry destination"
}

variable "registry" {
  type = object({
    server   = string
    username = string
    password = string
    email    = string
  })
  description = "Registry Server Credentials"
}

variable "root_password" {
  type = string
}

variable "node" {
  type = object({
    label      = string
    ip_address = string
  })
}
