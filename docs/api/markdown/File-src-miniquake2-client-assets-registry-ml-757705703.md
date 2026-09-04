# `src/miniquake2/client/assets/registry.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client assets registry facilities for this project.

Package: [`miniquake2.client.assets.registry`](Package-miniquake2-client-assets-registry-1269383860.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/assets/types.ml` as `cartypes` → [src/miniquake2/client/assets/types.ml](File-src-miniquake2-client-assets-types-ml-365285419.md)
- `miniquake2/qcommon/constants.ml` as `carqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/text.ml` as `cartext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)

## Declarations

<a id="function-function-miniquake2-client-assets-registry-appendbounded-function-appendbounded-values-value-maximum-src-miniquake2-client-assets-registry-ml-1221204128"></a>
### appendBounded

```ml
function appendBounded(values, value, maximum)
```

Append bounded.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L160)

<a id="function-function-miniquake2-client-assets-registry-bindings-function-bindings-state-src-miniquake2-client-assets-registry-ml-1548022636"></a>
### bindings

```ml
function bindings(state)
```

Return the bindings value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L857)

<a id="function-function-miniquake2-client-assets-registry-cached-function-cached-values-name-generation-src-miniquake2-client-assets-registry-ml-857874"></a>
### cached

```ml
function cached(values, name, generation)
```

Report whether cached.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `generation` | `dynamic` | — | generation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L189)

<a id="function-function-miniquake2-client-assets-registry-cachenamed-function-cachenamed-state-kind-entry-src-miniquake2-client-assets-registry-ml-98316616"></a>
### cacheNamed

```ml
function cacheNamed(state, kind, entry)
```

Cache named.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `entry` | `dynamic` | — | entry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L210)

<a id="function-function-miniquake2-client-assets-registry-callbacks-function-callbacks-loadmodel-loadskin-loadsound-onmissing-src-miniquake2-client-assets-registry-ml-1723514623"></a>
### callbacks

```ml
function callbacks(loadModel, loadSkin, loadSound, onMissing)
```

Performs the callbacks operation for the miniquake2 client assets registry module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `loadModel` | `dynamic` | — | loadModel value consumed by this operation. |
| `loadSkin` | `dynamic` | — | loadSkin value consumed by this operation. |
| `loadSound` | `dynamic` | — | loadSound value consumed by this operation. |
| `onMissing` | `dynamic` | — | onMissing value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L43)

<a id="global-global-miniquake2-client-assets-registry-clientassetbindingslot-clientassetbindingslot-src-miniquake2-client-assets-registry-ml-218213145"></a>
### clientAssetBindingSlot

```ml
clientAssetBindingSlot
```

Stores module-wide client asset binding slot state for the miniquake2 client assets registry module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L30)

- [miniquake2.client.assets.registry.ClientAssetBindingSlot](Type-miniquake2-client-assets-registry-clientassetbindingslot-97765904.md) — struct
<a id="function-function-miniquake2-client-assets-registry-clientassetboundmodelindex-function-clientassetboundmodelindex-index-src-miniquake2-client-assets-registry-ml-2008019597"></a>
### clientAssetBoundModelIndex

```ml
function clientAssetBoundModelIndex(index)
```

Return the client asset bound model index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L782)

<a id="function-function-miniquake2-client-assets-registry-clientassetboundmodelname-function-clientassetboundmodelname-name-src-miniquake2-client-assets-registry-ml-566177460"></a>
### clientAssetBoundModelName

```ml
function clientAssetBoundModelName(name)
```

Return the client asset bound model name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L790)

<a id="function-function-miniquake2-client-assets-registry-clientassetboundplayermodel-function-clientassetboundplayermodel-index-src-miniquake2-client-assets-registry-ml-926506087"></a>
### clientAssetBoundPlayerModel

```ml
function clientAssetBoundPlayerModel(index)
```

Return the client asset bound player model value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L832)

