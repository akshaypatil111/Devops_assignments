#!/bin/bash

# Function to create a tag
create_tag() {
    local tag_name=$1
    if [ -z "$tag_name" ]; then
        echo "Error: Tag name is required."
        exit 1
    fi
    git tag "$tag_name"
}

# Function to list all tags
list_tags() {
    git tag
}

# Function to delete a tag
delete_tag() {
    local tag_name=$1
    if [ -z "$tag_name" ]; then
        echo "Error: Tag name is required."
        exit 1
    fi
    git tag -d "$tag_name"
}

# Parse command-line arguments
while getopts "t:d:l" opt; do
    case $opt in
        t )
            create_tag "$OPTARG"
            ;;
        d )
            delete_tag "$OPTARG"
            ;;
        l )
            list_tags
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        : )
            echo "Invalid option: -$OPTARG requires an argument" >&2
            exit 1
            ;;
    esac
done
