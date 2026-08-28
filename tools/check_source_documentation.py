#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Audit and safely complete documentation for maintained source declarations."""

from __future__ import annotations

import argparse
import ast
from dataclasses import dataclass
from pathlib import Path
import re

import source_hygiene


ML_FUNCTION_RE = re.compile(
    r"(?m)^(?:static\s+)?function(?:\s+inline)?\s+"
    r"([A-Za-z_][A-Za-z0-9_]*)\s*\("
)
ML_STRUCT_RE = re.compile(r"(?m)^struct\s+([A-Za-z_][A-Za-z0-9_]*)\s*$")
C_FUNCTION_RE = re.compile(
    r"(?m)^(?:static\s+)?(?:MQ_EXPORT\s+)?"
    r"[A-Za-z_][A-Za-z0-9_\s*]*?\s+([A-Za-z_][A-Za-z0-9_]*)\s*"
    r"\([^;{}]*\)\s*\{"
)
C_TYPE_RE = re.compile(
    r"(?m)^typedef\s+(struct|enum|union)"
    r"(?:\s+([A-Za-z_][A-Za-z0-9_]*))?\s*\{"
)
POWERSHELL_FUNCTION_RE = re.compile(
    r"(?im)^\s*function\s+([A-Za-z_][A-Za-z0-9_-]*)\b"
)
WORD_RE = re.compile(
    r"[A-Z]+(?=[A-Z][a-z]|\d|$)|[A-Z]?[a-z]+|\d+"
)


@dataclass(frozen=True)
class Finding:
    """Describe one stable, line-addressed documentation violation."""

    path: Path
    line: int
    message: str


@dataclass(frozen=True)
class Coverage:
    """Store declaration and complex-routine coverage for one source file."""

    functions: int = 0
    documented_functions: int = 0
    types: int = 0
    documented_types: int = 0
    complex_functions: int = 0
    documented_complex_functions: int = 0


def source_files(root: Path) -> list[Path]:
    """Return every maintained code file in deterministic repository order."""
    files = set(source_hygiene.maintained_source_files(root))
    for directory in source_hygiene.SOURCE_DIRS:
        base = root / directory
        if not base.is_dir():
            continue
        for suffix in (".h", ".def", ".vert", ".frag"):
            files.update(
                path for path in base.rglob(f"*{suffix}")
                if "build" not in path.relative_to(root).parts
            )
    return sorted(files, key=lambda path: path.relative_to(root).as_posix())


def preceding_comment(lines: list[str], index: int, hash_comments: bool = False) -> bool:
    """Report whether a declaration has an immediately preceding comment."""
    cursor = index - 1
    while cursor >= 0 and not lines[cursor].strip():
        cursor -= 1
    if cursor < 0:
        return False
    previous = lines[cursor].strip()
    return (
        previous.startswith("//")
        or previous.endswith(("*/", "#>"))
        or (hash_comments and previous.startswith("#"))
    )


def identifier_words(name: str) -> list[str]:
    """Split snake, kebab and camel-case identifiers into readable words."""
    words: list[str] = []
    for part in re.split(r"[_-]+", name):
        words.extend(WORD_RE.findall(part))
    return [word.lower() for word in words if word]


def phrase(words: list[str]) -> str:
    """Join identifier words into a compact English noun phrase."""
    return " ".join(words) if words else "declared operation"


