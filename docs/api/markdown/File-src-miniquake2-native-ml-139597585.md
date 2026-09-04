# `src/miniquake2/native.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 native facilities for this project.

Package: [`miniquake2.native`](Package-miniquake2-native-387338532.md)

Reachable from entry: **yes**

## Declarations

<a id="function-function-miniquake2-native-atan2-function-atan2-y-x-src-miniquake2-native-ml-91421038"></a>
### atan2

```ml
function atan2(y, x)
```

Return the atan 2 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L615)

<a id="extern_function-extern-function-miniquake2-native-audiocapacity-extern-function-audiocapacity-from-miniquake-native-dll-symbol-mq-audio-capacity-returns-u32-src-miniquake2-native-ml-311934965"></a>
### audioCapacity

```ml
extern function audioCapacity() from "miniquake_native.dll" symbol "mq_audio_capacity" returns u32
```

Invokes the native audioCapacity entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L259)

<a id="extern_function-extern-function-miniquake2-native-audioclose-extern-function-audioclose-from-miniquake-native-dll-symbol-mq-audio-close-returns-void-src-miniquake2-native-ml-837406175"></a>
### audioClose

```ml
extern function audioClose() from "miniquake_native.dll" symbol "mq_audio_close" returns void
```

Invokes the native audioClose entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L244)

<a id="extern_function-extern-function-miniquake2-native-audiocompleted-extern-function-audiocompleted-from-miniquake-native-dll-symbol-mq-audio-completed-returns-u32-src-miniquake2-native-ml-480546254"></a>
### audioCompleted

```ml
extern function audioCompleted() from "miniquake_native.dll" symbol "mq_audio_completed" returns u32
```

Invokes the native audioCompleted entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L253)

<a id="extern_function-extern-function-miniquake2-native-audioisopen-extern-function-audioisopen-from-miniquake-native-dll-symbol-mq-audio-is-open-returns-i32-src-miniquake2-native-ml-493662436"></a>
### audioIsOpen

```ml
extern function audioIsOpen() from "miniquake_native.dll" symbol "mq_audio_is_open" returns i32
```

Invokes the native audioIsOpen entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L265)

<a id="extern_function-extern-function-miniquake2-native-audioopen-extern-function-audioopen-samplerate-as-u32-channels-as-u32-bitspersample-as-u32-from-miniquake-native-dll-symbol-mq-audio-open-returns-i32-src-miniquake2-native-ml-265428822"></a>
### audioOpen

```ml
extern function audioOpen(sampleRate as u32, channels as u32, bitsPerSample as u32) from "miniquake_native.dll" symbol "mq_audio_open" returns i32
```

Invokes the native audioOpen entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sampleRate` | `u32` | — | sampleRate value consumed by this operation. |
| `channels` | `u32` | — | channels value consumed by this operation. |
| `bitsPerSample` | `u32` | — | bitsPerSample value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L237)

<a id="extern_function-extern-function-miniquake2-native-audioqueued-extern-function-audioqueued-from-miniquake-native-dll-symbol-mq-audio-queued-returns-u32-src-miniquake2-native-ml-1451097168"></a>
### audioQueued

```ml
extern function audioQueued() from "miniquake_native.dll" symbol "mq_audio_queued" returns u32
```

Invokes the native audioQueued entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L247)

<a id="extern_function-extern-function-miniquake2-native-audioreset-extern-function-audioreset-from-miniquake-native-dll-symbol-mq-audio-reset-returns-i32-src-miniquake2-native-ml-810648512"></a>
### audioReset

```ml
extern function audioReset() from "miniquake_native.dll" symbol "mq_audio_reset" returns i32
```

Invokes the native audioReset entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L262)

<a id="extern_function-extern-function-miniquake2-native-audiosubmit-extern-function-audiosubmit-data-as-bytes-bytecount-as-u32-from-miniquake-native-dll-symbol-mq-audio-submit-returns-i32-src-miniquake2-native-ml-2035202501"></a>
### audioSubmit

```ml
extern function audioSubmit(data as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_audio_submit" returns i32
```

Invokes the native audioSubmit entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `bytes` | — | Input data consumed by the operation. |
| `byteCount` | `u32` | — | Number of byte to process. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L242)

<a id="extern_function-extern-function-miniquake2-native-audiosubmitted-extern-function-audiosubmitted-from-miniquake-native-dll-symbol-mq-audio-submitted-returns-u32-src-miniquake2-native-ml-1484567638"></a>
### audioSubmitted

```ml
extern function audioSubmitted() from "miniquake_native.dll" symbol "mq_audio_submitted" returns u32
```

Invokes the native audioSubmitted entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L250)

<a id="extern_function-extern-function-miniquake2-native-audiounderruns-extern-function-audiounderruns-from-miniquake-native-dll-symbol-mq-audio-underruns-returns-u32-src-miniquake2-native-ml-1821043197"></a>
### audioUnderruns

```ml
extern function audioUnderruns() from "miniquake_native.dll" symbol "mq_audio_underruns" returns u32
```

Invokes the native audioUnderruns entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L256)

<a id="function-function-miniquake2-native-bitsfloat-function-bitsfloat-bits-src-miniquake2-native-ml-995167511"></a>
### bitsFloat

```ml
function bitsFloat(bits)
```

Return the bits float value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bits` | `dynamic` | — | bits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L596)

<a id="function-function-miniquake2-native-cos-function-cos-value-src-miniquake2-native-ml-428188260"></a>
### cos

```ml
function cos(value)
```

Return the cos value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L608)

<a id="extern_function-extern-function-miniquake2-native-f32atan2-extern-function-f32atan2-ybits-as-u32-xbits-as-u32-from-miniquake-native-dll-symbol-mq-f32-atan2-returns-u32-src-miniquake2-native-ml-126382659"></a>
### f32Atan2

```ml
extern function f32Atan2(yBits as u32, xBits as u32) from "miniquake_native.dll" symbol "mq_f32_atan2" returns u32
```

Invokes the native f32Atan2 entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `yBits` | `u32` | — | yBits value consumed by this operation. |
| `xBits` | `u32` | — | xBits value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L33)

<a id="extern_function-extern-function-miniquake2-native-f32cos-extern-function-f32cos-bits-as-u32-from-miniquake-native-dll-symbol-mq-f32-cos-returns-u32-src-miniquake2-native-ml-741859159"></a>
### f32Cos

```ml
extern function f32Cos(bits as u32) from "miniquake_native.dll" symbol "mq_f32_cos" returns u32
```

Invokes the native f32Cos entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bits` | `u32` | — | bits value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L28)

<a id="extern_function-extern-function-miniquake2-native-f32fromraw-extern-function-f32fromraw-rawvalue-as-u64-from-miniquake-native-dll-symbol-mq-f32-from-ml-raw-returns-u32-src-miniquake2-native-ml-1891327729"></a>
### f32FromRaw

```ml
extern function f32FromRaw(rawValue as u64) from "miniquake_native.dll" symbol "mq_f32_from_ml_raw" returns u32
```

Invokes the native f32FromRaw entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `rawValue` | `u64` | — | rawValue value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L16)

<a id="extern_function-extern-function-miniquake2-native-f32sin-extern-function-f32sin-bits-as-u32-from-miniquake-native-dll-symbol-mq-f32-sin-returns-u32-src-miniquake2-native-ml-467499272"></a>
### f32Sin

```ml
extern function f32Sin(bits as u32) from "miniquake_native.dll" symbol "mq_f32_sin" returns u32
```

Invokes the native f32Sin entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bits` | `u32` | — | bits value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L24)

<a id="extern_function-extern-function-miniquake2-native-f32toraw-extern-function-f32toraw-bits-as-u32-from-miniquake-native-dll-symbol-mq-f32-to-ml-raw-returns-u64-src-miniquake2-native-ml-1381113971"></a>
### f32ToRaw

```ml
extern function f32ToRaw(bits as u32) from "miniquake_native.dll" symbol "mq_f32_to_ml_raw" returns u64
```

Invokes the native f32ToRaw entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bits` | `u32` | — | bits value consumed by this operation. |


**Returns:** Native u64 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L20)

<a id="function-function-miniquake2-native-floatbits-function-floatbits-value-src-miniquake2-native-ml-1827546970"></a>
### floatBits

```ml
function floatBits(value)
```

Return the float bits value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L590)

<a id="extern_function-extern-function-miniquake2-native-glactivetexture-extern-function-glactivetexture-unit-as-i32-from-miniquake-native-dll-symbol-mq-gl-active-texture-returns-void-src-miniquake2-native-ml-551361676"></a>
### glActiveTexture

```ml
extern function glActiveTexture(unit as i32) from "miniquake_native.dll" symbol "mq_gl_active_texture" returns void
```

Invokes the native glActiveTexture entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `unit` | `i32` | — | unit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L489)

<a id="extern_function-extern-function-miniquake2-native-glalphafunc-extern-function-glalphafunc-functionname-as-u32-referencebits-as-u32-from-miniquake-native-dll-symbol-mq-gl-alpha-func-returns-void-src-miniquake2-native-ml-1477666441"></a>
### glAlphaFunc

```ml
extern function glAlphaFunc(functionName as u32, referenceBits as u32) from "miniquake_native.dll" symbol "mq_gl_alpha_func" returns void
```

Invokes the native glAlphaFunc entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `functionName` | `u32` | — | functionName value consumed by this operation. |
| `referenceBits` | `u32` | — | referenceBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L353)

<a id="extern_function-extern-function-miniquake2-native-glbegin-extern-function-glbegin-mode-as-u32-from-miniquake-native-dll-symbol-mq-gl-begin-returns-void-src-miniquake2-native-ml-466544056"></a>
### glBegin

```ml
extern function glBegin(mode as u32) from "miniquake_native.dll" symbol "mq_gl_begin" returns void
```

Fixed-function OpenGL 1.1 bridge used by the Quake II refexport adapter. Floats cross the ABI as their exact IEEE-754 bit pattern; this is the same narrow bridge used and exercised by MiniQuake's renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `u32` | — | Mode selecting the requested behavior. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L299)

<a id="extern_function-extern-function-miniquake2-native-glbindtexture-extern-function-glbindtexture-target-as-u32-texture-as-u32-from-miniquake-native-dll-symbol-mq-gl-bind-texture-returns-void-src-miniquake2-native-ml-1603816757"></a>
### glBindTexture

```ml
extern function glBindTexture(target as u32, texture as u32) from "miniquake_native.dll" symbol "mq_gl_bind_texture" returns void
```

Invokes the native glBindTexture entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `u32` | — | target value consumed by this operation. |
| `texture` | `u32` | — | texture value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L407)

<a id="extern_function-extern-function-miniquake2-native-glblendfunc-extern-function-glblendfunc-source-as-u32-destination-as-u32-from-miniquake-native-dll-symbol-mq-gl-blend-func-returns-void-src-miniquake2-native-ml-1675249289"></a>
### glBlendFunc

```ml
extern function glBlendFunc(source as u32, destination as u32) from "miniquake_native.dll" symbol "mq_gl_blend_func" returns void
```

Invokes the native glBlendFunc entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `u32` | — | source value consumed by this operation. |
| `destination` | `u32` | — | destination value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L339)

<a id="extern_function-extern-function-miniquake2-native-glclear-extern-function-glclear-mask-as-u32-from-miniquake-native-dll-symbol-mq-gl-clear-returns-void-src-miniquake2-native-ml-42500289"></a>
### glClear

```ml
extern function glClear(mask as u32) from "miniquake_native.dll" symbol "mq_gl_clear" returns void
```

Invokes the native glClear entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mask` | `u32` | — | mask value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L329)

