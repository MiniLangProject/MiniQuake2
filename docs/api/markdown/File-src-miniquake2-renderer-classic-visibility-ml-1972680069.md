# `src/miniquake2/renderer/classic/visibility.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer classic visibility facilities for this project.

Package: [`miniquake2.renderer.classic.visibility`](Package-miniquake2-renderer-classic-visibility-1264506132.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/bsp.ml` as `fbsp` → [src/miniquake2/format/bsp.ml](File-src-miniquake2-format-bsp-ml-2080213539.md)
- `miniquake2/format/constants.ml` as `fc` → [src/miniquake2/format/constants.ml](File-src-miniquake2-format-constants-ml-1556940367.md)
- `miniquake2/format/types.ml` as `ft` → [src/miniquake2/format/types.ml](File-src-miniquake2-format-types-ml-129451131.md)
- `miniquake2/qcommon/byteio.ml` as `rvisibilitybyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/renderer/classic/constants.ml` as `rclassicconstants` → [src/miniquake2/renderer/classic/constants.ml](File-src-miniquake2-renderer-classic-constants-ml-1818163902.md)
- `miniquake2/renderer/classic/types.ml` as `rclassictypes` → [src/miniquake2/renderer/classic/types.ml](File-src-miniquake2-renderer-classic-types-ml-1346078158.md)
- `miniquake2/renderer/constants.ml` as `rc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)
- `std/array.ml` as `rvisibilityarray` → `../MiniLangCompilerML/std/array.ml` — external dependency
- `std/bytes.ml` as `rvisibilitybytes` → `../MiniLangCompilerML/std/bytes.ml` — external dependency
- `std/math.ml` as `rvisibilitymath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="constant-constant-miniquake2-renderer-classic-visibility-backface-epsilon-const-backface-epsilon-1-e-002-src-miniquake2-renderer-classic-visibility-ml-1312437185"></a>
### BACKFACE_EPSILON

```ml
const BACKFACE_EPSILON = 1.e-002
```

Defines the backface epsilon constant used by the miniquake2 renderer classic visibility module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L31)

- [miniquake2.renderer.classic.visibility.ClassicAlphaOrderState](Type-miniquake2-renderer-classic-visibility-classicalphaorderstate-1643975303.md) — struct
- [miniquake2.renderer.classic.visibility.ClassicBrushBounds](Type-miniquake2-renderer-classic-visibility-classicbrushbounds-1619649763.md) — struct
- [miniquake2.renderer.classic.visibility.ClassicBrushSelection](Type-miniquake2-renderer-classic-visibility-classicbrushselection-1612980036.md) — struct
- [miniquake2.renderer.classic.visibility.ClassicFrustumPlane](Type-miniquake2-renderer-classic-visibility-classicfrustumplane-1078358978.md) — struct
- [miniquake2.renderer.classic.visibility.ClassicPvsSelection](Type-miniquake2-renderer-classic-visibility-classicpvsselection-1044179329.md) — struct
- [miniquake2.renderer.classic.visibility.ClassicViewClusters](Type-miniquake2-renderer-classic-visibility-classicviewclusters-679721792.md) — struct
<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityangleaxes-function-classicvisibilityangleaxes-angles-src-miniquake2-renderer-classic-visibility-ml-825104275"></a>
### classicVisibilityAngleAxes

```ml
function classicVisibilityAngleAxes(angles)
```

Return the classic visibility angle axes value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angles` | `dynamic` | — | angles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L296)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityappendalphanode-function-classicvisibilityappendalphanode-state-nodeindex-src-miniquake2-renderer-classic-visibility-ml-627570910"></a>
### classicVisibilityAppendAlphaNode

```ml
function classicVisibilityAppendAlphaNode(state, nodeIndex)
```

Append one BSP node in the order produced when R_RecursiveWorldNode's front-to-back traversal inserts transparent surfaces at the chain head.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `nodeIndex` | `dynamic` | — | Zero-based index of node. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L843)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityareaallowed-inline-function-classicvisibilityareaallowed-areabits-area-src-miniquake2-renderer-classic-visibility-ml-1673091752"></a>
### classicVisibilityAreaAllowed

```ml
inline function classicVisibilityAreaAllowed(areaBits, area)
```

