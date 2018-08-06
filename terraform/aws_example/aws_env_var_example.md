You will need to set values for these environment variables on your terraform shell window to make this example work.
```bash
export TF_VAR_access_key="XXYYZZAABBCC"
export TF_VAR_secret_key="thatawssecretkey"
export TF_VAR_key_path="/path/to/private/ssh/key/that/aws/vms/connect/with"

export TF_VAR_salt_master=my.saltmaster.com #salt master fqdn or IP
export SALTAPI_PORT= 8000 #whatever you set this to in the saltapi configuration
export SALTAPI_USERNAME=terrasalt #salt api username
export SALTAPI_PASSWORD=saltterra #salt api password
export SALTAPI_EAUTH=pam # or whatever your salt master is setup for  e.g. ldap
export SALTAPI_SSL_VERIFY=False # or import the saltapi ssl cert
export SALTAPI_PROTO=HTTPS #recommend not using HTTP since your saltapi
# credentials will be in the clear text if you use HTTP.

```