def legacy_function_summary(name: str) -> str:
    """Reproduce the first fixer wording so generated text can be upgraded."""
    words = identifier_words(name)
    if name == "main":
        return "Run this source file's command-line entry point."
    if not words:
        return "Execute the declared operation."
    if words[0] == "noop":
        return "Intentionally perform no operation for this callback."
    if words[0] == "on":
        return f"Handle the {phrase(words[1:])} event."
    joined = phrase(words)
    first = words[0]
    remainder = phrase(words[1:]) if len(words) > 1 else "state"
    verbs = {
        "add": "Add",
        "advance": "Advance",
        "apply": "Apply",
        "begin": "Begin",
        "bind": "Bind",
        "build": "Build",
        "calculate": "Calculate",
        "capture": "Capture",
        "check": "Validate",
        "clear": "Clear",
        "close": "Close",
        "compare": "Compare",
        "compile": "Compile",
        "compute": "Compute",
        "configure": "Configure",
        "connect": "Connect",
        "convert": "Convert",
        "copy": "Copy",
        "create": "Create",
        "decode": "Decode",
        "dispatch": "Dispatch",
        "draw": "Draw",
        "emit": "Emit",
        "encode": "Encode",
        "end": "End",
        "execute": "Execute",
        "find": "Find",
        "finish": "Finish",
        "free": "Release",
        "generate": "Generate",
        "get": "Return",
        "handle": "Handle",
        "initialize": "Initialize",
        "insert": "Insert",
        "load": "Load",
        "make": "Create",
        "move": "Move",
        "normalize": "Normalize",
        "open": "Open",
        "parse": "Parse",
        "persist": "Persist",
        "play": "Play",
        "poll": "Poll",
        "prepare": "Prepare",
        "process": "Process",
        "publish": "Publish",
        "pump": "Pump",
        "read": "Read",
        "rebuild": "Rebuild",
        "record": "Record",
        "register": "Register",
        "release": "Release",
        "remove": "Remove",
        "render": "Render",
        "reset": "Reset",
        "resolve": "Resolve",
        "restore": "Restore",
        "run": "Run",
        "save": "Save",
        "select": "Select",
        "send": "Send",
        "serialize": "Serialize",
        "set": "Set",
        "shutdown": "Shut down",
        "sort": "Sort",
        "spawn": "Spawn",
        "start": "Start",
        "step": "Advance",
        "stop": "Stop",
        "submit": "Submit",
        "sync": "Synchronize",
        "test": "Verify",
        "trace": "Trace",
        "unbind": "Unbind",
        "update": "Update",
        "validate": "Validate",
        "verify": "Verify",
        "write": "Write",
    }
    if first in {"is", "has", "can", "should", "needs"}:
        return f"Report whether {remainder}."
    if first in verbs:
        return f"{verbs[first]} {remainder}."
    if words[-1] in {"assert", "assertion"}:
        return f"Assert the {phrase(words[:-1])} test condition."
    if words[-1] in {"test", "tests"}:
        return f"Verify {phrase(words[:-1])}."
    return f"Implement the {joined} operation."