Return the classic visibility area allowed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `areaBits` | `dynamic` | — | areaBits value consumed by this operation. |
| `area` | `dynamic` | — | area value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L248)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityareabitsequal-inline-function-classicvisibilityareabitsequal-first-second-src-miniquake2-renderer-classic-visibility-ml-834118356"></a>
### classicVisibilityAreaBitsEqual

```ml
inline function classicVisibilityAreaBitsEqual(first, second)
```

Report whether classic visibility area bits equal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L188)

- [miniquake2.renderer.classic.visibility.ClassicVisibilityAxes](Type-miniquake2-renderer-classic-visibility-classicvisibilityaxes-995069611.md) — struct
<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityboxoutsideplane-inline-function-classicvisibilityboxoutsideplane-draw-plane-src-miniquake2-renderer-classic-visibility-ml-1770569660"></a>
### classicVisibilityBoxOutsidePlane

```ml
inline function classicVisibilityBoxOutsidePlane(draw, plane)
```

Return the classic visibility box outside plane value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `plane` | `dynamic` | — | plane value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L343)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitybrushbounds-function-classicvisibilitybrushbounds-brushmodel-entity-src-miniquake2-renderer-classic-visibility-ml-588847693"></a>
### classicVisibilityBrushBounds

```ml
function classicVisibilityBrushBounds(brushModel, entity)
```

Return the classic visibility brush bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `brushModel` | `dynamic` | — | brushModel value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L492)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitybrushlocalview-function-classicvisibilitybrushlocalview-entity-vieworigin-src-miniquake2-renderer-classic-visibility-ml-2003236295"></a>
### classicVisibilityBrushLocalView

```ml
function classicVisibilityBrushLocalView(entity, viewOrigin)
```

Return the classic visibility brush local view value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L559)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitybrushmodelvisible-function-classicvisibilitybrushmodelvisible-brushmodel-entity-frame-src-miniquake2-renderer-classic-visibility-ml-1883129062"></a>
### classicVisibilityBrushModelVisible

```ml
function classicVisibilityBrushModelVisible(brushModel, entity, frame)
```

Report whether classic visibility brush model visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `brushModel` | `dynamic` | — | brushModel value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L576)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitybrushmodelvisibleprepared-function-classicvisibilitybrushmodelvisibleprepared-brushmodel-entity-planes-src-miniquake2-renderer-classic-visibility-ml-557280796"></a>
### classicVisibilityBrushModelVisiblePrepared

```ml
function classicVisibilityBrushModelVisiblePrepared(brushModel, entity, planes)
```

Report whether classic visibility brush model visible in prepared frustum.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `brushModel` | `dynamic` | — | brushModel value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `planes` | `dynamic` | — | planes value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L586)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitybrushworldpoint-function-classicvisibilitybrushworldpoint-entity-localpoint-src-miniquake2-renderer-classic-visibility-ml-713607579"></a>
### classicVisibilityBrushWorldPoint

```ml
function classicVisibilityBrushWorldPoint(entity, localPoint)
```

Return the classic visibility brush world point value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `localPoint` | `dynamic` | — | localPoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L542)

<a id="global-global-miniquake2-renderer-classic-visibility-classicvisibilitycacheslot-classicvisibilitycacheslot-src-miniquake2-renderer-classic-visibility-ml-1221317625"></a>
### classicVisibilityCacheSlot

```ml
classicVisibilityCacheSlot
```

Stores module-wide classic visibility cache slot state for the miniquake2 renderer classic visibility module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L170)

- [miniquake2.renderer.classic.visibility.ClassicVisibilityCacheSlot](Type-miniquake2-renderer-classic-visibility-classicvisibilitycacheslot-638337508.md) — struct
<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitycopyareabits-function-classicvisibilitycopyareabits-value-src-miniquake2-renderer-classic-visibility-ml-1167206308"></a>
### classicVisibilityCopyAreaBits

```ml
function classicVisibilityCopyAreaBits(value)
```

Copy classic visibility area bits.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L201)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityculledcount-function-classicvisibilityculledcount-selection-src-miniquake2-renderer-classic-visibility-ml-1929997361"></a>
### classicVisibilityCulledCount

```ml
function classicVisibilityCulledCount(selection)
```

