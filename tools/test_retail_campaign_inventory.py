#!/usr/bin/env python3
"""Self-contained tests for the read-only retail campaign inventory."""

from __future__ import annotations

import pathlib
import struct
import sys
import tempfile
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import retail_campaign_inventory as inventory


def bsp(entity_text: str) -> bytes:
    header_size = 8 + 19 * inventory.BSP_LUMP.size
    payload = entity_text.encode("latin-1") + b"\0"
    header = bytearray(header_size)
    header[:4] = b"IBSP"
    struct.pack_into("<i", header, 4, 38)
    inventory.BSP_LUMP.pack_into(header, 8, header_size, len(payload))
    return bytes(header) + payload


def pack(members: dict[str, bytes]) -> bytes:
    output = bytearray(inventory.PAK_HEADER.size)
    directory = bytearray()
    for name, data in members.items():
        offset = len(output)
        output.extend(data)
        encoded = name.encode("ascii")
        if len(encoded) >= 56:
            raise ValueError("fixture member name too long")
        directory.extend(inventory.PAK_ENTRY.pack(encoded + bytes(56 - len(encoded)), offset, len(data)))
    directory_offset = len(output)
    output.extend(directory)
    inventory.PAK_HEADER.pack_into(output, 0, b"PACK", directory_offset, len(directory))
    return bytes(output)


class RetailCampaignInventoryTests(unittest.TestCase):
    def test_pack_precedence_and_entity_counts(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            baseq2 = pathlib.Path(temporary) / "baseq2"
            baseq2.mkdir()
            first = '{\n"classname" "worldspawn"\n}\n{\n"classname" "light"\n}\n'
            replacement = '{\n"classname" "worldspawn"\n}\n{\n"classname" "func_door"\n}\n'
            second = '{\n"classname" "worldspawn"\n}\n{\n"classname" "monster_soldier"\n}\n'
            (baseq2 / "pak0.pak").write_bytes(pack({"maps/one.bsp": bsp(first)}))
            (baseq2 / "pak1.pak").write_bytes(
                pack({"MAPS\\ONE.BSP": bsp(replacement), "maps/two.bsp": bsp(second)})
            )

            resolved, maps = inventory.inventory(pathlib.Path(temporary))
            self.assertEqual(resolved, baseq2)
            self.assertEqual(list(maps), ["one", "two"])
            self.assertEqual(maps["one"], {"worldspawn": 1, "func_door": 1})
            self.assertEqual(maps["two"], {"worldspawn": 1, "monster_soldier": 1})

    def test_rejects_bad_bsp_and_escaping_pack_member(self) -> None:
        with self.assertRaises(inventory.InventoryError):
            inventory._entity_text(b"not-a-bsp", "maps/bad.bsp")
        with tempfile.TemporaryDirectory() as temporary:
            root = pathlib.Path(temporary)
            (root / "pak0.pak").write_bytes(pack({"maps/bad.bsp": b"broken"}))
            with self.assertRaises(inventory.InventoryError):
                inventory.inventory(root)

    def test_tracks_entities_without_classname(self) -> None:
        text = '{\n"classname" "worldspawn"\n}\n{\n"origin" "1 2 3"\n}\n'
        self.assertEqual(inventory._classes(text, "fixture"), {"worldspawn": 1, "<missing>": 1})

    def test_backslash_does_not_escape_closing_quote(self) -> None:
        text = '{\n"classname" "worldspawn"\n}\n{\n"light" "175\\"\n"classname" "light"\n}\n'
        self.assertEqual(inventory._classes(text, "fixture"), {"worldspawn": 1, "light": 1})


if __name__ == "__main__":
    unittest.main()