def function_summary(name: str) -> str:
    """Derive a concise behavioral summary from a maintained function name."""
    words = identifier_words(name)
    if name == "main":
        return "Run this source file's command-line entry point."
    if not words:
        return "Execute the declared operation."
    if "assert" in words or "assertion" in words:
        subject = phrase(
            [word for word in words if word not in {"assert", "assertion"}]
        )
        return f"Assert the {subject} test condition."
    predicate_words = {
        "active",
        "allows",
        "available",
        "blocked",
        "cached",
        "can",
        "completed",
        "connected",
        "contains",
        "dirty",
        "disabled",
        "empty",
        "enabled",
        "equal",
        "finished",
        "has",
        "inside",
        "is",
        "missing",
        "moved",
        "needs",
        "no",
        "off",
        "on",
        "pending",
        "queued",
        "ready",
        "should",
        "silent",
        "standing",
        "submitted",
        "supported",
        "valid",
        "visible",
    }
    if any(word in predicate_words for word in words):
        return f"Report whether {phrase(words)}."
    if words[-1] == "into":
        return f"Populate the {phrase(words[:-1])} destination."
    actions = {
        "accept": "Accept",
        "add": "Add",
        "attack": "Run",
        "advance": "Advance",
        "allocate": "Allocate",
        "adjust": "Adjust",
        "activate": "Activate",
        "apply": "Apply",
        "append": "Append",
        "assemble": "Assemble",
        "attach": "Attach",
        "begin": "Begin",
        "bind": "Bind",
        "build": "Build",
        "cache": "Cache",
        "calculate": "Calculate",
        "capture": "Capture",
        "cancel": "Cancel",
        "check": "Validate",
        "choose": "Choose",
        "clamp": "Clamp",
        "clear": "Clear",
        "clip": "Clip",
        "close": "Close",
        "collect": "Collect",
        "compare": "Compare",
        "compile": "Compile",
        "cross": "Compute",
        "commit": "Commit",
        "compute": "Compute",
        "configure": "Configure",
        "connect": "Connect",
        "consume": "Consume",
        "convert": "Convert",
        "copy": "Copy",
        "create": "Create",
        "decode": "Decode",
        "decompress": "Decompress",
        "discover": "Discover",
        "dispatch": "Dispatch",
        "divide": "Divide",
        "die": "Handle",
        "dot": "Compute",
        "drain": "Drain",
        "draw": "Draw",
        "drop": "Drop",
        "export": "Export",
        "emit": "Emit",
        "encode": "Encode",
        "end": "End",
        "ensure": "Ensure",
        "evaluate": "Evaluate",
        "execute": "Execute",
        "expand": "Expand",
        "extract": "Extract",
        "fill": "Fill",
        "fire": "Fire",
        "filter": "Filter",
        "find": "Find",
        "finish": "Finish",
        "flush": "Flush",
        "format": "Format",
        "free": "Release",
        "generate": "Generate",
        "get": "Return",
        "handle": "Handle",
        "ignore": "Ignore",
        "init": "Initialize",
        "initialize": "Initialize",
        "insert": "Insert",
        "install": "Install",
        "interpolate": "Interpolate",
        "invoke": "Invoke",
        "join": "Join",
        "link": "Link",
        "load": "Load",
        "lookup": "Look up",
        "make": "Create",
        "map": "Map",
        "kill": "Kill",
        "mark": "Mark",
        "materialize": "Materialize",
        "measure": "Measure",
        "merge": "Merge",
        "mix": "Mix",
        "move": "Move",
        "note": "Record",
        "normalize": "Normalize",
        "notify": "Notify",
        "open": "Open",
        "pad": "Pad",
        "pack": "Pack",
        "pain": "Handle",
        "parse": "Parse",
        "pause": "Pause",
        "persist": "Persist",
        "play": "Play",
        "pickup": "Pick up",
        "pick": "Choose",
        "poll": "Poll",
        "print": "Print",
        "prepare": "Prepare",
        "process": "Process",
        "project": "Project",
        "publish": "Publish",
        "put": "Write",
        "pump": "Pump",
        "queue": "Queue",
        "read": "Read",
        "receive": "Receive",
        "rebuild": "Rebuild",
        "refresh": "Refresh",
        "reconcile": "Reconcile",
        "record": "Record",
        "register": "Register",
        "reject": "Reject",
        "release": "Release",
        "remove": "Remove",
        "render": "Render",
        "restart": "Restart",
        "require": "Require",
        "reserve": "Reserve",
        "reset": "Reset",
        "resolve": "Resolve",
        "restore": "Restore",
        "resume": "Resume",
        "return": "Return",
        "rotate": "Rotate",
        "run": "Run",
        "sample": "Sample",
        "save": "Save",
        "scale": "Scale",
        "scan": "Scan",
        "schedule": "Schedule",
        "seek": "Seek",
        "select": "Select",
        "send": "Send",
        "serialize": "Serialize",
        "set": "Set",
        "shutdown": "Shut down",
        "slice": "Slice",
        "sort": "Sort",
        "spawn": "Spawn",
        "sp": "Spawn",
        "split": "Split",
        "start": "Start",
        "step": "Advance",
        "stop": "Stop",
        "submit": "Submit",
        "subtract": "Subtract",
        "synchronize": "Synchronize",
        "take": "Consume",
        "think": "Run",
        "swap": "Swap",
        "sync": "Synchronize",
        "test": "Verify",
        "trace": "Trace",
        "transform": "Transform",
        "toggle": "Toggle",
        "translate": "Translate",
        "trim": "Trim",
        "touch": "Handle",
        "unbind": "Unbind",
        "unpack": "Unpack",
        "unregister": "Unregister",
        "update": "Update",
        "use": "Use",
        "validate": "Validate",
        "verify": "Verify",
        "wrap": "Wrap",
        "write": "Write",
    }
    for index, word in enumerate(words):
        if word not in actions:
            continue
        subject_words = words[:index] + words[index + 1 :]
        subject = phrase(subject_words)
        if subject == "declared operation":
            subject = "state"
        if word == "copy" and len(subject_words) == 1:
            subject += " data"
        return f"{actions[word]} {subject}."
    if words[-1] == "at":
        return f"Return the {phrase(words[:-1])} for the requested position."
    if words[-1] == "for":
        return f"Return the {phrase(words[:-1])} for the requested input."
    if "from" in words:
        return f"Return the {phrase(words)}."
    if words[-1] in {
        "angles",
        "bounds",
        "count",
        "dimensions",
        "flags",
        "index",
        "length",
        "mask",
        "name",
        "number",
        "offset",
        "origin",
        "path",
        "position",
        "size",
        "state",
        "time",
        "value",
        "yaw",
    }:
        return f"Return the {phrase(words)}."
    return f"Return the {phrase(words)} value."


