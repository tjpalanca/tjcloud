variable "name" {
  type        = string
  description = "Name of the PersistentVolume and PersistentVolumeClaim"
}

variable "size" {
  type        = string
  description = "Size of the PersistentVolume and PersistentVolumeClaim"
}

variable "node_name" {
  type        = string
  description = "Name of the node that local volume is attached"
}

variable "node_path" {
  type        = string
  description = "Path inside the node where local volume is attached, including the subpath for shared volumes"
}

variable "storage_class_name" {
  type        = string
  description = "Storage class used for the volume"
}
