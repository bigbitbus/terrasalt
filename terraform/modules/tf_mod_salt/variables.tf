variable "docker_minion" {
  type        = "string"
  description = "The docker container running the T_Client minion"
}

variable "key_path" {
  type        = "string"
  description = "The ssh private key file path used in connections"
}

variable "ssh_user" {
  type        = "string"
  description = "Username for the ssh connection; this is usually the username set in the image being booted up; check the image/cloud provider documentation"
}

variable "ip" {
  type = "string"
  description = "IP of the minion; this could be the private IP if the salt-master is reachable from the private network or it could be the public IP of the VM"
}

variable "minion_id" {
  type = "string"
  description = "This is the minion_id of the VM being created/salted"
}

variable "salt_bootstrap_options" {
  type = "string"
  description = "cli options for salt bootstrap when it installs salt: https://docs.saltstack.com/en/latest/topics/tutorials/salt_bootstrap.html"
  default = ""
}

variable "salt_master" {
  type = "string"
  description = "salt-master FQDN or IP address"
}

variable "saltapi_user" {
  type = "string"
  description = "the salt api user e.g. terrasalt mentioned in the documentation"
}

variable "saltapi_password" {
  type = "string"
  description = "the salt api user's password"
}

variable "platformgrain" {
  type        = "string"
  description = "Just an example of how a custom grain can be set"
  default = "Doesn't matter"
}