Return the classic visibility culled count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `selection` | `dynamic` | — | selection value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L932)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityfinishselection-function-classicvisibilityfinishselection-pvs-frame-src-miniquake2-renderer-classic-visibility-ml-1187195475"></a>
### classicVisibilityFinishSelection

```ml
function classicVisibilityFinishSelection(pvs, frame)
```

Finish classic visibility selection with a compact public array. This keeps the diagnostic API while product rendering avoids the per-frame copy.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pvs` | `dynamic` | — | pvs value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L752)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityfinishselectionprefix-function-classicvisibilityfinishselectionprefix-pvs-frame-src-miniquake2-renderer-classic-visibility-ml-507955395"></a>
### classicVisibilityFinishSelectionPrefix

```ml
function classicVisibilityFinishSelectionPrefix(pvs, frame)
```

Finish classic visibility selection into reusable prefix storage. The count is authoritative; live rendering must not scan the unused capacity tail.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pvs` | `dynamic` | — | pvs value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L720)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityfrontfacing-function-classicvisibilityfrontfacing-draw-vieworigin-src-miniquake2-renderer-classic-visibility-ml-792265364"></a>
### classicVisibilityFrontFacing

```ml
function classicVisibilityFrontFacing(draw, viewOrigin)
```

Return the classic visibility front facing value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L482)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityfrontfacingfixed-inline-function-classicvisibilityfrontfacingfixed-draw-viewx-viewy-viewz-src-miniquake2-renderer-classic-visibility-ml-920627290"></a>
### classicVisibilityFrontFacingFixed

```ml
inline function classicVisibilityFrontFacingFixed(draw, viewX, viewY, viewZ)
```

Return the classic visibility front facing fixed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `viewX` | `dynamic` | — | viewX value consumed by this operation. |
| `viewY` | `dynamic` | — | viewY value consumed by this operation. |
| `viewZ` | `dynamic` | — | viewZ value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L470)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityfrustum-function-classicvisibilityfrustum-frame-src-miniquake2-renderer-classic-visibility-ml-1804665112"></a>
### classicVisibilityFrustum

```ml
function classicVisibilityFrustum(frame)
```

Return the classic visibility frustum value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L392)

<a id="global-global-miniquake2-renderer-classic-visibility-classicvisibilityfrustumscratch-classicvisibilityfrustumscratch-src-miniquake2-renderer-classic-visibility-ml-1108308497"></a>
### classicVisibilityFrustumScratch

```ml
classicVisibilityFrustumScratch
```

Stores module-wide classic visibility frustum scratch state for the miniquake2 renderer classic visibility module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L176)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityinsidefrustum-function-classicvisibilityinsidefrustum-draw-frame-src-miniquake2-renderer-classic-visibility-ml-390972186"></a>
### classicVisibilityInsideFrustum

```ml
function classicVisibilityInsideFrustum(draw, frame)
```

Report whether classic visibility inside frustum.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L439)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityinsidepreparedfrustum-inline-function-classicvisibilityinsidepreparedfrustum-draw-planes-src-miniquake2-renderer-classic-visibility-ml-341723595"></a>
### classicVisibilityInsidePreparedFrustum

```ml
inline function classicVisibilityInsidePreparedFrustum(draw, planes)
```

Report whether classic visibility inside prepared frustum.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `planes` | `dynamic` | — | planes value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L423)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitymarkleaffaces-function-classicvisibilitymarkleaffaces-map-leaf-marked-src-miniquake2-renderer-classic-visibility-ml-2097854593"></a>
### classicVisibilityMarkLeafFaces

```ml
function classicVisibilityMarkLeafFaces(map, leaf, marked)
```

Mark classic visibility leaf faces.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `leaf` | `dynamic` | — | leaf value consumed by this operation. |
| `marked` | `dynamic` | — | marked value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L260)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityplane-inline-function-classicvisibilityplane-normalx-normaly-normalz-distance-src-miniquake2-renderer-classic-visibility-ml-490486337"></a>
### classicVisibilityPlane

```ml
inline function classicVisibilityPlane(normalX, normalY, normalZ, distance)
```

Return the classic visibility plane value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `normalX` | `dynamic` | — | normalX value consumed by this operation. |
| `normalY` | `dynamic` | — | normalY value consumed by this operation. |
| `normalZ` | `dynamic` | — | normalZ value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L356)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitypointleaf-function-classicvisibilitypointleaf-map-origin-src-miniquake2-renderer-classic-visibility-ml-838877343"></a>
### classicVisibilityPointLeaf