<a id="extern_function-extern-function-miniquake2-native-glclearcolor-extern-function-glclearcolor-redbits-as-u32-greenbits-as-u32-bluebits-as-u32-alphabits-as-u32-from-miniquake-native-dll-symbol-mq-gl-clear-color-returns-void-src-miniquake2-native-ml-209432689"></a>
### glClearColor

```ml
extern function glClearColor(redBits as u32, greenBits as u32, blueBits as u32, alphaBits as u32) from "miniquake_native.dll" symbol "mq_gl_clear_color" returns void
```

Invokes the native glClearColor entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `redBits` | `u32` | — | redBits value consumed by this operation. |
| `greenBits` | `u32` | — | greenBits value consumed by this operation. |
| `blueBits` | `u32` | — | blueBits value consumed by this operation. |
| `alphaBits` | `u32` | — | alphaBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L326)

<a id="extern_function-extern-function-miniquake2-native-glcolor4ub-extern-function-glcolor4ub-red-as-u32-green-as-u32-blue-as-u32-alpha-as-u32-from-miniquake-native-dll-symbol-mq-gl-color4ub-returns-void-src-miniquake2-native-ml-1219726642"></a>
### glColor4ub

```ml
extern function glColor4ub(red as u32, green as u32, blue as u32, alpha as u32) from "miniquake_native.dll" symbol "mq_gl_color4ub" returns void
```

Invokes the native glColor4ub entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `red` | `u32` | — | red value consumed by this operation. |
| `green` | `u32` | — | green value consumed by this operation. |
| `blue` | `u32` | — | blue value consumed by this operation. |
| `alpha` | `u32` | — | alpha value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L320)

<a id="extern_function-extern-function-miniquake2-native-glcullface-extern-function-glcullface-mode-as-u32-from-miniquake-native-dll-symbol-mq-gl-cull-face-returns-void-src-miniquake2-native-ml-1855858651"></a>
### glCullFace

```ml
extern function glCullFace(mode as u32) from "miniquake_native.dll" symbol "mq_gl_cull_face" returns void
```

Invokes the native glCullFace entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `u32` | — | Mode selecting the requested behavior. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L356)

<a id="extern_function-extern-function-miniquake2-native-gldeletetextures-extern-function-gldeletetextures-count-as-i32-textureids-as-bytes-from-miniquake-native-dll-symbol-mq-gl-delete-textures-returns-void-src-miniquake2-native-ml-321977867"></a>
### glDeleteTextures

```ml
extern function glDeleteTextures(count as i32, textureIds as bytes) from "miniquake_native.dll" symbol "mq_gl_delete_textures" returns void
```

Invokes the native glDeleteTextures entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `i32` | — | Number of items or units to process. |
| `textureIds` | `bytes` | — | textureIds value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L411)

<a id="extern_function-extern-function-miniquake2-native-gldepthfunc-extern-function-gldepthfunc-functionname-as-u32-from-miniquake-native-dll-symbol-mq-gl-depth-func-returns-void-src-miniquake2-native-ml-1126120331"></a>
### glDepthFunc

```ml
extern function glDepthFunc(functionName as u32) from "miniquake_native.dll" symbol "mq_gl_depth_func" returns void
```

Invokes the native glDepthFunc entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `functionName` | `u32` | — | functionName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L342)

<a id="extern_function-extern-function-miniquake2-native-gldepthmask-extern-function-gldepthmask-enabled-as-i32-from-miniquake-native-dll-symbol-mq-gl-depth-mask-returns-void-src-miniquake2-native-ml-1719311265"></a>
### glDepthMask

```ml
extern function glDepthMask(enabled as i32) from "miniquake_native.dll" symbol "mq_gl_depth_mask" returns void
```

Invokes the native glDepthMask entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `i32` | — | enabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L345)

<a id="extern_function-extern-function-miniquake2-native-gldepthrange-extern-function-gldepthrange-nearbits-as-u32-farbits-as-u32-from-miniquake-native-dll-symbol-mq-gl-depth-range-returns-void-src-miniquake2-native-ml-1872747574"></a>
### glDepthRange

```ml
extern function glDepthRange(nearBits as u32, farBits as u32) from "miniquake_native.dll" symbol "mq_gl_depth_range" returns void
```

Invokes the native glDepthRange entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `nearBits` | `u32` | — | nearBits value consumed by this operation. |
| `farBits` | `u32` | — | farBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L349)

<a id="extern_function-extern-function-miniquake2-native-gldisable-extern-function-gldisable-capability-as-u32-from-miniquake-native-dll-symbol-mq-gl-disable-returns-void-src-miniquake2-native-ml-611366180"></a>
### glDisable

```ml
extern function glDisable(capability as u32) from "miniquake_native.dll" symbol "mq_gl_disable" returns void
```

Invokes the native glDisable entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `capability` | `u32` | — | capability value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L335)

<a id="extern_function-extern-function-miniquake2-native-gldrawaliasrgbend-extern-function-gldrawaliasrgbend-from-miniquake-native-dll-symbol-mq-gl-draw-alias-rgb-end-returns-void-src-miniquake2-native-ml-1771378877"></a>
### glDrawAliasRgbEnd

```ml
extern function glDrawAliasRgbEnd() from "miniquake_native.dll" symbol "mq_gl_draw_alias_rgb_end" returns void
```

Invokes the native glDrawAliasRgbEnd entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L586)

<a id="extern_function-extern-function-miniquake2-native-gldrawmd2rgb-extern-function-gldrawmd2rgb-data-as-bytes-bytecount-as-u32-frameindex-as-u32-oldframeindex-as-u32-backlerp-as-u32-shadedots-as-bytes-shadedotcount-as-u32-normalvectors-as-bytes-normalcount-as-u32-geometrykey-as-u64-geometrystate-as-u32-shadestate-as-u32-shadered-as-u32-shadegreen-as-u32-shadeblue-as-u32-alpha-as-u32-from-miniquake-native-dll-symbol-mq-gl-draw-md2-rgb-returns-i32-src-miniquake2-native-ml-1892922610"></a>
### glDrawMd2Rgb

```ml
extern function glDrawMd2Rgb(data as bytes, byteCount as u32, frameIndex as u32, oldFrameIndex as u32, backLerp as u32, shadeDots as bytes, shadeDotCount as u32, normalVectors as bytes, normalCount as u32, geometryKey as u64, geometryState as u32, shadeState as u32, shadeRed as u32, shadeGreen as u32, shadeBlue as u32, alpha as u32) from "miniquake_native.dll" symbol "mq_gl_draw_md2_rgb" returns i32
```

Invokes the native glDrawMd2Rgb entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `bytes` | — | Input data consumed by the operation. |
| `byteCount` | `u32` | — | Number of byte to process. |
| `frameIndex` | `u32` | — | Zero-based index of frame. |
| `oldFrameIndex` | `u32` | — | Zero-based index of old frame. |
| `backLerp` | `u32` | — | backLerp value consumed by this operation. |
| `shadeDots` | `bytes` | — | shadeDots value consumed by this operation. |
| `shadeDotCount` | `u32` | — | Number of shade dot to process. |
| `normalVectors` | `bytes` | — | normalVectors value consumed by this operation. |
| `normalCount` | `u32` | — | Number of normal to process. |
| `geometryKey` | `u64` | — | geometryKey value consumed by this operation. |
| `geometryState` | `u32` | — | geometryState value consumed by this operation. |
| `shadeState` | `u32` | — | shadeState value consumed by this operation. |
| `shadeRed` | `u32` | — | shadeRed value consumed by this operation. |
| `shadeGreen` | `u32` | — | shadeGreen value consumed by this operation. |
| `shadeBlue` | `u32` | — | shadeBlue value consumed by this operation. |
| `alpha` | `u32` | — | alpha value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L552)

<a id="extern_function-extern-function-miniquake2-native-gldrawmd2shadow-extern-function-gldrawmd2shadow-data-as-bytes-bytecount-as-u32-frameindex-as-u32-oldframeindex-as-u32-backlerp-as-u32-normalvectors-as-bytes-normalcount-as-u32-geometrykey-as-u64-geometrystate-as-u32-trianglecount-as-u32-shadex-as-u32-shadey-as-u32-lightheight-as-u32-from-miniquake-native-dll-symbol-mq-gl-draw-md2-shadow-returns-i32-src-miniquake2-native-ml-2075417398"></a>
### glDrawMd2Shadow

