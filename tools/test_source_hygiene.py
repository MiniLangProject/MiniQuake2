#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Focused regression tests for the standalone source-hygiene verifier."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

import source_hygiene


GPL_HEADER = """// Copyright (c) 2026 Nils Kopal
// SPDX-License-Identifier: GPL-2.0-or-later
"""


class SourceHygieneTests(unittest.TestCase):
    def issue_rules(self, root: Path, relative: str) -> list[str]:
        return [issue.rule for issue in source_hygiene.check_file(root, root / relative)]

    def test_accepts_complete_header_and_english_comment(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            path = root / "src" / "good.ml"
            path.parent.mkdir(parents=True)
            path.write_text(
                GPL_HEADER + '// Preserve this invariant.\nlet text = "// nicht a comment";\n',
                encoding="utf-8",
            )
            self.assertEqual([], source_hygiene.check_file(root, path))

    def test_reports_missing_header_fields(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            path = root / "tests" / "missing.ml"
            path.parent.mkdir(parents=True)
            path.write_text("function test() { return 1; }\n", encoding="utf-8")
            self.assertEqual(["copyright", "spdx"], sorted(self.issue_rules(root, "tests/missing.ml")))

    def test_reports_only_real_non_english_comments(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            path = root / "tools" / "language.py"
            path.parent.mkdir(parents=True)
            path.write_text(
                "# Copyright (c) 2026 Nils Kopal\n"
                "# SPDX-License-Identifier: Apache-2.0\n"
                'value = "# nicht a comment"\n'
                "# Dieser Kommentar ist nicht auf Englisch.\n",
                encoding="utf-8",
            )
            issues = source_hygiene.check_file(root, path)
            self.assertEqual(1, len(issues))
            self.assertEqual("comment-language", issues[0].rule)
            self.assertEqual(4, issues[0].line)

    def test_reports_minilang_block_comment_at_its_actual_line(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            path = root / "src" / "block.ml"
            path.parent.mkdir(parents=True)
            path.write_text(
                GPL_HEADER
                + "/* English summary.\n"
                + " * Diese Zeile is not English.\n"
                + " */\n"
                + "function value()\n  return 1\nend function\n",
                encoding="utf-8",
            )
            issues = source_hygiene.check_file(root, path)
            self.assertEqual(1, len(issues))
            self.assertEqual(4, issues[0].line)

    def test_powershell_ignores_strings_and_checks_block_comments(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            path = root / "scripts" / "language.ps1"
            path.parent.mkdir(parents=True)
            path.write_text(
                "# Copyright (c) 2026 Nils Kopal\n"
                "# SPDX-License-Identifier: Apache-2.0\n"
                '$Text = "# nicht a comment"\n'
                "<# English first line.\nDiese Zeile is not English. #>\n",
                encoding="utf-8",
            )
            issues = source_hygiene.check_file(root, path)
            self.assertEqual(1, len(issues))
            self.assertEqual(5, issues[0].line)

    def test_reports_unsupported_and_duplicate_spdx(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            path = root / "scripts" / "bad.ps1"
            path.parent.mkdir(parents=True)
            path.write_text(
                "# Copyright (c) 2026 Nils Kopal\n"
                "# SPDX-License-Identifier: MIT\n"
                "# SPDX-License-Identifier: Apache-2.0\n",
                encoding="utf-8",
            )
            issues = source_hygiene.check_file(root, path)
            self.assertEqual(["spdx"], [issue.rule for issue in issues])
            self.assertIn("multiple", issues[0].message)

    def test_scope_excludes_reference_and_build_trees(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            for relative in (
                "src/in_scope.ml",
                "Quake-2-original-source/ref.c",
                "build/generated.ml",
            ):
                path = root / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(GPL_HEADER, encoding="utf-8")
            files = source_hygiene.maintained_source_files(root)
            self.assertEqual([root / "src" / "in_scope.ml"], files)

    def test_checks_maintained_c_tool_source(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            path = root / "tools" / "helper.c"
            path.parent.mkdir(parents=True)
            path.write_text(
                "/*\n"
                "Copyright (c) 2026 Nils Kopal\n"
                "SPDX-License-Identifier: GPL-2.0-or-later\n"
                "*/\n"
                "// Deterministic helper.\n"
                "int helper(void) { return 1; }\n",
                encoding="utf-8",
            )
            self.assertEqual([path], source_hygiene.maintained_source_files(root))
            self.assertEqual([], source_hygiene.check_file(root, path))

    def test_fix_adds_language_defaults_and_preserves_python_preamble(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            c_path = root / "tools" / "bare.c"
            ml_path = root / "src" / "bare.ml"
            py_path = root / "tools" / "bare.py"
            ps_path = root / "scripts" / "bare.ps1"
            for path in (c_path, ml_path, py_path, ps_path):
                path.parent.mkdir(parents=True, exist_ok=True)
            c_path.write_text("int main(void) { return 0; }\n", encoding="utf-8")
            ml_path.write_text("package bare\n", encoding="utf-8")
            py_path.write_bytes(b"#!/usr/bin/env python3\r\nprint('ok')\r\n")
            ps_path.write_text("Write-Output 'ok'\n", encoding="utf-8")

            self.assertTrue(source_hygiene.fix_file(root, ml_path))
            self.assertTrue(source_hygiene.fix_file(root, c_path))
            self.assertTrue(source_hygiene.fix_file(root, py_path))
            self.assertTrue(source_hygiene.fix_file(root, ps_path))
            self.assertIn("SPDX-License-Identifier: GPL-2.0-or-later", ml_path.read_text())
            self.assertIn("SPDX-License-Identifier: GPL-2.0-or-later", c_path.read_text())
            py_bytes = py_path.read_bytes()
            self.assertTrue(
                py_bytes.startswith(
                    b"#!/usr/bin/env python3\r\n"
                    b"# Copyright (c) 2026 Nils Kopal\r\n"
                    b"# SPDX-License-Identifier: Apache-2.0\r\n"
                )
            )
            self.assertIn("SPDX-License-Identifier: Apache-2.0", ps_path.read_text())
            self.assertFalse(source_hygiene.fix_file(root, ml_path))

    def test_fix_never_overwrites_existing_or_partial_header(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            existing = root / "src" / "existing.ml"
            partial = root / "src" / "partial.ml"
            existing.parent.mkdir(parents=True)
            existing.write_text(
                "// Copyright (c) 2024 Example Corp\n"
                "// SPDX-License-Identifier: Apache-2.0\n"
                "package existing\n",
                encoding="utf-8",
            )
            partial.write_text(
                "// Copyright (c) 2024 Example Corp\npackage partial\n",
                encoding="utf-8",
            )
            before_existing = existing.read_bytes()
            before_partial = partial.read_bytes()
            self.assertFalse(source_hygiene.fix_file(root, existing))
            self.assertFalse(source_hygiene.fix_file(root, partial))
            self.assertEqual(before_existing, existing.read_bytes())
            self.assertEqual(before_partial, partial.read_bytes())

    def test_fix_adds_only_spdx_inside_checksum_special_notice(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            path = root / source_hygiene.SPECIAL_CHECKSUM_PATH
            path.parent.mkdir(parents=True)
            original = (
                "/*\n"
                "Copyright (C) 1990-2, RSA Data Security, Inc.\n"
                "Copyright (c) 2026 Nils Kopal\n\n"
                "This notice must remain.\n"
                "*/\n"
                "package miniquake2.qcommon.checksum\n"
            )
            path.write_text(original, encoding="utf-8")
            self.assertTrue(source_hygiene.fix_file(root, path))
            updated = path.read_text(encoding="utf-8")
            self.assertEqual(1, updated.count("Copyright (C) 1990-2"))
            self.assertEqual(1, updated.count("Copyright (c) 2026"))
            self.assertIn("This notice must remain.", updated)
            self.assertIn("SPDX-License-Identifier: GPL-2.0-or-later", updated)
            self.assertTrue(updated.startswith("/*\nCopyright"))
            self.assertFalse(source_hygiene.fix_file(root, path))


if __name__ == "__main__":
    unittest.main()
