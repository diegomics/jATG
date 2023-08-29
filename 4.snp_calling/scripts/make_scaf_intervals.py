import sys

# Check there is at least one arg in the command
if len(sys.argv) < 2:
    print("Please provide a .fai file as a command-line argument.")
    sys.exit(1)

filename = sys.argv[1]

groups = []
current_group = []
current_sum = 0

with open(filename, 'r') as file:
    for line in file:
        row = line.strip().split()
        row[1] = int(row[1])

        # If a single row exceeds 200000000, put it into its own group
        if row[1] > 200000000:
            # But first, add any current group to the groups
            if current_group:
                groups.append(current_group)
                current_group = []
                current_sum = 0
            groups.append([row])
            continue  # Skip to next iteration

        # Otherwise, check if adding this row's value to the current sum would exceed the limit
        elif current_sum + row[1] > 200000000:
            # If it would, add the current group to the groups and start a new group
            groups.append(current_group)
            current_group = []
            current_sum = 0

        current_sum += row[1]
        current_group.append(row)

# Handle any remaining rows that didn't reach the sum
if current_group:
    groups.append(current_group)

# Write each group to a separate file
for i, group in enumerate(groups):
    # Pad the group number with leading zeroes
    padded_group_number = str(i + 1).zfill(3)
    with open(f'interval{padded_group_number}.list', 'w') as file:
        for row in group:
            # Only write the first column (index 0) of each row to the file
            file.write(row[0] + '\n')
