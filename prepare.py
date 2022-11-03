# Fix PACKED attribute on structs for permuter.
BASE_C_FILE='base.c'

lines = []
with open(BASE_C_FILE, 'r') as file:
    lines = file.readlines()

bracket_stack = []
# Start line, End line
attributes = []

# Find all the packed attributes.
for i, line in enumerate(lines):
    if '{' in line:
        bracket_stack.append(i)
    #if '__attribute__((packed))' in line:
    if '__attribute__((packed' in line:
        attributes.append((bracket_stack[-1], i))
    if '}' in line:
        bracket_stack.pop()
    #print(i, line, bracket_stack)

# Sort attributes by start time-
attributes.sort(key=lambda x:x[0])

#print(attributes)

with open(BASE_C_FILE, 'w') as file:
    # Create the output by adding PERM_PRETEND and PERM_IGNORE
    cursor = 0
    for (start, end) in attributes:
        if cursor > start:
            #print(f'Ignore nested packed ({start}, {end}).')
            continue
        # Output lines until the start.
        for i in range(cursor, start):
            file.write(lines[i])

        # Output a PERM_PRETEND version without the attribute and a PERM_IGNORE version with the attribute
        struct = ''.join(lines[start:end+1])
        file.write('PERM_PRETEND(\n')
        file.write(struct.replace('__attribute__((packed))', '').replace('__attribute__((packed, aligned(2)))', ''))
        file.write(')\nPERM_IGNORE(\n')
        file.write(struct)
        file.write(')\n')

        cursor = end+1

    # Output remaining lines.
    for i in range(cursor, len(lines)):
        file.write(lines[i])