```ml
extern function glDrawMd2Shadow(data as bytes, byteCount as u32, frameIndex as u32, oldFrameIndex as u32, backLerp as u32, normalVectors as bytes, normalCount as u32, geometryKey as u64, geometryState as u32, triangleCount as u32, shadeX as u32, shadeY as u32, lightHeight as u32) from "miniquake_native.dll" symbol "mq_gl_draw_md2_shadow" returns i32
```

Invokes the native glDrawMd2Shadow entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `bytes` | — | Input data consumed by the operation. |
| `byteCount` | `u32` | — | Number of byte to process. |
| `frameIndex` | `u32` | — | Zero-based index of frame. |
| `oldFrameIndex` | `u32` | — | Zero-based index of old frame. |
| `backLerp` | `u32` | — | backLerp value consumed by this operation. |
| `normalVectors` | `bytes` | — | normalVectors value consumed by this operation. |
| `normalCount` | `u32` | — | Number of normal to process. |
| `geometryKey` | `u64` | — | geometryKey value consumed by this operation. |
| `geometryState` | `u32` | — | geometryState value consumed by this operation. |
| `triangleCount` | `u32` | — | Number of triangle to process. |
| `shadeX` | `u32` | — | shadeX value consumed by this operation. |
| `shadeY` | `u32` | — | shadeY value consumed by this operation. |
| `lightHeight` | `u32` | — | lightHeight value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L568)

<a id="extern_function-extern-function-miniquake2-native-gldrawmd2shadowsoft-extern-function-gldrawmd2shadowsoft-data-as-bytes-bytecount-as-u32-frameindex-as-u32-oldframeindex-as-u32-backlerp-as-u32-normalvectors-as-bytes-normalcount-as-u32-geometrykey-as-u64-geometrystate-as-u32-trianglecount-as-u32-shadex-as-u32-shadey-as-u32-lightheight-as-u32-from-miniquake-native-dll-symbol-mq-gl-draw-md2-shadow-soft-returns-i32-src-miniquake2-native-ml-1464255509"></a>
### glDrawMd2ShadowSoft

```ml
extern function glDrawMd2ShadowSoft(data as bytes, byteCount as u32, frameIndex as u32, oldFrameIndex as u32, backLerp as u32, normalVectors as bytes, normalCount as u32, geometryKey as u64, geometryState as u32, triangleCount as u32, shadeX as u32, shadeY as u32, lightHeight as u32) from "miniquake_native.dll" symbol "mq_gl_draw_md2_shadow_soft" returns i32
```

Invokes the native glDrawMd2ShadowSoft entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `bytes` | — | Input data consumed by the operation. |
| `byteCount` | `u32` | — | Number of byte to process. |
| `frameIndex` | `u32` | — | Zero-based index of frame. |
| `oldFrameIndex` | `u32` | — | Zero-based index of old frame. |
| `backLerp` | `u32` | — | backLerp value consumed by this operation. |
| `normalVectors` | `bytes` | — | normalVectors value consumed by this operation. |
| `normalCount` | `u32` | — | Number of normal to process. |
| `geometryKey` | `u64` | — | geometryKey value consumed by this operation. |
| `geometryState` | `u32` | — | geometryState value consumed by this operation. |
| `triangleCount` | `u32` | — | Number of triangle to process. |
| `shadeX` | `u32` | — | shadeX value consumed by this operation. |
| `shadeY` | `u32` | — | shadeY value consumed by this operation. |
| `lightHeight` | `u32` | — | lightHeight value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L584)

<a id="extern_function-extern-function-miniquake2-native-gldrawparticlebatch-extern-function-gldrawparticlebatch-data-as-bytes-bytecount-as-u32-vieworiginx-as-u32-vieworiginy-as-u32-vieworiginz-as-u32-viewforwardx-as-u32-viewforwardy-as-u32-viewforwardz-as-u32-viewupx-as-u32-viewupy-as-u32-viewupz-as-u32-viewrightx-as-u32-viewrighty-as-u32-viewrightz-as-u32-from-miniquake-native-dll-symbol-mq-gl-draw-particle-batch-returns-i32-src-miniquake2-native-ml-1665048770"></a>
### glDrawParticleBatch

```ml
extern function glDrawParticleBatch(data as bytes, byteCount as u32, viewOriginX as u32, viewOriginY as u32, viewOriginZ as u32, viewForwardX as u32, viewForwardY as u32, viewForwardZ as u32, viewUpX as u32, viewUpY as u32, viewUpZ as u32, viewRightX as u32, viewRightY as u32, viewRightZ as u32) from "miniquake_native.dll" symbol "mq_gl_draw_particle_batch" returns i32
```

Invokes the native glDrawParticleBatch entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `bytes` | — | Input data consumed by the operation. |
| `byteCount` | `u32` | — | Number of byte to process. |
| `viewOriginX` | `u32` | — | viewOriginX value consumed by this operation. |
| `viewOriginY` | `u32` | — | viewOriginY value consumed by this operation. |
| `viewOriginZ` | `u32` | — | viewOriginZ value consumed by this operation. |
| `viewForwardX` | `u32` | — | viewForwardX value consumed by this operation. |
| `viewForwardY` | `u32` | — | viewForwardY value consumed by this operation. |
| `viewForwardZ` | `u32` | — | viewForwardZ value consumed by this operation. |
| `viewUpX` | `u32` | — | viewUpX value consumed by this operation. |
| `viewUpY` | `u32` | — | viewUpY value consumed by this operation. |
| `viewUpZ` | `u32` | — | viewUpZ value consumed by this operation. |
| `viewRightX` | `u32` | — | viewRightX value consumed by this operation. |
| `viewRightY` | `u32` | — | viewRightY value consumed by this operation. |
| `viewRightZ` | `u32` | — | viewRightZ value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L516)

<a id="extern_function-extern-function-miniquake2-native-gldrawparticlebatchstyled-extern-function-gldrawparticlebatchstyled-data-as-bytes-bytecount-as-u32-vieworiginx-as-u32-vieworiginy-as-u32-vieworiginz-as-u32-viewforwardx-as-u32-viewforwardy-as-u32-viewforwardz-as-u32-viewupx-as-u32-viewupy-as-u32-viewupz-as-u32-viewrightx-as-u32-viewrighty-as-u32-viewrightz-as-u32-from-miniquake-native-dll-symbol-mq-gl-draw-particle-batch-styled-returns-i32-src-miniquake2-native-ml-124155482"></a>
### glDrawParticleBatchStyled

```ml
extern function glDrawParticleBatchStyled(data as bytes, byteCount as u32, viewOriginX as u32, viewOriginY as u32, viewOriginZ as u32, viewForwardX as u32, viewForwardY as u32, viewForwardZ as u32, viewUpX as u32, viewUpY as u32, viewUpZ as u32, viewRightX as u32, viewRightY as u32, viewRightZ as u32) from "miniquake_native.dll" symbol "mq_gl_draw_particle_batch_styled" returns i32
```

Invokes the native glDrawParticleBatchStyled entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `bytes` | — | Input data consumed by the operation. |
| `byteCount` | `u32` | — | Number of byte to process. |
| `viewOriginX` | `u32` | — | viewOriginX value consumed by this operation. |
| `viewOriginY` | `u32` | — | viewOriginY value consumed by this operation. |
| `viewOriginZ` | `u32` | — | viewOriginZ value consumed by this operation. |
| `viewForwardX` | `u32` | — | viewForwardX value consumed by this operation. |
| `viewForwardY` | `u32` | — | viewForwardY value consumed by this operation. |
| `viewForwardZ` | `u32` | — | viewForwardZ value consumed by this operation. |
| `viewUpX` | `u32` | — | viewUpX value consumed by this operation. |
| `viewUpY` | `u32` | — | viewUpY value consumed by this operation. |
| `viewUpZ` | `u32` | — | viewUpZ value consumed by this operation. |
| `viewRightX` | `u32` | — | viewRightX value consumed by this operation. |
| `viewRightY` | `u32` | — | viewRightY value consumed by this operation. |
| `viewRightZ` | `u32` | — | viewRightZ value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L533)

<a id="extern_function-extern-function-miniquake2-native-glenable-extern-function-glenable-capability-as-u32-from-miniquake-native-dll-symbol-mq-gl-enable-returns-void-src-miniquake2-native-ml-293698467"></a>
### glEnable

```ml
extern function glEnable(capability as u32) from "miniquake_native.dll" symbol "mq_gl_enable" returns void
```

Invokes the native glEnable entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `capability` | `u32` | — | capability value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L332)

<a id="extern_function-extern-function-miniquake2-native-glend-extern-function-glend-from-miniquake-native-dll-symbol-mq-gl-end-returns-void-src-miniquake2-native-ml-463057073"></a>
### glEnd

```ml
extern function glEnd() from "miniquake_native.dll" symbol "mq_gl_end" returns void
```

Invokes the native glEnd entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L301)

<a id="extern_function-extern-function-miniquake2-native-glfinish-extern-function-glfinish-from-miniquake-native-dll-symbol-mq-gl-finish-returns-void-src-miniquake2-native-ml-678507533"></a>
### glFinish

```ml
extern function glFinish() from "miniquake_native.dll" symbol "mq_gl_finish" returns void
```

Invokes the native glFinish entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L458)

<a id="extern_function-extern-function-miniquake2-native-glflush-extern-function-glflush-from-miniquake-native-dll-symbol-mq-gl-flush-returns-void-src-miniquake2-native-ml-1477381864"></a>
### glFlush

```ml
extern function glFlush() from "miniquake_native.dll" symbol "mq_gl_flush" returns void
```

Invokes the native glFlush entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L460)

<a id="extern_function-extern-function-miniquake2-native-glfrustum-extern-function-glfrustum-leftbits-as-u32-rightbits-as-u32-bottombits-as-u32-topbits-as-u32-nearbits-as-u32-farbits-as-u32-from-miniquake-native-dll-symbol-mq-gl-frustum-returns-void-src-miniquake2-native-ml-2112399478"></a>
### glFrustum

```ml
extern function glFrustum(leftBits as u32, rightBits as u32, bottomBits as u32, topBits as u32, nearBits as u32, farBits as u32) from "miniquake_native.dll" symbol "mq_gl_frustum" returns void
```

