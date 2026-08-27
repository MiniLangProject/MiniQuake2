#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Verify objective source-header and comment-language hygiene rules.

This checker is intentionally independent of the regular build verifier. It
scans maintained MiniQuake2 source, test and tool code; imported reference
source and generated build trees are outside its scope.
"""

from __future__ import annotations

import argparse
import io
import json
import re
import sys
import tokenize
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable, Iterator


ALLOWED_LICENSES = frozenset({"Apache-2.0", "GPL-2.0-or-later"})
SOURCE_SUFFIXES = frozenset({".c", ".ml", ".py", ".ps1"})
SOURCE_DIRS = ("src", "tests", "tools", "scripts")
EXTRA_SOURCE_FILES = ("build.ps1", "docs/reference/generate_port_ledger.py")
HEADER_LINE_LIMIT = 16
SPDX_RE = re.compile(r"SPDX-License-Identifier:\s*([^\s*#]+)")
COPYRIGHT_RE = re.compile(r"\bcopyright\b", re.IGNORECASE)
SPECIAL_CHECKSUM_PATH = "src/miniquake2/qcommon/checksum.ml"

# This deliberately conservative vocabulary catches unambiguous German prose
# without pretending to be a general natural-language detector. Short words
# shared with identifiers or English prose (for example "die") are excluded.
NON_ENGLISH_COMMENT_RE = re.compile(
    r"(?:[äöüß]|\b(?:"
    r"nicht|wird|werden|fuer|einen|einer|diese|dieser|hierbei|wenn|sonst|"
    r"bereits|muss|muessen|soll|fehler|datei|verzeichnis|pruefung|"
    r"zurueck|erzeugt|entfernt|hinzugefuegt|funktioniert|beispiel|"
    r"eingabe|ausgabe"
    r")\b)",
    re.IGNORECASE,
)


@dataclass(frozen=True)
class Issue:
    """Store issue data."""
    path: str
    line: int
    rule: str
    message: str


def maintained_source_files(root: Path) -> list[Path]:
    """Return the deterministic set of maintained code files in verifier scope."""
    files: list[Path] = []
    for source_dir in SOURCE_DIRS:
        base = root / source_dir
        if not base.is_dir():
            continue
        files.extend(
            path
            for path in base.rglob("*")
            if path.is_file() and path.suffix.lower() in SOURCE_SUFFIXES
        )
    for relative in EXTRA_SOURCE_FILES:
        extra = root / relative
        if extra.is_file():
            files.append(extra)
    return sorted(set(files), key=lambda path: path.relative_to(root).as_posix())


def _ml_comments(text: str) -> Iterator[tuple[int, str]]:
    """Yield MiniLang comments while ignoring comment tokens inside strings."""
    index = 0
    line = 1
    length = len(text)
    state = "code"
    block_depth = 0
    comment_line = 1
    comment: list[str] = []

    while index < length:
        char = text[index]
        following = text[index + 1] if index + 1 < length else ""

        if state == "code":
            if char == '"':
                state = "string"
            elif char == "/" and following == "/":
                state = "line_comment"
                comment_line = line
                comment = []
                index += 1
            elif char == "/" and following == "*":
                state = "block_comment"
                block_depth = 1
                comment_line = line
                comment = []
                index += 1
        elif state == "string":
            if char == "\\":
                index += 1
            elif char == '"':
                state = "code"
        elif state == "line_comment":
            if char in "\r\n":
                yield comment_line, "".join(comment)
                state = "code"
            else:
                comment.append(char)
        else:
            if char == "/" and following == "*":
                block_depth += 1
                comment.append("/*")
                index += 1
            elif char == "*" and following == "/":
                block_depth -= 1
                index += 1
                if block_depth == 0:
                    yield comment_line, "".join(comment)
                    state = "code"
                else:
                    comment.append("*/")
            else:
                comment.append(char)

        if char == "\n":
            line += 1
        index += 1

    if state in {"line_comment", "block_comment"}:
        yield comment_line, "".join(comment)


def _python_comments(text: str) -> Iterator[tuple[int, str]]:
    """Yield Python comments using the standard tokenizer."""
    try:
        tokens = tokenize.generate_tokens(io.StringIO(text).readline)
        for token in tokens:
            if token.type == tokenize.COMMENT:
                yield token.start[0], token.string[1:]
    except (IndentationError, tokenize.TokenError):
        # Syntax verification belongs to the build verifier. A partially edited
        # file must not make this independent hygiene audit crash.
        return


def _powershell_comments(text: str) -> Iterator[tuple[int, str]]:
    """Yield PowerShell line and block comments outside quoted strings."""
    index = 0
    line = 1
    length = len(text)
    quote = ""

    while index < length:
        char = text[index]
        following = text[index + 1] if index + 1 < length else ""
        if quote:
            if quote == '"' and char == "`":
                index += 1
            elif char == quote:
                # PowerShell escapes a quote inside the same quote type by
                # doubling it (single quotes) or with a backtick (both types).
                if following == quote:
                    index += 1
                else:
                    quote = ""
        elif char in {'"', "'"}:
            quote = char
        elif char == "#":
            start = line
            end = text.find("\n", index)
            if end < 0:
                end = length
            yield start, text[index + 1 : end]
            index = end - 1
        elif char == "<" and following == "#":
            start = line
            end = text.find("#>", index + 2)
            if end < 0:
                end = length
            yield start, text[index + 2 : end]
            line += text[index:end].count("\n")
            index = min(end + 1, length - 1)
        if char == "\n":
            line += 1
        index += 1


def comments_for(path: Path, text: str) -> Iterable[tuple[int, str]]:
    """Dispatch comment extraction according to the source language."""
    suffix = path.suffix.lower()
    if suffix in {".c", ".ml"}:
        return _ml_comments(text)
    if suffix == ".py":
        return _python_comments(text)
    if suffix == ".ps1":
        return _powershell_comments(text)
    return ()


def _header_text(path: Path, text: str) -> str:
    """Return only real comments from the legal-header line window."""
    header_source = "\n".join(text.splitlines()[:HEADER_LINE_LIMIT]) + "\n"
    return "\n".join(comment for _, comment in comments_for(path, header_source))


def _generated_header(suffix: str, newline: str) -> str:
    """Build the repository-default legal header for a previously bare file."""
    if suffix in {".c", ".ml"}:
        lines = [
            "/*",
            "Copyright (c) 2026 Nils Kopal",
            "SPDX-License-Identifier: GPL-2.0-or-later",
            "*/",
            "",
        ]
    else:
        lines = [
            "# Copyright (c) 2026 Nils Kopal",
            "# SPDX-License-Identifier: Apache-2.0",
            "",
        ]
    return newline.join(lines)


def _prepend_offset(text: str, suffix: str) -> int:
    """Keep Python shebang/encoding declarations ahead of an inserted header."""
    if suffix != ".py":
        return 0
    lines = text.splitlines(keepends=True)
    offset = 0
    index = 0
    if lines and lines[0].startswith("#!"):
        offset += len(lines[0])
        index = 1
    if index < len(lines) and re.match(r"^[ \t]*#.*coding[:=]", lines[index]):
        offset += len(lines[index])
    return offset


def _add_checksum_spdx(text: str, newline: str) -> str | None:
    """Add GPL SPDX metadata inside the preserved RSA MD4 notice."""
    lines = text.splitlines()
    copyright_indexes = [
        index
        for index, line in enumerate(lines[:HEADER_LINE_LIMIT])
        if COPYRIGHT_RE.search(line)
    ]
    if not copyright_indexes:
        return None
    insert_at = copyright_indexes[-1] + 1
    lines.insert(insert_at, "SPDX-License-Identifier: GPL-2.0-or-later")
    result = newline.join(lines)
    if text.endswith(("\n", "\r")):
        result += newline
    return result


def fix_file(root: Path, path: Path) -> bool:
    """Fill an objectively absent legal header without replacing existing text."""
    raw = path.read_bytes()
    bom = raw.startswith(b"\xef\xbb\xbf")
    payload = raw[3:] if bom else raw
    try:
        text = payload.decode("utf-8")
    except UnicodeDecodeError:
        return False
    header = _header_text(path, text)
    licenses = SPDX_RE.findall(header)
    has_copyright = COPYRIGHT_RE.search(header) is not None
    relative = path.relative_to(root).as_posix()
    newline = "\r\n" if "\r\n" in text else "\n"

    updated: str | None = None
    if relative == SPECIAL_CHECKSUM_PATH and not licenses and has_copyright:
        updated = _add_checksum_spdx(text, newline)
    elif not licenses and not has_copyright:
        offset = _prepend_offset(text, path.suffix.lower())
        updated = text[:offset] + _generated_header(path.suffix.lower(), newline) + text[offset:]
    # Partial, duplicate, unsupported and already present legal headers require
    # a human licensing decision; the fixer never rewrites or guesses them.
    if updated is None or updated == text:
        return False
    encoded = updated.encode("utf-8")
    if bom:
        encoded = b"\xef\xbb\xbf" + encoded
    path.write_bytes(encoded)
    return True


def check_file(root: Path, path: Path) -> list[Issue]:
    """Check one source file and return stable, line-addressed violations."""
    relative = path.relative_to(root).as_posix()
    try:
        text = path.read_text(encoding="utf-8-sig")
    except UnicodeDecodeError as exc:
        return [Issue(relative, exc.start, "encoding", "source is not valid UTF-8")]

    issues: list[Issue] = []
    # Only actual comments count as a legal header. String literals containing
    # SPDX-like fixture text must not satisfy or duplicate the declaration.
    header = _header_text(path, text)
    licenses = SPDX_RE.findall(header)
    if not licenses:
        issues.append(Issue(relative, 1, "spdx", "missing SPDX license identifier in header"))
    elif len(licenses) > 1:
        issues.append(Issue(relative, 1, "spdx", "multiple SPDX license identifiers in header"))
    elif licenses[0] not in ALLOWED_LICENSES:
        issues.append(
            Issue(relative, 1, "spdx", f"unsupported SPDX license identifier: {licenses[0]}")
        )
    if not COPYRIGHT_RE.search(header):
        issues.append(Issue(relative, 1, "copyright", "missing copyright notice in header"))

    for line, comment in comments_for(path, text):
        for offset, comment_line in enumerate(comment.splitlines() or [comment]):
            marker = NON_ENGLISH_COMMENT_RE.search(comment_line)
            if marker:
                issues.append(
                    Issue(
                        relative,
                        line + offset,
                        "comment-language",
                        f"non-English comment marker: {marker.group(0)}",
                    )
                )
    return issues


def verify(root: Path) -> tuple[list[Path], list[Issue]]:
    """Verify all maintained source files under ``root``."""
    files = maintained_source_files(root)
    issues: list[Issue] = []
    for path in files:
        issues.extend(check_file(root, path))
    issues.sort(key=lambda issue: (issue.path, issue.line, issue.rule))
    return files, issues


def main() -> int:
    """Run this source file's command-line entry point."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parent.parent)
    parser.add_argument("--json", type=Path, help="write the complete report as JSON")
    parser.add_argument("--quiet", action="store_true", help="suppress individual issue lines")
    parser.add_argument(
        "--fix",
        action="store_true",
        help="add only objectively missing default headers; never replace existing headers",
    )
    args = parser.parse_args()

    root = args.root.resolve()
    files = maintained_source_files(root)
    fixed_paths: list[str] = []
    if args.fix:
        for path in files:
            if fix_file(root, path):
                fixed_paths.append(path.relative_to(root).as_posix())
    files, issues = verify(root)
    report = {
        "root": str(root),
        "files_scanned": len(files),
        "files_fixed": len(fixed_paths),
        "fixed_paths": fixed_paths,
        "issue_count": len(issues),
        "issues": [asdict(issue) for issue in issues],
    }
    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    if not args.quiet:
        for issue in issues:
            print(f"{issue.path}:{issue.line}: {issue.rule}: {issue.message}")
    print(
        f"source hygiene: {len(files)} files, {len(fixed_paths)} fixed, "
        f"{len(issues)} issues"
    )
    return 1 if issues else 0


if __name__ == "__main__":
    sys.exit(main())