<a id="function-function-miniquake2-client-assets-registry-clientassetboundplayerskin-function-clientassetboundplayerskin-index-src-miniquake2-client-assets-registry-ml-2058556113"></a>
### clientAssetBoundPlayerSkin

```ml
function clientAssetBoundPlayerSkin(index)
```

Return the client asset bound player skin value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L840)

<a id="function-function-miniquake2-client-assets-registry-clientassetboundplayerweapon-function-clientassetboundplayerweapon-index-weaponindex-src-miniquake2-client-assets-registry-ml-45190465"></a>
### clientAssetBoundPlayerWeapon

```ml
function clientAssetBoundPlayerWeapon(index, weaponIndex)
```

Return the client asset bound player weapon value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `weaponIndex` | `dynamic` | — | Zero-based index of weapon. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L849)

<a id="function-function-miniquake2-client-assets-registry-clientassetboundskinname-function-clientassetboundskinname-name-src-miniquake2-client-assets-registry-ml-265579570"></a>
### clientAssetBoundSkinName

```ml
function clientAssetBoundSkinName(name)
```

Return the client asset bound skin name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L798)

<a id="function-function-miniquake2-client-assets-registry-clientassetboundsoundentity-function-clientassetboundsoundentity-entitynumber-soundindex-soundname-src-miniquake2-client-assets-registry-ml-1964902386"></a>
### clientAssetBoundSoundEntity

```ml
function clientAssetBoundSoundEntity(entityNumber, soundIndex, soundName)
```

Return the client asset bound sound entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entityNumber` | `dynamic` | — | entityNumber value consumed by this operation. |
| `soundIndex` | `dynamic` | — | Zero-based index of sound. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L824)

<a id="function-function-miniquake2-client-assets-registry-clientassetboundsoundindex-function-clientassetboundsoundindex-index-src-miniquake2-client-assets-registry-ml-1981507253"></a>
### clientAssetBoundSoundIndex

```ml
function clientAssetBoundSoundIndex(index)
```

Return the client asset bound sound index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L806)

<a id="function-function-miniquake2-client-assets-registry-clientassetboundsoundname-function-clientassetboundsoundname-name-src-miniquake2-client-assets-registry-ml-1777524816"></a>
### clientAssetBoundSoundName

```ml
function clientAssetBoundSoundName(name)
```

Return the client asset bound sound name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L814)

<a id="function-function-miniquake2-client-assets-registry-clientidentity-function-clientidentity-value-src-miniquake2-client-assets-registry-ml-1604130104"></a>
### clientIdentity

```ml
function clientIdentity(value)
```

Return the client identity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L366)

<a id="function-function-miniquake2-client-assets-registry-clientinfo-function-clientinfo-state-index-src-miniquake2-client-assets-registry-ml-1809954594"></a>
### clientInfo

```ml
function clientInfo(state, index)
```

Return the client info value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L568)

<a id="function-function-miniquake2-client-assets-registry-containstraversal-function-containstraversal-value-src-miniquake2-client-assets-registry-ml-1590556214"></a>
### containsTraversal

```ml
function containsTraversal(value)
```

Report whether contains traversal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L71)

<a id="function-function-miniquake2-client-assets-registry-create-function-create-loaders-src-miniquake2-client-assets-registry-ml-233792909"></a>
### create

```ml
function create(loaders)
```

Creates create for the miniquake2 client assets registry module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `loaders` | `dynamic` | — | loaders value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L54)

<a id="function-function-miniquake2-client-assets-registry-createlenient-function-createlenient-loadmodel-loadskin-loadsound-src-miniquake2-client-assets-registry-ml-2096674892"></a>
### createLenient

```ml
function createLenient(loadModel, loadSkin, loadSound)
```

Create lenient.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `loadModel` | `dynamic` | — | loadModel value consumed by this operation. |
| `loadSkin` | `dynamic` | — | loadSkin value consumed by this operation. |
| `loadSound` | `dynamic` | — | loadSound value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L65)

<a id="function-function-miniquake2-client-assets-registry-ignoremissing-function-ignoremissing-value-src-miniquake2-client-assets-registry-ml-1077725568"></a>
### ignoreMissing

```ml
function ignoreMissing(value)
```

Report whether ignore missing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L34)

<a id="function-function-miniquake2-client-assets-registry-indexed-function-indexed-entry-index-name-src-miniquake2-client-assets-registry-ml-583658844"></a>
### indexed

```ml
function indexed(entry, index, name)
```

Return the indexed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entry` | `dynamic` | — | entry value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L201)

