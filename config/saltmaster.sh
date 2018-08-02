#!/bin/bash

#Usage: terrasalt_configure_salt-master.sh <https port> <terrasalt_user_password>


# Install cherrypy and salt-api (former necessary for ubuntu 1604)
pip install cherrypy 
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

# Create a non-shell/homedir restricted terrasalt user
useradd -M terrasalt --shell /bin/false
usermod --password $1 terrasalt

# Restart salt-master to apply changes
service salt-master restart

# Restart the salt-api 
service salt-api restart


# Testing - replace saltmaster.com with your saltmaster fqdn
# Ideally run this test from the machine where terraform will be run.

#curl -ski https://saltmaster.com:$1/login \
# -H 'Accept: application/json' \
# -d username='terrasalt' \
# -d password='$2' \
# -d eauth='pam'

#You should see something like
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

#You should see something like
#curl -k  https://saltmaster.com:8000/ \
# -H "Accept: application/json" 
# -H "X-Auth-Token: TOKEN_RECEIVED_ABOVE"   
# -d client='wheel' 
# -d fun='key.list_all'

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

