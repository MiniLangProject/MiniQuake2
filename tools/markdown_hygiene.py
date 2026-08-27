#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Verify maintained Markdown structure, whitespace and relative links."""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from urllib.parse import unquote


EXCLUDED_DIRS = frozenset({".git", "build", "build_debug", "Quake-2-original-source"})
LINK_RE = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")
HEADING_RE = re.compile(r"^(#{1,6})\s+\S")
FENCE_RE = re.compile(r"^\s*(```|~~~)")


@dataclass(frozen=True)
class Issue:
    """Store issue data."""
    path: str
    line: int
    rule: str
    message: str


def maintained_markdown_files(root: Path) -> list[Path]:
    """Return maintained Markdown documents in deterministic path order."""
    return sorted(
        (
            path
            for path in root.rglob("*.md")
            if path.is_file()
            and not any(part in EXCLUDED_DIRS for part in path.relative_to(root).parts)
        ),
        key=lambda path: path.relative_to(root).as_posix(),
    )


def _link_path(raw_target: str) -> str | None:
    """Extract a local path from a simple CommonMark inline-link target."""
    target = raw_target.strip()
    if target.startswith("<") and ">" in target:
        target = target[1 : target.index(">")]
    else:
        target = target.split(maxsplit=1)[0]
    lowered = target.lower()
    if not target or target.startswith("#") or lowered.startswith(
        ("http://", "https://", "mailto:")
    ):
        return None
    return unquote(target.split("#", 1)[0])


def check_file(root: Path, path: Path) -> list[Issue]:
    """Check one Markdown file without interpreting fenced example content."""
    relative = path.relative_to(root).as_posix()
    try:
        lines = path.read_text(encoding="utf-8-sig").splitlines(keepends=True)
    except UnicodeDecodeError as exc:
        return [Issue(relative, exc.start, "encoding", "document is not valid UTF-8")]
    if not lines:
        return [Issue(relative, 1, "empty", "document is empty")]

    issues: list[Issue] = []
    fence = ""
    h1_count = 0
    previous_heading = 0
    for number, raw_line in enumerate(lines, start=1):
        line = raw_line.rstrip("\r\n")
        if line.endswith((" ", "\t")):
            issues.append(Issue(relative, number, "trailing-whitespace", "line has trailing whitespace"))
        fence_match = FENCE_RE.match(line)
        if fence_match:
            marker = fence_match.group(1)
            if not fence:
                fence = marker
            elif marker == fence:
                fence = ""
            continue
        if fence:
            continue

        heading = HEADING_RE.match(line)
        if heading:
            level = len(heading.group(1))
            if level == 1:
                h1_count += 1
            if previous_heading and level > previous_heading + 1:
                issues.append(
                    Issue(relative, number, "heading-order", "heading level skips its parent")
                )
            previous_heading = level

        for match in LINK_RE.finditer(line):
            local = _link_path(match.group(1))
            if local is None or not local:
                continue
            target = (path.parent / local).resolve()
            if not target.exists():
                issues.append(
                    Issue(relative, number, "relative-link", f"missing link target: {local}")
                )

    if fence:
        issues.append(Issue(relative, len(lines), "fence", "code fence is not closed"))
    if h1_count != 1:
        issues.append(Issue(relative, 1, "h1", f"expected exactly one level-1 heading, found {h1_count}"))
    return issues


def verify(root: Path) -> tuple[list[Path], list[Issue]]:
    """Verify every maintained Markdown document."""
    files = maintained_markdown_files(root)
    issues = [issue for path in files for issue in check_file(root, path)]
    issues.sort(key=lambda issue: (issue.path, issue.line, issue.rule))
    return files, issues


def main() -> int:
    """Run this source file's command-line entry point."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parent.parent)
    parser.add_argument("--json", type=Path, help="write the complete report as JSON")
    parser.add_argument("--quiet", action="store_true", help="suppress individual issue lines")
    args = parser.parse_args()

    root = args.root.resolve()
    files, issues = verify(root)
    report = {
        "root": str(root),
        "files_scanned": len(files),
        "issue_count": len(issues),
        "issues": [asdict(issue) for issue in issues],
    }
    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    if not args.quiet:
        for issue in issues:
            print(f"{issue.path}:{issue.line}: {issue.rule}: {issue.message}")
    print(f"markdown hygiene: {len(files)} files, {len(issues)} issues")
    return 1 if issues else 0


if __name__ == "__main__":
    sys.exit(main())
