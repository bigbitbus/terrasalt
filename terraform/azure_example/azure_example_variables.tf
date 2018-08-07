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

