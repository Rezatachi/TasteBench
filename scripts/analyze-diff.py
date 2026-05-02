#!/usr/bin/env python3
"""Analyze a TasteBench task diff and write a structured result.json.

This script intentionally limits itself to objective heuristics. It can tell us
whether the app built, whether tests passed, how large the diff was, whether the
agent used design-token keywords, and whether suspicious raw color patterns show
up in changed files. It does not pretend to score taste; human review fields stay
null until a person evaluates product quality.
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterable


SCORES_TEMPLATE = {
    "functionalCorrectness": None,
    "buildAndTestHealth": None,
    "visualConsistency": None,
    "designSystemAdherence": None,
    "interactionQuality": None,
    "restraint": None,
    "accessibility": None,
    "regressionRisk": None,
}


IGNORED_CHANGED_PREFIXES = (
    "runs/",
    "dashboard/",
    ".git/",
)

IGNORED_CHANGED_SUFFIXES = (
    ".pyc",
)


def run_git(repo_root: Path, args: list[str]) -> str:
    completed = subprocess.run(
        ["git", *args],
        cwd=repo_root,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if completed.returncode != 0:
        return ""
    return completed.stdout


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def parse_numstat(numstat_text: str) -> tuple[int, int]:
    added = 0
    removed = 0
    for line in numstat_text.splitlines():
        parts = line.split("\t")
        if len(parts) < 3:
            continue
        # Binary files use '-' in numstat output. Treat them as zero lines.
        if parts[0].isdigit():
            added += int(parts[0])
        if parts[1].isdigit():
            removed += int(parts[1])
    return added, removed


def normalize_changed_files(paths: Iterable[str]) -> list[str]:
    normalized: list[str] = []
    for raw_path in paths:
        path = raw_path.strip()
        if not path:
            continue
        path = path.replace("\\", "/")
        if path.startswith(IGNORED_CHANGED_PREFIXES) or path.endswith(IGNORED_CHANGED_SUFFIXES):
            continue
        if path not in normalized:
            normalized.append(path)
    return normalized


def changed_files_from_git(repo_root: Path) -> list[str]:
    tracked = run_git(repo_root, ["diff", "--name-only", "HEAD", "--", "."])
    untracked = run_git(repo_root, ["ls-files", "--others", "--exclude-standard"])
    return normalize_changed_files([*tracked.splitlines(), *untracked.splitlines()])


def numstat_from_git(repo_root: Path) -> str:
    return run_git(repo_root, ["diff", "--numstat", "HEAD", "--", "."])


def count_patterns(text: str, patterns: Iterable[str]) -> int:
    total = 0
    for pattern in patterns:
        total += len(re.findall(pattern, text))
    return total


def count_plain_keywords(text: str, keywords: Iterable[str]) -> int:
    return sum(text.count(keyword) for keyword in keywords)


def file_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return ""
    except FileNotFoundError:
        return ""


def is_allowed_file(path: str, allowed_prefixes: Iterable[str]) -> bool:
    normalized = path.replace("\\", "/")
    return any(normalized.startswith(prefix) for prefix in allowed_prefixes)


def parse_numstat_paths(numstat_text: str) -> set[str]:
    paths: set[str] = set()
    for line in numstat_text.splitlines():
        parts = line.split("\t")
        if len(parts) >= 3:
            paths.add(parts[2])
    return paths


def count_file_lines(path: Path) -> int:
    text = file_text(path)
    if not text:
        return 0
    return len(text.splitlines())


def analyze_changed_files(
    repo_root: Path,
    changed_files: list[str],
    numstat_text: str,
    config: dict[str, Any],
) -> dict[str, Any]:
    changed_files = normalize_changed_files(changed_files)
    lines_added, lines_removed = parse_numstat(numstat_text)
    numstat_paths = parse_numstat_paths(numstat_text)

    # Plain git diff --numstat does not include untracked files. Count untracked
    # text files as all-added lines so early benchmark runs still produce useful
    # diff-size signals before files are staged.
    for relative_path in changed_files:
        if relative_path not in numstat_paths and (repo_root / relative_path).exists():
            lines_added += count_file_lines(repo_root / relative_path)

    raw_color_usages = 0
    design_token_references = 0
    accessibility_references = 0

    for relative_path in changed_files:
        # Design-system, raw-color, and accessibility heuristics are intended for
        # SwiftUI source, not benchmark docs/config files that may mention these
        # strings as examples.
        if not relative_path.endswith(".swift"):
            continue
        text = file_text(repo_root / relative_path)
        raw_color_usages += count_patterns(text, config.get("disallowedRawColorPatterns", []))
        design_token_references += count_plain_keywords(text, config.get("designTokenKeywords", []))
        accessibility_references += count_plain_keywords(text, config.get("accessibilityKeywords", []))

    allowed_prefixes = config.get("allowedChangedPaths", [])
    unrelated = [
        path
        for path in changed_files
        if allowed_prefixes and not is_allowed_file(path, allowed_prefixes)
    ]

    return {
        "filesChanged": len(changed_files),
        "linesAdded": lines_added,
        "linesRemoved": lines_removed,
        "rawColorUsages": raw_color_usages,
        "designTokenReferences": design_token_references,
        "accessibilityReferences": accessibility_references,
        "unrelatedFilesChanged": unrelated,
    }


def log_looks_successful(log_text: str) -> bool:
    upper = log_text.upper()
    hard_failure_markers = (
        "** BUILD FAILED **",
        "** TEST FAILED **",
        "TESTS FAILED",
        "TESTING FAILED:",
        "THE FOLLOWING BUILD COMMANDS FAILED",
        "XCODEBUILD: ERROR:",
    )
    if any(marker in upper for marker in hard_failure_markers):
        return False
    return "SUCCEEDED" in upper or "TEST SUCCEEDED" in upper or "BUILD SUCCEEDED" in upper


def read_log_success(path: Path) -> bool:
    if not path.exists():
        return False
    return log_looks_successful(path.read_text(encoding="utf-8", errors="ignore"))


def make_result(
    repo_root: Path,
    task_id: str,
    agent: str,
    run_dir: Path,
    config: dict[str, Any],
) -> dict[str, Any]:
    changed_files_path = run_dir / "changed-files.txt"
    numstat_path = run_dir / "diff.numstat"

    if changed_files_path.exists():
        changed_files = normalize_changed_files(changed_files_path.read_text(encoding="utf-8").splitlines())
    else:
        changed_files = changed_files_from_git(repo_root)

    if numstat_path.exists():
        numstat_text = numstat_path.read_text(encoding="utf-8")
    else:
        numstat_text = numstat_from_git(repo_root)

    automated = analyze_changed_files(repo_root, changed_files, numstat_text, config)
    build_passed = read_log_success(run_dir / "build.log")
    tests_passed = read_log_success(run_dir / "test.log")
    automated = {
        "buildPassed": build_passed,
        "testsPassed": tests_passed,
        **automated,
    }

    status = "completed" if build_passed and tests_passed else "failed"

    return {
        "taskId": task_id,
        "taskName": config.get("taskName", task_id),
        "agent": agent,
        "status": status,
        "timestamp": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "automatedChecks": automated,
        "scores": dict(SCORES_TEMPLATE),
        "totalScore": None,
        "maxScore": 24,
        "shipReadiness": None,
        "summary": (
            "Automated checks generated. Human review is still required for taste, "
            "visual consistency, restraint, copy quality, and final ship readiness."
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate a TasteBench result.json from a task diff.")
    parser.add_argument("task_id")
    parser.add_argument("agent")
    parser.add_argument("--repo-root", default=".")
    parser.add_argument("--config", default=None)
    parser.add_argument("--run-dir", default=None)
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve()
    config_path = Path(args.config).resolve() if args.config else repo_root / "tasks" / args.task_id / "config.json"
    run_dir = Path(args.run_dir).resolve() if args.run_dir else repo_root / "runs" / args.agent / args.task_id
    run_dir.mkdir(parents=True, exist_ok=True)

    config = read_json(config_path)
    result = make_result(repo_root, args.task_id, args.agent, run_dir, config)

    output_path = run_dir / "result.json"
    output_path.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
