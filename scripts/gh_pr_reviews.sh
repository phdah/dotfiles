#!/bin/bash

# Lists open PRs across all `gh`-authenticated hosts that need your attention.
# Shared by the `pr-review` fzf picker and the i3status check.
#   review:   you are requested as a reviewer
#   response: you authored it and the latest human activity (comment or
#             review) is from someone else; your own comment or a new commit
#             clears it
# Repos listed in ~/.gh_pr_exclude (one owner/name per line) are skipped.
# Output: one PR per line as "type<TAB>repo<TAB>title<TAB>url"

HOSTS_FILE="$HOME/.config/gh/hosts.yml"
EXCLUDE_FILE="$HOME/.gh_pr_exclude"

[ -f "$HOSTS_FILE" ] || exit 0

QUERY='
fragment pr on PullRequest {
  title url repository { nameWithOwner }
  timelineItems(last: 20, itemTypes: [ISSUE_COMMENT, PULL_REQUEST_REVIEW, PULL_REQUEST_COMMIT]) {
    nodes {
      __typename
      ... on IssueComment { author { __typename login } }
      ... on PullRequestReview { author { __typename login } }
    }
  }
}
query {
  viewer { login }
  review: search(query: "is:pr is:open archived:false review-requested:@me", type: ISSUE, first: 100) { nodes { ...pr } }
  mine: search(query: "is:pr is:open archived:false author:@me", type: ISSUE, first: 100) { nodes { ...pr } }
}'

JQ='
.data.viewer.login as $me
| def row($type): "\($type)\t\(.repository.nameWithOwner)\t\(.title)\t\(.url)";
  (.data.review.nodes[] | row("review  ")),
  (.data.mine.nodes[]
    | select(
        [.timelineItems.nodes[] | select(.author.__typename != "Bot")] | last
        | . != null and .__typename != "PullRequestCommit" and .author.login != $me
      )
    | row("response"))'

for host in $(grep -E '^[^[:space:]#]+:' "$HOSTS_FILE" | sed 's/:$//'); do
    GH_HOST="$host" gh api graphql -f query="$QUERY" --jq "$JQ" 2>/dev/null
done | awk -F'\t' -v exclude="$EXCLUDE_FILE" '
    BEGIN {
        while ((getline line < exclude) > 0) {
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
            if (line != "" && line !~ /^#/) skip[line] = 1
        }
    }
    !($2 in skip)'
