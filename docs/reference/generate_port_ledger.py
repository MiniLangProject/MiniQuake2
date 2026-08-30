#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Generate MiniQuake2's deterministic Quake II 3.19 reference inventory.

The inventory is deliberately source-oriented.  Every Git-tracked reference
file is recorded, and every C function definition in ``*.c`` and ``*.h`` is
classified as an unported reference.  The extractor follows the formatting of
the released id Software sources: comments are removed while preserving line
numbers and translation-unit function definitions are recognized at column
zero.  Static helpers and conditionally compiled duplicate definitions remain
separate entries because all observable reference behavior must be accounted
for during the port.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
from collections import Counter
from pathlib import Path


EXPECTED_COMMIT = "372afde46e7defc9dd2d719a1732b8ace1fa096e"

FUNCTION_RE = re.compile(
    r"(?ms)^"
    r"(?:(?:static|extern|inline|__inline)\s+)*"
    r"(?:"
    r"[A-Za-z_][A-Za-z0-9_]*(?:\s+|\s*\*\s*)"
    r"|\([^;\n{}]*\)\s*"
    r")+?"
    r"([A-Za-z_][A-Za-z0-9_]*)\s*"
    r"\(([^;{}]*?)\)\s*\{"
)

C_EXTENSIONS = {".c", ".h"}
NATIVE_SOURCE_EXTENSIONS = {".asm", ".s", ".i386", ".axp", ".m"}
BUILD_EXTENSIONS = {
    ".def", ".dsp", ".dsw", ".mak", ".project", ".rc",
    ".inc", ".iconheader", ".bat",
}
TEXT_EXTENSIONS = {".txt", ".cfg", ""}


def sha256_bytes(data: bytes) -> str:
    """Perform sha 256 bytes processing."""
    return hashlib.sha256(data).hexdigest()


def run_git(root: Path, *args: str) -> str:
    """Run git."""
    return subprocess.check_output(
        ["git", "-C", str(root), *args],
        text=True,
        encoding="utf-8",
        errors="strict",
    ).strip()


def tracked_files(root: Path) -> list[str]:
    """Perform tracked files processing."""
    paths = [line for line in run_git(root, "ls-files").splitlines() if line]
    return sorted(path.replace("\\", "/") for path in paths)


def strip_comments_preserve_lines(text: str) -> str:
    """Perform strip comments preserve lines processing."""
    def block(match: re.Match[str]) -> str:
        """Perform block processing."""
        return "\n" * match.group(0).count("\n")

    text = re.sub(r"/\*.*?\*/", block, text, flags=re.S)
    return re.sub(r"//[^\n]*", "", text)


def file_kind(path: str, raw: bytes) -> str:
    """Perform file kind processing."""
    suffix = Path(path).suffix.lower()
    if suffix == ".c":
        return "c_translation_unit"
    if suffix == ".h":
        return "c_header"
    if suffix in NATIVE_SOURCE_EXTENSIONS:
        return "non_c_native_source"
    if suffix in BUILD_EXTENSIONS:
        return "build_metadata"
    if path.startswith("baseq2/"):
        return "bundled_game_data"
    if suffix in TEXT_EXTENSIONS:
        return "documentation_or_configuration"
    if b"\0" in raw[:8192]:
        return "binary_reference_artifact"
    return "reference_artifact"


def classify(path: str) -> tuple[str, int, str, str]:
    """Return subsystem, plan point, scope, and disposition for a file."""
    name = Path(path).name.lower()

    if path.startswith("baseq2/"):
        return "proprietary_game_data", 1, "asset_excluded", "do_not_redistribute"
    if path.startswith("ctf/"):
        return "ctf_game_module", 9, "deferred", "reference_only"
    if path.startswith(("linux/", "irix/", "solaris/", "rhapsody/", "unix/")):
        return "non_windows_platform_reference", 10, "out_of_scope", "reference_only"
    if path.startswith("ref_soft/"):
        return "software_renderer", 10, "deferred", "reference_only"
    if path.startswith("ref_gl/"):
        return "opengl_renderer", 6, "release_required", "planned_port"
    if path.startswith("server/"):
        return "server", 8, "release_required", "planned_port"
    if path.startswith("game/"):
        return "baseq2_game", 9, "release_required", "planned_port"
    if path.startswith("qcommon/"):
        if name in {"cmodel.c", "qfiles.h"}:
            return "formats_and_collision", 4, "release_required", "planned_port"
        if name in {"net_chan.c", "pmove.c"}:
            return "protocol_and_shared_movement", 7, "release_required", "planned_port"
        return "qcommon", 3, "release_required", "planned_port"
    if path.startswith("client/"):
        if name.startswith("snd_") or name in {"sound.h", "snd_loc.h", "cdaudio.h"}:
            return "audio", 5, "release_required", "planned_port"
        if name in {"ref.h", "vid.h", "screen.h"}:
            return "renderer_frontend", 6, "release_required", "planned_port"
        if name == "cl_cin.c":
            return "cinematics", 4, "release_required", "planned_port"
        return "client", 7, "release_required", "planned_port"
    if path.startswith("null/"):
        return "headless_platform", 5, "release_required", "planned_port"
    if path.startswith("win32/"):
        if name.startswith(("qgl_", "glw_", "vid_", "rw_")) or name in {"glw_win.h", "rw_win.h"}:
            if name.startswith("rw_"):
                return "software_renderer_platform", 10, "deferred", "reference_only"
            return "windows_renderer_platform", 6, "release_required", "planned_port"
        return "windows_platform", 5, "release_required", "planned_port"
    return "reference_distribution_metadata", 1, "reference_only", "reference_only"


