#!/bin/bash

# Function to check if the template file exists
check_file_exists() {
    if [ ! -f "$1" ]; then
        echo "Template file not found!"
        exit 1
    fi
}

# Function to replace placeholders in the template
replace_placeholders() {
    local template_file="$1"
    shift

    # Read the template file
    template=$(cat "$template_file")

    # Process the key-value pairs
    for arg in "$@"; do
        key="${arg%%=*}"
        value="${arg#*=}"
        template=$(echo "$template" | sed "s/{{${key}}}/${value}/g")
    done

    # Output the result
    echo "$template"
}

# Check if at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <template file> <key1=value1> <key2=value2> ..."
    exit 1
fi

# First argument is the template file
template_file="$1"
shift

# Check if the template file exists
check_file_exists "$template_file"

# Replace placeholders and output the result
replace_placeholders "$template_file" "$@"
