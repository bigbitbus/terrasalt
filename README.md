# Terrasalt

Terrasalt (Terraform + Salt) helps integrate [Hashicorp's Terraform](https://www.terraform.io/) cloud orchestration with [Salt](https://saltstack.com/) configuration management. This helps create infrastructure (e.g. virtual machines) using Terraform and then configure and management them using Salt.

The inspiration for this project came when we switched from using [Salt cloud](https://docs.saltstack.com/en/latest/topics/cloud/) to Terraform; we missed the close integration between the orchestration (Terraform) and configuration management pieces (Salt) that salt cloud earlier provided out of the box. For example, we wanted a newly spun up VM to install salt minion software and then to automatically register with our salt-master. We also wanted the VM to be de-registered from the salt-master when it was terminated.

## Getting Started

### Pre-requisites

#### Stuff to know

Before proceeding further we assume you know the basics of Terraform and Salt. You can brush-up your knowledge via these links
 * [Terraform Introduction](https://www.terraform.io/intro/index.html)
 * [Terraform Modules](https://www.terraform.io/docs/modules/index.html)
 * [Salt Documentation](https://docs.saltstack.com/en/latest/), in particular look at 
   * [Installing salt](https://docs.saltstack.com/en/latest/topics/installation/index.html)
   * [Event driven infrastructure](https://docs.saltstack.com/en/getstarted/event/)
   
You will be adding the Terrasalt module to your terraform infrastructure-as-code scripts and then connecting the VM(s) terraform creates to your pre-existing salt-master. Custom saltstack events will be used for signalling your salt-master about Terraform actions (creation and destruction of VM(s)). If the last couple of sentences sounded alien to you then we recommend  you go through some of the material mentioned above.

#### Stack and Assumptions

1. The terraform client machine (the computer that runs the terraform cli) that is capable of running a docker container.
2. A configured salt-master capable of being connected from the new VMs that terraform spins up.

### Architecture

Our aim is to add terraform-created VMs to a salt master as a salt minion. This means
1. Install salt minion software on a terraform newly created VM.
2. Configure the salt minion VM to try to connect to a specified salt-master
3. Tell the salt master to accept the key of the salt minion VM, so that you don't have to manually accept it's key on the salt-master
4. Tell the salt master when terraform destroys the salt minion VM, so that it's key can be removed from the list of accepted minion keys on the salt master.

Fig. 1 shows the architecture of how this will be achieved.

1. The terraform client machine will run a salt minion in a docker container that will be connected to the salt-master. The docker container is recommended in order to isolate the terraform client machine from the salt master.  
2. The terraform client salt minion will be used to insert events into the salt messaging bus that the salt master can


      
### Usage


### Examples



## FAQs


## Authors

* **Sachin Agarwal** - *Initial work* - [BitBitBus](http://bigbitbus.com)

### Contributors
 * Your-name-here
 
## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details