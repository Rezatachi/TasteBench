# TasteBench

TasteBench is an open-source benchmark for evaluating whether AI coding agents can make product-quality SwiftUI changes.

The first benchmark app is **Mira**, a calm journaling app for daily reflection. Agents modify Mira by completing product tasks, and TasteBench evaluates the result with a mix of automated checks and human product review.

## Repository Structure

```text
TasteBench/
  Mira/                         # SwiftUI benchmark app
  tasks/                        # Benchmark task specs and configs
  runs/                         # Per-agent run outputs
  scripts/                      # Local evaluation scripts
  tests/                        # Tests for the evaluation tooling
```

## Product Principles

Read Mira's product principles before implementing tasks:

```text
Mira/docs/product-principles.md
```

Mira should feel quiet, editorial, warm, restrained, human, and native to iOS.

## Task 001: Add Settings Screen

The first benchmark task lives at:

```text
tasks/001-add-settings-screen/
```

It includes:

- `task.md` — task overview and scope
- `config.json` — automated evaluation configuration
- `scoring.md` — human + automated scoring rubric

The original agent prompt is also available in:

```text
Mira/tasks/001-add-settings-screen/agent-prompt.md
```

## Running an Evaluation

After an agent completes a task and leaves its changes in the working tree, run:

```bash
./scripts/evaluate-run.sh 001-add-settings-screen claude-code
```

The script creates:

```text
runs/claude-code/001-add-settings-screen/
  result.json
  build.log
  test.log
  diff.patch
  diff.stat
  diff.numstat
  changed-files.txt
  human-review.md
  screenshots/
```

## What Is Automated

The evaluation script automatically checks objective signals:

- Xcode build result
- Xcode test result
- files changed
- lines added and removed
- files changed outside the task's allowed paths
- raw color pattern usage
- design token keyword references
- accessibility keyword references

These are useful signals, but they are not the same thing as product taste.

## What Requires Human Review

TasteBench intentionally leaves product-quality scores as `null` in `result.json` until a human reviews the work.

Human review should judge:

- visual consistency
- restraint
- copy quality
- interaction quality
- whether the screen feels like Mira
- whether the change is shippable

The core thesis is:

> Some parts of product quality can be automated. The final judgment still requires human taste.

## Configuring Build and Test Commands

The evaluator defaults to:

```bash
MIRA_DIR="$REPO_ROOT/Mira"
DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
XCODE_PROJECT="Mira.xcodeproj"
XCODE_SCHEME="Mira"
XCODE_DESTINATION="platform=iOS Simulator,name=iPhone 16,OS=18.5,arch=arm64"
```

Override them when needed:

```bash
XCODE_DESTINATION='platform=iOS Simulator,name=iPhone 15,OS=18.5' \
./scripts/evaluate-run.sh 001-add-settings-screen claude-code
```

## Testing the Evaluation Tooling

Run:

```bash
python3 -m unittest discover -s tests -p 'test_*.py' -v
```
