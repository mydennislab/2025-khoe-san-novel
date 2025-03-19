#!/bin/bash

# Output JSON file
OUTPUT_FILE="repo_contents.json"

# Function to recursively list files and directories
generate_json() {
    local path="$1"
    local indent="$2"
    local first_entry=true

    echo "[" >> "$OUTPUT_FILE"

    for entry in "$path"/*; do
        [[ -e "$entry" ]] || continue  # Skip if the entry doesn't exist

        if [ "$first_entry" = false ]; then
            echo "," >> "$OUTPUT_FILE"
        fi
        first_entry=false

        local filename=$(basename "$entry")
        local is_dir=false
        if [ -d "$entry" ]; then
            is_dir=true
        fi

        echo -n "  { \"name\": \"$filename\", \"type\": \"$(if [ "$is_dir" = true ]; then echo "dir"; else echo "file"; fi)\"" >> "$OUTPUT_FILE"

        if [ "$is_dir" = true ]; then
            echo ", \"contents\": " >> "$OUTPUT_FILE"
            generate_json "$entry" "  $indent"
        else
            echo " }" >> "$OUTPUT_FILE"
        fi
    done

    echo "]" >> "$OUTPUT_FILE"
}

# Clear previous JSON file if exists
echo "Generating repository file structure..."
> "$OUTPUT_FILE"

# Start JSON generation from the current directory
generate_json "." ""

# Format JSON (optional)
jq '.' "$OUTPUT_FILE" > tmp.json && mv tmp.json "$OUTPUT_FILE"

echo "✅ Repository structure saved to $OUTPUT_FILE"
