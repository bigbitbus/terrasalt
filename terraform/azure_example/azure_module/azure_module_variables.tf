 variable "instance_type" {
  type        = "string"
  description = "The size of the instance"
}

variable "ssh_user" {
  type        = "string"
  description = "Username ssh connections"
}

variable "key_data" {
  type        = "string"
  description = "Public key of the ssh_user"
}


variable "region" {
  type        = "string"
  description = "Region to spin up infrastructure in"
}
