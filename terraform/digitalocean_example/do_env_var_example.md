You will need to set values for these environment variables on your terraform shell window to make this example work.
```bash
export TF_VAR_DO_PAT=Your_digital_ocean_api_token
export TF_VAR_pvt_key="ssh/private/key/path/on/local/terraform/machine"
export TF_VAR_ssh_fingerprint=07:07:cd:37:99:25:2f:39:92:3b:09:4d:2d:c2:d3:a3


export TF_VAR_salt_master=my.saltmaster.com #salt master fqdn or IP
export SALTAPI_PORT= 8000 #whatever you set this to in the saltapi configuration
export SALTAPI_USERNAME=terrasalt #salt api username
export SALTAPI_PASSWORD=saltterra #salt api password
export SALTAPI_EAUTH=pam # or whatever your salt master is setup for  e.g. ldap
export SALTAPI_SSL_VERIFY=False # or import the saltapi ssl cert
export SALTAPI_PROTO=HTTPS #recommend not using HTTP since your saltapi
# credentials will be in the clear text if you use HTTP.

```