#!/bin/env bash

# Find all *.md files except README.md and 0-template.md
files=($(ls *.md | grep -v "README\|0-template"))

# Generate markdown table
table="\n"
table+="| Document | Description |\n"
table+="|:---|:---|\n"

for file in "${files[@]}"
do
    name=$(echo $file | sed 's/\.md//g')
    description=$(head -n 1 $file | sed 's/^# //g')
    row="| [${file}](${file}) | ${description} |\n"
    table+="${row}"
done

# Insert table into README.md
orig_readme=$(cat README.md)
top_part=$(echo "$orig_readme" | sed -n '1,/^## Documents/p')

echo "$top_part" > README.md
echo -e "$table" >> README.md
