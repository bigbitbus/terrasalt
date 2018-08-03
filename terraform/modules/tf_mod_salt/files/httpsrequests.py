import requests

def get_saltapi_token():
    url = "https://"+"sriharikota.bigbitbus.com" +":" + "8000"+"/login"
    payload = {'eauth': 'pam'}
    headers = {'Accept': 'application/json'}

    r = requests.get(url,
                     data=payload,
                     auth=("terrasalt","saltterra"),
                     headers=headers,
                     verify=False,
                     allow_redirects=True)
    return r.content

if __name__=="__main__":
    print (get_saltapi_token())

get_saltapi_token()