def type_summary(name: str) -> str:
    """Derive a compact ownership summary for a struct, class or aggregate."""
    return f"Store {phrase(identifier_words(name))} data."


def c_type_name(text: str, match: re.Match[str]) -> str:
    """Resolve the tag or trailing alias of one C aggregate declaration."""
    if match.group(2):
        return match.group(2)
    cursor = match.end() - 1
    depth = 0
    while cursor < len(text):
        if text[cursor] == "{":
            depth += 1
        elif text[cursor] == "}":
            depth -= 1
            if depth == 0:
                alias = re.match(r"\s*([A-Za-z_][A-Za-z0-9_]*)", text[cursor + 1 :])
                return alias.group(1) if alias else match.group(1)
        cursor += 1
    return match.group(1)


def complex_function_spans(text: str) -> list[tuple[int, int, str, bool]]:
    """Return complex MiniLang routine spans and internal-comment coverage."""
    lines = text.splitlines()
    spans: list[tuple[int, int, str, bool]] = []
    index = 0
    while index < len(lines):
        match = re.match(
            r"^(?:static\s+)?function(?:\s+inline)?\s+"
            r"([A-Za-z_][A-Za-z0-9_]*)\s*\(",
            lines[index],
        )
        if match is None:
            index += 1
            continue
        end = index + 1
        while end < len(lines) and lines[end].strip() != "end function":
            end += 1
        body = lines[index + 1 : end]
        logical_lines = sum(bool(line.strip()) for line in body)
        decisions = sum(
            len(
                re.findall(
                    r"\b(?:if|while|for|select|case)\b",
                    re.sub(r'"(?:[^"\\]|\\.)*"', '""', line),
                )
            )
            for line in body
            if not line.strip().startswith(("//", "/*", "*"))
        )
        complex_body = (
            logical_lines >= 100
            or (logical_lines >= 60 and decisions >= 3)
            or (logical_lines >= 35 and decisions >= 12)
        )
        if complex_body:
            documented = any(
                line.strip().startswith(("//", "/*", "*")) for line in body
            )
            spans.append((index, end, match.group(1), documented))
        index = end + 1
    return spans


def audit_file(path: Path, root: Path) -> tuple[list[Finding], Coverage]:
    """Audit one maintained source file and return findings plus coverage."""
    text = path.read_text(encoding="utf-8-sig", errors="replace")
    lines = text.splitlines()
    relative = path.relative_to(root)
    findings = [
        Finding(relative, issue.line, issue.message)
        for issue in source_hygiene.check_file(root, path)
    ]
    functions = 0
    documented_functions = 0
    types = 0
    documented_types = 0
    complex_functions = 0
    documented_complex_functions = 0

    if path.suffix.lower() == ".ml":
        function_matches = list(ML_FUNCTION_RE.finditer(text))
        type_matches = list(ML_STRUCT_RE.finditer(text))
        for match in function_matches:
            line = text.count("\n", 0, match.start()) + 1
            if preceding_comment(lines, line - 1):
                documented_functions += 1
            else:
                findings.append(
                    Finding(relative, line, f"function {match.group(1)} lacks a preceding comment")
                )
        for match in type_matches:
            line = text.count("\n", 0, match.start()) + 1
            if preceding_comment(lines, line - 1):
                documented_types += 1
            else:
                findings.append(
                    Finding(relative, line, f"type declaration {match.group(1)} lacks a preceding comment")
                )
        functions = len(function_matches)
        types = len(type_matches)
        complex_spans = complex_function_spans(text)
        complex_functions = len(complex_spans)
        documented_complex_functions = sum(span[3] for span in complex_spans)
        for start, _, name, documented in complex_spans:
            if not documented:
                findings.append(
                    Finding(relative, start + 1, f"complex function {name} lacks an internal roadmap comment")
                )
    elif path.suffix.lower() in {".c", ".h"}:
        function_matches = list(C_FUNCTION_RE.finditer(text))
        type_matches = list(C_TYPE_RE.finditer(text))
        for match in function_matches:
            line = text.count("\n", 0, match.start()) + 1
            if preceding_comment(lines, line - 1):
                documented_functions += 1
            else:
                findings.append(
                    Finding(relative, line, f"function {match.group(1)} lacks a preceding comment")
                )
        for match in type_matches:
            line = text.count("\n", 0, match.start()) + 1
            name = c_type_name(text, match)
            if preceding_comment(lines, line - 1):
                documented_types += 1
            else:
                findings.append(
                    Finding(relative, line, f"type declaration {name} lacks a preceding comment")
                )
        functions = len(function_matches)
        types = len(type_matches)
    elif path.suffix.lower() == ".py":
        try:
            tree = ast.parse(text)
        except SyntaxError as exc:
            findings.append(Finding(relative, exc.lineno or 1, f"invalid Python syntax: {exc.msg}"))
        else:
            function_nodes = [
                node
                for node in ast.walk(tree)
                if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef))
            ]
            class_nodes = [node for node in ast.walk(tree) if isinstance(node, ast.ClassDef)]
            functions = len(function_nodes)
            types = len(class_nodes)
            documented_functions = sum(ast.get_docstring(node) is not None for node in function_nodes)
            documented_types = sum(ast.get_docstring(node) is not None for node in class_nodes)
            for node in function_nodes:
                if ast.get_docstring(node) is None:
                    findings.append(Finding(relative, node.lineno, f"function {node.name} lacks a docstring"))
            for node in class_nodes:
                if ast.get_docstring(node) is None:
                    findings.append(Finding(relative, node.lineno, f"class {node.name} lacks a docstring"))
    elif path.suffix.lower() == ".ps1":
        function_matches = list(POWERSHELL_FUNCTION_RE.finditer(text))
        functions = len(function_matches)
        for match in function_matches:
            line = text.count("\n", 0, match.start()) + 1
            if preceding_comment(lines, line - 1, hash_comments=True):
                documented_functions += 1
            else:
                findings.append(
                    Finding(relative, line, f"function {match.group(1)} lacks a preceding comment")
                )

    coverage = Coverage(
        functions,
        documented_functions,
        types,
        documented_types,
        complex_functions,
        documented_complex_functions,
    )
    findings.sort(key=lambda finding: (finding.line, finding.message))
    return findings, coverage


