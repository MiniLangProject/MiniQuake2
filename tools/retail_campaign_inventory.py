#!/usr/bin/env python3
# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
"""Read-only Quake II retail map inventory and MiniQuake2 campaign smoke.

The tool never extracts or copies retail data.  It reads the PAK directory and
the BSP entity lump in place, then optionally invokes a MiniQuake2 executable's
``--asset-smoke`` command for every discovered BSP38 map.
"""

from __future__ import annotations

import argparse
import collections
import json
import pathlib
import re
import struct
import subprocess
import sys
from dataclasses import dataclass
from typing import Iterable


PAK_HEADER = struct.Struct("<4sii")
PAK_ENTRY = struct.Struct("<56sii")
BSP_LUMP = struct.Struct("<ii")
# COM_Parse treats the next quote as the terminator; a backslash has no escape
# semantics.  This matters for three stock train.bsp lights whose value ends in
# a literal backslash immediately before the closing quote.
TOKEN = re.compile(r'"([^"]*)"|([{}])|(\S+)')


class InventoryError(RuntimeError):
    """Store inventory error data."""
    pass


@dataclass(frozen=True)
class PackEntry:
    """Store pack entry data."""
    pack: pathlib.Path
    offset: int
    size: int


def _baseq2_directory(root: pathlib.Path) -> pathlib.Path:
    """Return the baseq 2 directory value."""
    candidate = root / "baseq2"
    return candidate if candidate.is_dir() else root