Invokes the native glFrustum entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `leftBits` | `u32` | — | leftBits value consumed by this operation. |
| `rightBits` | `u32` | — | rightBits value consumed by this operation. |
| `bottomBits` | `u32` | — | bottomBits value consumed by this operation. |
| `topBits` | `u32` | — | topBits value consumed by this operation. |
| `nearBits` | `u32` | — | nearBits value consumed by this operation. |
| `farBits` | `u32` | — | farBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L403)

<a id="extern_function-extern-function-miniquake2-native-glgeterror-extern-function-glgeterror-from-miniquake-native-dll-symbol-mq-gl-get-error-returns-u32-src-miniquake2-native-ml-1516768585"></a>
### glGetError

```ml
extern function glGetError() from "miniquake_native.dll" symbol "mq_gl_get_error" returns u32
```

Invokes the native glGetError entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L447)

<a id="function-function-miniquake2-native-glgetstring-function-glgetstring-name-src-miniquake2-native-ml-629657636"></a>
### glGetString

```ml
function glGetString(name)
```

Return gl string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L652)

<a id="extern_function-extern-function-miniquake2-native-glgetstringraw-extern-function-glgetstringraw-name-as-u32-output-as-bytes-capacity-as-u32-from-miniquake-text-dll-symbol-mqt-gl-get-string-returns-u32-src-miniquake2-native-ml-1227344061"></a>
### glGetStringRaw

```ml
extern function glGetStringRaw(name as u32, output as bytes, capacity as u32) from "miniquake_text.dll" symbol "mqt_gl_get_string" returns u32
```

Invokes the native glGetStringRaw entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `u32` | — | Name of the affected item. |
| `output` | `bytes` | — | Output collection or buffer populated by the operation. |
| `capacity` | `u32` | — | capacity value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L444)

<a id="extern_function-extern-function-miniquake2-native-glloadidentity-extern-function-glloadidentity-from-miniquake-native-dll-symbol-mq-gl-load-identity-returns-void-src-miniquake2-native-ml-501655633"></a>
### glLoadIdentity

```ml
extern function glLoadIdentity() from "miniquake_native.dll" symbol "mq_gl_load_identity" returns void
```

Invokes the native glLoadIdentity entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L367)

<a id="extern_function-extern-function-miniquake2-native-glmatrixmode-extern-function-glmatrixmode-mode-as-u32-from-miniquake-native-dll-symbol-mq-gl-matrix-mode-returns-void-src-miniquake2-native-ml-170419066"></a>
### glMatrixMode

```ml
extern function glMatrixMode(mode as u32) from "miniquake_native.dll" symbol "mq_gl_matrix_mode" returns void
```

Invokes the native glMatrixMode entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `u32` | — | Mode selecting the requested behavior. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L365)

<a id="extern_function-extern-function-miniquake2-native-glmultitexcoord2-extern-function-glmultitexcoord2-unit-as-i32-sbits-as-u32-tbits-as-u32-from-miniquake-native-dll-symbol-mq-gl-multi-tex-coord2-returns-void-src-miniquake2-native-ml-1211246044"></a>
### glMultiTexCoord2

```ml
extern function glMultiTexCoord2(unit as i32, sBits as u32, tBits as u32) from "miniquake_native.dll" symbol "mq_gl_multi_tex_coord2" returns void
```

Invokes the native glMultiTexCoord2 entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `unit` | `i32` | — | unit value consumed by this operation. |
| `sBits` | `u32` | — | sBits value consumed by this operation. |
| `tBits` | `u32` | — | tBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L494)

<a id="extern_function-extern-function-miniquake2-native-glmultitextureavailable-extern-function-glmultitextureavailable-from-miniquake-native-dll-symbol-mq-gl-multitexture-available-returns-i32-src-miniquake2-native-ml-1597592576"></a>
### glMultitextureAvailable

```ml
extern function glMultitextureAvailable() from "miniquake_native.dll" symbol "mq_gl_multitexture_available" returns i32
```

Invokes the native glMultitextureAvailable entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L486)

<a id="extern_function-extern-function-miniquake2-native-glortho-extern-function-glortho-leftbits-as-u32-rightbits-as-u32-bottombits-as-u32-topbits-as-u32-nearbits-as-u32-farbits-as-u32-from-miniquake-native-dll-symbol-mq-gl-ortho-returns-void-src-miniquake2-native-ml-1571851034"></a>
### glOrtho

```ml
extern function glOrtho(leftBits as u32, rightBits as u32, bottomBits as u32, topBits as u32, nearBits as u32, farBits as u32) from "miniquake_native.dll" symbol "mq_gl_ortho" returns void
```

Invokes the native glOrtho entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `leftBits` | `u32` | — | leftBits value consumed by this operation. |
| `rightBits` | `u32` | — | rightBits value consumed by this operation. |
| `bottomBits` | `u32` | — | bottomBits value consumed by this operation. |
| `topBits` | `u32` | — | topBits value consumed by this operation. |
| `nearBits` | `u32` | — | nearBits value consumed by this operation. |
| `farBits` | `u32` | — | farBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L395)

<a id="extern_function-extern-function-miniquake2-native-glpopmatrix-extern-function-glpopmatrix-from-miniquake-native-dll-symbol-mq-gl-pop-matrix-returns-void-src-miniquake2-native-ml-1321197323"></a>
### glPopMatrix

```ml
extern function glPopMatrix() from "miniquake_native.dll" symbol "mq_gl_pop_matrix" returns void
```

Invokes the native glPopMatrix entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L371)

<a id="extern_function-extern-function-miniquake2-native-glpushmatrix-extern-function-glpushmatrix-from-miniquake-native-dll-symbol-mq-gl-push-matrix-returns-void-src-miniquake2-native-ml-1279241454"></a>
### glPushMatrix

```ml
extern function glPushMatrix() from "miniquake_native.dll" symbol "mq_gl_push_matrix" returns void
```

Invokes the native glPushMatrix entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L369)

<a id="extern_function-extern-function-miniquake2-native-glreadpixels-extern-function-glreadpixels-x-as-i32-y-as-i32-width-as-i32-height-as-i32-format-as-u32-type-as-u32-pixels-as-bytes-from-miniquake-native-dll-symbol-mq-gl-read-pixels-returns-void-src-miniquake2-native-ml-1810616269"></a>
### glReadPixels

```ml
extern function glReadPixels(x as i32, y as i32, width as i32, height as i32, format as u32, type as u32, pixels as bytes) from "miniquake_native.dll" symbol "mq_gl_read_pixels" returns void
```

Invokes the native glReadPixels entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `i32` | — | Horizontal coordinate used by the operation. |
| `y` | `i32` | — | Vertical coordinate used by the operation. |
| `width` | `i32` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `i32` | — | Height in the coordinate or storage units used by the caller. |
| `format` | `u32` | — | format value consumed by this operation. |
| `type` | `u32` | — | type value consumed by this operation. |
| `pixels` | `bytes` | — | pixels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L456)

<a id="extern_function-extern-function-miniquake2-native-glrotate-extern-function-glrotate-anglebits-as-u32-xbits-as-u32-ybits-as-u32-zbits-as-u32-from-miniquake-native-dll-symbol-mq-gl-rotate-returns-void-src-miniquake2-native-ml-289523311"></a>
### glRotate

```ml
extern function glRotate(angleBits as u32, xBits as u32, yBits as u32, zBits as u32) from "miniquake_native.dll" symbol "mq_gl_rotate" returns void
```

Invokes the native glRotate entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angleBits` | `u32` | — | angleBits value consumed by this operation. |
| `xBits` | `u32` | — | xBits value consumed by this operation. |
| `yBits` | `u32` | — | yBits value consumed by this operation. |
| `zBits` | `u32` | — | zBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L377)

<a id="extern_function-extern-function-miniquake2-native-glscale-extern-function-glscale-xbits-as-u32-ybits-as-u32-zbits-as-u32-from-miniquake-native-dll-symbol-mq-gl-scale-returns-void-src-miniquake2-native-ml-1222586525"></a>
### glScale

```ml
extern function glScale(xBits as u32, yBits as u32, zBits as u32) from "miniquake_native.dll" symbol "mq_gl_scale" returns void
```

Invokes the native glScale entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xBits` | `u32` | — | xBits value consumed by this operation. |
| `yBits` | `u32` | — | yBits value consumed by this operation. |
| `zBits` | `u32` | — | zBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L387)

<a id="extern_function-extern-function-miniquake2-native-glstaticgeometrycall-extern-function-glstaticgeometrycall-keyvalue-as-u64-passvalue-as-i32-from-miniquake-native-dll-symbol-mq-gl-static-geometry-call-returns-i32-src-miniquake2-native-ml-1424064529"></a>
### glStaticGeometryCall

```ml
extern function glStaticGeometryCall(keyValue as u64, passValue as i32) from "miniquake_native.dll" symbol "mq_gl_static_geometry_call" returns i32
```

Invokes the native glStaticGeometryCall entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `keyValue` | `u64` | — | keyValue value consumed by this operation. |
| `passValue` | `i32` | — | passValue value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L465)

<a id="extern_function-extern-function-miniquake2-native-glstaticgeometrycallbatch-extern-function-glstaticgeometrycallbatch-keys-as-bytes-bytecount-as-u32-passvalue-as-i32-from-miniquake-native-dll-symbol-mq-gl-static-geometry-call-batch-returns-i32-src-miniquake2-native-ml-1119469087"></a>
### glStaticGeometryCallBatch

```ml
extern function glStaticGeometryCallBatch(keys as bytes, byteCount as u32, passValue as i32) from "miniquake_native.dll" symbol "mq_gl_static_geometry_call_batch" returns i32
```

Invokes the native glStaticGeometryCallBatch entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `keys` | `bytes` | — | keys value consumed by this operation. |
| `byteCount` | `u32` | — | Number of byte to process. |
| `passValue` | `i32` | — | passValue value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L471)

