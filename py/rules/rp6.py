import argparse
import pandas as pd
import ast

def apply_update_rules(row, update_rules):
    for rule in update_rules:
        conditions = rule.get('conditions', [])
        if all(row[field] == value for field, value in conditions):
            apply_rule(row, rule)
    return row

def apply_rule(row, rule):
    for update in rule.get('updates', []):
        field = update['field']
        old_value = row[field]

        if 'new_value' in update:
            row[field] = update['new_value']
        elif 'equation' in update:
            equation = update['equation']
            try:
                # Evaluate the equation using old_value as a variable
                new_value = eval(equation, {'old_value': old_value})
                row[field] = new_value
            except Exception as e:
                print(f"Error in evaluating equation for field {field}: {e}")

def read_rules_from_file(file_path):
    with open(file_path, 'r') as file:
        rules_content = file.read()
    return ast.literal_eval(rules_content)

def main(args):
    # Read CSV file
    df = pd.read_csv(args.input_csv)

    # Read update rules from file
    update_rules = read_rules_from_file(args.rules_file)

    # Apply update rules to the DataFrame
    df = df.apply(lambda row: apply_update_rules(row, update_rules), axis=1)

    # Print the updated DataFrame
    print(df)

    # Save the updated DataFrame to a new CSV file
    df.to_csv(args.output_csv, index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Apply update rules to a CSV file.")
    parser.add_argument("--input_csv", required=True, help="Path to the input CSV file")
    parser.add_argument("--output_csv", required=True, help="Path to the output CSV file")
    parser.add_argument("--rules_file", required=True, help="Path to the file containing update rules")

    args = parser.parse_args()
    main(args)
