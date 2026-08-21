# Quake II 3.19 Reference Inventory

`PORT_LEDGER.json` is generated from the nested, read-only
`Quake-2-original-source` repository. The generator requires exact Git commit
`372afde46e7defc9dd2d719a1732b8ace1fa096e` and refuses local modifications.

## Inventory coverage

| Item | Count |
| --- | ---: |
| Git-tracked reference files | 371 |
| C translation units (`.c`) | 187 |
| C headers (`.h`) | 77 |
| C/header files | 264 |
| C function definitions | 4,525 |
| First-release-required function definitions | 2,574 |
| Deferred function definitions | 965 |
| Out-of-scope platform function definitions | 986 |

Every tracked file records its path, SHA-256, size, kind, status, planned
subsystem, port-plan point, scope, and disposition. Every C function definition
records its source path, source line, name, normalized-signature SHA-256,
status, subsystem, plan point, scope, and disposition.

All current function and file statuses are `reference`. This is intentionally
not a completion state: it means only that the original behavior has been
inventoried. A future verifier must require a named MiniLang target or approved
adapter plus evidence before accepting an implemented classification.

## Extraction semantics

The C extractor removes comments while preserving newlines, then recognizes
column-zero function definitions in the formatting used by the release. It
includes static helpers, generated OpenGL logging wrappers, and definitions in
conditional branches. Two conditionally compiled definitions of the same
function remain two entries with distinct line-based IDs.

Header prototypes are not function definitions and therefore are not counted;
all headers are nevertheless individually fingerprinted. Non-C native sources
(`.asm`, `.s`, `.i386`, `.AXP`, and Objective-C `.m`), build metadata, project
files, and binary reference artifacts are included in the file inventory but
not in the function count.

The reference tree digest is SHA-256 over a canonical, path-sorted sequence of
`<file-sha256><two spaces><path><newline>` rows. The ledger's own
`inventory_sha256` covers canonical JSON before that field is added.

## Scope classification

- `release_required`: Win32 platform, qcommon, collision/formats, client,
  server, OpenGL renderer, and the base game needed by the first release.
- `deferred`: CTF, software renderer, and associated platform support.
- `out_of_scope`: historic non-Windows platform implementations.
- `reference_only`: distribution/build metadata with no direct port target.
- `asset_excluded`: the three files below the reference `baseq2` directory;
  these must not enter MiniQuake2 packages.

The inventory intentionally retains deferred and out-of-scope functions. This
prevents apparent coverage gains caused by silently dropping original files.

## Reproduction and validation

```powershell
python MiniQuake2\docs\reference\generate_port_ledger.py `
  --reference-root MiniQuake2\Quake-2-original-source `
  --output MiniQuake2\PORT_LEDGER.json

python MiniQuake2\docs\reference\generate_port_ledger.py `
  --reference-root MiniQuake2\Quake-2-original-source `
  --output MiniQuake2\PORT_LEDGER.json `
  --check
```

The built-in validation asserts the exact file/function counts, unique paths
and definition IDs, per-file function totals, and `reference` status for every
entry. JSON parsing is an additional required check.
