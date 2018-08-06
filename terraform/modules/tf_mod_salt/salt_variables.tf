#   Copyright 2018 BigBitBus Inc. http://bigbitbus.com
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

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

variable "dependence" {
  type = "string"
  description = "special variable used to force implicit dependency"
}


variable "salt_master" {
  type = "string"
  description = "FQDN or IP address of the salt-master"
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

variable "platformgrain" {
  type        = "string"
  description = "An example of a static grain being set in the minion host"
}

