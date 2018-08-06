provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  tenant_id = "${var.tenant_id}"
  client_secret = "${var.client_secret}"
}

module "azurevm1" {
  source = "./azure_module"
  instance_type = "${var.instance_type}"
  ssh_user = "${var.ssh_user}"
  key_data = "${var.key_data}"
  region = "${var.region}"

}

# The dependence variable ensures that azurevm1 is completed before salt1 starts (implicit dependency detected by terraform)
module "salt1" {
  source = "../modules/tf_mod_salt"
  salt_master = "${var.salt_master}"
  minion_id = "${var.platformgrain}-${var.instance_type}"
  ssh_user = "${var.ssh_user}"
  key_path = "${var.key_path}"
  ip = "${module.azurevm1.ip}"
  dependence = "${module.azurevm1.machineid}"
  platformgrain = "${var.platformgrain}"
}