def _pack_entries(baseq2: pathlib.Path) -> dict[str, PackEntry]:
    """Pack entries."""
    result: dict[str, PackEntry] = {}
    packs = sorted(baseq2.glob("pak*.pak"), key=lambda path: path.name.lower())
    if not packs:
        raise InventoryError(f"no pak*.pak found below {baseq2}")
    for pack in packs:
        with pack.open("rb") as stream:
            header = stream.read(PAK_HEADER.size)
            if len(header) != PAK_HEADER.size:
                raise InventoryError(f"truncated PAK header: {pack}")
            magic, directory_offset, directory_length = PAK_HEADER.unpack(header)
            file_size = pack.stat().st_size
            if magic != b"PACK" or directory_length < 0 or directory_length % PAK_ENTRY.size:
                raise InventoryError(f"invalid PAK directory: {pack}")
            if directory_offset < PAK_HEADER.size or directory_offset + directory_length > file_size:
                raise InventoryError(f"PAK directory outside file: {pack}")
            stream.seek(directory_offset)
            for _ in range(directory_length // PAK_ENTRY.size):
                raw_name, offset, size = PAK_ENTRY.unpack(stream.read(PAK_ENTRY.size))
                name = raw_name.split(b"\0", 1)[0].decode("ascii", "strict").replace("\\", "/").lower()
                if not name or offset < 0 or size < 0 or offset + size > file_size:
                    raise InventoryError(f"invalid PAK member in {pack}: {name!r}")
                # Quake II searches later PAKs first, so later entries replace
                # earlier members without extracting either one.
                result[name] = PackEntry(pack, offset, size)
    return result


def _read_member(entry: PackEntry) -> bytes:
    """Read member."""
    with entry.pack.open("rb") as stream:
        stream.seek(entry.offset)
        data = stream.read(entry.size)
    if len(data) != entry.size:
        raise InventoryError(f"truncated PAK member in {entry.pack}")
    return data


def _entity_text(bsp: bytes, member_name: str) -> str:
    """Return the entity text value."""
    if len(bsp) < 8 + 19 * BSP_LUMP.size or bsp[:4] != b"IBSP":
        raise InventoryError(f"not a BSP38 file: {member_name}")
    version = struct.unpack_from("<i", bsp, 4)[0]
    if version != 38:
        raise InventoryError(f"unsupported BSP version {version}: {member_name}")
    entity_offset, entity_length = BSP_LUMP.unpack_from(bsp, 8)
    if entity_offset < 0 or entity_length < 0 or entity_offset + entity_length > len(bsp):
        raise InventoryError(f"entity lump outside BSP: {member_name}")
    return bsp[entity_offset : entity_offset + entity_length].rstrip(b"\0").decode("latin-1")


def _tokens(text: str) -> Iterable[str]:
    """Return the tokens value."""
    for match in TOKEN.finditer(text):
        quoted, brace, bare = match.groups()
        if quoted is not None:
            yield quoted
        elif brace is not None:
            yield brace
        else:
            yield bare


def _classes(text: str, map_name: str) -> collections.Counter[str]:
    """Return the classes value."""
    values = iter(_tokens(text))
    classes: collections.Counter[str] = collections.Counter()
    entities = 0
    while True:
        try:
            opening = next(values)
        except StopIteration:
            break
        if opening != "{":
            raise InventoryError(f"expected entity opening brace in {map_name}, got {opening!r}")
        classname = ""
        while True:
            try:
                key = next(values)
            except StopIteration as exc:
                raise InventoryError(f"unterminated entity in {map_name}") from exc
            if key == "}":
                break
            try:
                value = next(values)
            except StopIteration as exc:
                raise InventoryError(f"missing value for {key!r} in {map_name}") from exc
            if value in ("{", "}"):
                raise InventoryError(f"invalid value for {key!r} in {map_name}")
            if key.lower() == "classname":
                classname = value.lower()
        classes[classname or "<missing>"] += 1
        entities += 1
    if entities == 0 or classes["worldspawn"] != 1:
        raise InventoryError(f"{map_name} does not contain exactly one worldspawn")
    return classes


def inventory(root: pathlib.Path) -> tuple[pathlib.Path, dict[str, collections.Counter[str]]]:
    """Return the inventory value."""
    baseq2 = _baseq2_directory(root.resolve())
    entries = _pack_entries(baseq2)
    maps: dict[str, collections.Counter[str]] = {}
    for member_name, entry in sorted(entries.items()):
        if not member_name.startswith("maps/") or not member_name.endswith(".bsp"):
            continue
        map_name = member_name[len("maps/") : -len(".bsp")]
        maps[map_name] = _classes(_entity_text(_read_member(entry), member_name), map_name)
    if not maps:
        raise InventoryError(f"no BSP38 maps found in {baseq2 / 'pak*.pak'}")
    return baseq2, maps


def _run_smokes(executable: pathlib.Path, root: pathlib.Path, maps: Iterable[str]) -> dict[str, dict[str, object]]:
    """Run smokes."""
    if not executable.is_file():
        raise InventoryError(f"MiniQuake2 executable not found: {executable}")
    results: dict[str, dict[str, object]] = {}
    for map_name in maps:
        completed = subprocess.run(
            [str(executable), "--asset-smoke", str(root), map_name],
            text=True,
            encoding="utf-8",
            errors="replace",
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
        fields: dict[str, int] = {}
        for line in completed.stdout.splitlines():
            key, separator, value = line.partition("=")
            if separator and key in {"edicts", "skipped-edicts"}:
                try:
                    fields[key] = int(value)
                except ValueError:
                    pass
        results[map_name] = {
            "exit_code": completed.returncode,
            "edicts": fields.get("edicts"),
            "skipped_edicts": fields.get("skipped-edicts"),
            "output": completed.stdout.strip(),
        }
    return results


def _report(baseq2: pathlib.Path, maps: dict[str, collections.Counter[str]], smokes: dict[str, dict[str, object]]) -> dict[str, object]:
    """Return the report value."""
    totals: collections.Counter[str] = collections.Counter()
    map_rows = []
    for map_name, classes in maps.items():
        totals.update(classes)
        row: dict[str, object] = {
            "name": map_name,
            "entities": sum(classes.values()),
            "classes": len(classes),
            "class_counts": dict(sorted(classes.items())),
        }
        if map_name in smokes:
            row["smoke"] = smokes[map_name]
        map_rows.append(row)
    return {
        "baseq2": str(baseq2),
        "map_count": len(maps),
        "single_player_map_count": sum(1 for name in maps if not name.startswith("q2dm")),
        "deathmatch_map_count": sum(1 for name in maps if name.startswith("q2dm")),
        "entity_count": sum(totals.values()),
        "unique_class_count": len(totals),
        "class_counts": dict(sorted(totals.items())),
        "maps": map_rows,
    }


def main() -> int:
    """Run this source file's command-line entry point."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", type=pathlib.Path, help="Quake II install root or baseq2 directory")
    parser.add_argument("--exe", type=pathlib.Path, help="run --asset-smoke for every discovered map")
    parser.add_argument("--json", type=pathlib.Path, help="write the full machine-readable report")
    parser.add_argument("--require-zero-skips", action="store_true", help="fail if any smoke reports skipped edicts")
    args = parser.parse_args()

    try:
        baseq2, maps = inventory(args.root)
        smokes = _run_smokes(args.exe.resolve(), args.root.resolve(), maps) if args.exe else {}
        report = _report(baseq2, maps, smokes)
    except (InventoryError, OSError, struct.error) as exc:
        print(f"retail campaign inventory: FAIL: {exc}", file=sys.stderr)
        return 2

    print(
        "retail campaign inventory: "
        f"maps={report['map_count']} entities={report['entity_count']} "
        f"classes={report['unique_class_count']} "
        f"single-player={report['single_player_map_count']} deathmatch={report['deathmatch_map_count']}"
    )
    failures = 0
    skipped = 0
    for row in report["maps"]:
        suffix = ""
        smoke = row.get("smoke")
        if smoke is not None:
            skipped_value = smoke["skipped_edicts"]
            skipped += skipped_value if isinstance(skipped_value, int) else 0
            if smoke["exit_code"] != 0:
                failures += 1
                last_line = str(smoke["output"]).splitlines()[-1] if smoke["output"] else "no output"
                suffix = f" smoke=FAIL({smoke['exit_code']}) {last_line}"
            else:
                suffix = f" smoke=PASS live={smoke['edicts']} skipped={skipped_value}"
        print(f"  {row['name']:<16} entities={row['entities']:>4} classes={row['classes']:>3}{suffix}")
    if smokes:
        print(f"campaign asset smoke: maps={len(smokes)} failures={failures} skipped={skipped}")

    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")

    if failures or (args.require_zero_skips and skipped):
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
