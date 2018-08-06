You will need to set values for these environment variables on your terraform shell window to make this example work.
```bash
#From azure account
export TF_VAR_json_account_file="/gcp/credentials/gcp_service_account.json"
export TF_VAR_project_name="gcp_project_name=aabb324"
export TF_VAR_ssh_user="username_inside_vm"
export TF_VAR_key_path="ssh/private/key/path/on/local/terraform/machine"

export TF_VAR_salt_master=my.saltmaster.com #salt master fqdn or IP
export SALTAPI_PORT= 8000 #whatever you set this to in the saltapi configuration
export SALTAPI_USERNAME=terrasalt #salt api username
export SALTAPI_PASSWORD=saltterra #salt api password
export SALTAPI_EAUTH=pam # or whatever your salt master is setup for  e.g. ldap
export SALTAPI_SSL_VERIFY=False # or import the saltapi ssl cert
export SALTAPI_PROTO=HTTPS #recommend not using HTTP since your saltapi
# credentials will be in the clear text if you use HTTP.

```