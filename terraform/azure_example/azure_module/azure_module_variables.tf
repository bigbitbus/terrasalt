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

 variable "instance_type" {
  type        = "string"
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