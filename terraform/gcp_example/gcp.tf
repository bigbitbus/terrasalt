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

provider "google" {
  credentials = "${file(var.json_account_file)}"
  project = "${var.project_name}"
  region = "${var.region}"
}

module "gcpvm1" {
  source = "gcp_module"
  image = "${var.image}"
  instance_type = "${var.instance_type}"
  zone = "${var.zone}"
  network_interface = "${var.network_interface}"
}


# The dependence variable ensures that gcpvm1 is completed before salt1 starts (implicit dependency detected by terraform)
module "salt1" {
  source = "../modules/tf_mod_salt"
  salt_master = "${var.salt_master}"
  minion_id = "gcp-${var.instance_type}"
  ssh_user = "${var.ssh_user}"
  key_path = "${var.key_path}"
  ip = "${module.gcpvm1.ip}"
  dependence = "${module.gcpvm1.ip}"
  grain_keys = "${var.grain_keys}"
  grain_vals = "${var.grain_vals}"
}