<a id="extern_function-extern-function-miniquake2-native-glstaticgeometrycallmultitexturebatch-extern-function-glstaticgeometrycallmultitexturebatch-records-as-bytes-bytecount-as-u32-from-miniquake-native-dll-symbol-mq-gl-static-geometry-call-multitexture-batch-returns-i32-src-miniquake2-native-ml-786496952"></a>
### glStaticGeometryCallMultitextureBatch

```ml
extern function glStaticGeometryCallMultitextureBatch(records as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_gl_static_geometry_call_multitexture_batch" returns i32
```

Invokes the native glStaticGeometryCallMultitextureBatch entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `records` | `bytes` | — | records value consumed by this operation. |
| `byteCount` | `u32` | — | Number of byte to process. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L476)

<a id="extern_function-extern-function-miniquake2-native-glstaticgeometryclear-extern-function-glstaticgeometryclear-from-miniquake-native-dll-symbol-mq-gl-static-geometry-clear-returns-void-src-miniquake2-native-ml-905079993"></a>
### glStaticGeometryClear

```ml
extern function glStaticGeometryClear() from "miniquake_native.dll" symbol "mq_gl_static_geometry_clear" returns void
```

Invokes the native glStaticGeometryClear entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L483)

<a id="extern_function-extern-function-miniquake2-native-glstaticgeometryprepare-extern-function-glstaticgeometryprepare-keyvalue-as-u64-passvalue-as-i32-from-miniquake-native-dll-symbol-mq-gl-static-geometry-prepare-returns-i32-src-miniquake2-native-ml-1139030592"></a>
### glStaticGeometryPrepare

```ml
extern function glStaticGeometryPrepare(keyValue as u64, passValue as i32) from "miniquake_native.dll" symbol "mq_gl_static_geometry_prepare" returns i32
```

Invokes the native glStaticGeometryPrepare entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `keyValue` | `u64` | — | keyValue value consumed by this operation. |
| `passValue` | `i32` | — | passValue value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L481)

<a id="extern_function-extern-function-miniquake2-native-gltexcoord2-extern-function-gltexcoord2-sbits-as-u32-tbits-as-u32-from-miniquake-native-dll-symbol-mq-gl-texcoord2-returns-void-src-miniquake2-native-ml-518577597"></a>
### glTexcoord2

```ml
extern function glTexcoord2(sBits as u32, tBits as u32) from "miniquake_native.dll" symbol "mq_gl_texcoord2" returns void
```

Invokes the native glTexcoord2 entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sBits` | `u32` | — | sBits value consumed by this operation. |
| `tBits` | `u32` | — | tBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L314)

<a id="extern_function-extern-function-miniquake2-native-gltexenvi-extern-function-gltexenvi-target-as-u32-name-as-u32-value-as-i32-from-miniquake-native-dll-symbol-mq-gl-tex-env-i-returns-void-src-miniquake2-native-ml-1445110204"></a>
### glTexEnvI

```ml
extern function glTexEnvI(target as u32, name as u32, value as i32) from "miniquake_native.dll" symbol "mq_gl_tex_env_i" returns void
```

Invokes the native glTexEnvI entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `u32` | — | target value consumed by this operation. |
| `name` | `u32` | — | Name of the affected item. |
| `value` | `i32` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L499)

<a id="extern_function-extern-function-miniquake2-native-glteximage2d-extern-function-glteximage2d-target-as-u32-level-as-i32-internalformat-as-i32-width-as-i32-height-as-i32-border-as-i32-format-as-u32-type-as-u32-pixels-as-bytes-from-miniquake-native-dll-symbol-mq-gl-tex-image-2d-returns-void-src-miniquake2-native-ml-1218698665"></a>
### glTexImage2D

```ml
extern function glTexImage2D(target as u32, level as i32, internalFormat as i32, width as i32, height as i32, border as i32, format as u32, type as u32, pixels as bytes) from "miniquake_native.dll" symbol "mq_gl_tex_image_2d" returns void
```

Invokes the native glTexImage2D entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `u32` | — | target value consumed by this operation. |
| `level` | `i32` | — | level value consumed by this operation. |
| `internalFormat` | `i32` | — | internalFormat value consumed by this operation. |
| `width` | `i32` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `i32` | — | Height in the coordinate or storage units used by the caller. |
| `border` | `i32` | — | border value consumed by this operation. |
| `format` | `u32` | — | format value consumed by this operation. |
| `type` | `u32` | — | type value consumed by this operation. |
| `pixels` | `bytes` | — | pixels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L427)

<a id="extern_function-extern-function-miniquake2-native-gltexparameteri-extern-function-gltexparameteri-target-as-u32-name-as-u32-value-as-i32-from-miniquake-native-dll-symbol-mq-gl-tex-parameter-i-returns-void-src-miniquake2-native-ml-1163967636"></a>
### glTexParameterI

```ml
extern function glTexParameterI(target as u32, name as u32, value as i32) from "miniquake_native.dll" symbol "mq_gl_tex_parameter_i" returns void
```

Invokes the native glTexParameterI entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `u32` | — | target value consumed by this operation. |
| `name` | `u32` | — | Name of the affected item. |
| `value` | `i32` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L416)

<a id="extern_function-extern-function-miniquake2-native-gltexsubimage2d-extern-function-gltexsubimage2d-target-as-u32-level-as-i32-xoffset-as-i32-yoffset-as-i32-width-as-i32-height-as-i32-format-as-u32-type-as-u32-pixels-as-bytes-from-miniquake-native-dll-symbol-mq-gl-tex-sub-image-2d-returns-void-src-miniquake2-native-ml-1180257467"></a>
### glTexSubImage2D

```ml
extern function glTexSubImage2D(target as u32, level as i32, xOffset as i32, yOffset as i32, width as i32, height as i32, format as u32, type as u32, pixels as bytes) from "miniquake_native.dll" symbol "mq_gl_tex_sub_image_2d" returns void
```

Invokes the native glTexSubImage2D entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `u32` | — | target value consumed by this operation. |
| `level` | `i32` | — | level value consumed by this operation. |
| `xOffset` | `i32` | — | xOffset value consumed by this operation. |
| `yOffset` | `i32` | — | yOffset value consumed by this operation. |
| `width` | `i32` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `i32` | — | Height in the coordinate or storage units used by the caller. |
| `format` | `u32` | — | format value consumed by this operation. |
| `type` | `u32` | — | type value consumed by this operation. |
| `pixels` | `bytes` | — | pixels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L438)

<a id="extern_function-extern-function-miniquake2-native-gltranslate-extern-function-gltranslate-xbits-as-u32-ybits-as-u32-zbits-as-u32-from-miniquake-native-dll-symbol-mq-gl-translate-returns-void-src-miniquake2-native-ml-991916869"></a>
### glTranslate

```ml
extern function glTranslate(xBits as u32, yBits as u32, zBits as u32) from "miniquake_native.dll" symbol "mq_gl_translate" returns void
```

Invokes the native glTranslate entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xBits` | `u32` | — | xBits value consumed by this operation. |
| `yBits` | `u32` | — | yBits value consumed by this operation. |
| `zBits` | `u32` | — | zBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L382)

<a id="extern_function-extern-function-miniquake2-native-glvertex2-extern-function-glvertex2-xbits-as-u32-ybits-as-u32-from-miniquake-native-dll-symbol-mq-gl-vertex2-returns-void-src-miniquake2-native-ml-1456269343"></a>
### glVertex2

```ml
extern function glVertex2(xBits as u32, yBits as u32) from "miniquake_native.dll" symbol "mq_gl_vertex2" returns void
```

Invokes the native glVertex2 entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xBits` | `u32` | — | xBits value consumed by this operation. |
| `yBits` | `u32` | — | yBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L305)

<a id="extern_function-extern-function-miniquake2-native-glvertex3-extern-function-glvertex3-xbits-as-u32-ybits-as-u32-zbits-as-u32-from-miniquake-native-dll-symbol-mq-gl-vertex3-returns-void-src-miniquake2-native-ml-2069918522"></a>
### glVertex3

```ml
extern function glVertex3(xBits as u32, yBits as u32, zBits as u32) from "miniquake_native.dll" symbol "mq_gl_vertex3" returns void
```

Invokes the native glVertex3 entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xBits` | `u32` | — | xBits value consumed by this operation. |
| `yBits` | `u32` | — | yBits value consumed by this operation. |
| `zBits` | `u32` | — | zBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L310)

<a id="extern_function-extern-function-miniquake2-native-glviewport-extern-function-glviewport-x-as-i32-y-as-i32-width-as-i32-height-as-i32-from-miniquake-native-dll-symbol-mq-gl-viewport-returns-void-src-miniquake2-native-ml-1838749028"></a>
### glViewport

```ml
extern function glViewport(x as i32, y as i32, width as i32, height as i32) from "miniquake_native.dll" symbol "mq_gl_viewport" returns void
```

Invokes the native glViewport entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `i32` | — | Horizontal coordinate used by the operation. |
| `y` | `i32` | — | Vertical coordinate used by the operation. |
| `width` | `i32` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `i32` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L362)

<a id="extern_function-extern-function-miniquake2-native-oggchannels-extern-function-oggchannels-from-miniquake-native-dll-symbol-mq-ogg-channels-returns-u32-src-miniquake2-native-ml-46402230"></a>
### oggChannels

```ml
extern function oggChannels() from "miniquake_native.dll" symbol "mq_ogg_channels" returns u32
```

Invokes the native oggChannels entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L280)

<a id="extern_function-extern-function-miniquake2-native-oggclose-extern-function-oggclose-from-miniquake-native-dll-symbol-mq-ogg-close-returns-void-src-miniquake2-native-ml-265819858"></a>
### oggClose

```ml
extern function oggClose() from "miniquake_native.dll" symbol "mq_ogg_close" returns void
```

Invokes the native oggClose entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L293)

<a id="extern_function-extern-function-miniquake2-native-oggdecode-extern-function-oggdecode-output-as-bytes-framecapacity-as-u32-from-miniquake-native-dll-symbol-mq-ogg-decode-returns-u32-src-miniquake2-native-ml-1453840893"></a>
### oggDecode

