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
cp -rf asserts/ docs/

echo "Document for mkdocs is prepared!"
echo "Run the following command to build and serve these doc!"
echo "mkdocs serve -a 0.0.0.0:8009"
