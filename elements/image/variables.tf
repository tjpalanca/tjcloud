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

variable "image_address" {
  type        = string
  description = "Registry address for the image"
}

variable "image_version" {
  type        = string
  description = "Registry version for the image"
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

variable "node_password" {
  type = string
}

variable "node" {
  type = object({
    label      = string
    ip_address = string
  })
}

variable "post_copy_commands" {
  type    = list(string)
  default = [""]
}
