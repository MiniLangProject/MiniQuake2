#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0

"""Extract a binary release archive and smoke the shipped executable in place."""

from __future__ import annotations

import argparse
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path, PurePosixPath


def validate_members(archive: zipfile.ZipFile) -> None:
    """Validate members."""
    names = archive.namelist()
    if len(names) != len(set(names)):
        raise ValueError("release archive contains duplicate members")
    for name in names:
        member = PurePosixPath(name)
        if member.is_absolute() or ".." in member.parts:
            raise ValueError(f"unsafe release archive member: {name}")


def run(executable: Path, *arguments: str) -> str:
    """Run state."""
    completed = subprocess.run(
        [str(executable), *arguments],
        cwd=executable.parent,
        capture_output=True,
        text=True,
        timeout=30,
        check=False,
    )
    output = completed.stdout + completed.stderr
    if completed.returncode != 0:
        raise RuntimeError(
            f"packaged command failed ({completed.returncode}): "
            f"{' '.join(arguments)}\n{output}"
        )
    return output


def main() -> int:
    """Run this source file's command-line entry point."""
    parser = argparse.ArgumentParser()
    parser.add_argument("--archive", type=Path, required=True)
    args = parser.parse_args()
    archive_path = args.archive.resolve()
    if not archive_path.is_file():
        raise FileNotFoundError(f"release archive is missing: {archive_path}")

    with tempfile.TemporaryDirectory(prefix="MiniQuake2-package-smoke-") as temporary:
        destination = Path(temporary)
        with zipfile.ZipFile(archive_path) as archive:
            validate_members(archive)
            archive.extractall(destination)

        executables = list(destination.rglob("MiniQuake2.exe"))
        if len(executables) != 1:
            raise ValueError(
                f"expected exactly one packaged MiniQuake2.exe, found {len(executables)}"
            )
        executable = executables[0]
        diagnostics = run(executable, "--diagnostics")
        cli_smoke = run(executable, "--cli-smoke", "package")
        if "MiniQuake2 diagnostics: PASS" not in diagnostics:
            raise RuntimeError("packaged diagnostics did not report PASS")
        if "MiniQuake2 CLI smoke: PASS" not in cli_smoke:
            raise RuntimeError("packaged CLI smoke did not report PASS")

    print(f"MiniQuake2 packaged runtime smoke: PASS\n  archive={archive_path}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, RuntimeError, ValueError, zipfile.BadZipFile) as exc:
        print(f"MiniQuake2 packaged runtime smoke: FAIL: {exc}", file=sys.stderr)
        raise SystemExit(1)