```ml
extern function oggDecode(output as bytes, frameCapacity as u32) from "miniquake_native.dll" symbol "mq_ogg_decode" returns u32
```

Invokes the native oggDecode entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `bytes` | — | Output collection or buffer populated by the operation. |
| `frameCapacity` | `u32` | — | frameCapacity value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L288)

<a id="extern_function-extern-function-miniquake2-native-oggframes-extern-function-oggframes-from-miniquake-native-dll-symbol-mq-ogg-frames-returns-u32-src-miniquake2-native-ml-695291412"></a>
### oggFrames

```ml
extern function oggFrames() from "miniquake_native.dll" symbol "mq_ogg_frames" returns u32
```

Invokes the native oggFrames entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L283)

<a id="extern_function-extern-function-miniquake2-native-oggopen-extern-function-oggopen-data-as-bytes-bytecount-as-u32-from-miniquake-native-dll-symbol-mq-ogg-open-returns-u32-src-miniquake2-native-ml-1476233318"></a>
### oggOpen

```ml
extern function oggOpen(data as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_ogg_open" returns u32
```

Invokes the native oggOpen entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `bytes` | — | Input data consumed by the operation. |
| `byteCount` | `u32` | — | Number of byte to process. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L270)

<a id="extern_function-extern-function-miniquake2-native-oggopenfile-extern-function-oggopenfile-filename-as-wstr-from-miniquake-native-dll-symbol-mq-ogg-open-file-returns-u32-src-miniquake2-native-ml-778230502"></a>
### oggOpenFile

```ml
extern function oggOpenFile(filename as wstr) from "miniquake_native.dll" symbol "mq_ogg_open_file" returns u32
```

Invokes the native oggOpenFile entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | `wstr` | — | filename value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L274)

<a id="extern_function-extern-function-miniquake2-native-oggrate-extern-function-oggrate-from-miniquake-native-dll-symbol-mq-ogg-rate-returns-u32-src-miniquake2-native-ml-1883938540"></a>
### oggRate

```ml
extern function oggRate() from "miniquake_native.dll" symbol "mq_ogg_rate" returns u32
```

Invokes the native oggRate entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L277)

<a id="extern_function-extern-function-miniquake2-native-oggseekstart-extern-function-oggseekstart-from-miniquake-native-dll-symbol-mq-ogg-seek-start-returns-i32-src-miniquake2-native-ml-616303635"></a>
### oggSeekStart

```ml
extern function oggSeekStart() from "miniquake_native.dll" symbol "mq_ogg_seek_start" returns i32
```

Invokes the native oggSeekStart entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L291)

<a id="extern_function-extern-function-miniquake2-native-processhandlecount-extern-function-processhandlecount-from-miniquake-native-dll-symbol-mq-process-handle-count-returns-u32-src-miniquake2-native-ml-945072306"></a>
### processHandleCount

```ml
extern function processHandleCount() from "miniquake_native.dll" symbol "mq_process_handle_count" returns u32
```

Invokes the native processHandleCount entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L43)

<a id="function-function-miniquake2-native-sin-function-sin-value-src-miniquake2-native-ml-228033562"></a>
### sin

```ml
function sin(value)
```

Return the sin value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L602)

<a id="extern_function-extern-function-miniquake2-native-sysconsolealloc-extern-function-sysconsolealloc-from-miniquake-native-dll-symbol-mq-sys-console-alloc-returns-i32-src-miniquake2-native-ml-171628489"></a>
### sysConsoleAlloc

```ml
extern function sysConsoleAlloc() from "miniquake_native.dll" symbol "mq_sys_console_alloc" returns i32
```

Invokes the native sysConsoleAlloc entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L49)

<a id="extern_function-extern-function-miniquake2-native-sysconsoleeventpop-extern-function-sysconsoleeventpop-from-miniquake-native-dll-symbol-mq-sys-console-event-pop-returns-u32-src-miniquake2-native-ml-878404678"></a>
### sysConsoleEventPop

```ml
extern function sysConsoleEventPop() from "miniquake_native.dll" symbol "mq_sys_console_event_pop" returns u32
```

Invokes the native sysConsoleEventPop entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L55)

<a id="extern_function-extern-function-miniquake2-native-sysconsolefree-extern-function-sysconsolefree-from-miniquake-native-dll-symbol-mq-sys-console-free-returns-i32-src-miniquake2-native-ml-1743172960"></a>
### sysConsoleFree

```ml
extern function sysConsoleFree() from "miniquake_native.dll" symbol "mq_sys_console_free" returns i32
```

Invokes the native sysConsoleFree entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L52)

<a id="extern_function-extern-function-miniquake2-native-sysconsolewrite-extern-function-sysconsolewrite-text-as-cstr-from-miniquake-native-dll-symbol-mq-sys-console-write-returns-i32-src-miniquake2-native-ml-2109588096"></a>
### sysConsoleWrite

```ml
extern function sysConsoleWrite(text as cstr) from "miniquake_native.dll" symbol "mq_sys_console_write" returns i32
```

Invokes the native sysConsoleWrite entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `cstr` | — | Text consumed by the operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L59)

<a id="extern_function-extern-function-miniquake2-native-syscounter-extern-function-syscounter-from-miniquake-native-dll-symbol-mq-sys-counter-returns-u64-src-miniquake2-native-ml-177656869"></a>
### sysCounter

```ml
extern function sysCounter() from "miniquake_native.dll" symbol "mq_sys_counter" returns u64
```

Invokes the native sysCounter entry point used by the miniquake2 native module.


**Returns:** Native u64 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L37)

<a id="extern_function-extern-function-miniquake2-native-sysfrequency-extern-function-sysfrequency-from-miniquake-native-dll-symbol-mq-sys-frequency-returns-u64-src-miniquake2-native-ml-1034763591"></a>
### sysFrequency

```ml
extern function sysFrequency() from "miniquake_native.dll" symbol "mq_sys_frequency" returns u64
```

Invokes the native sysFrequency entry point used by the miniquake2 native module.


**Returns:** Native u64 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L40)

<a id="extern_function-extern-function-miniquake2-native-syssleepuntilinput-extern-function-syssleepuntilinput-milliseconds-as-u32-from-miniquake-native-dll-symbol-mq-sys-sleep-until-input-returns-void-src-miniquake2-native-ml-1237360229"></a>
### sysSleepUntilInput

```ml
extern function sysSleepUntilInput(milliseconds as u32) from "miniquake_native.dll" symbol "mq_sys_sleep_until_input" returns void
```

Invokes the native sysSleepUntilInput entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `milliseconds` | `u32` | — | milliseconds value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L62)

<a id="function-function-miniquake2-native-textresult-function-textresult-buffer-count-src-miniquake2-native-ml-470835974"></a>
### textResult

```ml
function textResult(buffer, count)
```

Return the text result value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L622)

<a id="function-function-miniquake2-native-udpboundaddress-function-udpboundaddress-handle-src-miniquake2-native-ml-884625271"></a>
### udpBoundAddress

```ml
function udpBoundAddress(handle)
```

Return the udp bound address value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Native or runtime handle used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L638)

<a id="extern_function-extern-function-miniquake2-native-udpboundaddressraw-extern-function-udpboundaddressraw-handle-as-u64-output-as-bytes-capacity-as-u32-from-miniquake-text-dll-symbol-mqt-udp-bound-address-returns-u32-src-miniquake2-native-ml-182566552"></a>
### udpBoundAddressRaw

```ml
extern function udpBoundAddressRaw(handle as u64, output as bytes, capacity as u32) from "miniquake_text.dll" symbol "mqt_udp_bound_address" returns u32
```

Invokes the native udpBoundAddressRaw entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `u64` | — | Native or runtime handle used by the operation. |
| `output` | `bytes` | — | Output collection or buffer populated by the operation. |
| `capacity` | `u32` | — | capacity value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L224)

<a id="extern_function-extern-function-miniquake2-native-udpboundport-extern-function-udpboundport-handle-as-u64-from-miniquake-native-dll-symbol-mq-udp-bound-port-returns-u32-src-miniquake2-native-ml-1851220275"></a>
### udpBoundPort

```ml
extern function udpBoundPort(handle as u64) from "miniquake_native.dll" symbol "mq_udp_bound_port" returns u32
```

Invokes the native udpBoundPort entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `u64` | — | Native or runtime handle used by the operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L185)

<a id="extern_function-extern-function-miniquake2-native-udpclose-extern-function-udpclose-handle-as-u64-from-miniquake-native-dll-symbol-mq-udp-close-returns-void-src-miniquake2-native-ml-1332880537"></a>
### udpClose

```ml
extern function udpClose(handle as u64) from "miniquake_native.dll" symbol "mq_udp_close" returns void
```

Invokes the native udpClose entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `u64` | — | Native or runtime handle used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L181)

<a id="extern_function-extern-function-miniquake2-native-udpenablebroadcast-extern-function-udpenablebroadcast-handle-as-u64-from-miniquake-native-dll-symbol-mq-udp-enable-broadcast-returns-i32-src-miniquake2-native-ml-174380064"></a>
### udpEnableBroadcast

```ml
extern function udpEnableBroadcast(handle as u64) from "miniquake_native.dll" symbol "mq_udp_enable_broadcast" returns i32
```

Invokes the native udpEnableBroadcast entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `u64` | — | Native or runtime handle used by the operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L189)

<a id="function-function-miniquake2-native-udplastaddress-function-udplastaddress-src-miniquake2-native-ml-92961091"></a>
### udpLastAddress

```ml
function udpLastAddress()
```

Return the udp last address value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L631)

<a id="extern_function-extern-function-miniquake2-native-udplastaddressraw-extern-function-udplastaddressraw-output-as-bytes-capacity-as-u32-from-miniquake-text-dll-symbol-mqt-udp-last-address-returns-u32-src-miniquake2-native-ml-1113403439"></a>
### udpLastAddressRaw

```ml
extern function udpLastAddressRaw(output as bytes, capacity as u32) from "miniquake_text.dll" symbol "mqt_udp_last_address" returns u32
```

