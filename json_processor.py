import json

# Input and Output File Paths
input_file = "mytable_data.json"
output_file = "data.out"

try:
    # Read JSON data from the file
    with open(input_file, 'r') as f:
        data = json.load(f)

    # Process the data (replace with your desired logic)
    output_lines = []
    if 'data' in data and isinstance(data['data'], list):
        for item in data['data']:
            output_lines.append(f"SUBS: {item.get('SUBS', '')}, RSTEP: {item.get('RSTEP', '')}, DATE: {item.get('DATE', '')}, TIME: {item.get('TIME', '')}, LSTAT: {item.get('LSTAT', '')}")

    # Write the processed data to the output file
    with open(output_file, 'w') as outfile:
        for line in output_lines:
            outfile.write(line + '\n')

    print(f"Data written to {output_file}")

except FileNotFoundError:
    print(f"Error: File not found: {input_file}")
except json.JSONDecodeError:
    print(f"Error: Invalid JSON format in {input_file}")
except Exception as e:
    print(f"An unexpected error occurred: {e}")
