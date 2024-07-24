#!/bin/bash

# Function to show usage
usage() {
    echo "Usage: $0 -l | -b <branch_name> | -d <branch_name> | -m -1 <branch_name1> -2 <branch_name2> | -r -1 <branch_name1> -2 <branch_name2>"
    exit 1
}

# Function to list branches
list_branches() {
    echo "Listing branches:"
    git branch
}

# Function to create a new branch
create_branch() {
    local branch_name="$1"
    echo "Creating branch: $branch_name"
    git checkout -b "$branch_name"
}

# Function to delete a branch
delete_branch() {
    local branch_name="$1"
    echo "Deleting branch: $branch_name"
    git branch -d "$branch_name"
}

# Function to merge two branches
merge_branches() {
    local branch_to_merge="$1"
    local target_branch="$2"
    echo "Merging branch $branch_to_merge into $target_branch"
    git checkout "$target_branch"
    git merge "$branch_to_merge"
}

# Function to rebase one branch onto another
rebase_branches() {
    local branch_to_rebase="$1"
    local base_branch="$2"
    echo "Rebasing branch $branch_to_rebase onto $base_branch"
    git checkout "$branch_to_rebase"
    git rebase "$base_branch"
}

# Check for the correct number of arguments
if [ $# -lt 1 ]; then
    usage
fi

# Parse command-line arguments
while getopts ":l:b:d:m:r:" opt; do
    case $opt in
        l) list_branches ;;
        b) create_branch "$OPTARG" ;;
        d) delete_branch "$OPTARG" ;;
        m) 
            branch1="$OPTARG"
            shift
            branch2="$1"
            merge_branches "$branch1" "$branch2"
            ;;
        r) 
            branch1="$OPTARG"
            shift
            branch2="$1"
            rebase_branches "$branch1" "$branch2"
            ;;
        \?) usage ;;
    esac
done
