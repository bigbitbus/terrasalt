variable "subscription_id" {
  type        = "string"
  description = "The azure subscription id"
}

variable "client_id" {
  type        = "string"
  description = "The azure client id (appid)"
}

variable "tenant_id" {
  type        = "string"
  description = "The azure tenant id"
}

variable "client_secret" {
  type        = "string"
  description = "The azure client secret (password)"
}

variable "region" {
  type        = "string"
  description = "Region to spin up infrastructure in"
}

variable "instance_type" {
  type = "string"
  description = "The size of the instance"
}

variable "ssh_user" {
  type        = "string"
  description = "Username ssh connections"
}

variable "key_data" {
  type        = "string"
  description = "public key of the ssh user"
}

variable "key_path" {
  type = "string"
  description = "The ssh private key used in connections"
}

variable "salt_master" {
  type = "string"
  description = "FQDN or IP address of the salt master"
}

variable "platformgrain" {
  type        = "string"
  description = "The name of the platform - aws/gce/don/aze etc."
}
