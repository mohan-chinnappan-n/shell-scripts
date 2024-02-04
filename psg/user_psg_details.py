"""
This Python script (user_psg_details.py) is designed to retrieve and list permission sets associated with a given assignee.

Author: Mohan Chinnappan
-----------------------------------------------------------------------------------------------

Usage:
    python user_psg_details.py <assignee_name> <assignee_file_path> <permission_set_file_path> <output_file_path>

Example:
    python user_psg_details.py JohnDoe assignee_data.csv permission_set_data.csv output_result.csv

Arguments:
    - assignee_name (str): The Assignee.Name to search for in the data.
    - assignee_file_path (str): Path to the CSV file containing assignee data.
    - permission_set_file_path (str): Path to the CSV file containing permission set data.
    - output_file_path (str): Path to the output CSV file where results will be saved.

This script leverages the pandas library for efficient handling and manipulation of CSV data.
The get_permission_sets function is defined to merge assignee and permission set dataframes, filter rows based on the assignee name,
and group the results by permission set groups.

Command line arguments are parsed using the argparse module. Execution of this script from the command line
provides a convenient way to extract and analyze permission set data.

Make sure to replace 'script_name.py', 'JohnDoe', 'assignee_data.csv', 'permission_set_data.csv', and 'output_result.csv'
with your actual script name, assignee name, assignee data file, permission set data file, and desired output file.
"""
import pandas as pd
import argparse

def get_permission_sets(assignee_name, assignee_df, permission_set_df):
    # Merge the two dataframes on "PermissionSetGroup.DeveloperName"
    merged_df = pd.merge(assignee_df, permission_set_df, on="PermissionSetGroup.DeveloperName", how="left")

    # Filter the rows where Assignee.Name matches the given value
    filtered_df = merged_df[merged_df["Assignee.Name"] == assignee_name]

    # Group by "PermissionSetGroup.DeveloperName" and aggregate PermissionSet.Name into a list
    result_df = filtered_df.groupby("PermissionSetGroup.DeveloperName")["PermissionSet.Name"].agg(list).reset_index()

    # Add a column for Assignee.Name
    result_df["Assignee.Name"] = assignee_name

    return result_df

def main():
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="List Permission Sets for a given Assignee")
    parser.add_argument("assignee_name", help="Assignee.Name to search for")
    parser.add_argument("assignee_file", help="Path to the Assignee CSV file")
    parser.add_argument("permission_set_file", help="Path to the Permission Set CSV file")
    parser.add_argument("output_file", help="Path to the output CSV file")
    args = parser.parse_args()

    # Load CSV files into dataframes
    assignee_df = pd.read_csv(args.assignee_file)
    permission_set_df = pd.read_csv(args.permission_set_file)

    # Get the result dataframe
    result_df = get_permission_sets(args.assignee_name, assignee_df, permission_set_df)

    # Save the result dataframe to CSV
    result_df.to_csv(args.output_file, index=False)

if __name__ == "__main__":
    main()
