#!/bin/bash
set -euo pipefail

: "${GITHUB_TOKEN:?GITHUB_TOKEN env var required}"
: "${GOTIFY_SERVER:?GOTIFY_SERVER env var required}"
: "${GOTIFY_TOKEN:?GOTIFY_TOKEN env var required}"

GIT_REPO="${GIT_REPO:-github.com/bergpb/nvchecker-gh-actions.git}"
GIT_BRANCH="${GIT_BRANCH:-main}"
REPO_DIR="$(mktemp -d)"
trap 'rm -rf "$REPO_DIR"' EXIT

git clone --depth 1 --branch "$GIT_BRANCH" \
    "https://x-access-token:${GITHUB_TOKEN}@${GIT_REPO}" "$REPO_DIR"
cd "$REPO_DIR"

git config user.name "swarm-cronjob Bot"
git config user.email "swarm-cronjob@localhost"

sed -i -e "s/__GITHUB_ACCESS_TOKEN__/${GITHUB_TOKEN}/g" keyfile.toml

LOG_FILE="nvchecker_$(date +'%Y-%m-%d_%H-%M-%S').log"

nvchecker --file config.toml --keyfile keyfile.toml 2>&1 | tee "$LOG_FILE"

if grep -q '^\[E ' "$LOG_FILE"; then
    echo "nvchecker reported errors, skipping version commit and notification" >&2
    exit 1
fi

nvcmp --file config.toml > result.tmp
nvtake --file config.toml --all

RESULT="$(cat result.tmp)"

if [[ -n "$RESULT" ]]; then
    curl -s "${GOTIFY_SERVER}/message?token=${GOTIFY_TOKEN}" \
        -F "title=nvchecker Updates" \
        -F "message=${RESULT}" \
        -F "priority=5" > /dev/null
else
    echo "No new versions"
fi

rm -f result.tmp "$LOG_FILE"

if ! git diff --quiet -- '*.json'; then
    git add -- '*.json'
    git commit -m "chore: apply version record files changes"
    git push origin "$GIT_BRANCH"
fi
