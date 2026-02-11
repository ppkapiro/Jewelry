#!/bin/bash
set -euo pipefail

usage() {
  echo "Usage: $0 <fork_name> <fork_url> [rebase|merge]"
  echo "Example: $0 ppkapiro https://github.com/ppkapiro/Jewelry.git rebase"
}

if [ $# -lt 2 ]; then
  usage
  exit 1
fi

FORK_NAME="$1"
FORK_URL="$2"
STRATEGY="${3:-rebase}"

if [ "$STRATEGY" != "rebase" ] && [ "$STRATEGY" != "merge" ]; then
  echo "Error: strategy must be 'rebase' or 'merge'."
  exit 1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Error: not inside a git repository."
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "Error: working tree is not clean. Commit or stash changes first."
  exit 1
fi

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

if git remote get-url "$FORK_NAME" >/dev/null 2>&1; then
  EXISTING_URL="$(git remote get-url "$FORK_NAME")"
  if [ "$EXISTING_URL" != "$FORK_URL" ]; then
    echo "Error: remote '$FORK_NAME' exists with a different URL."
    echo "Existing: $EXISTING_URL"
    echo "Expected: $FORK_URL"
    exit 1
  fi
else
  git remote add "$FORK_NAME" "$FORK_URL"
fi

git fetch "$FORK_NAME"

BRANCHES=("main" "develop")

for BRANCH in "${BRANCHES[@]}"; do
  if git ls-remote --exit-code --heads "$FORK_NAME" "$BRANCH" >/dev/null 2>&1; then
    if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
      git checkout "$BRANCH"
    elif git show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
      git checkout -b "$BRANCH" "origin/$BRANCH"
    else
      git checkout -b "$BRANCH" "$FORK_NAME/$BRANCH"
    fi

    if [ "$STRATEGY" = "rebase" ]; then
      git rebase "$FORK_NAME/$BRANCH"
    else
      git merge --no-ff "$FORK_NAME/$BRANCH"
    fi

    echo "Synced $BRANCH with $FORK_NAME/$BRANCH using $STRATEGY."
  else
    echo "Skipping $BRANCH: not found on $FORK_NAME."
  fi
done

git checkout "$CURRENT_BRANCH" >/dev/null 2>&1 || true

echo "Sync complete. Review changes and push if needed:"
echo "  git push origin main"
echo "  git push origin develop"
