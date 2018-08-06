variable "secret_key" {
  type = "string"
  description = "The AWS secret key"
}


variable "key_path" {
  type = "string"
  description = "The ssh private key used in connections"
}

variable "ssh_user" {
  type = "string"
  description = "Username ssh connections"
  default = "ubuntu"
}

variable "access_key" {
  type = "string"
  description = "The AWS access key"
}

variable "ami" {
  type = "map"
  description = "The AMIs to use, based on region"
}

variable "instance_type" {
  type = "string"
  description = "The size of the instance"
}

variable "region" {
  type = "string"
  description = "Region"
}

variable "ssh_key_name" {
  type = "string"
  description = "Name of the keypair for ssh connections"
  default = "bbb"
}

variable "salt_master" {
  type = "string"
  description = "FQDN or IP address of the salt master"
}

variable "platformgrain" {
  type = "string"
  description = "Example of a grain being set in the newly created minion host"
}