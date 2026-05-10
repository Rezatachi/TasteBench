#!/usr/bin/env bash
set -euo pipefail

# Capture simulator screenshots for a TasteBench run by recreating the run in a
# temporary worktree, applying its diff.patch, adding a temporary screenshot host
# to MiraApp.swift, and launching specific screens directly.
#
# Usage:
#   ./scripts/capture-run-screenshots.sh <task-id> <agent> [appearance]
#
# Examples:
#   ./scripts/capture-run-screenshots.sh 003-dark-mode-fidelity codex dark
#   ./scripts/capture-run-screenshots.sh 002-journal-empty-state hermes light

TASK_ID="${1:-}"
AGENT="${2:-}"
APPEARANCE="${3:-dark}"

if [[ -z "$TASK_ID" || -z "$AGENT" ]]; then
  echo "Usage: $0 <task-id> <agent> [appearance: light|dark]" >&2
  exit 1
fi

if [[ "$APPEARANCE" != "light" && "$APPEARANCE" != "dark" ]]; then
  echo "Appearance must be 'light' or 'dark'" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RUN_DIR="$REPO_ROOT/runs/$AGENT/$TASK_ID"
PATCH_PATH="$RUN_DIR/diff.patch"
SCREENSHOT_DIR="$RUN_DIR/screenshots"

if [[ ! -f "$PATCH_PATH" ]]; then
  echo "Missing patch: $PATCH_PATH" >&2
  exit 1
fi

DEVELOPER_DIR="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"
DEVICE_NAME="${DEVICE_NAME:-iPhone 16}"
DEVICE_OS="${DEVICE_OS:-18.5}"
DEVICE_UDID="${DEVICE_UDID:-}"
if [[ -z "$DEVICE_UDID" ]]; then
  DEVICE_UDID="$(DEVELOPER_DIR="$DEVELOPER_DIR" xcrun simctl list devices available -j | python3 -c '
import json, sys
name, os_version = sys.argv[1], sys.argv[2]
data = json.load(sys.stdin)
wanted_runtime = "iOS-" + os_version.replace(".", "-")
for runtime, devices in data.get("devices", {}).items():
    if wanted_runtime not in runtime:
        continue
    for device in devices:
        if device.get("name") == name and device.get("isAvailable"):
            print(device["udid"])
            raise SystemExit(0)
raise SystemExit(1)
' "$DEVICE_NAME" "$DEVICE_OS")"
fi
DESTINATION="platform=iOS Simulator,id=$DEVICE_UDID"
BUNDLE_ID="com.tastebench.mira"
BASE_REF="${BASE_REF:-main}"
SHORT_TASK="${TASK_ID//[^A-Za-z0-9]/-}"
WORKTREE="${WORKTREE:-/tmp/tastebench-screenshots-$AGENT-$SHORT_TASK}"
DERIVED_DATA="${DERIVED_DATA:-/tmp/tastebench-screenshots-dd-$AGENT-$SHORT_TASK}"

case "$TASK_ID" in
  003-dark-mode-fidelity)
    SCREENS=(today journal entry-detail new-entry settings)
    ;;
  002-journal-empty-state)
    SCREENS=(journal-empty)
    ;;
  001-add-settings-screen)
    SCREENS=(settings today)
    ;;
  *)
    SCREENS=(today journal entry-detail new-entry settings)
    ;;
esac

mkdir -p "$SCREENSHOT_DIR"

echo "Preparing worktree: $WORKTREE"
if [[ -d "$WORKTREE" ]]; then
  git -C "$REPO_ROOT" worktree remove --force "$WORKTREE" >/dev/null 2>&1 || rm -rf "$WORKTREE"
fi

git -C "$REPO_ROOT" worktree add --detach "$WORKTREE" "$BASE_REF" >/dev/null

if [[ -s "$PATCH_PATH" ]]; then
  git -C "$WORKTREE" apply "$PATCH_PATH"
else
  echo "Patch is empty; using $BASE_REF app code."
fi

