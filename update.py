#!/usr/bin/env python3
import os
from datetime import datetime

# Find all *.md files except README.md and 0-template.md
files = sorted([f for f in os.listdir() if f.endswith(".md") and f not in ["README.md", "0-template.md"]])

# Generate markdown table
table = "\n\n"
table += f"> Generated by `python3 update.py` @ {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n"
table += "\n"
table += "| Document | Description |\n"
table += "|:---|:---|\n"

mkdoc_entries = "\n"

for file in files:
    mkdoc_entries += f"    - {file}\n"
    with open(file, 'r') as f:
        lines = f.readlines()
        if lines:
            name = file.replace('.md', '')
            description = lines[0].lstrip('# ').strip()
            row = f"| [{file}]({file}) | {description} |\n"
            table += row

def find_and_replace(fpath, start, end, replace):
    if os.path.isfile(fpath) == False:
        print("{fpath} file not exist!")
        return
    # Read the existing fpath content
    with open(fpath, 'r') as handle_file:
        orig_handle = handle_file.read()

    # Update content below ## Documents
    start_index = orig_handle.find(start) + len(start)
    end_index = orig_handle.find(end, start_index)
    updated_handle = orig_handle[:start_index] + replace + orig_handle[end_index:]


    # Write the updated content back to fpath
    with open(fpath, 'w') as handle_file:
        handle_file.write(updated_handle)

    print(f"Updated in {fpath}")

find_and_replace("README.md", "## Documents", "##", table)
find_and_replace("mkdocs.yml", "README.md", "exclude", mkdoc_entries)