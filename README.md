# Terrasalt

Terrasalt (Terraform + Salt) integrates [Hashicorp's Terraform](https://www.terraform.io/) cloud orchestration with [Salt](https://saltstack.com/) configuration management. This enables us to create infrastructure (e.g. virtual machines) using Terraform and then configure and manage the infrastructure via Salt.

The inspiration for this project came when we switched from using [Salt cloud](https://docs.saltstack.com/en/latest/topics/cloud/) to Terraform; we missed the close integration between the orchestration (Terraform) and configuration management pieces (Salt) that salt cloud provided out of the box. For example, we wanted a newly spun up VM to install salt minion software and then to automatically register with our salt-master. We also wanted the VM to be de-registered from the salt-master when it was terminated.

## Getting Started


### Pre-requisites

Before proceeding further we assume you know the basics of Terraform and Salt. You can brush-up your knowledge via these links
 * [Terraform Introduction](https://www.terraform.io/intro/index.html)
 * [Terraform Modules](https://www.terraform.io/docs/modules/index.html)
 * [Salt Documentation](https://docs.saltstack.com/en/latest/), in particular look at 
   * [Installing salt](https://docs.saltstack.com/en/latest/topics/installation/index.html)
   
You will be adding the Terrasalt module to your terraform infrastructure-as-code scripts and then connecting the VM(s) that terraform creates to your pre-existing salt-master. 

### Stack and Assumptions

1. A configured salt-master capable of being connected from the new VMs that terraform spins up and capable of running salt API.
2. Ability for the terraform machine to send an HTTP(s) request to the salt-master (any firewall issues to allow connecting from the Terraform machine to the salt-master via HTTPS on port 443).
3. Python is installed on the terraform machine. Also, please install the requests python package.
```
# In the shell you use to run terraform commands run

# *nix
python -m pip install requests

# Windows
python.exe -m pip install requests
```

### Architecture

Our aim is to add terraform-created VMs as minions of our  salt-master. For this the terraform machine needs to 
1. Install salt minion software on a terraform newly created VM.
2. Configure the salt minion VM to try to send its minion key to the salt-master.
3. Tell the salt-master to accept the key of the salt minion VM, so that you don't have to manually go to the salt-master to accept the minion key of the newly created VM.
4. Tell the salt-master when terraform destroys the salt minion VM, so that it's key can be removed from the list of accepted minion keys.

![Fig. 1: Timing Diagram](./docs/terrasalt.png]
Fig. 1 shows the timing diagram of a VM lifecycle. The important phases are marked with numbers 1..6 in the figure:

1. The terraform user calls `terraform apply` to create a VM and make it a minion; all configuration is within the terraform code being executed. The cloud provider boots up the VM, brings up the OS, installs salt minion software and signals the terraform client that the VM is ready. 
2.  The new VM sends its minion key to the salt-master; the salt-master will only accept the key when it gets a API request from the terraform machine or when the user manually accepts the key using the `salt-key -a <minion_id>` command on the saltmaster.
3. The terraform machine sends an (authenticated) API request to the salt-master to accept the minion key of the newly spun up VM. The salt-master accepts the minion key and 
4. The virtual machine is ready to be managed by the salt-master (e.g. run highstate, remote execution commands etc.)

   If the user wishes to terminate the VM then:
5. The user enters the `terraform destroy` command; the terraform machine sends a salt API HTTPS request to the salt-master to remove the VM from its list of accepted minoions.
6. Terraform completes the termination of the VM. 
   
### Usage

#### Configuring the salt-master for  salt-api

We need to install the [salt-api](https://docs.saltstack.com/en/latest/ref/netapi/all/salt.netapi.rest_cherrypy.html) server into the salt-master and setup a "terrasalt" user whose credentials can be used to authenticate requests being sent to the salt-api server running on the salt-master. We have included a simple script along with descriptions of each command below. Use the script as a starting point and adapt it to your setup.

```bash
#!/bin/bash

#Usage: terrasalt_configure_salt-master.sh <https port> <terrasalt_user_password>
# e.g. (as root user)
# ./terrasalt_configure_salt-master.sh 443 sUp3r53cr3T

# Install cherrypy and salt-api (former necessary for ubuntu 1604); 
# assuming that the salt-master is also a salt-minion
salt-call pip.install cherrypy 
salt-call pkg.install salt-api

# Generate certificate for HTTPS, assuming salt-master is also a salt-minion
salt-call tls.create_self_signed_cert

# Write out saltapi configuration 
cat <<EOF > /etc/salt/master.d/saltapi_terrasalt.conf
rest_cherrypy:
  port: $2
  ssl_crt: /etc/pki/tls/certs/localhost.crt
  ssl_key: /etc/pki/tls/certs/localhost.key

external_auth:
  pam:
    terrasalt:
      - '@wheel'
EOF

# Create a non-shell/non-homedir restricted terrasalt user
useradd -M terrasalt --shell /bin/false
usermod --password $1 terrasalt

# Restart salt-master to apply changes
service salt-master restart

# Restart the salt-api 
service salt-api restart
```

If everything goes well then you can test the setup from your terraform machine. curl the following commands to check if the outputs are similar to the ones pasted below:

```bash
$.curl -ski https://saltmaster.com:$1/login \
 -H 'Accept: application/json' \
 -d username='terrasalt' \
 -d password='sUp3r53cr3T' \
 -d eauth='pam' \
 | python -m json.tool
```
Piping the output to the python json tool is optional; it pretty prints the json output. 
```json
{
  "return": [
    {
      "perms": [
        "@wheel"
      ],
      "start": 153327418.78768,
      "token": "408f5b43b4ac36a5c5ffa6e1502027000528",
      "expire": 153290618.787681,
      "user": "terrasalt",
      "eauth": "pam"
    }
  ]
}

```
If you instead see an error, consider these potential issues:
1. Is there a firewall blocking the saltapi port.
2. Has the salt-api server successfully started (check the process and the logs at `/var/log/salt/api` on the salt-master).
3. Have you entered the salt-api URL, username and password correctly?
4. Check the SSL configuration; as well as check if salt-api was previously configured with different settings in the `/etc/salt` configuration files.



The token can now be used to access salt-api (the terrasalt user is limited to salt wheel commands as per our salt-master configuration above). For example:
```bash
# Note - we are asking curl to ignore self-issued SSL certificates; a better way would be to add the self-issued SSL certificate to our terraform machine. 
$.curl -k  https://saltmaster.com:8000/ \
 -H "Accept: application/json" 
 -H "X-Auth-Token: 408f5b43b4ac36a5c5ffa6e1502027000528"   
 -d client='wheel' 
 -d fun='key.list_all' \
  | python -m json.tool
```
Returned data:
```json
{
  "return": [
    {
      "tag": "salt/wheel/201808020425106733",
      "data": {
        "jid": "201808022204206733",
        "return": {
          "local": [
            "master.pem",
            "master.pub"
          ],
          "minions_rejected": [],
          "minions_denied": [],
          "minions_pre": [],
          "minions": [
            "salt-master",
            "some-other-minion"
          ]
        },
        "success": true,
        "_stamp": "2018-08-02T22:04:25.120663",
        "tag": "salt/wheel/201808022204256733",
        "user": "terrasalt",
        "fun": "wheel.key.list_all"
      }
    }
  ]
}

```

#### The Terrasalt module






## FAQs


## Authors

* **Sachin Agarwal** - *Initial work* - [BitBitBus](http://bigbitbus.com)

### Contributors
 * Your-name-here
 
## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details