def extract_definitions(path: Path, relative: str) -> list[dict[str, object]]:
    """Perform extract definitions processing."""
    text = path.read_text(encoding="latin-1", errors="replace")
    clean = strip_comments_preserve_lines(text)
    subsystem, point, scope, disposition = classify(relative)
    definitions: list[dict[str, object]] = []
    for ordinal, match in enumerate(FUNCTION_RE.finditer(clean), 1):
        name = match.group(1)
        line = clean.count("\n", 0, match.start()) + 1
        signature = name + "(" + " ".join(match.group(2).split()) + ")"
        definitions.append({
            "id": f"{relative}:{line}:{name}:{ordinal}",
            "name": name,
            "line": line,
            "signature_sha256": sha256_bytes(signature.encode("utf-8")),
            "status": "reference",
            "planned_subsystem": subsystem,
            "plan_point": point,
            "scope": scope,
            "disposition": disposition,
        })
    return definitions


def make_ledger(reference_root: Path) -> dict[str, object]:
    """Create ledger."""
    commit = run_git(reference_root, "rev-parse", "HEAD")
    if commit != EXPECTED_COMMIT:
        raise RuntimeError(
            f"reference commit mismatch: expected {EXPECTED_COMMIT}, got {commit}"
        )
    if run_git(reference_root, "status", "--porcelain"):
        raise RuntimeError("reference source has local changes; inventory would not be canonical")

    paths = tracked_files(reference_root)
    files: list[dict[str, object]] = []
    functions: list[dict[str, object]] = []
    tree_rows: list[str] = []
    kind_counts: Counter[str] = Counter()
    scope_counts: Counter[str] = Counter()
    subsystem_file_counts: Counter[str] = Counter()
    subsystem_function_counts: Counter[str] = Counter()

    for relative in paths:
        path = reference_root / Path(relative)
        raw = path.read_bytes()
        digest = sha256_bytes(raw)
        kind = file_kind(relative, raw)
        subsystem, point, scope, disposition = classify(relative)
        definitions = (
            extract_definitions(path, relative)
            if path.suffix.lower() in C_EXTENSIONS
            else []
        )
        for definition in definitions:
            functions.append({"source": relative, **definition})
            subsystem_function_counts[subsystem] += 1
        files.append({
            "path": relative,
            "sha256": digest,
            "bytes": len(raw),
            "kind": kind,
            "status": "reference",
            "planned_subsystem": subsystem,
            "plan_point": point,
            "scope": scope,
            "disposition": disposition,
            "function_definition_count": len(definitions),
        })
        tree_rows.append(f"{digest}  {relative}\n")
        kind_counts[kind] += 1
        scope_counts[scope] += 1
        subsystem_file_counts[subsystem] += 1

    c_files = sum(1 for item in files if item["kind"] == "c_translation_unit")
    h_files = sum(1 for item in files if item["kind"] == "c_header")
    source_tree_digest = sha256_bytes("".join(tree_rows).encode("utf-8"))

    document: dict[str, object] = {
        "schema": "MiniQuake2PortLedger/1",
        "project": "MiniQuake2",
        "ledger_state": "reference_inventory_with_current_gate_snapshot",
        "compatibility_target": {
            "engine": "Quake II 3.19",
            "reference_platform": "Win32/x86 behavior",
            "target_platform": "Windows x64",
            "network_protocol": 34,
            "bsp_version": 38,
            "game_api_version": 3,
            "renderer_api_version": 3,
            "game_directory": "baseq2",
            "minilang_owns_engine_and_gameplay": True,
            "native_boundary": "OS, device, UDP, and graphics-driver access only",
            "binary_game_dll_abi": "deferred",
            "binary_renderer_dll_abi": "deferred",
        },
        "reference": {
            "path_label": "Quake-2-original-source",
            "version": "3.19",
            "git_commit": commit,
            "git_subject": run_git(reference_root, "log", "-1", "--format=%s"),
            "tracked_tree_sha256": source_tree_digest,
            "tracked_file_count": len(files),
            "c_translation_unit_count": c_files,
            "c_header_count": h_files,
            "c_and_header_count": c_files + h_files,
            "c_function_definition_count": len(functions),
            "function_extractor": "column-zero definition regex; comments removed with line preservation",
            "function_inventory_semantics": "definitions, including static and conditional duplicates; prototypes excluded",
            "status_meaning": "reference means inventoried original behavior, not implemented MiniLang behavior",
        },
        "inventory_counts": {
            "by_kind": dict(sorted(kind_counts.items())),
            "by_scope": dict(sorted(scope_counts.items())),
            "files_by_subsystem": dict(sorted(subsystem_file_counts.items())),
            "functions_by_subsystem": dict(sorted(subsystem_function_counts.items())),
        },
        "acceptance_gates": [
            {"id": "G01", "plan_point": 1, "status": "complete", "criterion": "compatibility contract and canonical reference inventory committed"},
            {"id": "G02", "plan_point": 2, "status": "complete", "criterion": "reproducible Windows x64 debug, release, and dedicated builds"},
            {"id": "G03", "plan_point": 3, "status": "implemented_tested", "criterion": "qcommon differential fixtures pass for buffers, commands, cvars, filesystem, checksums, and lifecycle"},
            {"id": "G04", "plan_point": 4, "status": "implemented_47_map_retail_spawn_smoke_passed", "criterion": "BSP38 and asset parsers are bounds-safe; collision/PVS/area results match 3.19"},
            {"id": "G05", "plan_point": 5, "status": "implemented_manual_device_gate_pending", "criterion": "window, input, audio, UDP/loopback, timing, and headless contracts pass"},
            {"id": "G06", "plan_point": 6, "status": "deterministic_capture_passed_original_pixel_pair_pending", "criterion": "OpenGL ref API v3 path renders required scenes with accepted visual evidence"},
            {"id": "G07", "plan_point": 7, "status": "independent_wire_peer_passed_original_process_blocked", "criterion": "Protocol 34 client connects to original 3.19 server and replays reference demos"},
            {"id": "G08", "plan_point": 8, "status": "independent_wire_peer_passed_original_process_blocked", "criterion": "original 3.19 client connects to MiniQuake2 listen/dedicated server across map changes"},
            {"id": "G09", "plan_point": 9, "status": "complete_baseq2_coverage_with_body_queue_generic_edict_reuse_flymissile_pusher_and_per_player_help_counters_passed", "criterion": "baseq2 campaign, save/load, coop, and deathmatch acceptance matrix passes"},
            {"id": "G10", "plan_point": 10, "status": "retail_soak_physical_ai_trace_and_aggregate_performance_passed_external_closure_pending", "criterion": "interop, visual, soak, performance, license, asset, and reproducibility release gates pass"},
        ],
        "files": files,
        "functions": functions,
    }

    canonical = json.dumps(document, sort_keys=True, separators=(",", ":")).encode("utf-8")
    document["inventory_sha256"] = sha256_bytes(canonical)
    return document


