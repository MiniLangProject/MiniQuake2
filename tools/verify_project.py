#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0

"""Verify MiniQuake2 source syntax, inventory, manifest, and build hygiene.

The original Quake II source directory is an input reference, not part of the
MiniQuake2 delivery.  It is intentionally excluded from both the maintained
source inventory and SOURCE_MANIFEST.sha256.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
import tempfile
from collections import Counter
from dataclasses import asdict, dataclass
from pathlib import Path

MANIFEST_NAME = "SOURCE_MANIFEST.sha256"
REFERENCE_TREE = "Quake-2-original-source"
EXCLUDED_DIR_NAMES = {
    ".git",
    ".pytest_cache",
    "__pycache__",
    "build",
    "build_debug",
}
EXCLUDED_ROOT_FILES = {
    "miniquake2-crash.log",
}
FORBIDDEN_BUILD_SUFFIXES = {
    ".bsp",
    ".cin",
    ".dm2",
    ".md2",
    ".pak",
    ".pcx",
    ".sp2",
    ".wal",
    ".wav",
}
FORBIDDEN_BUILD_SOURCE_SUFFIXES = {".c", ".cc", ".cpp", ".h", ".hpp"}
FORBIDDEN_GAME_DIR_NAMES = {"baseq2", "ctf", "rogue", "xatrix"}
MISPLACED_BUILD_SUFFIXES = {".exe", ".exp", ".ilk", ".lib", ".obj", ".pdb"}
REQUIRED_PATHS = {
    ".gitignore",
    "LICENSE.md",
    "NOTICE.md",
    MANIFEST_NAME,
    "build.ps1",
    "native/README.md",
    "scripts/package.ps1",
    "scripts/test.ps1",
    "scripts/update_manifest.ps1",
    "src/main.ml",
    "tools/package_release.py",
    "tools/verify_project.py",
}
OPEN_TO_CLOSE = {"(": ")", "[": "]"}
CLOSE_TO_OPEN = {value: key for key, value in OPEN_TO_CLOSE.items()}


@dataclass(frozen=True)
class Issue:
    """Store issue data."""
    path: str
    line: int
    column: int
    message: str


def sha256(path: Path) -> str:
    """Return a streaming SHA-256 digest for *path*."""
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def is_excluded(rel: Path) -> bool:
    """Return whether *rel* belongs to generated or reference material."""
    if len(rel.parts) == 1 and rel.as_posix() in EXCLUDED_ROOT_FILES:
        return True
    if rel.parts and rel.parts[0] == REFERENCE_TREE:
        return True
    return any(part in EXCLUDED_DIR_NAMES for part in rel.parts)


def maintained_files(root: Path) -> list[Path]:
    """Enumerate maintained delivery files in deterministic path order."""
    result: list[Path] = []
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        rel = path.relative_to(root)
        if is_excluded(rel) or rel.as_posix() == MANIFEST_NAME:
            continue
        result.append(path)
    return sorted(result, key=lambda value: value.relative_to(root).as_posix().lower())


def minilang_files(root: Path) -> list[Path]:
    """Enumerate every maintained MiniLang translation unit."""
    return [path for path in maintained_files(root) if path.suffix.lower() == ".ml"]


def scan_minilang(path: Path, root: Path) -> list[Issue]:
    """Check UTF-8 and delimiter/string/comment balance in a MiniLang unit."""
    rel = path.relative_to(root).as_posix()
    raw = path.read_bytes()
    issues: list[Issue] = []
    if raw.startswith(b"\xef\xbb\xbf"):
        issues.append(Issue(rel, 1, 1, "UTF-8 BOM is not permitted"))
        raw = raw[3:]
    elif raw.startswith((b"\xff\xfe", b"\xfe\xff")):
        return [Issue(rel, 1, 1, "UTF-16 is not permitted; use UTF-8 without BOM")]
    try:
        text = raw.decode("utf-8", errors="strict")
    except UnicodeDecodeError as exc:
        return [Issue(rel, 1, 1, f"invalid UTF-8: {exc}")]

    stack: list[tuple[str, int, int]] = []
    state = "normal"
    block_depth = 0
    line = 1
    column = 1
    index = 0
    while index < len(text):
        char = text[index]
        following = text[index + 1] if index + 1 < len(text) else ""

        if state == "line-comment":
            if char == "\n":
                state = "normal"
        elif state == "block-comment":
            if char == "/" and following == "*":
                block_depth += 1
                index += 1
                column += 1
            elif char == "*" and following == "/":
                block_depth -= 1
                index += 1
                column += 1
                if block_depth == 0:
                    state = "normal"
        elif state == "string":
            if char == "\\" and index + 1 < len(text):
                index += 1
                column += 1
            elif char == '"':
                state = "normal"
        elif char == "/" and following == "/":
            state = "line-comment"
            index += 1
            column += 1
        elif char == "/" and following == "*":
            state = "block-comment"
            block_depth = 1
            index += 1
            column += 1
        elif char == '"':
            state = "string"
        elif char in OPEN_TO_CLOSE:
            stack.append((char, line, column))
        elif char in CLOSE_TO_OPEN:
            if not stack:
                issues.append(Issue(rel, line, column, f"unexpected closing delimiter {char!r}"))
            else:
                opener, open_line, open_column = stack.pop()
                expected = OPEN_TO_CLOSE[opener]
                if char != expected:
                    issues.append(Issue(
                        rel,
                        line,
                        column,
                        f"mismatched delimiter: {opener!r} at {open_line}:{open_column} expects {expected!r}",
                    ))

        if char == "\n":
            line += 1
            column = 1
        else:
            column += 1
        index += 1

    if state == "string":
        issues.append(Issue(rel, line, column, "unterminated string literal"))
    if state == "block-comment":
        issues.append(Issue(rel, line, column, "unterminated block comment"))
    for opener, open_line, open_column in stack:
        issues.append(Issue(
            rel,
            open_line,
            open_column,
            f"unclosed delimiter {opener!r}; expected {OPEN_TO_CLOSE[opener]!r}",
        ))
    return issues


def syntax_report(root: Path) -> dict[str, object]:
    """Build the MiniLang lexical verification report."""
    files = minilang_files(root)
    issues = [issue for path in files for issue in scan_minilang(path, root)]
    # The current MiniLang linker interns import aliases for the complete
    # transitive program.  Reusing one alias for different packages therefore
    # creates order-dependent member resolution even when the imports live in
    # different source files.  Make that integration constraint explicit.
    alias_pattern = re.compile(r"^\s*import\s+(\S+)\s+as\s+(\S+)\s*$")
    alias_targets: dict[str, dict[str, list[tuple[Path, int]]]] = {}
    for path in files:
        if path.relative_to(root).parts[0] != "src":
            continue
        for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            match = alias_pattern.match(line)
            if match is None:
                continue
            package, alias = match.groups()
            alias_targets.setdefault(alias, {}).setdefault(package, []).append((path, line_number))
    for alias, targets in sorted(alias_targets.items()):
        if len(targets) <= 1:
            continue
        descriptions = ", ".join(sorted(targets))
        first_path, first_line = next(iter(next(iter(targets.values()))))
        issues.append(Issue(
            first_path.relative_to(root).as_posix(),
            first_line,
            1,
            f"import alias {alias!r} maps to multiple packages: {descriptions}",
        ))
    return {
        "check": "minilang_syntax",
        "passed": not issues,
        "files_checked": len(files),
        "issues": [asdict(issue) for issue in issues],
    }


def build_hygiene_errors(root: Path) -> list[str]:
    """Reject copied retail assets and original C sources in build outputs."""
    errors: list[str] = []
    for directory_name in ("build", "build_debug"):
        output = root / directory_name
        if not output.is_dir():
            continue
        for path in output.rglob("*"):
            if not path.is_file():
                continue
            rel = path.relative_to(root).as_posix()
            suffix = path.suffix.lower()
            if any(part.lower() in FORBIDDEN_GAME_DIR_NAMES for part in path.relative_to(output).parts):
                errors.append(f"game-data directory in build output: {rel}")
            if suffix in FORBIDDEN_BUILD_SUFFIXES:
                errors.append(f"proprietary/retail asset in build output: {rel}")
            if suffix in FORBIDDEN_BUILD_SOURCE_SUFFIXES:
                errors.append(f"C/C++ reference source in build output: {rel}")
    return errors


def inventory_report(root: Path) -> dict[str, object]:
    """Describe the maintained tree and validate its delivery boundary."""
    files = maintained_files(root)
    paths = [path.relative_to(root).as_posix() for path in files]
    missing = sorted(path for path in REQUIRED_PATHS if not (root / path).is_file())
    errors = [f"required path missing: {path}" for path in missing]
    for path in files:
        if path.suffix.lower() in MISPLACED_BUILD_SUFFIXES:
            rel = path.relative_to(root).as_posix()
            errors.append(f"generated build artifact outside build directory: {rel}")
    errors.extend(build_hygiene_errors(root))
    suffix_counts = Counter(path.suffix.lower() or "<none>" for path in files)
    return {
        "check": "source_inventory",
        "passed": not errors,
        "maintained_file_count": len(files),
        "minilang_file_count": len([path for path in files if path.suffix.lower() == ".ml"]),
        "reference_tree": REFERENCE_TREE,
        "reference_tree_present": (root / REFERENCE_TREE).is_dir(),
        "reference_tree_included": False,
        "counts_by_suffix": dict(sorted(suffix_counts.items())),
        "maintained_files": paths,
        "errors": errors,
    }


def write_manifest(root: Path) -> int:
    """Atomically write hashes for exactly the maintained delivery files."""
    lines = [
        f"{sha256(path)} *{path.relative_to(root).as_posix()}\n"
        for path in maintained_files(root)
    ]
    destination = root / MANIFEST_NAME
    temporary = destination.with_suffix(destination.suffix + ".tmp")
    temporary.write_text("".join(lines), encoding="utf-8", newline="\n")
    temporary.replace(destination)
    return len(lines)


def parse_manifest(path: Path) -> tuple[dict[str, str], list[str]]:
    """Parse a coreutils-style SHA-256 manifest without unsafe paths."""
    entries: dict[str, str] = {}
    errors: list[str] = []
    if not path.is_file():
        return entries, [f"manifest missing: {path.name}"]
    for line_number, raw_line in enumerate(path.read_text(encoding="utf-8-sig").splitlines(), 1):
        if not raw_line.strip():
            continue
        match = re.fullmatch(r"([0-9a-fA-F]{64})\s+\*?(.+)", raw_line)
        if not match:
            errors.append(f"invalid manifest line {line_number}: {raw_line!r}")
            continue
        rel = match.group(2).replace("\\", "/")
        rel_path = Path(rel)
        if rel_path.is_absolute() or ".." in rel_path.parts:
            errors.append(f"unsafe manifest path at line {line_number}: {rel}")
            continue
        if rel == MANIFEST_NAME or is_excluded(rel_path):
            errors.append(f"excluded path listed in manifest: {rel}")
            continue
        if rel in entries:
            errors.append(f"duplicate manifest path: {rel}")
            continue
        entries[rel] = match.group(1).lower()
    return entries, errors


def manifest_report(root: Path) -> dict[str, object]:
    """Verify exact membership and hashes of the maintained source tree."""
    entries, errors = parse_manifest(root / MANIFEST_NAME)
    actual = {path.relative_to(root).as_posix(): path for path in maintained_files(root)}
    for rel in sorted(set(actual) - set(entries)):
        errors.append(f"file is not listed in manifest: {rel}")
    for rel in sorted(set(entries) - set(actual)):
        errors.append(f"manifest path is missing: {rel}")
    for rel in sorted(set(actual) & set(entries)):
        actual_hash = sha256(actual[rel])
        if actual_hash != entries[rel]:
            errors.append(f"hash mismatch: {rel}")
    return {
        "check": "source_manifest",
        "passed": not errors,
        "listed_file_count": len(entries),
        "actual_file_count": len(actual),
        "errors": errors,
    }


def run_self_test() -> tuple[bool, list[str]]:
    """Exercise success and failure paths without touching the workspace."""
    errors: list[str] = []
    with tempfile.TemporaryDirectory(prefix="miniquake2-verify-") as temp:
        root = Path(temp)
        for rel in REQUIRED_PATHS:
            path = root / rel
            path.parent.mkdir(parents=True, exist_ok=True)
            if rel == "src/main.ml":
                path.write_text("function main(args)\n  print len(args)\n  return 0\nend function\n", encoding="utf-8")
            elif rel != MANIFEST_NAME:
                path.write_text("test\n", encoding="utf-8")
        write_manifest(root)
        if not syntax_report(root)["passed"]:
            errors.append("valid MiniLang fixture failed syntax verification")
        if not inventory_report(root)["passed"]:
            errors.append("valid fixture failed inventory verification")
        if not manifest_report(root)["passed"]:
            errors.append("fresh manifest failed verification")

        (root / "src/main.ml").write_text("function main(args[)\nend function\n", encoding="utf-8")
        if syntax_report(root)["passed"]:
            errors.append("delimiter corruption was not detected")
        if manifest_report(root)["passed"]:
            errors.append("hash corruption was not detected")

        build = root / "build"
        build.mkdir()
        (build / "pak0.pak").write_bytes(b"not retail data")
        if inventory_report(root)["passed"]:
            errors.append("forbidden build asset was not detected")
    return not errors, errors


def print_report(report: dict[str, object]) -> None:
    """Print one concise, stable check summary."""
    status = "PASS" if report["passed"] else "FAIL"
    print(f"MiniQuake2 {report['check']}: {status}")
    for key in ("files_checked", "maintained_file_count", "minilang_file_count", "listed_file_count", "actual_file_count"):
        if key in report:
            print(f"  {key}={report[key]}")
    for issue in report.get("issues", []):
        print(f"  {issue['path']}:{issue['line']}:{issue['column']}: {issue['message']}")
    for error in report.get("errors", []):
        print(f"  {error}")


def main() -> int:
    """Run the selected verification workflow."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", default=".", help="MiniQuake2 repository root")
    parser.add_argument(
        "--mode",
        choices=("all", "syntax", "inventory", "manifest"),
        default="all",
    )
    parser.add_argument("--json", default="", help="optional JSON report path")
    parser.add_argument("--write-manifest", action="store_true")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()

    if args.self_test:
        passed, errors = run_self_test()
        print(f"MiniQuake2 verifier self-test: {'PASS' if passed else 'FAIL'}")
        for error in errors:
            print(f"  {error}")
        return 0 if passed else 1

    root = Path(args.root).resolve()
    if args.write_manifest:
        count = write_manifest(root)
        print(f"MiniQuake2 source manifest updated: {count} files")

    checks = {
        "syntax": syntax_report,
        "inventory": inventory_report,
        "manifest": manifest_report,
    }
    selected = list(checks) if args.mode == "all" else [args.mode]
    reports = [checks[name](root) for name in selected]
    for report in reports:
        print_report(report)

    combined = {
        "schema": "MiniQuake2ProjectVerification/1",
        "passed": all(bool(report["passed"]) for report in reports),
        "checks": reports,
    }
    if args.json:
        output = Path(args.json)
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(json.dumps(combined, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return 0 if combined["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
