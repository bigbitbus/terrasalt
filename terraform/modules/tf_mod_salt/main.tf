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

resource "null_resource" "install_configure_salt" {
  connection {
    user = "${var.ssh_user}"
    private_key = "${file(var.key_path)}"
    host = "${var.ip}"
  }

  provisioner "file" {
    source = "${path.module}/files/installsaltminion.sh"
    destination = "/tmp/installsaltminion.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installsaltminion.sh",
      "sudo /tmp/installsaltminion.sh ${var.salt_master} ${var.minion_id}",
    ]
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command = "python ${path.module}/files/httpsrequests.py  ${var.minion_id} key.accept"
  }

  provisioner "local-exec" {
    command = "python ${path.module}/files/httpsrequests.py  ${var.minion_id} key.delete"
    when = "destroy"
  }

  #Dummy command to force use of dependence variable
  provisioner "local-exec" {
    command = "echo ${var.dependence} > /dev/null"
  }
}

resource "null_resource" "set_grains" {
  connection {
    user = "${var.ssh_user}"
    private_key = "${file(var.key_path)}"
    host = "${var.ip}"
  }

  count = "${length(var.grain_keys)}"
  provisioner "remote-exec" {
    inline = [
      "sudo salt-call grains.set ${element(var.grain_keys, count.index )} ${element(var.grain_vals, count.index )}"
    ]
    on_failure = "continue"
  }
  depends_on = [
    "null_resource.install_configure_salt"]
}