def validate(ledger: dict[str, object]) -> None:
    """Validate state."""
    reference = ledger["reference"]
    files = ledger["files"]
    functions = ledger["functions"]
    assert isinstance(reference, dict)
    assert isinstance(files, list)
    assert isinstance(functions, list)
    assert len(files) == reference["tracked_file_count"]
    assert len(functions) == reference["c_function_definition_count"]
    assert len({item["path"] for item in files}) == len(files)
    assert len({item["id"] for item in functions}) == len(functions)
    assert all(item["status"] == "reference" for item in files)
    assert all(item["status"] == "reference" for item in functions)
    assert sum(item["function_definition_count"] for item in files) == len(functions)
    assert reference["c_and_header_count"] == 264
    assert reference["tracked_file_count"] == 371
    assert reference["c_function_definition_count"] == 4525


def main() -> int:
    """Run this source file's command-line entry point."""
    parser = argparse.ArgumentParser()
    parser.add_argument("--reference-root", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    ledger = make_ledger(args.reference_root.resolve())
    validate(ledger)
    rendered = json.dumps(ledger, indent=2, sort_keys=False) + "\n"

    if args.check:
        current = args.output.read_text(encoding="utf-8")
        if current != rendered:
            raise SystemExit("PORT_LEDGER.json is stale; regenerate it")
    else:
        args.output.write_text(rendered, encoding="utf-8")

    reference = ledger["reference"]
    print("MiniQuake2 reference inventory: PASS")
    print(f"  tracked_files={reference['tracked_file_count']}")
    print(f"  c_translation_units={reference['c_translation_unit_count']}")
    print(f"  c_headers={reference['c_header_count']}")
    print(f"  c_function_definitions={reference['c_function_definition_count']}")
    print(f"  inventory_sha256={ledger['inventory_sha256']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