```ml
function classicVisibilityPointLeaf(map, origin)
```

Return the classic visibility point leaf value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L215)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitypvscontains-inline-function-classicvisibilitypvscontains-row-cluster-src-miniquake2-renderer-classic-visibility-ml-453448864"></a>
### classicVisibilityPvsContains

```ml
inline function classicVisibilityPvsContains(row, cluster)
```

Report whether classic visibility pvs contains.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `row` | `dynamic` | — | row value consumed by this operation. |
| `cluster` | `dynamic` | — | cluster value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L287)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitypvsrow-function-classicvisibilitypvsrow-map-cluster-src-miniquake2-renderer-classic-visibility-ml-1400577385"></a>
### classicVisibilityPvsRow

```ml
function classicVisibilityPvsRow(map, cluster)
```

Return the classic visibility pvs row value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `cluster` | `dynamic` | — | cluster value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L276)

<a id="global-global-miniquake2-renderer-classic-visibility-classicvisibilityselectionscratch-classicvisibilityselectionscratch-src-miniquake2-renderer-classic-visibility-ml-1503266789"></a>
### classicVisibilitySelectionScratch

```ml
classicVisibilitySelectionScratch
```

Stores module-wide classic visibility selection scratch state for the miniquake2 renderer classic visibility module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L174)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityselectpvs-function-classicvisibilityselectpvs-world-frame-src-miniquake2-renderer-classic-visibility-ml-108650804"></a>
### classicVisibilitySelectPvs

```ml
function classicVisibilitySelectPvs(world, frame)
```

Select classic visibility pvs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L652)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitysetplane-inline-function-classicvisibilitysetplane-plane-normalx-normaly-normalz-distance-src-miniquake2-renderer-classic-visibility-ml-22857407"></a>
### classicVisibilitySetPlane

```ml
inline function classicVisibilitySetPlane(plane, normalX, normalY, normalZ, distance)
```

