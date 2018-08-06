 variable "instance_type" {
  type        = "string"
  description = "The size of the instance"
}

 variable "ami" {
  type        = "string"
  description = "The AMIs to use, based on region"
}

variable "ssh_key_name" {
  type        = "string"
  description = "Name of the keypair for ssh connections"
}
variable "region" {
  type        = "string"
  description = "Region"
}
