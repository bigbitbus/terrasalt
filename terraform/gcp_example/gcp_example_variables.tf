variable "json_account_file" {
  type        = "string"
  description = "Google account credentials json file"
}

variable "project_name" {
  type        = "string"
  description = "Google project name"
}

variable "region" {
  type        = "string"
  description = "Region to spin up infrastructure in"
}

variable "zone" {
  type        = "string"
  description = "Zone to spin up infrastructure in"
}

variable "instance_type" {
  type = "string"
  description = "The size of the instance"
}

variable "image" {
  type        = "string"
  description = "The OS image to use"
}

variable "ssh_user" {
  type        = "string"
  description = "ssh connection username"
}

variable "key_path" {
  type        = "string"
  description = "The ssh private key used in connections"
}

variable "salt_master" {
  type = "string"
  description = "FQDN or IP address of the salt master"
}

variable "platformgrain" {
  type = "string"
  description = "Example of a grain being set in the newly created minion host"
}