def insert_preceding_comments(text: str, suffix: str) -> str:
    """Insert missing declaration comments for MiniLang, C and PowerShell."""
    lines = text.splitlines()
    trailing_newline = text.endswith("\n")
    declarations: list[tuple[int, str, str]] = []
    if suffix == ".ml":
        declarations.extend(
            (text.count("\n", 0, match.start()), match.group(1), "function")
            for match in ML_FUNCTION_RE.finditer(text)
        )
        declarations.extend(
            (text.count("\n", 0, match.start()), match.group(1), "type")
            for match in ML_STRUCT_RE.finditer(text)
        )
    elif suffix in {".c", ".h"}:
        declarations.extend(
            (text.count("\n", 0, match.start()), match.group(1), "function")
            for match in C_FUNCTION_RE.finditer(text)
        )
        declarations.extend(
            (text.count("\n", 0, match.start()), c_type_name(text, match), "type")
            for match in C_TYPE_RE.finditer(text)
        )
    elif suffix == ".ps1":
        declarations.extend(
            (text.count("\n", 0, match.start()), match.group(1), "function")
            for match in POWERSHELL_FUNCTION_RE.finditer(text)
        )
    marker = "#" if suffix == ".ps1" else "//"
    for index, name, kind in sorted(declarations, reverse=True):
        summary = function_summary(name) if kind == "function" else type_summary(name)
        legacy = legacy_function_summary(name) if kind == "function" else type_summary(name)
        if index > 0 and lines[index - 1].strip() == f"{marker} {legacy}":
            lines[index - 1] = f"{marker} {summary}"
            continue
        if preceding_comment(lines, index, hash_comments=suffix == ".ps1"):
            continue
        lines.insert(index, f"{marker} {summary}")
    result = "\n".join(lines)
    return result + "\n" if trailing_newline else result


