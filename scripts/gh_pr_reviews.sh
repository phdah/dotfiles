#!/bin/bash

# Lists open PRs across all `gh`-authenticated hosts where you are requested
# as a reviewer. Shared by the `pr-review` fzf picker and the i3status check.
# Output: one PR per line as "repo<TAB>title<TAB>url"

HOSTS_FILE="$HOME/.config/gh/hosts.yml"

[ -f "$HOSTS_FILE" ] || exit 0

for host in $(grep -E '^[^[:space:]#]+:' "$HOSTS_FILE" | sed 's/:$//'); do
    GH_HOST="$host" gh search prs --review-requested=@me --state=open --archived=false \
        --json repository,title,url \
        --jq '.[] | "\(.repository.nameWithOwner)\t\(.title)\t\(.url)"' 2>/dev/null
done
