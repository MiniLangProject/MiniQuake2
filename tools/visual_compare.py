#!/usr/bin/env python3
"""Compare MiniQuake2/original-ref_gl TGA captures and emit stable JSON."""

from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import sys
from dataclasses import dataclass


@dataclass(frozen=True)
class Image:
    width: int
    height: int
    rgba: bytes


def read_tga(path: pathlib.Path) -> Image:
    data = path.read_bytes()
    if len(data) < 18:
        raise ValueError(f"{path}: truncated TGA header")
    image_id_length = data[0]
    color_map_type = data[1]
    image_type = data[2]
    width = int.from_bytes(data[12:14], "little")
    height = int.from_bytes(data[14:16], "little")
    depth = data[16]
    descriptor = data[17]
    if color_map_type != 0 or image_type != 2:
        raise ValueError(f"{path}: only uncompressed true-colour TGA is supported")
    if width < 1 or height < 1 or depth not in (24, 32):
        raise ValueError(f"{path}: invalid TGA dimensions or pixel depth")
    bytes_per_pixel = depth // 8
    offset = 18 + image_id_length
    required = width * height * bytes_per_pixel
    if offset + required > len(data):
        raise ValueError(f"{path}: truncated TGA pixel payload")
    top_origin = bool(descriptor & 0x20)
    right_origin = bool(descriptor & 0x10)
    rgba = bytearray(width * height * 4)
    source = offset
    for file_y in range(height):
        y = file_y if top_origin else height - file_y - 1
        for file_x in range(width):
            x = width - file_x - 1 if right_origin else file_x
            target = (y * width + x) * 4
            blue, green, red = data[source : source + 3]
            alpha = data[source + 3] if bytes_per_pixel == 4 else 255
            rgba[target : target + 4] = bytes((red, green, blue, alpha))
            source += bytes_per_pixel
    return Image(width, height, bytes(rgba))


def write_tga(path: pathlib.Path, image: Image) -> None:
    if len(image.rgba) != image.width * image.height * 4:
        raise ValueError("invalid RGBA payload")
    header = bytearray(18)
    header[2] = 2
    header[12:14] = image.width.to_bytes(2, "little")
    header[14:16] = image.height.to_bytes(2, "little")
    header[16] = 32
    header[17] = 0x28
    payload = bytearray(len(image.rgba))
    for pixel in range(image.width * image.height):
        source = pixel * 4
        payload[source : source + 4] = bytes(
            (image.rgba[source + 2], image.rgba[source + 1], image.rgba[source], image.rgba[source + 3])
        )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(header + payload)


def compare_images(
    expected: Image, actual: Image, channel_tolerance: int = 0, include_alpha: bool = False
) -> tuple[dict[str, int | bool], Image]:
    if (expected.width, expected.height) != (actual.width, actual.height):
        raise ValueError(
            f"capture dimensions differ: {expected.width}x{expected.height} vs "
            f"{actual.width}x{actual.height}"
        )
    if not 0 <= channel_tolerance <= 255:
        raise ValueError("channel tolerance outside [0,255]")
    channel_count = 4 if include_alpha else 3
    total_pixels = expected.width * expected.height
    differing_pixels = 0
    differing_channels = 0
    max_channel_delta = 0
    absolute_error = 0
    heat = bytearray(total_pixels * 4)
    for pixel in range(total_pixels):
        base = pixel * 4
        pixel_max = 0
        differs = False
        for channel in range(channel_count):
            delta = abs(actual.rgba[base + channel] - expected.rgba[base + channel])
            absolute_error += delta
            pixel_max = max(pixel_max, delta)
            max_channel_delta = max(max_channel_delta, delta)
            if delta > channel_tolerance:
                differing_channels += 1
                differs = True
        if differs:
            differing_pixels += 1
        heat[base : base + 4] = bytes((pixel_max, 0, 0, 255))
    mismatch_ratio_ppm = round(differing_pixels * 1_000_000 / total_pixels)
    mean_absolute_error_ppm = round(
        absolute_error * 1_000_000 / (total_pixels * channel_count * 255)
    )
    metrics: dict[str, int | bool] = {
        "width": expected.width,
        "height": expected.height,
        "total_pixels": total_pixels,
        "compared_channels": channel_count,
        "channel_tolerance": channel_tolerance,
        "differing_pixels": differing_pixels,
        "differing_channels": differing_channels,
        "mismatch_ratio_ppm": mismatch_ratio_ppm,
        "max_channel_delta": max_channel_delta,
        "absolute_error": absolute_error,
        "mean_absolute_error_ppm": mean_absolute_error_ppm,
        "exact": differing_channels == 0,
    }
    return metrics, Image(expected.width, expected.height, bytes(heat))


def sha256(path: pathlib.Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("expected", type=pathlib.Path)
    parser.add_argument("actual", type=pathlib.Path)
    parser.add_argument("--channel-tolerance", type=int, default=0)
    parser.add_argument("--include-alpha", action="store_true")
    parser.add_argument("--max-differing-pixels", type=int)
    parser.add_argument("--max-mismatch-ratio-ppm", type=int)
    parser.add_argument("--max-mean-absolute-error-ppm", type=int)
    parser.add_argument("--diff-output", type=pathlib.Path)
    parser.add_argument("--json-output", type=pathlib.Path)
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        expected = read_tga(args.expected)
        actual = read_tga(args.actual)
        metrics, heat = compare_images(
            expected, actual, args.channel_tolerance, args.include_alpha
        )
        checks: list[bool] = []
        if args.max_differing_pixels is not None:
            checks.append(metrics["differing_pixels"] <= args.max_differing_pixels)
        if args.max_mismatch_ratio_ppm is not None:
            checks.append(metrics["mismatch_ratio_ppm"] <= args.max_mismatch_ratio_ppm)
        if args.max_mean_absolute_error_ppm is not None:
            checks.append(
                metrics["mean_absolute_error_ppm"] <= args.max_mean_absolute_error_ppm
            )
        passed = all(checks) if checks else bool(metrics["exact"])
        report = {
            "schema": "miniquake2.visual-diff.v1",
            "expected": {"path": str(args.expected), "sha256": sha256(args.expected)},
            "actual": {"path": str(args.actual), "sha256": sha256(args.actual)},
            "metrics": metrics,
            "thresholds": {
                "max_differing_pixels": args.max_differing_pixels,
                "max_mismatch_ratio_ppm": args.max_mismatch_ratio_ppm,
                "max_mean_absolute_error_ppm": args.max_mean_absolute_error_ppm,
            },
            "pass": passed,
        }
        if args.diff_output:
            write_tga(args.diff_output, heat)
            report["diff_output"] = str(args.diff_output)
        rendered = json.dumps(report, indent=2, sort_keys=True)
        print(rendered)
        if args.json_output:
            args.json_output.parent.mkdir(parents=True, exist_ok=True)
            args.json_output.write_text(rendered + "\n", encoding="utf-8")
        return 0 if passed else 1
    except (OSError, ValueError) as exc:
        print(json.dumps({"schema": "miniquake2.visual-diff.v1", "error": str(exc)}))
        return 2


if __name__ == "__main__":
    sys.exit(main())
