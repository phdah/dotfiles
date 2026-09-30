#!/bin/bash

# Writes the count of open PRs awaiting your review to a sentinel file so
# i3status' "read_file" module can display it on the bar.
SENTINEL="/tmp/gh-pr-review-count"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

count=$("$SCRIPT_DIR/gh_pr_reviews.sh" | wc -l)

if [ "$count" -gt 0 ]; then
    echo "PR Reviews: $count" > "$SENTINEL"
else
    : > "$SENTINEL"
fi
