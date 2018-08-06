You will need to set values for these environment variables on your terraform shell window to make this example work.
```bash
#From azure account
export TF_VAR_subscription_id=qwert-qweqweasdfdf-sdfsdf-xcvb-sdfgsdfs
export TF_VAR_client_id=123456-qwertr-34ew-2323-656
export TF_VAR_tenant_id=qqqqq-wwww-eeeee-rrrrr-sssss
export TF_VAR_client_secret=aaaaa-bbbb-ccccc-ddddd-eeeee

#Other stuff
export TF_VAR_key_path="/local/path/to/private/ssh/key/ e.g. id_rsa path"
export TF_VAR_ssh_user="azureuser" #User inside the VM being spun up
export TF_VAR_key_data="ssh public key data e.g. contents of id_rsa.pub"

export TF_VAR_salt_master=my.saltmaster.com #salt master fqdn or IP
export SALTAPI_PORT= 8000 #whatever you set this to in the saltapi configuration
export SALTAPI_USERNAME=terrasalt #salt api username
export SALTAPI_PASSWORD=saltterra #salt api password
export SALTAPI_EAUTH=pam # or whatever your salt master is setup for  e.g. ldap
export SALTAPI_SSL_VERIFY=False # or import the saltapi ssl cert
export SALTAPI_PROTO=HTTPS #recommend not using HTTP since your saltapi
# credentials will be in the clear text if you use HTTP.

```