<a id="function-function-miniquake2-client-assets-registry-inlinemodelname-function-inlinemodelname-name-src-miniquake2-client-assets-registry-ml-554764160"></a>
### inlineModelName

```ml
function inlineModelName(name)
```

Return the inline model name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L96)

<a id="function-function-miniquake2-client-assets-registry-loadclientinfo-function-loadclientinfo-state-value-src-miniquake2-client-assets-registry-ml-1671050715"></a>
### loadClientInfo

```ml
function loadClientInfo(state, value)
```

Load client info.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L399)

<a id="function-function-miniquake2-client-assets-registry-loadmodelasset-function-loadmodelasset-state-index-name-src-miniquake2-client-assets-registry-ml-278709113"></a>
### loadModelAsset

```ml
function loadModelAsset(state, index, name)
```

Load model asset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L239)

<a id="function-function-miniquake2-client-assets-registry-loadoptionalskinasset-function-loadoptionalskinasset-state-name-src-miniquake2-client-assets-registry-ml-1842491985"></a>
### loadOptionalSkinAsset

```ml
function loadOptionalSkinAsset(state, name)
```

CL_LoadClientinfo probes an authored player skin, optionally retries that skin on the male model, and finally uses male/grunt. The first two misses are normal fallback control flow and must not pollute the precache-missing list.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L338)

<a id="function-function-miniquake2-client-assets-registry-loadoptionalsoundasset-function-loadoptionalsoundasset-state-name-src-miniquake2-client-assets-registry-ml-566338223"></a>
### loadOptionalSoundAsset

```ml
function loadOptionalSoundAsset(state, name)
```

S_RegisterSexedSound probes a model-specific file without treating absence as a missing precache asset: failure is the normal path to the male alias.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L297)

<a id="function-function-miniquake2-client-assets-registry-loadskinasset-function-loadskinasset-state-name-src-miniquake2-client-assets-registry-ml-1561605137"></a>
### loadSkinAsset

```ml
function loadSkinAsset(state, name)
```

Load skin asset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L317)

<a id="function-function-miniquake2-client-assets-registry-loadsoundasset-function-loadsoundasset-state-index-name-src-miniquake2-client-assets-registry-ml-2014884165"></a>
### loadSoundAsset

```ml
function loadSoundAsset(state, index, name)
```

Load sound asset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L259)

<a id="constant-constant-miniquake2-client-assets-registry-max-client-weapon-models-const-max-client-weapon-models-20-src-miniquake2-client-assets-registry-ml-661167604"></a>
### MAX_CLIENT_WEAPON_MODELS

```ml
const MAX_CLIENT_WEAPON_MODELS = 20
```

Defines the max client weapon models constant used by the miniquake2 client assets registry module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L19)

<a id="constant-constant-miniquake2-client-assets-registry-max-missing-assets-const-max-missing-assets-512-src-miniquake2-client-assets-registry-ml-1341089884"></a>
### MAX_MISSING_ASSETS

```ml
const MAX_MISSING_ASSETS = 512
```

Defines the max missing assets constant used by the miniquake2 client assets registry module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L17)

<a id="constant-constant-miniquake2-client-assets-registry-max-named-assets-const-max-named-assets-256-src-miniquake2-client-assets-registry-ml-1897469389"></a>
### MAX_NAMED_ASSETS