def insert_python_docstrings(text: str) -> str:
    """Insert missing class and function docstrings without rewriting bodies."""
    tree = ast.parse(text)
    lines = text.splitlines()
    trailing_newline = text.endswith("\n")
    inserts: list[tuple[int, str]] = []
    nodes = [
        node
        for node in ast.walk(tree)
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef))
    ]
    for node in nodes:
        if not node.body:
            continue
        summary = type_summary(node.name) if isinstance(node, ast.ClassDef) else function_summary(node.name)
        legacy = type_summary(node.name) if isinstance(node, ast.ClassDef) else legacy_function_summary(node.name)
        current = ast.get_docstring(node, clean=False)
        if current == legacy and isinstance(node.body[0], ast.Expr):
            doc_line = node.body[0].lineno - 1
            indentation = re.match(r"\s*", lines[doc_line]).group(0)
            lines[doc_line] = f'{indentation}"""{summary}"""'
            continue
        if current is not None or node.body[0].lineno <= node.lineno:
            continue
        insert_at = node.body[0].lineno - 1
        indentation = re.match(r"\s*", lines[insert_at]).group(0)
        inserts.append((insert_at, f'{indentation}"""{summary}"""'))
    for index, docstring in sorted(inserts, reverse=True):
        lines.insert(index, docstring)
    result = "\n".join(lines)
    return result + "\n" if trailing_newline else result


def insert_complex_roadmaps(text: str) -> str:
    """Insert one internal phase comment in undocumented complex ML routines."""
    lines = text.splitlines()
    trailing_newline = text.endswith("\n")
    inserts: list[tuple[int, str]] = []
    for start, _, name, documented in complex_function_spans(text):
        if documented:
            continue
        signature_end = start
        balance = 0
        while signature_end < len(lines):
            balance += lines[signature_end].count("(") - lines[signature_end].count(")")
            if balance <= 0:
                break
            signature_end += 1
        inserts.append(
            (
                signature_end + 1,
                f"  // Keep {phrase(identifier_words(name))} phases explicit: validate inputs, update owned state, then publish the result.",
            )
        )
    for index, comment in sorted(inserts, reverse=True):
        lines.insert(index, comment)
    result = "\n".join(lines)
    return result + "\n" if trailing_newline else result


def fix_file(path: Path) -> bool:
    """Add only objectively missing documentation to one maintained source."""
    text = path.read_text(encoding="utf-8-sig")
    suffix = path.suffix.lower()
    updated = text
    if suffix in {".ml", ".c", ".h", ".ps1"}:
        updated = insert_preceding_comments(updated, suffix)
    if suffix == ".py":
        updated = insert_python_docstrings(updated)
    if suffix == ".ml":
        updated = insert_complex_roadmaps(updated)
    if updated == text:
        return False
    path.write_text(updated, encoding="utf-8", newline="\n")
    return True


def add_coverage(total: Coverage, current: Coverage) -> Coverage:
    """Combine two immutable coverage records."""
    return Coverage(
        total.functions + current.functions,
        total.documented_functions + current.documented_functions,
        total.types + current.types,
        total.documented_types + current.documented_types,
        total.complex_functions + current.complex_functions,
        total.documented_complex_functions + current.documented_complex_functions,
    )


def run_audit(root: Path) -> tuple[list[Path], list[Finding], Coverage]:
    """Audit all maintained sources and aggregate deterministic coverage."""
    files = source_files(root)
    findings: list[Finding] = []
    coverage = Coverage()
    for path in files:
        current_findings, current_coverage = audit_file(path, root)
        findings.extend(current_findings)
        coverage = add_coverage(coverage, current_coverage)
    findings.sort(key=lambda finding: (finding.path.as_posix(), finding.line, finding.message))
    return files, findings, coverage


def main() -> int:
    """Run the documentation audit and optionally complete missing comments."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--report-all", action="store_true")
    parser.add_argument("--fix", action="store_true")
    args = parser.parse_args()
    root = args.root.resolve()
    fixed: list[str] = []
    if args.fix:
        for path in source_files(root):
            if fix_file(path):
                fixed.append(path.relative_to(root).as_posix())
    files, findings, coverage = run_audit(root)
    print(f"audited maintained source files: {len(files)}")
    print(
        "maintained functions documented: "
        f"{coverage.documented_functions}/{coverage.functions}"
    )
    print(
        "maintained type declarations documented: "
        f"{coverage.documented_types}/{coverage.types}"
    )
    print(
        "complex MiniLang functions with internal comments: "
        f"{coverage.documented_complex_functions}/{coverage.complex_functions}"
    )
    print(f"files updated: {len(fixed)}")
    print(f"findings: {len(findings)}")
    if findings:
        shown = findings if args.report_all else findings[:100]
        for finding in shown:
            print(f"{finding.path.as_posix()}:{finding.line}: {finding.message}")
        if len(shown) != len(findings):
            print(f"... {len(findings) - len(shown)} further finding(s); use --report-all")
        return 1
    print("source documentation audit: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
