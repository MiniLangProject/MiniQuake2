# `src/miniquake2/renderer/validation.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer validation facilities for this project.

Package: [`miniquake2.renderer.validation`](Package-miniquake2-renderer-validation-1260912305.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/renderer/constants.ml` as `rc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)
- `miniquake2/renderer/types.ml` as `rt` → [src/miniquake2/renderer/types.ml](File-src-miniquake2-renderer-types-ml-975707623.md)

## Declarations

<a id="function-function-miniquake2-renderer-validation-invalid-function-invalid-code-message-src-miniquake2-renderer-validation-ml-1882367578"></a>
### invalid

```ml
function invalid(code, message)
```

Return the invalid value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `code` | `dynamic` | — | code value consumed by this operation. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L31)

<a id="function-function-miniquake2-renderer-validation-numeric-function-numeric-value-src-miniquake2-renderer-validation-ml-1066987277"></a>
### numeric

```ml
function numeric(value)
```

Performs the numeric operation for the miniquake2 renderer validation module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L37)

<a id="function-function-miniquake2-renderer-validation-requirefunction-function-requirefunction-value-fieldname-src-miniquake2-renderer-validation-ml-506429128"></a>
### requireFunction

```ml
function requireFunction(value, fieldName)
```

Require function.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `fieldName` | `dynamic` | — | fieldName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L178)

<a id="function-function-miniquake2-renderer-validation-valid-function-valid-src-miniquake2-renderer-validation-ml-1218753738"></a>
### valid

```ml
function valid()
```

Report whether valid.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L24)

<a id="function-function-miniquake2-renderer-validation-validatedlight-function-validatedlight-value-index-src-miniquake2-renderer-validation-ml-1402866899"></a>
### validateDLight

```ml
function validateDLight(value, index)
```

Validate d light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L76)

<a id="function-function-miniquake2-renderer-validation-validateentity-function-validateentity-value-index-src-miniquake2-renderer-validation-ml-664947371"></a>
### validateEntity

```ml
function validateEntity(value, index)
```

Validate entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L57)

<a id="function-function-miniquake2-renderer-validation-validatelightstyle-function-validatelightstyle-value-index-src-miniquake2-renderer-validation-ml-1129555615"></a>
### validateLightStyle

```ml
function validateLightStyle(value, index)
```

Validate light style.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L100)

<a id="function-function-miniquake2-renderer-validation-validateparticle-function-validateparticle-value-index-src-miniquake2-renderer-validation-ml-1504941187"></a>
### validateParticle

```ml
function validateParticle(value, index)
```

Validate particle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L88)

<a id="function-function-miniquake2-renderer-validation-validaterefdef-function-validaterefdef-frame-src-miniquake2-renderer-validation-ml-149715543"></a>
### validateRefDef

```ml
function validateRefDef(frame)
```

Validate ref def.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L120)

<a id="function-function-miniquake2-renderer-validation-validaterefexport-function-validaterefexport-exports-src-miniquake2-renderer-validation-ml-2059339091"></a>
### validateRefExport

```ml
function validateRefExport(exports)
```

Validate ref export.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L209)

<a id="function-function-miniquake2-renderer-validation-validaterefimport-function-validaterefimport-imports-src-miniquake2-renderer-validation-ml-1289731778"></a>
### validateRefImport

```ml
function validateRefImport(imports)
```

Validate ref import.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `imports` | `dynamic` | — | imports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L185)

<a id="function-function-miniquake2-renderer-validation-validatevec3-function-validatevec3-value-fieldname-src-miniquake2-renderer-validation-ml-574980578"></a>
### validateVec3

```ml
function validateVec3(value, fieldName)
```

Validate vec 3.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `fieldName` | `dynamic` | — | fieldName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/validation.ml#L45)

- [miniquake2.renderer.validation.ValidationResult](Type-miniquake2-renderer-validation-validationresult-94742219.md) — struct
