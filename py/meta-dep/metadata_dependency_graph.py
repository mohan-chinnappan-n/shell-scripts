
"""
Script: metadata_dependency_graph.py
Author: Mohan Chinnappn

Description:
    This script retrieves metadata dependencies from Salesforce using REST API and draws a dependency graph
    using Graphviz. It reads access token and instance URL from a JSON file named 'credentials.json'.

Usage:
    python metadata_dependency_graph.py

Dependencies:
    - requests library (Install with: pip3 install requests)
    - graphviz library (Install with: pip3 install graphviz)

Credentials JSON format:
{
  "access_token": "YOUR_ACCESS_TOKEN",
  "instance_url": "YOUR_INSTANCE_URL"
}
"""

import requests
import json
import argparse
from graphviz import Source

def read_credentials(credentials_file):
    try:
        with open(credentials_file, "r") as file:
            credentials = json.load(file)
            access_token = credentials.get("access_token")
            instance_url = credentials.get("instance_url")
            return access_token, instance_url
    except FileNotFoundError:
        print(f"Error: Credentials file '{credentials_file}' not found.")
        return None, None
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON format in credentials file '{credentials_file}'.")
        return None, None

def fetch_metadata_dependencies(access_token, instance_url, api_version='60.0'):
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }
    query = "SELECT Id, MetadataComponentId, MetadataComponentNamespace, MetadataComponentName, MetadataComponentType, RefMetadataComponentId, RefMetadataComponentNamespace, RefMetadataComponentName, RefMetadataComponentType FROM MetadataComponentDependency"
    url = f"{instance_url}/services/data/v{api_version}/tooling/query?q={query}"
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        print("Error fetching metadata dependencies:")
        print(response.text)
        return None


spec = """  graph [  
              rankdir="RL"  
              bgcolor="#efeffd"  
              label="Salesforce ERD "  
              labeljust="r"  
              nodesep="0.18"  
              ranksep="0.46"        
              fontname="Courier"  
              fontsize="9"  
            ]; 
            node [  
              fontname="Courier"  
              fontsize="11"  
              shape="plaintext"  
              color="#99ccff"  
            ]; 
            edge [ arrowsize="0.8"   ];
            
            """
def generate_dot(metadata_dependencies):
    dot = "digraph MetadataDependencies {\n"
    dot += spec  # Adjust height as needed
    for dependency in metadata_dependencies["records"]:
        ref_name = dependency["RefMetadataComponentName"]
        metadata_name = dependency["MetadataComponentName"]
        dot += f'  "{ref_name}" [label=< <font color="blue">{ref_name}</font> >, shape="box"];\n'
        dot += f'  "{metadata_name}" -> "{ref_name}" [dir=back];\n'
    dot += "}\n"
    return dot





def main():
    parser = argparse.ArgumentParser(description="Draw metadata dependency graph")
    parser.add_argument("-c", "--credentials", required=True, help="Credentials file name")
    parser.add_argument("-v", "--api_version", help="API Version", default="60.0")
    args = parser.parse_args()
    credentials_file = args.credentials
    api_version = args.api_version

    access_token, instance_url = read_credentials(credentials_file)
    if access_token and instance_url:
        metadata_dependencies = fetch_metadata_dependencies(access_token, instance_url, api_version)
        if metadata_dependencies:
            dot = generate_dot(metadata_dependencies)
            graph = Source(dot)
            graph.format = 'svg'
            graph.render("dependency_graph", cleanup=True)

if __name__ == "__main__":
    main()