```ml
const MAX_NAMED_ASSETS = 256
```

Defines the max named assets constant used by the miniquake2 client assets registry module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L15)

<a id="function-function-miniquake2-client-assets-registry-missingassets-function-missingassets-state-src-miniquake2-client-assets-registry-ml-788237330"></a>
### missingAssets

```ml
function missingAssets(state)
```

Report whether missing assets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L879)

<a id="function-function-miniquake2-client-assets-registry-missingnamed-function-missingnamed-state-kind-index-name-reason-src-miniquake2-client-assets-registry-ml-9319291"></a>
### missingNamed

```ml
function missingNamed(state, kind, index, name, reason)
```

Report whether missing named.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `name` | `dynamic` | — | Name of the affected item. |
| `reason` | `dynamic` | — | reason value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L229)

<a id="function-function-miniquake2-client-assets-registry-notemissing-function-notemissing-state-kind-index-name-reason-src-miniquake2-client-assets-registry-ml-1744056515"></a>
### noteMissing

```ml
function noteMissing(state, kind, index, name, reason)
```

Report whether note missing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `name` | `dynamic` | — | Name of the affected item. |
| `reason` | `dynamic` | — | reason value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L178)

<a id="function-function-miniquake2-client-assets-registry-refreshclientinfos-function-refreshclientinfos-state-configstrings-src-miniquake2-client-assets-registry-ml-1718560502"></a>
### refreshClientInfos

```ml
function refreshClientInfos(state, configStrings)
```

Refresh client infos.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L441)

<a id="function-function-miniquake2-client-assets-registry-refreshconfigstrings-function-refreshconfigstrings-state-configstrings-src-miniquake2-client-assets-registry-ml-2106807470"></a>
### refreshConfigStrings

```ml
function refreshConfigStrings(state, configStrings)
```

Quake II may allocate model, sound and image configstrings after sign-on. Weapon projectiles are the common case: g_weapon.c calls modelindex when a shot is spawned, so an active client must register the new indexed asset without restarting the whole map registration generation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L467)

<a id="function-function-miniquake2-client-assets-registry-registerconfigstrings-function-registerconfigstrings-state-configstrings-mapname-src-miniquake2-client-assets-registry-ml-754986079"></a>
### registerConfigStrings

```ml
function registerConfigStrings(state, configStrings, mapName)
```

Register config strings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L639)

<a id="function-function-miniquake2-client-assets-registry-releasebindings-function-releasebindings-src-miniquake2-client-assets-registry-ml-1807609819"></a>
### releaseBindings

```ml
function releaseBindings()
```

Release bindings.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L868)

<a id="function-function-miniquake2-client-assets-registry-reset-function-reset-state-mapname-src-miniquake2-client-assets-registry-ml-470817185"></a>
### reset

```ml
function reset(state, mapName)
```

Performs the reset operation for the miniquake2 client assets registry module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L615)

<a id="function-function-miniquake2-client-assets-registry-resolvemodelindex-function-resolvemodelindex-state-index-src-miniquake2-client-assets-registry-ml-448199548"></a>
### resolveModelIndex

```ml
function resolveModelIndex(state, index)
```

Resolve model index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L700)

<a id="function-function-miniquake2-client-assets-registry-resolvemodelname-function-resolvemodelname-state-name-src-miniquake2-client-assets-registry-ml-745517679"></a>
### resolveModelName

```ml
function resolveModelName(state, name)
```

Resolve model name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L722)

<a id="function-function-miniquake2-client-assets-registry-resolveplayermodel-function-resolveplayermodel-state-index-src-miniquake2-client-assets-registry-ml-895460786"></a>
### resolvePlayerModel

```ml
function resolvePlayerModel(state, index)
```

Resolve player model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L580)

