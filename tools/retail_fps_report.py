#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Measure every user-owned baseq2 BSP through MiniQuake2's product renderer.

The report distinguishes wall-clock process throughput (including map startup
and the product's frame cap) from CPU engine-work throughput derived from the
instrumented frame phases. Retail data is only read in place.
"""

from __future__ import annotations

import argparse
import csv
import json
import pathlib
import re
import statistics
import subprocess
import sys
import time
from typing import Iterable

import retail_campaign_inventory


KEY_VALUE = re.compile(r"([a-z][a-z-]*)=([^ ]+)")


def _fields(output: str) -> dict[str, str]:
    """Return the fields value."""
    result: dict[str, str] = {}
    for line in output.splitlines():
        for key, value in KEY_VALUE.findall(line):
            result[key] = value
    return result


def _prefixed_fields(output: str, prefix: str) -> dict[str, str]:
    """Parse only telemetry lines with *prefix* so repeated keys stay scoped."""
    result: dict[str, str] = {}
    for line in output.splitlines():
        stripped = line.strip()
        if stripped.startswith(prefix):
            for key, value in KEY_VALUE.findall(stripped[len(prefix):]):
                result[key] = value
    return result


def _integer(fields: dict[str, str], key: str) -> int | None:
    """Return the integer value."""
    try:
        return int(fields[key])
    except (KeyError, ValueError):
        return None


def _number(fields: dict[str, str], key: str) -> float | None:
    """Return the number."""
    try:
        return float(fields[key])
    except (KeyError, ValueError):
        return None


def parse_result(map_name: str, frames_requested: int, elapsed: float,
                 exit_code: int, output: str) -> dict[str, object]:
    """Parse result."""
    fields = _fields(output)
    timings = _prefixed_fields(output, "timing-ms ")
    audio_buffers = _prefixed_fields(output, "audio-buffers ")
    heap = _prefixed_fields(output, "heap-bytes ")
    frames = _integer(fields, "frames")
    frame_work_ms = _number(timings, "frame")
    work_fps = None
    if frames is not None and frames > 0 and frame_work_ms is not None and frame_work_ms > 0.0:
        work_fps = frames * 1000.0 / frame_work_ms
    wall_fps = frames / elapsed if frames is not None and frames > 0 and elapsed > 0.0 else None
    return {
        "map": map_name,
        "frames_requested": frames_requested,
        "frames": frames,
        "exit_code": exit_code,
        "passed": exit_code == 0 and "interactive vertical slice: PASS" in output,
        "wall_seconds": elapsed,
        "wall_fps_including_startup": wall_fps,
        "engine_work_fps": work_fps,
        "mean_engine_work_ms": frame_work_ms / frames if frames and frame_work_ms is not None else None,
        "max_frame_ms": _number(fields, "max-frame-ms"),
        "input_ms": _number(timings, "input-total"),
        "client_ms": _number(timings, "client"),
        "world_ms": _number(timings, "world"),
        "entities_ms": _number(timings, "entities"),
        "hud_ms": _number(timings, "hud"),
        "present_ms": _number(timings, "present"),
        "audio_ms": _number(timings, "audio"),
        "missing_assets": _integer(fields, "missing-assets"),
        "audio_underruns": _integer(audio_buffers, "underruns"),
        "observed_collections": _integer(heap, "observed-collections"),
        "heap_bytes": _integer(heap, "current"),
        "output": output.strip(),
    }


def run_map(executable: pathlib.Path, root: pathlib.Path, map_name: str,
            frames: int, timeout: float) -> dict[str, object]:
    """Run map."""
    started = time.perf_counter()
    try:
        completed = subprocess.run(
            [str(executable), "--play", str(root), map_name, str(frames)],
            text=True,
            encoding="utf-8",
            errors="replace",
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
            timeout=timeout,
        )
        elapsed = time.perf_counter() - started
        return parse_result(map_name, frames, elapsed, completed.returncode, completed.stdout)
    except subprocess.TimeoutExpired as exc:
        elapsed = time.perf_counter() - started
        output = exc.stdout or ""
        if isinstance(output, bytes):
            output = output.decode("utf-8", "replace")
        result = parse_result(map_name, frames, elapsed, 124, output)
        result["timed_out"] = True
        return result


def _selected_maps(names: Iterable[str], scope: str) -> list[str]:
    """Return the selected maps value."""
    if scope == "campaign":
        return [name for name in names if not name.startswith("q2dm")]
    if scope == "deathmatch":
        return [name for name in names if name.startswith("q2dm")]
    return list(names)


def summarize(rows: list[dict[str, object]]) -> dict[str, object]:
    """Return the summarize value."""
    passed = [row for row in rows if row["passed"]]
    work = [float(row["engine_work_fps"]) for row in passed if row["engine_work_fps"] is not None]
    return {
        "maps": len(rows),
        "passed": len(passed),
        "failed": len(rows) - len(passed),
        "engine_work_fps_min": min(work) if work else None,
        "engine_work_fps_median": statistics.median(work) if work else None,
        "engine_work_fps_max": max(work) if work else None,
        "audio_underruns": sum(int(row["audio_underruns"] or 0) for row in rows),
        "observed_collections": sum(int(row["observed_collections"] or 0) for row in rows),
        "missing_assets": sum(int(row["missing_assets"] or 0) for row in rows),
    }


def _write_csv(path: pathlib.Path, rows: list[dict[str, object]]) -> None:
    """Write csv."""
    columns = [key for key in rows[0] if key != "output"] if rows else []
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=columns, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    """Run this source file's command-line entry point."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", type=pathlib.Path, help="Quake II install root or baseq2 directory")
    parser.add_argument("--exe", type=pathlib.Path, required=True, help="MiniQuake2 executable")
    parser.add_argument("--frames", type=int, default=500, help="rendered frames per map (default: 500)")
    parser.add_argument("--scope", choices=("all", "campaign", "deathmatch"), default="all")
    parser.add_argument("--timeout", type=float, default=120.0, help="per-map timeout in seconds")
    parser.add_argument("--json", type=pathlib.Path, help="write machine-readable report")
    parser.add_argument("--csv", type=pathlib.Path, help="write one row per map")
    args = parser.parse_args()
    if args.frames < 1 or args.timeout <= 0.0:
        parser.error("--frames and --timeout must be positive")

    try:
        baseq2, inventory = retail_campaign_inventory.inventory(args.root)
        executable = args.exe.resolve(strict=True)
    except (OSError, retail_campaign_inventory.InventoryError) as exc:
        print(f"retail fps report: FAIL: {exc}", file=sys.stderr)
        return 2

    names = _selected_maps(inventory, args.scope)
    rows: list[dict[str, object]] = []
    for index, map_name in enumerate(names, 1):
        row = run_map(executable, args.root.resolve(), map_name, args.frames, args.timeout)
        rows.append(row)
        fps = row["engine_work_fps"]
        fps_text = f"{float(fps):.2f}" if fps is not None else "n/a"
        print(f"[{index:02d}/{len(names):02d}] {map_name:<10} "
              f"{'PASS' if row['passed'] else 'FAIL'} engine-work-fps={fps_text}", flush=True)

    report = {
        "schema": 1,
        "baseq2": str(baseq2),
        "executable": str(executable),
        "scope": args.scope,
        "frames_per_map": args.frames,
        "metric_note": "engine_work_fps excludes frame-cap sleep; wall FPS includes process/map startup",
        "summary": summarize(rows),
        "maps": rows,
    }
    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    if args.csv:
        _write_csv(args.csv, rows)
    summary = report["summary"]
    minimum = summary["engine_work_fps_min"]
    median = summary["engine_work_fps_median"]
    maximum = summary["engine_work_fps_max"]
    fps_range = "n/a"
    if minimum is not None and median is not None and maximum is not None:
        fps_range = f"{minimum:.2f}/{median:.2f}/{maximum:.2f}"
    print("retail fps report: "
          f"maps={summary['maps']} passed={summary['passed']} failed={summary['failed']} "
          f"min/median/max={fps_range} "
          f"underruns={summary['audio_underruns']} gc={summary['observed_collections']} "
          f"missing={summary['missing_assets']}")
    return 0 if summary["failed"] == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
