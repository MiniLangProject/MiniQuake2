#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Focused regression tests for the Markdown-hygiene verifier."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

import markdown_hygiene


class MarkdownHygieneTests(unittest.TestCase):
    """Store markdown hygiene tests data."""
    def test_accepts_structure_links_and_fenced_examples(self) -> None:
        """Verify accepts structure links and fenced examples."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            docs = root / "docs"
            docs.mkdir()
            (docs / "target.md").write_text("# Target\n", encoding="utf-8")
            source = docs / "source.md"
            source.write_text(
                "# Source\n\n## Detail\n\n[Target](target.md#ignored-anchor)\n\n"
                "```text\n[Fixture](missing.md)\n```\n",
                encoding="utf-8",
            )
            self.assertEqual([], markdown_hygiene.check_file(root, source))

    def test_reports_objective_structure_and_link_issues(self) -> None:
        """Verify reports objective structure and link issues."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            path = root / "README.md"
            path.write_text(
                "# First  \n# Second\n### Skipped\n[Missing](docs/nope.md)\n```\n",
                encoding="utf-8",
            )
            rules = [issue.rule for issue in markdown_hygiene.check_file(root, path)]
            self.assertEqual(
                ["trailing-whitespace", "heading-order", "relative-link", "fence", "h1"],
                rules,
            )

    def test_scope_excludes_reference_and_build_docs(self) -> None:
        """Verify scope excludes reference and build docs."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            expected = root / "docs" / "kept.md"
            for path in (
                expected,
                root / "build" / "generated.md",
                root / "Quake-2-original-source" / "reference.md",
            ):
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("# Document\n", encoding="utf-8")
            self.assertEqual([expected], markdown_hygiene.maintained_markdown_files(root))


if __name__ == "__main__":
    unittest.main()
