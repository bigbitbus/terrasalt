import requests
import json
import os
import sys
from traceback import format_exc


def saltapi_server_url(salt_master_host=None,
                       saltapi_port=None,
                       saltapi_proto=None):
    """
    Return the url of the saltapi server
    :param salt_master_host: hostname or IP of saltapi server
    :param saltapi_port: saltapi port
    :param saltapi_proto: either HTTP or HTTPS
    :return:
    """
    try:
        if salt_master_host == None:
            salt_master_host = os.environ.get("SALT_MASTER_HOST")
        if saltapi_port == None:
            saltapi_port = os.environ.get("SALTAPI_PORT")
        if saltapi_proto == None:
            saltapi_proto = os.environ.get("SALTAPI_PROTO")

        return saltapi_proto + "://" + \
               salt_master_host + ":" + \
               str(saltapi_port)
    except:
        print("Error setting up saltapi url: {}".format(format_exc()))
        raise


def get_saltapi_token(salt_master_host=None,
                      saltapi_port=None,
                      saltapi_username=None,
                      saltapi_password=None,
                      saltapi_eauth=None,
                      saltapi_ssl_verify=None):
    """
    Get an auth token from the salt-api server.
    This function assumes that the environment variables
    shown below are available in the OS envinonment.
    :param salt_master_host:
    :param saltapi_port:
    :param saltapi_username:
    :param saltapi_password:
    :param saltapi_eauth:
    :param saltapi_ssl_verify:
    :return:
    """

    try:

        if saltapi_username == None:
            saltapi_username = os.environ.get("SALTAPI_USERNAME")
        if saltapi_password == None:
            saltapi_password = os.environ.get("SALTAPI_PASSWORD")
        if saltapi_eauth == None:
            saltapi_eauth = os.environ.get("SALTAPI_EAUTH")
        if saltapi_ssl_verify == None:
            saltapi_ssl_verify = os.environ.get("SALTAPI_SSL_VERIFY") \
                                 in set(['True', 'true', 'Yes', 'yes', '1'])

        url = saltapi_server_url() + "/login"
        payload = {'eauth': saltapi_eauth,
                   'username': saltapi_username,
                   'password': saltapi_password}
        headers = {'Accept': 'application/json',
                   'Content-type': 'application/x-www-form-urlencoded'}
        requests.packages.urllib3.disable_warnings()
        r = requests.post(url,
                          data=payload,
                          headers=headers,
                          verify=saltapi_ssl_verify,
                          )

        return json.loads(r.content)['return'][0]['token']
    except:
        print("Error getting SaltAPI token: {}".format(format_exc()))
        print("RESPONSE HEADERS: {}".format(r.headers))
        print("RESPONSE TEXT: {}".format(r.text))
        raise


def wheel_minion(minion_name, fun, saltapi_ssl_verify = None):
    """
    curl -k  https://sriharikota.bigbitbus.com:8000/ -H "Accept: application/json" -H "X-Auth-Token: 7e5442854dd2ecaa5d98fb8732761f5c5dca7df4"   -d client='wheel' -d fun='key.accept' -d match="T_Client"
    :param minion_name: name of the minion
    :param fun: function to execute - key.accept or key.delete
    :return:
    """
    try:
        if saltapi_ssl_verify == None:
            saltapi_ssl_verify = os.environ.get("SALTAPI_SSL_VERIFY") \
                                 in set(['True', 'true', 'Yes', 'yes', '1'])
        url = saltapi_server_url()
        headers = {
            "Accept": "application/json",
            "X-Auth-Token": get_saltapi_token()
        }
        payload = {
            "client": 'wheel',
            "fun": fun,
            "match": minion_name
        }
        r = requests.post(url,
                          data=payload,
                          headers=headers,
                          verify=saltapi_ssl_verify,
                          )
        return json.loads(r.content)['return']
    except:
        print("Error sending wheel request: {}".format(format_exc()))
        print("RESPONSE HEADERS: {}".format(r.headers))
        print("RESPONSE TEXT: {}".format(r.text))
        raise

if __name__ == "__main__":
    print(wheel_minion(sys.argv[1],sys.argv[2]))


# #Here is an example of environment variables that would work
# export SALT_MASTER_HOST=yoursaltmaster.com
# export SALTAPI_PORT=8001
# export SALTAPI_PASSWORD=saltterra
# export SALTAPI_USERNAME=terrasalt
# export SALTAPI_EAUTH=pam
# export SALTAPI_SSL_VERIFY=False
# export SALTAPI_PROTO=HTTPS
