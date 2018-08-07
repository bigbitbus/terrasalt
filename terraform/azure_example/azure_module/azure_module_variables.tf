variable "instance_type" {
  type = "string"
  description = "The size of the instance"
}

variable "ssh_user" {
  type = "string"
  description = "Username ssh connections"
}

variable "key_data" {
  type = "string"
  description = "Public key of the ssh_user"
}


variable "region" {
  type = "string"
  description = "Region to spin up infrastructure in"
}

variable "resource_group_name" {
  type = "string"
  description = "Name of the resource group"
}

variable "security_group_id" {
  type = "string"
  description = "ID of the security group"
}

variable "subnet_id" {
  type = "string"
  description = "ID of the subnet where the NIC is created"
}