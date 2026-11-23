#!/bin/bash

# Writes the counts of open PRs awaiting your review, and of your PRs with
# responses, to sentinel files so i3status' "read_file" modules can display
# them on the bar.
REVIEW_SENTINEL="/tmp/gh-pr-review-count"
RESPONSE_SENTINEL="/tmp/gh-pr-response-count"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

prs=$("$SCRIPT_DIR/gh_pr_reviews.sh")

write_count() {
    local type="$1" label="$2" sentinel="$3" count
    # types are space-padded for fzf alignment
    count=$(grep -c "^$type *"$'\t' <<< "$prs")
    if [ "$count" -gt 0 ]; then
        echo "$label: $count" > "$sentinel"
    else
        : > "$sentinel"
    fi
}

write_count review "PR Reviews" "$REVIEW_SENTINEL"
write_count response "PR Responses" "$RESPONSE_SENTINEL"