Update one reusable fixed-point frustum plane without allocating a record.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plane` | `dynamic` | — | plane value consumed by this operation. |
| `normalX` | `dynamic` | — | normalX value consumed by this operation. |
| `normalY` | `dynamic` | — | normalY value consumed by this operation. |
| `normalZ` | `dynamic` | — | normalZ value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L375)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitysphereinsidefrustum-function-classicvisibilitysphereinsidefrustum-origin-radius-frame-src-miniquake2-renderer-classic-visibility-ml-60763764"></a>
### classicVisibilitySphereInsideFrustum

```ml
function classicVisibilitySphereInsideFrustum(origin, radius, frame)
```

Test a conservative world-space sphere against the prepared fixed-point frustum. Alias models use this with their current/previous pose union radius so no interpolated vertex can be clipped prematurely.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L450)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitystockalphadraws-function-classicvisibilitystockalphadraws-world-draws-vieworigin-src-miniquake2-renderer-classic-visibility-ml-1002517179"></a>
### classicVisibilityStockAlphaDraws

```ml
function classicVisibilityStockAlphaDraws(world, draws, viewOrigin)
```

Order visible world alpha polygons exactly like ref_gl's global alpha chain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L875)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilitystockalphadrawsprefix-function-classicvisibilitystockalphadrawsprefix-world-draws-drawcount-vieworigin-src-miniquake2-renderer-classic-visibility-ml-920201570"></a>
### classicVisibilityStockAlphaDrawsPrefix

```ml
function classicVisibilityStockAlphaDrawsPrefix(world, draws, drawCount, viewOrigin)
```

Order a visible alpha prefix using world-owned scratch storage. This is the live equivalent of classicVisibilityStockAlphaDraws without allocating two face tables and an output array on every rendered frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `drawCount` | `dynamic` | — | Number of draw to process. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L904)

<a id="function-function-miniquake2-renderer-classic-visibility-classicvisibilityviewclusters-function-classicvisibilityviewclusters-map-origin-src-miniquake2-renderer-classic-visibility-ml-679163127"></a>
### classicVisibilityViewClusters

```ml
function classicVisibilityViewClusters(map, origin)
```

Match R_SetupFrame's second-cluster probe so crossing a solid water boundary exposes both PVS rows instead of popping the opposite side of the surface.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L320)

<a id="function-function-miniquake2-renderer-classic-visibility-compactclassicdraws-function-compactclassicdraws-values-count-src-miniquake2-renderer-classic-visibility-ml-134455572"></a>
### compactClassicDraws

```ml
function compactClassicDraws(values, count)
```

Return the compact classic draws value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L637)

<a id="function-function-miniquake2-renderer-classic-visibility-selectclassicbrushmodel-function-selectclassicbrushmodel-brushmodel-entity-frame-src-miniquake2-renderer-classic-visibility-ml-1427680608"></a>
### selectClassicBrushModel

```ml
function selectClassicBrushModel(brushModel, entity, frame)
```

Select classic brush model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `brushModel` | `dynamic` | — | brushModel value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L626)

<a id="function-function-miniquake2-renderer-classic-visibility-selectclassicbrushmodelprepared-function-selectclassicbrushmodelprepared-brushmodel-entity-frame-planes-src-miniquake2-renderer-classic-visibility-ml-1411573087"></a>
### selectClassicBrushModelPrepared

```ml
function selectClassicBrushModelPrepared(brushModel, entity, frame, planes)
```

Select a classic brush model using the frame-owned frustum and retain the local view point needed by the special-surface planner.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `brushModel` | `dynamic` | — | brushModel value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `planes` | `dynamic` | — | planes value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L598)

<a id="function-function-miniquake2-renderer-classic-visibility-selectclassicworld-function-selectclassicworld-world-frame-src-miniquake2-renderer-classic-visibility-ml-1813417056"></a>
### selectClassicWorld

```ml
function selectClassicWorld(world, frame)
```

Select classic world.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L764)

<a id="function-function-miniquake2-renderer-classic-visibility-selectclassicworldcached-function-selectclassicworldcached-world-frame-src-miniquake2-renderer-classic-visibility-ml-311316144"></a>
### selectClassicWorldCached

```ml
function selectClassicWorldCached(world, frame)
```

Product snapshots carry an area-bit array on every frame even when no door changed. Key the cached candidate list by its contents as well as cluster; treating every non-void array as an override forced a full BSP/PVS scan of roughly 7k surfaces every rendered frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L783)

<a id="function-function-miniquake2-renderer-classic-visibility-selectclassicworldcachedprefix-function-selectclassicworldcachedprefix-world-frame-src-miniquake2-renderer-classic-visibility-ml-73744704"></a>
### selectClassicWorldCachedPrefix

```ml
function selectClassicWorldCachedPrefix(world, frame)
```

Cached product selection retaining the capacity-sized reusable output.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L813)

<a id="function-function-miniquake2-renderer-classic-visibility-selectclassicworldprefix-function-selectclassicworldprefix-world-frame-src-miniquake2-renderer-classic-visibility-ml-1638367640"></a>
### selectClassicWorldPrefix

```ml
function selectClassicWorldPrefix(world, frame)
```

Select the world into reusable prefix storage for live OpenGL submission.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L772)

<a id="constant-constant-miniquake2-renderer-classic-visibility-visibility-deg-to-rad-const-visibility-deg-to-rad-1-74532925199433e-002-src-miniquake2-renderer-classic-visibility-ml-306317087"></a>
### VISIBILITY_DEG_TO_RAD

```ml
const VISIBILITY_DEG_TO_RAD = 1.74532925199433e-002
```

Defines the visibility deg to rad constant used by the miniquake2 renderer classic visibility module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L25)

<a id="constant-constant-miniquake2-renderer-classic-visibility-visibility-far-const-visibility-far-8192-src-miniquake2-renderer-classic-visibility-ml-356412572"></a>
### VISIBILITY_FAR

```ml
const VISIBILITY_FAR = 8192.
```

Defines the visibility far constant used by the miniquake2 renderer classic visibility module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L29)

<a id="constant-constant-miniquake2-renderer-classic-visibility-visibility-near-const-visibility-near-4-src-miniquake2-renderer-classic-visibility-ml-1707133490"></a>
### VISIBILITY_NEAR

```ml
const VISIBILITY_NEAR = 4.
```

Defines the visibility near constant used by the miniquake2 renderer classic visibility module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L27)
