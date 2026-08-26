# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
from __future__ import annotations

import importlib.util
import pathlib
import sys
import tempfile
import unittest


TOOL = pathlib.Path(__file__).parents[1] / "tools" / "visual_compare.py"
SPEC = importlib.util.spec_from_file_location("miniquake2_visual_compare", TOOL)
assert SPEC and SPEC.loader
visual_compare = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = visual_compare
SPEC.loader.exec_module(visual_compare)


class VisualCompareTests(unittest.TestCase):
    def test_round_trip_and_metrics(self) -> None:
        expected = visual_compare.Image(
            2,
            1,
            bytes((10, 20, 30, 255, 40, 50, 60, 255)),
        )
        actual = visual_compare.Image(
            2,
            1,
            bytes((12, 20, 30, 0, 40, 50, 70, 255)),
        )
        metrics, heat = visual_compare.compare_images(expected, actual, 2, False)
        self.assertEqual(metrics["differing_pixels"], 1)
        self.assertEqual(metrics["differing_channels"], 1)
        self.assertEqual(metrics["max_channel_delta"], 10)
        self.assertEqual(metrics["absolute_error"], 12)
        self.assertEqual(heat.rgba, bytes((2, 0, 0, 255, 10, 0, 0, 255)))
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / "roundtrip.tga"
            visual_compare.write_tga(path, expected)
            self.assertEqual(visual_compare.read_tga(path), expected)

    def test_original_ref_gl_bottom_left_24_bit(self) -> None:
        # Original Quake II GL_ScreenShot_f writes descriptor 0 and BGR rows
        # from glReadPixels, hence bottom row first.
        header = bytearray(18)
        header[2] = 2
        header[12:14] = (1).to_bytes(2, "little")
        header[14:16] = (2).to_bytes(2, "little")
        header[16] = 24
        bottom_red_then_top_blue = bytes((0, 0, 255, 255, 0, 0))
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / "quake00.tga"
            path.write_bytes(header + bottom_red_then_top_blue)
            decoded = visual_compare.read_tga(path)
        self.assertEqual(decoded.rgba, bytes((0, 0, 255, 255, 255, 0, 0, 255)))


if __name__ == "__main__":
    unittest.main()
