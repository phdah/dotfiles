#!/bin/bash

# Function to find the Git root
find_git_root() {
    local dir=$(pwd)
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.git" ]; then
            echo "$dir"
            return
        fi
        dir=$(dirname "$dir")
    done
}

# Get the Git root
GIT_ROOT=$(find_git_root)

# Check if we're inside a Git repository
if [ -z "$GIT_ROOT" ]; then
    echo "Not inside a Git repository"
else
    # Export PYTHONPATH to include the Git root
    export PYTHONPATH="$GIT_ROOT:$PYTHONPATH"
    echo "PYTHONPATH updated with $GIT_ROOT"
fi
