
"""
Script: psg_graph.py
Author: Mohan Chinnappan
-------------------------------------------------------------

Description:
    This script retrieves relationships between Salesforce objects User, Profile, PermissionSet,
    PermissionSetGroup, and PermissionSetAssignment for a given user's name or ID using REST API
    and draws a relationship graph. It reads access token and instance URL from
    a JSON file named 'credentials.json'.

Usage:
    python3 psg_graph.py --c credentials.json --user_name "user_name" OR --user_id "user_id"

Dependencies:
    - sfutilpsg library (Install with: pip install sfutilpsg==0.1.4)

Credentials JSON format:
{
  "access_token": "YOUR_ACCESS_TOKEN",
  "instance_url": "YOUR_INSTANCE_URL"
}
-------------------------------------------------------------
"""
import argparse
from sfutilpsg import SFUtilPSG

def main():
    parser = argparse.ArgumentParser(description="Draw Salesforce relationship graph")
    parser.add_argument("--credentials", required=True, help="Credentials file name")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--user_name", help="Name of the user")
    group.add_argument("--user_id", help="ID of the user")

    group.add_argument("--api_version", help="API Version: default:59.0", default="59.0")
    group.add_argument("--output", help="Output SVG file: default:psg_graph", default="psg_graph")


    args = parser.parse_args()
    credentials_file = args.credentials
    user_id = args.user_id
    api_version = args.api_version
    output = args.output

    sf_util_psg = SFUtilPSG(credentials_file, api_version=api_version, output=output)
    sf_util_psg.draw_relationship_graph(user_id)

if __name__ == "__main__":
    main()