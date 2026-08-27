#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Convert deterministic MiniQuake2 TGA captures to GitHub-friendly JPEGs."""

from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image


def build_parser() -> argparse.ArgumentParser:
    """Build the command-line parser for one lossless-to-preview conversion."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="input TGA capture")
    parser.add_argument("destination", type=Path, help="output JPEG preview")
    parser.add_argument("--quality", type=int, default=88, choices=range(1, 96))
    return parser


def convert(source: Path, destination: Path, quality: int) -> None:
    """Write a progressive, optimized RGB JPEG from one renderer capture."""
    if not source.is_file():
        raise FileNotFoundError(f"capture does not exist: {source}")
    destination.parent.mkdir(parents=True, exist_ok=True)
    with Image.open(source) as capture:
        capture.convert("RGB").save(
            destination,
            format="JPEG",
            quality=quality,
            optimize=True,
            progressive=True,
        )


def main() -> int:
    """Convert the requested capture and report its resulting dimensions."""
    args = build_parser().parse_args()
    convert(args.source, args.destination, args.quality)
    with Image.open(args.destination) as preview:
        width, height = preview.size
    print(f"gallery image: {args.destination} ({width}x{height})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
