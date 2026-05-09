#!/usr/bin/env python3
"""Generate TasteBench dashboard/report artifacts from run result.json files."""

from __future__ import annotations

import json
from datetime import datetime, timezone
from pathlib import Path
from statistics import mean

REPO_ROOT = Path(__file__).resolve().parents[1]
RUNS_DIR = REPO_ROOT / "runs"
REPORTS_DIR = REPO_ROOT / "reports"
DATA_PATH = REPORTS_DIR / "dashboard-data.json"
SNAPSHOT_PATH = REPORTS_DIR / "portfolio-snapshot.md"

SCORE_LABELS = {
    "functionalCorrectness": "Functional",
    "buildAndTestHealth": "Build/test",
    "visualConsistency": "Visual",
    "designSystemAdherence": "Design system",
    "interactionQuality": "Interaction",
    "restraint": "Restraint",
    "accessibility": "Accessibility",
    "regressionRisk": "Regression risk",
}


def load_results() -> list[dict]:
    results = []
    for path in sorted(RUNS_DIR.glob("*/*/result.json")):
        data = json.loads(path.read_text())
        data["resultPath"] = str(path.relative_to(REPO_ROOT))
        human_review = path.with_name("human-review.md")
        if human_review.exists():
            data["humanReviewPath"] = str(human_review.relative_to(REPO_ROOT))
        results.append(data)
    return results


def summarize(results: list[dict]) -> dict:
    scored = [r for r in results if isinstance(r.get("totalScore"), (int, float))]
    automated_passed = [
        r for r in results
        if r.get("automatedChecks", {}).get("buildPassed") is True
        and r.get("automatedChecks", {}).get("testsPassed") is True
    ]
    blocked_after_auto = [
        r for r in automated_passed
        if str(r.get("shipReadiness", "")).lower() in {"no", "blocked", "not-ready"}
    ]
    return {
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "runCount": len(results),
        "scoredRunCount": len(scored),
        "averageHumanScore": round(mean(r["totalScore"] for r in scored), 2) if scored else None,
        "automatedBuildAndTestPassCount": len(automated_passed),
        "automatedPassButHumanBlockedCount": len(blocked_after_auto),
        "agents": sorted({r.get("agent") for r in results if r.get("agent")}),
        "tasks": sorted({r.get("taskId") for r in results if r.get("taskId")}),
    }


def run_row(result: dict) -> str:
    checks = result.get("automatedChecks", {})
    score = result.get("totalScore")
    score_text = "pending" if score is None else f"{score}/{result.get('maxScore', 24)}"
    ship = result.get("shipReadiness") or "pending"
    return (
        f"| {result.get('taskId')} | {result.get('agent')} | "
        f"{checks.get('buildPassed')} | {checks.get('testsPassed')} | "
        f"{checks.get('filesChanged')} | {checks.get('linesAdded')} / {checks.get('linesRemoved')} | "
        f"{score_text} | {ship} |"
    )


def score_table(result: dict) -> list[str]:
    scores = result.get("scores") or {}
    if not any(v is not None for v in scores.values()):
        return ["Human scores pending."]
    lines = ["| Dimension | Score |", "| --- | ---: |"]
    for key, label in SCORE_LABELS.items():
        value = scores.get(key)
        lines.append(f"| {label} | {'pending' if value is None else str(value) + '/3'} |")
    return lines


def write_snapshot(results: list[dict], summary: dict) -> None:
    lines = [
        "# TasteBench Portfolio Snapshot",
        "",
        "TasteBench evaluates whether AI coding agents can make product-quality app changes, not just code that builds.",
        "",
        "## Current Dashboard Summary",
        "",
        f"- Runs captured: {summary['runCount']}",
        f"- Scored runs: {summary['scoredRunCount']}",
        f"- Average human score: {summary['averageHumanScore']}",
        f"- Build+test pass count: {summary['automatedBuildAndTestPassCount']}",
        f"- Automated pass but human-blocked count: {summary['automatedPassButHumanBlockedCount']}",
        f"- Agents: {', '.join(summary['agents'])}",
        f"- Tasks: {', '.join(summary['tasks'])}",
        "",
        "## Run Matrix",
        "",
        "| Task | Agent | Build | Tests | Files | + / - | Human score | Ship readiness |",
        "| --- | --- | --- | --- | ---: | ---: | ---: | --- |",
    ]
    lines.extend(run_row(r) for r in results)
    lines += [
        "",
        "## Early Findings",
        "",
        "1. Build/test success is necessary but not sufficient. Task 001 passed automation but failed human product review because visual spacing, motion, and alignment were not shippable.",
        "2. Small diffs can still show meaningful taste differences. For Task 002, both agents changed one file and passed automation, but the more restrained copy/hierarchy reviewed better.",
        "3. Product-management review needs separate language from code review: copy, hierarchy, restraint, interaction feel, and product fit deserve explicit scoring.",
        "",
        "## Per-Run Notes",
        "",
    ]
    for result in results:
        lines += [
            f"### {result.get('taskId')} — {result.get('agent')}",
            "",
            f"Result: `{result.get('resultPath')}`",
        ]
        if result.get("humanReviewPath"):
            lines.append(f"Human review: `{result.get('humanReviewPath')}`")
        lines += ["", result.get("summary", ""), ""]
        lines.extend(score_table(result))
        lines.append("")
    SNAPSHOT_PATH.write_text("\n".join(lines))


def main() -> None:
    REPORTS_DIR.mkdir(exist_ok=True)
    results = load_results()
    summary = summarize(results)
    DATA_PATH.write_text(json.dumps({"summary": summary, "runs": results}, indent=2) + "\n")
    write_snapshot(results, summary)
    print(f"Wrote {DATA_PATH.relative_to(REPO_ROOT)}")
    print(f"Wrote {SNAPSHOT_PATH.relative_to(REPO_ROOT)}")


if __name__ == "__main__":
    main()
