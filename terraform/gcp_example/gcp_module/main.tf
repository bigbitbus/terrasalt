
resource "google_compute_instance" "_gcp_vm" {
  name = "my-gcp-vm"
  machine_type = "${var.instance_type}"
  zone = "${var.zone}"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # ephemeral external ip address
    }
  }
}

output "ip" {
  value = "${google_compute_instance._gcp_vm.network_interface.0.access_config.0.assigned_nat_ip}"
}