#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0

"""Create deterministic, asset-free MiniQuake2 binary and source archives."""
from __future__ import annotations

import argparse
import hashlib
import sys
import zipfile
from pathlib import Path, PurePosixPath

EPOCH = (1980, 1, 1, 0, 0, 0)
RETAIL_SUFFIXES = {".pak", ".bsp", ".md2", ".sp2", ".wal", ".pcx", ".wav", ".cin", ".dm2"}
GAME_DIRS = {"baseq2", "ctf", "rogue", "xatrix"}
EXPECTED_DLL_NAMES = ("miniquake_native.dll", "miniquake_text.dll")


def digest(path: Path) -> str:
    """Return the digest value."""
    value = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            value.update(block)
    return value.hexdigest()


def manifest_dll_digests(root: Path) -> dict[str, str]:
    """Return checked native DLL digests from the repository manifest."""
    manifest = root / "SOURCE_MANIFEST.sha256"
    expected: dict[str, str] = {}
    for line in manifest.read_text(encoding="utf-8").splitlines():
        if " *" not in line:
            continue
        checksum, relative = line.split(" *", 1)
        relative = relative.replace("\\", "/")
        for name in EXPECTED_DLL_NAMES:
            if relative == f"native/{name}":
                expected[name] = checksum.lower()
    missing = [name for name in EXPECTED_DLL_NAMES if name not in expected]
    if missing:
        raise ValueError("native DLLs missing from source manifest: " + ", ".join(missing))
    return expected


def safe_name(name: str) -> None:
    """Return the safe name."""
    path = PurePosixPath(name)
    if path.is_absolute() or ".." in path.parts:
        raise ValueError(f"unsafe archive path: {name}")
    if path.suffix.lower() in RETAIL_SUFFIXES:
        raise ValueError(f"retail-data suffix rejected: {name}")
    if any(part.lower() in GAME_DIRS for part in path.parts):
        raise ValueError(f"retail-data directory rejected: {name}")


def add_file(archive: zipfile.ZipFile, source: Path, name: str) -> None:
    """Add file."""
    safe_name(name)
    info = zipfile.ZipInfo(name, EPOCH)
    info.compress_type = zipfile.ZIP_DEFLATED
    info.external_attr = 0o100644 << 16
    archive.writestr(info, source.read_bytes(), compresslevel=9)


def write_archive(destination: Path, entries: list[tuple[Path, str]]) -> None:
    """Write archive."""
    destination.parent.mkdir(parents=True, exist_ok=True)
    temporary = destination.with_suffix(destination.suffix + ".tmp")
    with zipfile.ZipFile(temporary, "w", allowZip64=True) as archive:
        for source, name in sorted(entries, key=lambda item: item[1].lower()):
            add_file(archive, source, name)
    temporary.replace(destination)


def maintained_sources(root: Path) -> list[tuple[Path, str]]:
    """Return the maintained sources value."""
    entries: list[tuple[Path, str]] = []
    excluded = {"build", "build_debug", ".git", ".pytest_cache", "__pycache__", "Quake-2-original-source"}
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        relative = path.relative_to(root)
        if any(part in excluded for part in relative.parts) or path.suffix.lower() == ".dll":
            continue
        entries.append((path, f"MiniQuake2-source/{relative.as_posix()}"))
    gpl = root / "Quake-2-original-source" / "gnu.txt"
    if not gpl.is_file():
        raise FileNotFoundError("canonical GPL text is missing from the reference tree")
    entries.append((gpl, "MiniQuake2-source/COPYING.txt"))

    return entries


def verify_archive(path: Path) -> None:
    """Verify archive."""
    with zipfile.ZipFile(path) as archive:
        names = archive.namelist()
        if len(names) != len(set(names)):
            raise ValueError(f"duplicate archive members in {path.name}")
        for name in names:
            safe_name(name)
            if archive.getinfo(name).date_time != EPOCH:
                raise ValueError(f"non-deterministic timestamp in {path.name}: {name}")


def main() -> int:
    """Run this source file's command-line entry point."""
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--version", default="0.5.0-foundation")
    args = parser.parse_args()
    root = args.root.resolve()
    output = root / "build"
    executable = output / "MiniQuake2.exe"
    if not executable.is_file():
        raise FileNotFoundError("build/MiniQuake2.exe is missing; build the release first")
    for name, expected in manifest_dll_digests(root).items():
        path = output / name
        if not path.is_file() or digest(path) != expected:
            raise ValueError(f"native bridge mismatch: {name}")

    prefix = f"MiniQuake2-{args.version}-win64"
    binary_entries = [
        (executable, f"{prefix}/MiniQuake2.exe"),
        (output / "miniquake_native.dll", f"{prefix}/miniquake_native.dll"),
        (output / "miniquake_text.dll", f"{prefix}/miniquake_text.dll"),
        (root / "README.md", f"{prefix}/README.md"),
        (root / "LICENSE.md", f"{prefix}/LICENSE.md"),
        (root / "NOTICE.md", f"{prefix}/NOTICE.md"),
        (root / "SOURCE_MANIFEST.sha256", f"{prefix}/SOURCE_MANIFEST.sha256"),
    ]
    binary_zip = output / f"MiniQuake2-{args.version}-win64.zip"
    source_zip = output / f"MiniQuake2-{args.version}-source.zip"
    write_archive(binary_zip, binary_entries)
    write_archive(source_zip, maintained_sources(root))
    verify_archive(binary_zip)
    verify_archive(source_zip)
    print(f"MiniQuake2 package: PASS\n  binary={binary_zip}\n  source={source_zip}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, zipfile.BadZipFile) as exc:
        print(f"MiniQuake2 package: FAIL: {exc}", file=sys.stderr)
        raise SystemExit(1)
