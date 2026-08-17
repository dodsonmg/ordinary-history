#!/bin/bash
# PostToolUse hook (git push): watches the GitHub Actions deploy run to
# completion and reports pass/fail back to Claude, so deployment is
# verified every push instead of relying on the model remembering to check.
set -uo pipefail

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ "$BRANCH" != "main" ]; then
  exit 0
fi

REPO="dodsonmg/ordinary-history"
RUN_ID=""
for i in 1 2 3 4 5 6; do
  RUN_ID=$(gh run list --repo "$REPO" --branch main --limit 1 --json databaseId --jq '.[0].databaseId' 2>/dev/null)
  [ -n "$RUN_ID" ] && [ "$RUN_ID" != "null" ] && break
  sleep 5
done

if [ -z "$RUN_ID" ] || [ "$RUN_ID" = "null" ]; then
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"PostToolUse\",\"additionalContext\":\"Could not resolve the GitHub Actions run for this push to main — verify deployment manually: gh run list --repo $REPO --branch main --limit 1\"}}"
  exit 0
fi

if gh run watch "$RUN_ID" --repo "$REPO" --exit-status >/dev/null 2>&1; then
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"PostToolUse\",\"additionalContext\":\"Deploy verified: GitHub Actions run $RUN_ID on main succeeded — https://github.com/$REPO/actions/runs/$RUN_ID\"}}"
else
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"PostToolUse\",\"additionalContext\":\"Deploy check FAILED: GitHub Actions run $RUN_ID on main did not succeed — inspect with: gh run view $RUN_ID --repo $REPO --log-failed\"}}"
fi
