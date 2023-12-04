#!/bin/env bash

if [ ! -f mkdocs.yml ] ; then
    echo "Not in mkdocs.yml located document folder!"
    exit 1
fi

# update mkdocs.yml and README.md
python3 update.py
rm -rf docs site
mkdir -p docs
cp -rf *.md docs/
cp -rf *.css docs/
cp -rf asserts/ docs/

sed -i "s|0-template.md|https://github.com/Nuclei-Software/nuclei-studio/blob/main/0-template.md|" docs/README.md

echo "Document for mkdocs is prepared!"
echo "Run the following command to build and serve these doc!"
echo "mkdocs serve -a 0.0.0.0:8009"