<a id="function-function-miniquake2-client-assets-registry-resolveplayerskin-function-resolveplayerskin-state-index-src-miniquake2-client-assets-registry-ml-328645842"></a>
### resolvePlayerSkin

```ml
function resolvePlayerSkin(state, index)
```

Resolve player skin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L589)

<a id="function-function-miniquake2-client-assets-registry-resolveplayerweapon-function-resolveplayerweapon-state-index-weaponindex-src-miniquake2-client-assets-registry-ml-784131238"></a>
### resolvePlayerWeapon

```ml
function resolvePlayerWeapon(state, index, weaponIndex)
```

Resolve player weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `weaponIndex` | `dynamic` | — | Zero-based index of weapon. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L599)

<a id="function-function-miniquake2-client-assets-registry-resolveskinname-function-resolveskinname-state-name-src-miniquake2-client-assets-registry-ml-127963663"></a>
### resolveSkinName

```ml
function resolveSkinName(state, name)
```

Resolve skin name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L731)

<a id="function-function-miniquake2-client-assets-registry-resolvesoundforentity-function-resolvesoundforentity-state-entitynumber-soundindex-soundname-src-miniquake2-client-assets-registry-ml-1295431169"></a>
### resolveSoundForEntity

```ml
function resolveSoundForEntity(state, entityNumber, soundIndex, soundName)
```

Resolve sound for entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `entityNumber` | `dynamic` | — | entityNumber value consumed by this operation. |
| `soundIndex` | `dynamic` | — | Zero-based index of sound. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L751)

<a id="function-function-miniquake2-client-assets-registry-resolvesoundindex-function-resolvesoundindex-state-index-src-miniquake2-client-assets-registry-ml-472036596"></a>
### resolveSoundIndex

```ml
function resolveSoundIndex(state, index)
```

Resolve sound index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L711)

<a id="function-function-miniquake2-client-assets-registry-resolvesoundname-function-resolvesoundname-state-name-src-miniquake2-client-assets-registry-ml-1979955395"></a>
### resolveSoundName

```ml
function resolveSoundName(state, name)
```

Resolve sound name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L740)

<a id="function-function-miniquake2-client-assets-registry-safemodelname-function-safemodelname-name-src-miniquake2-client-assets-registry-ml-133381868"></a>
### safeModelName

```ml
function safeModelName(name)
```

Return the safe model name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L112)

<a id="function-function-miniquake2-client-assets-registry-saferegularname-function-saferegularname-name-src-miniquake2-client-assets-registry-ml-2035636262"></a>
### safeRegularName

```ml
function safeRegularName(name)
```

Return the safe regular name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L83)

<a id="function-function-miniquake2-client-assets-registry-safesoundname-function-safesoundname-name-src-miniquake2-client-assets-registry-ml-351637236"></a>
### safeSoundName

```ml
function safeSoundName(name)
```

Return the safe sound name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L120)

<a id="function-function-miniquake2-client-assets-registry-textslice-inline-function-textslice-value-start-count-src-miniquake2-client-assets-registry-ml-1014785760"></a>
### textSlice

```ml
inline function textSlice(value, start, count)
```

Performs the textSlice operation for the miniquake2 client assets registry module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L359)

<a id="function-function-miniquake2-client-assets-registry-validmodel-function-validmodel-value-src-miniquake2-client-assets-registry-ml-922483308"></a>
### validModel

```ml
function validModel(value)
```

Report whether valid model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L128)

<a id="function-function-miniquake2-client-assets-registry-validskin-function-validskin-value-src-miniquake2-client-assets-registry-ml-1311630018"></a>
### validSkin

```ml
function validSkin(value)
```

Report whether valid skin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L149)

<a id="function-function-miniquake2-client-assets-registry-validsound-function-validsound-value-src-miniquake2-client-assets-registry-ml-1457445560"></a>
### validSound

```ml
function validSound(value)
```

Report whether valid sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/assets/registry.ml#L136)
