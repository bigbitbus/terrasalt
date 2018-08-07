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

resource "google_compute_instance" "_gcp_vm" {
  name = "gcp-${var.instance_type}"
  machine_type = "${var.instance_type}"
  zone = "${var.zone}"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    network = "${var.network_interface}"

    access_config {
      # ephemeral external ip address
    }
  }
}

output "ip" {
  value = "${google_compute_instance._gcp_vm.network_interface.0.access_config.0.assigned_nat_ip}"
}