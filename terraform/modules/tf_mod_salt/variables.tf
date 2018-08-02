variable "platformgrain" {
  type        = "string"
  description = "The name of the platform - aws/gce/don/aze etc."
}
variable "docker_minion" {
  type        = "string"
  description = "The docker container running the T_Client minion"
}


variable "key_path" {
  type        = "string"
  description = "The ssh private key used in connections"
}

variable "ssh_user" {
  type        = "string"
  description = "Username ssh connections"
  default = "ubuntu"
}

variable "public_ip" {
  type = "string"
  description = "Public IP of the minion"
}

variable "minion_id" {
  type = "string"
  description = "This is the minion_id of the VM being created/salted"
}

variable "salt_master" {
  type = "string"
  description = "salt-master to connect to"
}