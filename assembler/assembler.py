import sys
import os
import re

from riscv_assembler.convert import AssemblyConverter

# instantiate
convert = AssemblyConverter(output_mode = 'f', nibble_mode = True, hex_mode = False)

def convert_file(file):
    # Convert a whole .s file to text file
    root, old_ext = os.path.splitext(file)
    output = f"{root}.txt"
    convert(file, output)

    # Removing all whitespace for easy copying
    with open(output, 'r') as file:
        content = file.read()
    new_content = re.sub(r'[ \t\f\v\r]+', '', content)
    with open(output, 'w') as file:
        file.write(new_content)
    print(f'Generated Machine Code: {output}')

def main():
    if len(sys.argv)!=2:
        print("Usage: python assembler.py <assembly_file>")
        sys.exit(1)
    file_name = sys.argv[1]
    convert_file(file_name)


if __name__ == "__main__":
    main()

