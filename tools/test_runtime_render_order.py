#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Guard world/entity pass ordering in alternate product render paths."""

from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def minilang_function(path: Path, name: str) -> str:
    """Return one top-level MiniLang function body for a source contract test."""
    text = path.read_text(encoding="utf-8")
    start = text.index(f"function {name}(")
    end = text.index("end function", start)
    return text[start:end]


class RuntimeRenderOrderTests(unittest.TestCase):
    """Keep Classic world submission ahead of entity/alpha consumption."""

    def assert_world_before_frame(self, body: str) -> None:
        """Require the producer pass before RenderFrame consumes pending state."""
        world = body.index("submitClassicWorld")
        frame = body.index("RenderFrame")
        self.assertLess(world, frame)

    def test_demo_world_precedes_render_frame(self) -> None:
        """Prevent demo frames from consuming the prior pending world pass."""
        body = minilang_function(
            ROOT / "src/miniquake2/runtime/application.ml",
            "applicationSubmitDemoFrame",
        )
        self.assert_world_before_frame(body)

    def test_capture_world_precedes_render_frame(self) -> None:
        """Prevent captures from leaving the final alpha pass unflushed."""
        body = minilang_function(
            ROOT / "src/miniquake2/runtime/visual_capture.ml",
            "captureRetailScene",
        )
        self.assert_world_before_frame(body)


if __name__ == "__main__":
    unittest.main()
