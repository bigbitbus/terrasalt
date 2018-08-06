provider "google" {
  credentials = "${file(var.json_account_file)}"
  project     = "${var.project_name}"
  region      = "${var.region}"
}

module "gcpvm1" {
  source = "gcp_module"
  image = "${var.image}"
  instance_type = "${var.instance_type}"
  zone = "${var.zone}"
}


# The dependence variable ensures that gcpvm1 is completed before salt1 starts (implicit dependency detected by terraform)
module "salt1" {
  source = "../modules/tf_mod_salt"
  salt_master = "${var.salt_master}"
  minion_id = "${var.platformgrain}-${var.instance_type}"
  ssh_user = "${var.ssh_user}"
  key_path = "${var.key_path}"
  ip = "${module.gcpvm1.ip}"
  dependence = "${module.gcpvm1.ip}"
  platformgrain = "${var.platformgrain}"
}
