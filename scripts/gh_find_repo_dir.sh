#!/bin/bash

# Finds the local clone of a repo under ~/repos matching the given hostname
# and "owner/repo", by comparing each repo's git "origin" remote URL.
# Prints the first matching directory path, or nothing if not found.
#
# Usage: gh_find_repo_dir.sh <hostname> <owner/repo>

hostname="$1"
owner_repo="$2"
SEARCH_ROOT="$HOME/repos"

for gitdir in $(find "$SEARCH_ROOT" -type d -name ".git" -prune 2>/dev/null); do
    dir=$(dirname "$gitdir")
    remote=$(git -C "$dir" remote get-url origin 2>/dev/null)
    if [[ "$remote" == *"$hostname"* && "$remote" == *"$owner_repo"* ]]; then
        echo "$dir"
        exit 0
    fi
done
