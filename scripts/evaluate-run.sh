#!/usr/bin/env bash
set -u

# TasteBench local evaluator.
# Usage: ./scripts/evaluate-run.sh 001-add-settings-screen claude-code
#
# This script automates objective checks only: build, tests, diff stats,
# changed-file scope, raw color heuristics, design-token references, and
# accessibility keyword references. Human taste review stays manual.

TASK_ID="${1:-}"
AGENT="${2:-}"

if [ -z "$TASK_ID" ] || [ -z "$AGENT" ]; then
  echo "Usage: ./scripts/evaluate-run.sh <task-id> <agent>" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RUN_DIR="$REPO_ROOT/runs/$AGENT/$TASK_ID"
CONFIG_PATH="$REPO_ROOT/tasks/$TASK_ID/config.json"

# Build/test settings are intentionally easy to override for different machines.
MIRA_DIR="${MIRA_DIR:-$REPO_ROOT/Mira}"
DEVELOPER_DIR="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"
XCODE_PROJECT="${XCODE_PROJECT:-Mira.xcodeproj}"
XCODE_SCHEME="${XCODE_SCHEME:-Mira}"
XCODE_DESTINATION="${XCODE_DESTINATION:-platform=iOS Simulator,name=iPhone 16,OS=18.5,arch=arm64}"

if [ ! -f "$CONFIG_PATH" ]; then
  echo "Missing task config: $CONFIG_PATH" >&2
  exit 1
fi

mkdir -p "$RUN_DIR/screenshots"

cd "$REPO_ROOT" || exit 1

# Capture diff artifacts. Untracked files are listed separately because plain
# git diff does not include their contents until staged.
git diff HEAD -- . ':(exclude)runs/**' > "$RUN_DIR/diff.patch"
git diff --stat HEAD -- . ':(exclude)runs/**' > "$RUN_DIR/diff.stat"
git diff --numstat HEAD -- . ':(exclude)runs/**' > "$RUN_DIR/diff.numstat"
{
  git diff --name-only HEAD -- . ':(exclude)runs/**'
  git ls-files --others --exclude-standard | grep -v '^runs/' || true
} | awk 'NF && !seen[$0]++' > "$RUN_DIR/changed-files.txt"

# Run build and tests. Keep going even if either fails so result.json can report
# the failure instead of aborting the entire evaluation.
BUILD_STATUS=0
TEST_STATUS=0

cd "$MIRA_DIR" || exit 1

DEVELOPER_DIR="$DEVELOPER_DIR" xcodebuild build \
  -project "$XCODE_PROJECT" \
  -scheme "$XCODE_SCHEME" \
  -destination "$XCODE_DESTINATION" \
  > "$RUN_DIR/build.log" 2>&1 || BUILD_STATUS=$?

DEVELOPER_DIR="$DEVELOPER_DIR" xcodebuild test \
  -project "$XCODE_PROJECT" \
  -scheme "$XCODE_SCHEME" \
  -destination "$XCODE_DESTINATION" \
  > "$RUN_DIR/test.log" 2>&1 || TEST_STATUS=$?

cd "$REPO_ROOT" || exit 1

python3 "$SCRIPT_DIR/analyze-diff.py" "$TASK_ID" "$AGENT" \
  --repo-root "$REPO_ROOT" \
  --config "$CONFIG_PATH" \
  --run-dir "$RUN_DIR"

if [ "$BUILD_STATUS" -ne 0 ] || [ "$TEST_STATUS" -ne 0 ]; then
  echo "Evaluation completed with build/test failure. See $RUN_DIR/result.json"
  exit 1
fi

echo "Evaluation completed. See $RUN_DIR/result.json"
