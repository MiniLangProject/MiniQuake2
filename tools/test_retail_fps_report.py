#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Focused parser and aggregation tests for the retail FPS reporter."""

from __future__ import annotations

import pathlib
import sys
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import retail_fps_report


SAMPLE = """MiniQuake2 interactive vertical slice: PASS
  frames=500 client-state=4 server-frame=41
  models=65 sounds=79 missing-assets=0 submitted-entities=5570
  timing-ms client=120 world=230 entities=80 hud=20
  timing-ms present=10 audio=40 frame=1000
  timing-ms input-total=400
  audio-buffers submitted=10 completed=9 underruns=1 capacity=8
  max-frame-ms=7.5 first-audio-underrun-frame=42
  heap-bytes current=123456 maximum=234567 observed-collections=0
"""


class RetailFpsReportTests(unittest.TestCase):
    """Store retail fps report tests data."""
    def test_parse_result_separates_wall_and_engine_work(self) -> None:
        """Verify parse result separates wall and engine work."""
        row = retail_fps_report.parse_result("base1", 500, 5.0, 0, SAMPLE)
        self.assertTrue(row["passed"])
        self.assertEqual(500.0, row["engine_work_fps"])
        self.assertEqual(100.0, row["wall_fps_including_startup"])
        self.assertEqual(2.0, row["mean_engine_work_ms"])
        self.assertEqual(1, row["audio_underruns"])
        self.assertEqual(123456, row["heap_bytes"])
        self.assertEqual(400.0, row["input_ms"])
        self.assertEqual(120.0, row["client_ms"])
        self.assertEqual(230.0, row["world_ms"])

    def test_failure_with_missing_telemetry_stays_reportable(self) -> None:
        """Report whether test failure with missing telemetry stays reportable."""
        row = retail_fps_report.parse_result("bad", 500, 0.1, 1, "ERROR: bad map")
        self.assertFalse(row["passed"])
        self.assertIsNone(row["engine_work_fps"])
        self.assertIsNone(row["frames"])

    def test_scope_selection(self) -> None:
        """Verify scope selection."""
        names = ["base1", "q2dm1", "boss2"]
        self.assertEqual(names, retail_fps_report._selected_maps(names, "all"))
        self.assertEqual(["base1", "boss2"], retail_fps_report._selected_maps(names, "campaign"))
        self.assertEqual(["q2dm1"], retail_fps_report._selected_maps(names, "deathmatch"))

    def test_summary(self) -> None:
        """Verify summary."""
        rows = [
            {"passed": True, "engine_work_fps": 100.0, "audio_underruns": 1,
             "observed_collections": 0, "missing_assets": 0},
            {"passed": True, "engine_work_fps": 200.0, "audio_underruns": 2,
             "observed_collections": 1, "missing_assets": 0},
            {"passed": False, "engine_work_fps": None, "audio_underruns": None,
             "observed_collections": None, "missing_assets": 3},
        ]
        summary = retail_fps_report.summarize(rows)
        self.assertEqual(3, summary["maps"])
        self.assertEqual(2, summary["passed"])
        self.assertEqual(150.0, summary["engine_work_fps_median"])
        self.assertEqual(3, summary["audio_underruns"])
        self.assertEqual(1, summary["observed_collections"])
        self.assertEqual(3, summary["missing_assets"])


if __name__ == "__main__":
    unittest.main()
