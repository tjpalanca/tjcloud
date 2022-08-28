variable "name" {
  type        = string
  description = "Name fo the PersistentVolume and PersistentVolumeClaim"
}

variable "size" {
  type        = string
  description = "Size of the volumes"
}

variable "path" {
  type        = string
  description = "Path inside the node that local volume is attached"
}

variable "node" {
  type        = string
  description = "ID of the node to which the volume is attached"
}
