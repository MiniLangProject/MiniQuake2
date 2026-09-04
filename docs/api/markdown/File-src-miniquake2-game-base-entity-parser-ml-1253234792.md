# `src/miniquake2/game/base/entity_parser.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game base entity parser facilities for this project.

Package: [`miniquake2.game.base.entity_parser`](Package-miniquake2-game-base-entity-parser-907756417.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/base/types.ml` as `btypes` → [src/miniquake2/game/base/types.ml](File-src-miniquake2-game-base-types-ml-1537748126.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)

## Declarations

<a id="function-function-miniquake2-game-base-entity-parser-appendunknown-function-appendunknown-entity-key-src-miniquake2-game-base-entity-parser-ml-1765646081"></a>
### appendUnknown

```ml
function appendUnknown(entity, key)
```

Append unknown.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L332)

<a id="function-function-miniquake2-game-base-entity-parser-createscanner-function-createscanner-value-src-miniquake2-game-base-entity-parser-ml-61449708"></a>
### createScanner

```ml
function createScanner(value)
```

Create scanner.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L57)

<a id="function-function-miniquake2-game-base-entity-parser-ed-newstring-function-ed-newstring-value-src-miniquake2-game-base-entity-parser-ml-108080448"></a>
### ED_NewString

```ml
function ED_NewString(value)
```

Exact ED_NewString behavior: \n becomes a newline; every other backslash pair becomes one literal backslash and discards the second byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L34)

<a id="function-function-miniquake2-game-base-entity-parser-ed-parsefield-function-ed-parsefield-entity-key-value-src-miniquake2-game-base-entity-parser-ml-652935302"></a>
### ED_ParseField

```ml
function ED_ParseField(entity, key, value)
```

Returns true for a recognized field and false for the original diagnostic path ("... is not a field"). Utility keys beginning with _ are ignored.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L342)

<a id="function-function-miniquake2-game-base-entity-parser-finishprefix-function-finishprefix-values-count-src-miniquake2-game-base-entity-parser-ml-1298835676"></a>
### finishPrefix

```ml
function finishPrefix(values, count)
```

Finish prefix.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L129)

<a id="function-function-miniquake2-game-base-entity-parser-iswhitespace-function-iswhitespace-value-src-miniquake2-game-base-entity-parser-ml-1887346404"></a>
### isWhitespace

```ml
function isWhitespace(value)
```

Report whether is whitespace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L27)

<a id="function-function-miniquake2-game-base-entity-parser-materialize-function-materialize-parsed-src-miniquake2-game-base-entity-parser-ml-2098411772"></a>
### materialize

```ml
function materialize(parsed)
```

Materialize state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `parsed` | `dynamic` | — | parsed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L405)

<a id="function-function-miniquake2-game-base-entity-parser-nexttoken-function-nexttoken-scanner-src-miniquake2-game-base-entity-parser-ml-2010795261"></a>
### nextToken

```ml
function nextToken(scanner)
```

Return the next token value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scanner` | `dynamic` | — | scanner value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L94)

<a id="function-function-miniquake2-game-base-entity-parser-parseentities-function-parseentities-value-src-miniquake2-game-base-entity-parser-ml-840814984"></a>
### parseEntities

```ml
function parseEntities(value)
```

Parse entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L142)

<a id="function-function-miniquake2-game-base-entity-parser-parseinteger-function-parseinteger-value-fieldname-src-miniquake2-game-base-entity-parser-ml-1537122645"></a>
### parseInteger

```ml
function parseInteger(value, fieldName)
```

Parse integer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `fieldName` | `dynamic` | — | fieldName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L298)

<a id="function-function-miniquake2-game-base-entity-parser-parsematerializedentities-function-parsematerializedentities-value-src-miniquake2-game-base-entity-parser-ml-719488954"></a>
### parseMaterializedEntities

```ml
function parseMaterializedEntities(value)
```

Production spawn ingestion deliberately does not retain EntityPair token strings.  Each field is consumed while both scanner tokens and the target BaseEntity are live locals, so a long sequence of retail level loads cannot expose an old pair through a later allocation/collection boundary.  The ParsedEntity API above remains available for syntax/contract inspection.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L202)

<a id="function-function-miniquake2-game-base-entity-parser-parsenumber-function-parsenumber-value-fieldname-src-miniquake2-game-base-entity-parser-ml-1769113917"></a>
### parseNumber

```ml
function parseNumber(value, fieldName)
```

Parse number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `fieldName` | `dynamic` | — | fieldName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L242)

<a id="function-function-miniquake2-game-base-entity-parser-parsererror-function-parsererror-code-offset-message-src-miniquake2-game-base-entity-parser-ml-221324166"></a>
### parserError

```ml
function parserError(code, offset, message)
```

Return the parser error value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `code` | `dynamic` | — | code value consumed by this operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L21)

<a id="function-function-miniquake2-game-base-entity-parser-parsevector-function-parsevector-value-fieldname-src-miniquake2-game-base-entity-parser-ml-439158457"></a>
### parseVector

```ml
function parseVector(value, fieldName)
```

Parse vector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `fieldName` | `dynamic` | — | fieldName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L306)

<a id="function-function-miniquake2-game-base-entity-parser-skiptrivia-function-skiptrivia-scanner-src-miniquake2-game-base-entity-parser-ml-614257833"></a>
### skipTrivia

```ml
function skipTrivia(scanner)
```

Return the skip trivia value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scanner` | `dynamic` | — | scanner value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/entity_parser.ml#L74)
