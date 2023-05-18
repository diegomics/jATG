import sys

# Define dictionary to map input keys to output keys
key_map = {
    "sum": "Asm_size",
    "n": "Scaffolds",
    "ave": "",
    "largest": "Longest_scaff",
    "N50": "Scaff_N50",
    "N60": "",
    "N70": "",
    "N80": "",
    "N90": "Scaff_N90",
    "N100": "",
    "N_count": "Gaps_sum",
    "Gaps": "Gaps"
}

# Define dictionary for output data
output_data = {}

# Check that command line argument was provided
if len(sys.argv) != 2:
    print("Usage: python table_from_stats.py <input_file>")
    sys.exit(1)

# Read data from file
with open(sys.argv[1], 'r') as f:
    prev_key = None
    for line in f:
        # Split line into key-value pairs
        pairs = line.strip().split(', ')
        for pair in pairs:
            if ' = ' in pair:
                key, value = pair.split(' = ')
                # Try convert the value to an integer, and if that fails, convert it to float
                try:
                    value = int(value)
                except ValueError:
                    value = float(value)
                # If key is 'n', it's a sub-key of the previous key
                if key == 'n' and prev_key.startswith('N') and key_map[prev_key]:
                    # Append 'L' to previous key and add it to output data
                    output_data[key_map[prev_key].replace('N', 'L')] = value
                elif key in key_map and key_map[key]:
                    # Add key-value pair to output data
                    output_data[key_map[key]] = value
                prev_key = key

# Print output data in the correct order
print(f"Asm_size\t{output_data['Asm_size']}")
print(f"Scaffolds\t{output_data['Scaffolds']}")
print(f"Longest_scaff\t{output_data['Longest_scaff']}")
print(f"Scaff_N50\t{output_data['Scaff_N50']}")
print(f"Scaff_L50\t{output_data['Scaff_L50']}")
print(f"Scaff_N90\t{output_data['Scaff_N90']}")
print(f"Scaff_L90\t{output_data['Scaff_L90']}")
print(f"Gaps_sum\t{output_data['Gaps_sum']}")
print(f"Gaps\t{output_data['Gaps']}")