Invokes the native udpLastAddressRaw entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `bytes` | — | Output collection or buffer populated by the operation. |
| `capacity` | `u32` | — | capacity value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L218)

<a id="extern_function-extern-function-miniquake2-native-udplasterror-extern-function-udplasterror-from-miniquake-native-dll-symbol-mq-udp-last-error-returns-i32-src-miniquake2-native-ml-1366649921"></a>
### udpLastError

```ml
extern function udpLastError() from "miniquake_native.dll" symbol "mq_udp_last_error" returns i32
```

Invokes the native udpLastError entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L213)

<a id="extern_function-extern-function-miniquake2-native-udplastport-extern-function-udplastport-from-miniquake-native-dll-symbol-mq-udp-last-port-returns-u32-src-miniquake2-native-ml-894937466"></a>
### udpLastPort

```ml
extern function udpLastPort() from "miniquake_native.dll" symbol "mq_udp_last_port" returns u32
```

Invokes the native udpLastPort entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L210)

<a id="extern_function-extern-function-miniquake2-native-udpopenbound-extern-function-udpopenbound-port-as-u32-address-as-cstr-from-miniquake-native-dll-symbol-mq-udp-open-bound-returns-u64-src-miniquake2-native-ml-1009046633"></a>
### udpOpenBound

```ml
extern function udpOpenBound(port as u32, address as cstr) from "miniquake_native.dll" symbol "mq_udp_open_bound" returns u64
```

Invokes the native udpOpenBound entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `port` | `u32` | — | port value consumed by this operation. |
| `address` | `cstr` | — | address value consumed by this operation. |


**Returns:** Native u64 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L178)

<a id="extern_function-extern-function-miniquake2-native-udppeek-extern-function-udppeek-handle-as-u64-from-miniquake-native-dll-symbol-mq-udp-peek-returns-i32-src-miniquake2-native-ml-245816818"></a>
### udpPeek

```ml
extern function udpPeek(handle as u64) from "miniquake_native.dll" symbol "mq_udp_peek" returns i32
```

Invokes the native udpPeek entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `u64` | — | Native or runtime handle used by the operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L193)

<a id="extern_function-extern-function-miniquake2-native-udpreceive-extern-function-udpreceive-handle-as-u64-data-as-bytes-capacity-as-u32-from-miniquake-native-dll-symbol-mq-udp-receive-returns-i32-src-miniquake2-native-ml-1677428163"></a>
### udpReceive

```ml
extern function udpReceive(handle as u64, data as bytes, capacity as u32) from "miniquake_native.dll" symbol "mq_udp_receive" returns i32
```

Invokes the native udpReceive entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `u64` | — | Native or runtime handle used by the operation. |
| `data` | `bytes` | — | Input data consumed by the operation. |
| `capacity` | `u32` | — | capacity value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L207)

<a id="function-function-miniquake2-native-udpresolvename-function-udpresolvename-name-src-miniquake2-native-ml-1615520068"></a>
### udpResolveName

```ml
function udpResolveName(name)
```

Resolve udp name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L645)

<a id="extern_function-extern-function-miniquake2-native-udpresolvenameraw-extern-function-udpresolvenameraw-name-as-cstr-output-as-bytes-capacity-as-u32-from-miniquake-text-dll-symbol-mqt-udp-resolve-name-returns-u32-src-miniquake2-native-ml-603492165"></a>
### udpResolveNameRaw

```ml
extern function udpResolveNameRaw(name as cstr, output as bytes, capacity as u32) from "miniquake_text.dll" symbol "mqt_udp_resolve_name" returns u32
```

Invokes the native udpResolveNameRaw entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `cstr` | — | Name of the affected item. |
| `output` | `bytes` | — | Output collection or buffer populated by the operation. |
| `capacity` | `u32` | — | capacity value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L230)

<a id="extern_function-extern-function-miniquake2-native-udpsend-extern-function-udpsend-handle-as-u64-address-as-cstr-port-as-u32-data-as-bytes-bytecount-as-u32-from-miniquake-native-dll-symbol-mq-udp-send-returns-i32-src-miniquake2-native-ml-1400410982"></a>
### udpSend

```ml
extern function udpSend(handle as u64, address as cstr, port as u32, data as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_udp_send" returns i32
```

Invokes the native udpSend entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `u64` | — | Native or runtime handle used by the operation. |
| `address` | `cstr` | — | address value consumed by this operation. |
| `port` | `u32` | — | port value consumed by this operation. |
| `data` | `bytes` | — | Input data consumed by the operation. |
| `byteCount` | `u32` | — | Number of byte to process. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L201)

<a id="extern_function-extern-function-miniquake2-native-winclientheight-extern-function-winclientheight-from-miniquake-native-dll-symbol-mq-win-client-height-returns-i32-src-miniquake2-native-ml-1167668710"></a>
### winClientHeight

```ml
extern function winClientHeight() from "miniquake_native.dll" symbol "mq_win_client_height" returns i32
```

Invokes the native winClientHeight entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L105)

<a id="extern_function-extern-function-miniquake2-native-winclientwidth-extern-function-winclientwidth-from-miniquake-native-dll-symbol-mq-win-client-width-returns-i32-src-miniquake2-native-ml-1108244243"></a>
### winClientWidth

```ml
extern function winClientWidth() from "miniquake_native.dll" symbol "mq_win_client_width" returns i32
```

Invokes the native winClientWidth entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L102)

<a id="extern_function-extern-function-miniquake2-native-winconfiguredisplaymode-extern-function-winconfiguredisplaymode-width-as-i32-height-as-i32-bpp-as-i32-frequency-as-i32-fullscreen-as-i32-usecurrent-as-i32-from-miniquake-native-dll-symbol-mq-win-configure-display-mode-returns-i32-src-miniquake2-native-ml-1468912518"></a>
### winConfigureDisplayMode

```ml
extern function winConfigureDisplayMode(width as i32, height as i32, bpp as i32, frequency as i32, fullscreen as i32, useCurrent as i32) from "miniquake_native.dll" symbol "mq_win_configure_display_mode" returns i32
```

Invokes the native winConfigureDisplayMode entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `i32` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `i32` | — | Height in the coordinate or storage units used by the caller. |
| `bpp` | `i32` | — | bpp value consumed by this operation. |
| `frequency` | `i32` | — | frequency value consumed by this operation. |
| `fullscreen` | `i32` | — | fullscreen value consumed by this operation. |
| `useCurrent` | `i32` | — | useCurrent value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L86)

<a id="extern_function-extern-function-miniquake2-native-wincreate-extern-function-wincreate-title-as-wstr-width-as-i32-height-as-i32-fullscreen-as-i32-from-miniquake-native-dll-symbol-mq-win-create-returns-ptr-src-miniquake2-native-ml-1727373783"></a>
### winCreate

```ml
extern function winCreate(title as wstr, width as i32, height as i32, fullscreen as i32) from "miniquake_native.dll" symbol "mq_win_create" returns ptr
```

Invokes the native winCreate entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `wstr` | — | Human-readable title presented to the user. |
| `width` | `i32` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `i32` | — | Height in the coordinate or storage units used by the caller. |
| `fullscreen` | `i32` | — | fullscreen value consumed by this operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L70)

<a id="extern_function-extern-function-miniquake2-native-windesktopheight-extern-function-windesktopheight-from-miniquake-native-dll-symbol-mq-win-desktop-height-returns-i32-src-miniquake2-native-ml-901948645"></a>
### winDesktopHeight

```ml
extern function winDesktopHeight() from "miniquake_native.dll" symbol "mq_win_desktop_height" returns i32
```

Invokes the native winDesktopHeight entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L116)

<a id="extern_function-extern-function-miniquake2-native-windesktopwidth-extern-function-windesktopwidth-from-miniquake-native-dll-symbol-mq-win-desktop-width-returns-i32-src-miniquake2-native-ml-1296869066"></a>
### winDesktopWidth

```ml
extern function winDesktopWidth() from "miniquake_native.dll" symbol "mq_win_desktop_width" returns i32
```

Invokes the native winDesktopWidth entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L113)

<a id="extern_function-extern-function-miniquake2-native-windestroy-extern-function-windestroy-from-miniquake-native-dll-symbol-mq-win-destroy-returns-void-src-miniquake2-native-ml-1005439969"></a>
### winDestroy

```ml
extern function winDestroy() from "miniquake_native.dll" symbol "mq_win_destroy" returns void
```

Invokes the native winDestroy entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L90)

<a id="extern_function-extern-function-miniquake2-native-wingetgammaramp-extern-function-wingetgammaramp-ramp-as-bytes-bytecount-as-u32-from-miniquake-native-dll-symbol-mq-win-get-gamma-ramp-returns-i32-src-miniquake2-native-ml-1898605826"></a>
### winGetGammaRamp

```ml
extern function winGetGammaRamp(ramp as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_win_get_gamma_ramp" returns i32
```

