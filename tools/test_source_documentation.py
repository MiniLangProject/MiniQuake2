#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Regression tests for the declaration-level source documentation audit."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

import check_source_documentation as documentation


HEADER = """/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
"""


class SourceDocumentationTests(unittest.TestCase):
    """Verify comment detection and conservative documentation completion."""

    def test_fixer_documents_minilang_declarations(self) -> None:
        """Add distinct function, type and complex-routine comments."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            path = root / "src" / "sample.ml"
            path.parent.mkdir(parents=True)
            body = "\n".join("  value = value + 1" for _ in range(101))
            path.write_text(
                HEADER
                + "package sample\n\n"
                + "struct RuntimeState\n  value\nend struct\n\n"
                + "function updateRuntime(value)\n"
                + body
                + "\n  return value\nend function\n",
                encoding="utf-8",
            )
            self.assertTrue(documentation.fix_file(path))
            findings, coverage = documentation.audit_file(path, root)
            self.assertEqual([], findings)
            self.assertEqual((1, 1, 1, 1, 1, 1), tuple(coverage.__dict__.values()))

    def test_fixer_preserves_existing_comment(self) -> None:
        """Leave a hand-authored declaration comment unchanged."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            path = root / "src" / "sample.ml"
            path.parent.mkdir(parents=True)
            original = (
                HEADER
                + "package sample\n\n"
                + "// Return the protocol version expected by peers.\n"
                + "function protocolVersion()\n  return 34\nend function\n"
            )
            path.write_text(original, encoding="utf-8")
            self.assertFalse(documentation.fix_file(path))
            self.assertEqual(original, path.read_text(encoding="utf-8"))

    def test_fixer_adds_python_docstrings(self) -> None:
        """Document Python classes and methods without changing their result."""
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "tool.py"
            path.write_text(
                "class FrameState:\n"
                "    def build_frame(self):\n"
                "        return 34\n",
                encoding="utf-8",
            )
            self.assertTrue(documentation.fix_file(path))
            namespace: dict[str, object] = {}
            exec(path.read_text(encoding="utf-8"), namespace)
            instance = namespace["FrameState"]()
            self.assertEqual(34, instance.build_frame())
            self.assertIsNotNone(instance.__class__.__doc__)
            self.assertIsNotNone(instance.build_frame.__doc__)

    def test_generated_summaries_describe_common_declaration_shapes(self) -> None:
        """Keep generated predicate, action and accessor prose readable."""
        self.assertEqual(
            "Report whether body can be pushed.",
            documentation.function_summary("bodyCanBePushed"),
        )
        self.assertEqual(
            "Append bounded text.",
            documentation.function_summary("appendBoundedText"),
        )
        self.assertEqual(
            "Return the body bounds for the requested position.",
            documentation.function_summary("bodyBoundsAt"),
        )

    def test_source_scope_includes_native_c_and_python(self) -> None:
        """Prevent native implementation functions from escaping the audit."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            c_path = root / "native" / "bridge.c"
            py_path = root / "native" / "build_bridge.py"
            c_path.parent.mkdir(parents=True)
            c_path.write_text(
                HEADER + "// Return one.\nint bridge_value(void) { return 1; }\n",
                encoding="utf-8",
            )
            py_path.write_text(
                "# Copyright (c) 2026 Nils Kopal\n"
                "# SPDX-License-Identifier: Apache-2.0\n\n"
                "def build_bridge():\n"
                "    \"\"\"Build the bridge.\"\"\"\n"
                "    return True\n",
                encoding="utf-8",
            )
            files = documentation.source_files(root)
            self.assertIn(c_path, files)
            self.assertIn(py_path, files)
            c_findings, c_coverage = documentation.audit_file(c_path, root)
            py_findings, py_coverage = documentation.audit_file(py_path, root)
            self.assertEqual([], c_findings + py_findings)
            self.assertEqual(1, c_coverage.documented_functions)
            self.assertEqual(1, py_coverage.documented_functions)


if __name__ == "__main__":
    unittest.main()