APP_FILE="$WORKTREE/Mira/Mira/App/MiraApp.swift"
python3 - "$APP_FILE" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
path.write_text('''import SwiftUI

@main
struct MiraApp: App {
    @StateObject private var journalViewModel = JournalViewModel()

    var body: some Scene {
        WindowGroup {
            screenshotRoot
        }
    }

    @ViewBuilder
    private var screenshotRoot: some View {
        let screen = ProcessInfo.processInfo.environment["MIRA_SCREENSHOT_SCREEN"] ?? "today"

        switch screen {
        case "journal":
            NavigationStack { JournalView(viewModel: journalViewModel) }
        case "journal-empty":
            NavigationStack { JournalView(viewModel: JournalViewModel(entries: [])) }
        case "entry-detail":
            NavigationStack {
                if let entry = journalViewModel.featuredEntry {
                    EntryDetailView(entry: entry)
                } else if let entry = SampleData.entries.first {
                    EntryDetailView(entry: entry)
                }
            }
        case "new-entry":
            NewEntryView(viewModel: journalViewModel)
        case "settings":
            NavigationStack { SettingsView() }
        default:
            TodayView(viewModel: journalViewModel)
        }
    }
}
''')
PY

echo "Booting simulator $DEVICE_NAME ($DEVICE_UDID)"
DEVELOPER_DIR="$DEVELOPER_DIR" xcrun simctl boot "$DEVICE_UDID" >/dev/null 2>&1 || true
open -a Simulator >/dev/null 2>&1 || true
DEVELOPER_DIR="$DEVELOPER_DIR" xcrun simctl bootstatus "$DEVICE_UDID" -b >/dev/null
DEVELOPER_DIR="$DEVELOPER_DIR" xcrun simctl ui "$DEVICE_UDID" appearance "$APPEARANCE" >/dev/null

echo "Building Mira for $AGENT / $TASK_ID"
rm -rf "$DERIVED_DATA"
DEVELOPER_DIR="$DEVELOPER_DIR" xcodebuild build \
  -project "$WORKTREE/Mira/Mira.xcodeproj" \
  -scheme Mira \
  -destination "$DESTINATION" \
  -derivedDataPath "$DERIVED_DATA" \
  -quiet

APP_PATH="$(find "$DERIVED_DATA/Build/Products" -name Mira.app -type d | head -1)"
if [[ -z "$APP_PATH" ]]; then
  echo "Could not locate built Mira.app under $DERIVED_DATA" >&2
  exit 1
fi

DEVELOPER_DIR="$DEVELOPER_DIR" xcrun simctl uninstall "$DEVICE_UDID" "$BUNDLE_ID" >/dev/null 2>&1 || true
DEVELOPER_DIR="$DEVELOPER_DIR" xcrun simctl install "$DEVICE_UDID" "$APP_PATH"

for SCREEN in "${SCREENS[@]}"; do
  echo "Capturing $SCREEN ($APPEARANCE)"
  DEVELOPER_DIR="$DEVELOPER_DIR" xcrun simctl terminate "$DEVICE_UDID" "$BUNDLE_ID" >/dev/null 2>&1 || true
  SIMCTL_CHILD_MIRA_SCREENSHOT_SCREEN="$SCREEN" \
    DEVELOPER_DIR="$DEVELOPER_DIR" xcrun simctl launch --terminate-running-process "$DEVICE_UDID" "$BUNDLE_ID" >/dev/null
  sleep 2
  OUT="$SCREENSHOT_DIR/result-$APPEARANCE-$SCREEN.png"
  DEVELOPER_DIR="$DEVELOPER_DIR" xcrun simctl io "$DEVICE_UDID" screenshot "$OUT" >/dev/null
  echo "  wrote $OUT"
done

cat > "$SCREENSHOT_DIR/comparison-notes.md" <<EOF_NOTES
# Screenshot Notes — $TASK_ID / $AGENT

Captured with scripts/capture-run-screenshots.sh.

- Appearance: $APPEARANCE
- Device: $DEVICE_NAME / iOS $DEVICE_OS / $DEVICE_UDID
- Base ref: $BASE_REF
- Run patch: $PATCH_PATH
- Temporary worktree: $WORKTREE
- Screens: ${SCREENS[*]}

The script temporarily patches MiraApp.swift in the worktree so each target screen can be launched directly for deterministic screenshot capture. This patch is not applied to the benchmark repository or included in the run diff.
EOF_NOTES

echo "Done. Screenshots in $SCREENSHOT_DIR"
