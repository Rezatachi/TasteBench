# TasteBench Visual Dashboard Roadmap

Goal: turn TasteBench from a set of run artifacts into an explainable, beautiful product-evaluation dashboard with side-by-side model graphs and task screenshots.

## Desired End State

A viewer can open one local/public artifact and immediately understand:

1. What each task asked the agent to do.
2. Which model/agent worked on each task.
3. Whether the run built and tested successfully.
4. How much code changed.
5. Where automation passed but product taste failed.
6. How human scores differed by rubric dimension.
7. What the app looked like before/after through screenshots.
8. Why the winning model won.

## Phase 1 — Data Model Cleanup

Add screenshot and visualization metadata to each run artifact.

Target structure:

```text
runs/<agent>/<task-id>/
  result.json
  human-review.md
  diff.patch
  build.log
  test.log
  screenshots/
    baseline-light.png
    baseline-dark.png
    result-light.png
    result-dark.png
    comparison-notes.md
```

Suggested `result.json` additions:

```json
{
  "screenshots": {
    "baselineLight": "runs/.../screenshots/baseline-light.png",
    "baselineDark": "runs/.../screenshots/baseline-dark.png",
    "resultLight": "runs/.../screenshots/result-light.png",
    "resultDark": "runs/.../screenshots/result-dark.png"
  },
  "reviewHighlights": [
    "Build/test passed, but product review blocked shipping",
    "Clean token usage separated the winner from a merely valid run"
  ]
}
```

## Phase 2 — Screenshot Capture

Capture screenshots for the Mira app screens most relevant to each task.

Core screens:

- Today
- Journal
- Entry Detail
- New Entry
- Settings

For each benchmark task, capture only the relevant screens:

- Task 001 Settings Screen: Settings, Today navigation entry point
- Task 002 Journal Empty State: Journal empty state
- Task 003 Dark Mode Fidelity: Today, Journal, Entry Detail, New Entry, Settings in dark mode

Preferred approach:

1. Build and install each run onto an iOS Simulator.
2. Use `xcrun simctl ui <device> appearance light|dark`.
3. Launch Mira.
4. Navigate deterministically to target screens, ideally via UI tests or launch arguments.
5. Capture screenshots with `xcrun simctl io booted screenshot <path>`.
6. Store screenshots under the run directory.

If deterministic UI navigation is too slow initially, use a manual first pass:

1. Open the relevant run in Xcode/simulator.
2. Navigate to the target screen.
3. Save screenshots into the expected run directory.
4. Add notes in `comparison-notes.md` describing exactly what was captured.

## Phase 3 — Explainable Graphs

Create a designed dashboard artifact from `reports/dashboard-data.json`.

Recommended file:

```text
reports/tastebench-dashboard.html
```

Graph modules:

1. Score by task and model
   - grouped bar chart
   - x-axis: task
   - y-axis: human score out of 24
   - color: model/agent

2. Rubric radar or small-multiple bars
   - one panel per model/run
   - dimensions: functional, build/test, visual, design system, interaction, restraint, accessibility, regression risk
   - explainable labels, not just shapes

3. Automation vs human decision
   - build/test pass indicators beside ship-readiness badges
   - highlights cases where automation passed but human review blocked shipping

4. Diff footprint
   - files changed, lines added, lines removed
   - raw color usages and design-token references
   - useful for showing implementation quality and reviewability

5. Task story cards
   - prompt summary
   - winner
   - what automation saw
   - what human review saw
   - screenshot thumbnails

Design direction:

- Editorial, warm, restrained, matching Mira/TasteBench.
- Avoid generic SaaS analytics dashboards.
- Use large readable typography, sparse charts, and human-readable annotations.
- Every graph should answer a specific product-evaluation question.

## Phase 4 — Generate Static Assets

Add a generator script:

```text
scripts/generate-dashboard.py
```

Inputs:

- `runs/*/*/result.json`
- `runs/*/*/human-review.md`
- screenshot files, when present
- task docs under `tasks/*/task.md` and `tasks/*/scoring.md`

Outputs:

- `reports/dashboard-data.json`
- `reports/portfolio-snapshot.md`
- `reports/tastebench-dashboard.html`
- optionally `reports/assets/*.png` thumbnails or exported chart screenshots

## Phase 5 — Public Portfolio Layer

Once screenshots and dashboard are in place, create:

```text
reports/portfolio-case-study.md
reports/x-thread-draft.md
```

Thesis arc:

1. Task 001: automation passed, product taste failed.
2. Task 002: both agents solved the task, but human copy/hierarchy judgment separated them.
3. Task 003: both agents were shippable, but design-system hygiene separated the winner.
4. TasteBench evaluates agents as product builders, not just code generators.

## Immediate Next Actions

1. Add screenshot directories for existing runs.
2. Implement a first `tastebench-dashboard.html` that renders current data without screenshots.
3. Add screenshot placeholders and clear missing-screenshot states.
4. Capture real screenshots for Task 003 first, because dark-mode fidelity is the most visual task so far.
5. Commit and push the dashboard artifact.
6. Then add screenshot automation or UI-test-driven navigation.

## Open Implementation Questions

- Should the dashboard be a self-contained static HTML artifact, or a small app under `dashboard/`?
- Should screenshots represent exact agent worktrees, or the final preferred/manual implementation?
- Do we want model names to be agent surfaces (`codex`, `hermes`, `claude-code`) or underlying models/providers once available?

Recommended defaults:

- Start with self-contained static HTML in `reports/tastebench-dashboard.html`.
- Store screenshots at the run level.
- Label current results by agent surface, then add provider/model metadata later.
