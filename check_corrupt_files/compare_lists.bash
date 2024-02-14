#!/bin/bash

LIST1="file_names_list.txt"
LIST2="corrupt_files_list.txt"
OUTPUT="non_corrupt_files_list.txt"

# Check if both input files exist
if [ ! -f "$LIST1" ] || [ ! -f "$LIST2" ]; then
    echo "One or both of the input files do not exist."
    exit 1
fi

# Sort the input files in-place
sort "$LIST1" -o "$LIST1"
sort "$LIST2" -o "$LIST2"

# Use `comm` to find unique lines and remove leading tabs
comm -3 "$LIST1" "$LIST2" | sed 's/^\t//' > "$OUTPUT"

echo "Unique file names have been written to $OUTPUT."
