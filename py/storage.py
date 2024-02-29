import requests

# Salesforce credentials
username = 'your_username'
password = 'your_password'
security_token = 'your_security_token'
domain = 'your_salesforce_domain'  # for example, 'login' for production or 'test' for sandbox
client_id = 'your_client_id'
client_secret = 'your_client_secret'

# Authenticate and get access token
url = f'https://{domain}.salesforce.com/services/oauth2/token'
payload = {
    'grant_type': 'password',
    'client_id': client_id,
    'client_secret': client_secret,
    'username': username,
    'password': password + security_token
}
response = requests.post(url, data=payload)
access_token = response.json()['access_token']
instance_url = response.json()['instance_url']

# Query for storage usage
url = f"{instance_url}/services/data/v52.0/tooling/query?q=SELECT+TableEnumOrId,DataSize+FROM+EntityParticle+WHERE+EntityDefinition.DurableId+IN+(SELECT+DurableId+FROM+EntityDefinition+WHERE+IsQueryable+=+True)"
headers = {'Authorization': f'Bearer {access_token}'}
response = requests.get(url, headers=headers)
storage_info = response.json()

# Print storage usage
print("Storage Usage:")
for record in storage_info['records']:
    object_name = record['TableEnumOrId']
    data_size = record['DataSize']
    print(f"  Object: {object_name}, Data Size: {data_size} bytes")