Invokes the native winGetGammaRamp entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ramp` | `bytes` | — | ramp value consumed by this operation. |
| `byteCount` | `u32` | — | Number of byte to process. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L145)

<a id="extern_function-extern-function-miniquake2-native-winhasfocus-extern-function-winhasfocus-from-miniquake-native-dll-symbol-mq-win-has-focus-returns-i32-src-miniquake2-native-ml-1087513630"></a>
### winHasFocus

```ml
extern function winHasFocus() from "miniquake_native.dll" symbol "mq_win_has_focus" returns i32
```

Invokes the native winHasFocus entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L119)

<a id="extern_function-extern-function-miniquake2-native-wininputeventpop-extern-function-wininputeventpop-from-miniquake-native-dll-symbol-mq-win-input-event-pop-returns-u32-src-miniquake2-native-ml-860713168"></a>
### winInputEventPop

```ml
extern function winInputEventPop() from "miniquake_native.dll" symbol "mq_win_input_event_pop" returns u32
```

Invokes the native winInputEventPop entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L140)

<a id="extern_function-extern-function-miniquake2-native-winjoyaxis-extern-function-winjoyaxis-axis-as-u32-from-miniquake-native-dll-symbol-mq-win-joy-axis-returns-u32-src-miniquake2-native-ml-2015016248"></a>
### winJoyAxis

```ml
extern function winJoyAxis(axis as u32) from "miniquake_native.dll" symbol "mq_win_joy_axis" returns u32
```

Invokes the native winJoyAxis entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `axis` | `u32` | — | axis value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L160)

<a id="extern_function-extern-function-miniquake2-native-winjoybuttoncount-extern-function-winjoybuttoncount-from-miniquake-native-dll-symbol-mq-win-joy-button-count-returns-u32-src-miniquake2-native-ml-1768683802"></a>
### winJoyButtonCount

```ml
extern function winJoyButtonCount() from "miniquake_native.dll" symbol "mq_win_joy_button_count" returns u32
```

Invokes the native winJoyButtonCount entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L169)

<a id="extern_function-extern-function-miniquake2-native-winjoybuttons-extern-function-winjoybuttons-from-miniquake-native-dll-symbol-mq-win-joy-buttons-returns-u32-src-miniquake2-native-ml-119735757"></a>
### winJoyButtons

```ml
extern function winJoyButtons() from "miniquake_native.dll" symbol "mq_win_joy_buttons" returns u32
```

Invokes the native winJoyButtons entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L163)

<a id="extern_function-extern-function-miniquake2-native-winjoyhaspov-extern-function-winjoyhaspov-from-miniquake-native-dll-symbol-mq-win-joy-has-pov-returns-i32-src-miniquake2-native-ml-1809609972"></a>
### winJoyHasPov

```ml
extern function winJoyHasPov() from "miniquake_native.dll" symbol "mq_win_joy_has_pov" returns i32
```

Invokes the native winJoyHasPov entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L172)

<a id="extern_function-extern-function-miniquake2-native-winjoypov-extern-function-winjoypov-from-miniquake-native-dll-symbol-mq-win-joy-pov-returns-u32-src-miniquake2-native-ml-563956049"></a>
### winJoyPov

```ml
extern function winJoyPov() from "miniquake_native.dll" symbol "mq_win_joy_pov" returns u32
```

Invokes the native winJoyPov entry point used by the miniquake2 native module.


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L166)

<a id="extern_function-extern-function-miniquake2-native-winjoyread-extern-function-winjoyread-from-miniquake-native-dll-symbol-mq-win-joy-read-returns-i32-src-miniquake2-native-ml-1557487074"></a>
### winJoyRead

```ml
extern function winJoyRead() from "miniquake_native.dll" symbol "mq_win_joy_read" returns i32
```

Invokes the native winJoyRead entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L156)

<a id="extern_function-extern-function-miniquake2-native-winjoystartup-extern-function-winjoystartup-from-miniquake-native-dll-symbol-mq-win-joy-startup-returns-i32-src-miniquake2-native-ml-551113389"></a>
### winJoyStartup

```ml
extern function winJoyStartup() from "miniquake_native.dll" symbol "mq_win_joy_startup" returns i32
```

Invokes the native winJoyStartup entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L153)

<a id="extern_function-extern-function-miniquake2-native-winmousebuttons-extern-function-winmousebuttons-from-miniquake-native-dll-symbol-mq-win-mouse-buttons-returns-i32-src-miniquake2-native-ml-1870389944"></a>
### winMouseButtons

```ml
extern function winMouseButtons() from "miniquake_native.dll" symbol "mq_win_mouse_buttons" returns i32
```

Invokes the native winMouseButtons entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L134)

<a id="extern_function-extern-function-miniquake2-native-winmousedx-extern-function-winmousedx-from-miniquake-native-dll-symbol-mq-win-mouse-dx-returns-i32-src-miniquake2-native-ml-1737567039"></a>
### winMouseDx

```ml
extern function winMouseDx() from "miniquake_native.dll" symbol "mq_win_mouse_dx" returns i32
```

Invokes the native winMouseDx entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L128)

<a id="extern_function-extern-function-miniquake2-native-winmousedy-extern-function-winmousedy-from-miniquake-native-dll-symbol-mq-win-mouse-dy-returns-i32-src-miniquake2-native-ml-1188025438"></a>
### winMouseDy

```ml
extern function winMouseDy() from "miniquake_native.dll" symbol "mq_win_mouse_dy" returns i32
```

Invokes the native winMouseDy entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L131)

<a id="extern_function-extern-function-miniquake2-native-winmousewheel-extern-function-winmousewheel-from-miniquake-native-dll-symbol-mq-win-mouse-wheel-returns-i32-src-miniquake2-native-ml-625012486"></a>
### winMouseWheel

```ml
extern function winMouseWheel() from "miniquake_native.dll" symbol "mq_win_mouse_wheel" returns i32
```

Invokes the native winMouseWheel entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L137)

<a id="extern_function-extern-function-miniquake2-native-winpoll-extern-function-winpoll-from-miniquake-native-dll-symbol-mq-win-poll-returns-i32-src-miniquake2-native-ml-826528596"></a>
### winPoll

```ml
extern function winPoll() from "miniquake_native.dll" symbol "mq_win_poll" returns i32
```

Invokes the native winPoll entry point used by the miniquake2 native module.


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L93)

<a id="extern_function-extern-function-miniquake2-native-winresizeclient-extern-function-winresizeclient-width-as-i32-height-as-i32-from-miniquake-native-dll-symbol-mq-win-resize-client-returns-i32-src-miniquake2-native-ml-1203974880"></a>
### winResizeClient

```ml
extern function winResizeClient(width as i32, height as i32) from "miniquake_native.dll" symbol "mq_win_resize_client" returns i32
```

Invokes the native winResizeClient entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `i32` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `i32` | — | Height in the coordinate or storage units used by the caller. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L110)

<a id="extern_function-extern-function-miniquake2-native-winrestoredisplaymode-extern-function-winrestoredisplaymode-from-miniquake-native-dll-symbol-mq-win-restore-display-mode-returns-void-src-miniquake2-native-ml-1341276322"></a>
### winRestoreDisplayMode

```ml
extern function winRestoreDisplayMode() from "miniquake_native.dll" symbol "mq_win_restore_display_mode" returns void
```

Invokes the native winRestoreDisplayMode entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L88)

<a id="extern_function-extern-function-miniquake2-native-winsetcursorcapture-extern-function-winsetcursorcapture-enabled-as-i32-from-miniquake-native-dll-symbol-mq-win-set-cursor-capture-returns-void-src-miniquake2-native-ml-909590596"></a>
### winSetCursorCapture

```ml
extern function winSetCursorCapture(enabled as i32) from "miniquake_native.dll" symbol "mq_win_set_cursor_capture" returns void
```

Invokes the native winSetCursorCapture entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `i32` | — | enabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L125)

<a id="extern_function-extern-function-miniquake2-native-winsetgammaramp-extern-function-winsetgammaramp-ramp-as-bytes-bytecount-as-u32-from-miniquake-native-dll-symbol-mq-win-set-gamma-ramp-returns-i32-src-miniquake2-native-ml-298870374"></a>
### winSetGammaRamp

```ml
extern function winSetGammaRamp(ramp as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_win_set_gamma_ramp" returns i32
```

Invokes the native winSetGammaRamp entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ramp` | `bytes` | — | ramp value consumed by this operation. |
| `byteCount` | `u32` | — | Number of byte to process. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L150)

<a id="extern_function-extern-function-miniquake2-native-winsetswapinterval-extern-function-winsetswapinterval-interval-as-i32-from-miniquake-native-dll-symbol-mq-win-set-swap-interval-returns-i32-src-miniquake2-native-ml-956681832"></a>
### winSetSwapInterval

```ml
extern function winSetSwapInterval(interval as i32) from "miniquake_native.dll" symbol "mq_win_set_swap_interval" returns i32
```

Invokes the native winSetSwapInterval entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `interval` | `i32` | — | interval value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L99)

<a id="extern_function-extern-function-miniquake2-native-winsettitle-extern-function-winsettitle-title-as-wstr-from-miniquake-native-dll-symbol-mq-win-set-title-returns-void-src-miniquake2-native-ml-1666388816"></a>
### winSetTitle

```ml
extern function winSetTitle(title as wstr) from "miniquake_native.dll" symbol "mq_win_set_title" returns void
```

Invokes the native winSetTitle entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `wstr` | — | Human-readable title presented to the user. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L122)

<a id="extern_function-extern-function-miniquake2-native-winsleep-extern-function-winsleep-milliseconds-as-u32-from-miniquake-native-dll-symbol-mq-win-sleep-returns-void-src-miniquake2-native-ml-470037970"></a>
### winSleep

```ml
extern function winSleep(milliseconds as u32) from "miniquake_native.dll" symbol "mq_win_sleep" returns void
```

Invokes the native winSleep entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `milliseconds` | `u32` | — | milliseconds value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L46)

<a id="extern_function-extern-function-miniquake2-native-winswap-extern-function-winswap-from-miniquake-native-dll-symbol-mq-win-swap-returns-void-src-miniquake2-native-ml-1972465378"></a>
### winSwap

```ml
extern function winSwap() from "miniquake_native.dll" symbol "mq_win_swap" returns void
```

Invokes the native winSwap entry point used by the miniquake2 native module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L95)

<a id="extern_function-extern-function-miniquake2-native-wintestdisplaymode-extern-function-wintestdisplaymode-width-as-i32-height-as-i32-bpp-as-i32-frequency-as-i32-from-miniquake-native-dll-symbol-mq-win-test-display-mode-returns-i32-src-miniquake2-native-ml-1017686677"></a>
### winTestDisplayMode

```ml
extern function winTestDisplayMode(width as i32, height as i32, bpp as i32, frequency as i32) from "miniquake_native.dll" symbol "mq_win_test_display_mode" returns i32
```

Invokes the native winTestDisplayMode entry point used by the miniquake2 native module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `i32` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `i32` | — | Height in the coordinate or storage units used by the caller. |
| `bpp` | `i32` | — | bpp value consumed by this operation. |
| `frequency` | `i32` | — | frequency value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/native.ml#L77)
