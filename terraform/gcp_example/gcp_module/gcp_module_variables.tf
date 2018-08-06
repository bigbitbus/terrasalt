 variable "instance_type" {
  type        = "string"
  description = "The size of the instance"
}

variable "zone" {
  type        = "string"
  description = "Zone where the VM is created"
}


variable "image" {
  type        = "string"
  description = "The OS image to use"
}