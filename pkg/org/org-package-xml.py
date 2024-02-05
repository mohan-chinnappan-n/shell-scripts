"""
Salesforce Metadata API Script
org-package-xml.py
Author: Mohan Chinnappan
---------------------------------------------------------

This script connects to the Salesforce Metadata API to describe metadata types
and generate a package.xml file with all available metadata components.

Requirements:
- Salesforce credentials (username, password, and security token) set in .env file
- Python 'requests' and 'python-dotenv' libraries installed.

Usage:
1. Set Salesforce credentials in environment variables:
   - SF_USERNAME: Salesforce username
   - SF_PASSWORD: Salesforce password
   - SF_SECURITY_TOKEN: Salesforce security token
in .env file like this:
SF_USERNAME=username
SF_PASSWORD=pwd
SF_SECURITY_TOKEN=st

2. Run the script:
   $ python org-package-xml.py

Note: The Salesforce API version is set to '58.0' by default. You can modify the 'api_version' variable as needed.
"""

import os

import requests
from xml.etree.ElementTree import ElementTree, Element, SubElement, fromstring, tostring
import xml.dom.minidom

from dotenv import load_dotenv

api_version = '58.0'
output_file='package.xml'

def pretty_format_xml(xml_str):
    """
    Pretty format an XML string.
    """
    dom = xml.dom.minidom.parseString(xml_str)
    return dom.toprettyxml(indent="  ")


def load_salesforce_credentials():
    """
    Load Salesforce credentials from environment variables.
    """
    load_dotenv()
    username = os.environ.get('SF_USERNAME')
    password = os.environ.get('SF_PASSWORD')
    security_token = os.environ.get('SF_SECURITY_TOKEN')

    if not (username and password and security_token):
        raise ValueError("Salesforce credentials (username, password, security token) are not provided.")

    return username, password, security_token

def load_salesforce_credentials():
    """
    Load Salesforce credentials from environment variables.
    """
    load_dotenv()
    username = os.environ.get('SF_USERNAME')
    password = os.environ.get('SF_PASSWORD')
    security_token = os.environ.get('SF_SECURITY_TOKEN')

    if not (username and password and security_token):
        raise ValueError("Salesforce credentials (username, password, security token) are not provided.")

    return username, password, security_token

def authenticate_salesforce(username, password, security_token, sandbox=False, api_version="58.0"):
    """
    Authenticate with Salesforce to obtain session ID and server URL.
    """
    base_url = 'https://login.salesforce.com' if not sandbox else 'https://test.salesforce.com'
    login_url = f'{base_url}/services/Soap/u/{api_version}'

    login_envelope = f'''
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
                      xmlns:urn="urn:partner.soap.sforce.com">
        <soapenv:Body>
            <urn:login>
                <urn:username>{username}</urn:username>
                <urn:password>{password}{security_token}</urn:password>
            </urn:login>
        </soapenv:Body>
    </soapenv:Envelope>
    '''

    login_headers = {'Content-Type': 'text/xml', 'SOAPAction': 'login'}
    login_response = requests.post(login_url, data=login_envelope, headers=login_headers)

    if login_response.status_code == 200:
        root = fromstring(login_response.content)
        session_id = root.find('.//{urn:partner.soap.sforce.com}sessionId').text
        sf_server_url = root.find('.//{urn:partner.soap.sforce.com}serverUrl').text

        # Extract server URL and set it in the metadata URL
        sf_server_instance = sf_server_url.split('/')[2]
        metadata_url = f'https://{sf_server_instance}/services/Soap/m/{api_version}'

        sf = {'session_id': session_id}
        return metadata_url, sf

    raise ValueError(f'Error: {login_response.status_code} - {login_response.text}')

def describe_metadata(metadata_url, sf):
    """
    Describe metadata from Salesforce org and create a package.xml file.
    """
    # SOAP envelope for Metadata API requests
    envelope = f'''
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
                      xmlns:met="http://soap.sforce.com/2006/04/metadata">
        <soapenv:Header>
            <met:SessionHeader>
                <met:sessionId>{sf['session_id']}</met:sessionId>
            </met:SessionHeader>
        </soapenv:Header>
        <soapenv:Body>
            <met:describeMetadata/>
        </soapenv:Body>
    </soapenv:Envelope>
    '''

    # Make the request
    headers = {'Content-Type': 'text/xml', 'SOAPAction': 'describeMetadata'}
    response = requests.post(metadata_url, data=envelope, headers=headers)

    # Parse the response to get metadata types
    metadata_types = []
    if response.status_code == 200:
        root = fromstring(response.content)
        for metadata_type in root.findall(".//met:metadataObjects", namespaces={'met': 'http://soap.sforce.com/2006/04/metadata'}):
            metadata_types.append(metadata_type.find('met:xmlName', namespaces={'met': 'http://soap.sforce.com/2006/04/metadata'}).text)

        # Create the package.xml structure
        package = Element('Package')
        package.set('xmlns', 'http://soap.sforce.com/2006/04/metadata')

        # Add each metadata component to the package.xml
        for metadata_type in metadata_types:
            types = SubElement(package, 'types')
            name = SubElement(types, 'name')
            name.text = metadata_type

            members = SubElement(types, 'members')
            members.text = '*'  # Include all members for each metadata type

        # Add version and save the package.xml
        version = SubElement(package, 'version')
        version.text = api_version  # Use the Salesforce API version of your org

        tree = ElementTree(package)
        # pretty format
        xml_str = tostring(package, encoding='utf-8', method='xml').decode('utf-8')
        pretty_xml = pretty_format_xml(xml_str)
        with open(output_file, 'w', encoding='utf-8') as file:
            file.write(pretty_xml)
        print(f'{output_file} created successfully.')
    else:
        print(f'Error: {response.status_code} - {response.text}')

if __name__ == "__main__":
    try:
        sf_username, sf_password, sf_security_token = load_salesforce_credentials()
        metadata_url, sf = authenticate_salesforce(sf_username, sf_password, sf_security_token)

        describe_metadata(metadata_url, sf)
    except ValueError as e:
        print(f'Error: {e}')

