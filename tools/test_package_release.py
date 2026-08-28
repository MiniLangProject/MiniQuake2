#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Regression tests for standalone deterministic release packaging."""

from __future__ import annotations

import hashlib
import tempfile
import unittest
from pathlib import Path

import package_release


class PackageReleaseTests(unittest.TestCase):
    """Verify release inputs are repository-owned and manifest-derived."""

    def test_manifest_supplies_native_dll_digests(self) -> None:
        """Use the source manifest instead of duplicated stale constants."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            native = root / "native"
            native.mkdir()
            lines: list[str] = []
            for name, payload in (
                ("miniquake_native.dll", b"native"),
                ("miniquake_text.dll", b"text"),
            ):
                path = native / name
                path.write_bytes(payload)
                lines.append(f"{hashlib.sha256(payload).hexdigest()} *native/{name}")
            (root / "SOURCE_MANIFEST.sha256").write_text(
                "\n".join(lines) + "\n", encoding="utf-8"
            )
            expected = package_release.manifest_dll_digests(root)
            self.assertEqual(package_release.digest(native / "miniquake_native.dll"),
                             expected["miniquake_native.dll"])
            self.assertEqual(package_release.digest(native / "miniquake_text.dll"),
                             expected["miniquake_text.dll"])

    def test_source_archive_is_standalone(self) -> None:
        """Package only the native sources owned by MiniQuake2."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "MiniQuake2"
            native = root / "native"
            reference = root / "Quake-2-original-source"
            native.mkdir(parents=True)
            reference.mkdir()
            (native / "bridge.c").write_text("int bridge(void) { return 1; }\n",
                                              encoding="utf-8")
            (reference / "gnu.txt").write_text("GPL\n", encoding="utf-8")
            entries = package_release.maintained_sources(root)
            names = [name for _, name in entries]
            self.assertIn("MiniQuake2-source/native/bridge.c", names)
            self.assertFalse(any("native-source/" in name for name in names))


if __name__ == "__main__":
    unittest.main()
