# `src/main.ml`

[Home](README.md) · [Files](Files.md)

Provides main facilities for this project.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/byteio.ml` as `mainByteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/runtime/application.ml` as `runtimeApplication` → [src/miniquake2/runtime/application.ml](File-src-miniquake2-runtime-application-ml-1538219473.md)
- `miniquake2/runtime/crash_report.ml` as `crashReport` → [src/miniquake2/runtime/crash_report.ml](File-src-miniquake2-runtime-crash-report-ml-1005648729.md)
- `miniquake2/runtime/diagnostics.ml` as `runtimeDiagnostics` → [src/miniquake2/runtime/diagnostics.ml](File-src-miniquake2-runtime-diagnostics-ml-1722753055.md)
- `miniquake2/runtime/product_startup.ml` as `productStartup` → [src/miniquake2/runtime/product_startup.ml](File-src-miniquake2-runtime-product-startup-ml-320456564.md)

## Declarations

<a id="function-function-discoverdefaultproductroot-function-discoverdefaultproductroot-src-main-ml-278221783"></a>
### discoverDefaultProductRoot

```ml
function discoverDefaultProductRoot()
```

Discover default product root.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L68)

<a id="function-function-dispatchmain-function-dispatchmain-args-src-main-ml-976033228"></a>
### dispatchMain

```ml
function dispatchMain(args)
```

Dispatch the asset-free bootstrap commands.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L505)

<a id="function-function-main-function-main-args-src-main-ml-776500952"></a>
### main

```ml
function main(args)
```

Catch every propagated MiniLang error at the process boundary. Keeping the original error value preserves its source file, line and function for the persistent report and the copyable Windows crash dialog.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L552)

<a id="constant-constant-miniquake2-version-const-miniquake2-version-0-5-0-foundation-src-main-ml-1239638117"></a>
### MINIQUAKE2_VERSION

```ml
const MINIQUAKE2_VERSION = "0.5.0-foundation"
```

Defines the miniquake2 version constant used by the main module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L18)

<a id="constant-constant-port-stage-const-port-stage-integrated-runtime-foundation-src-main-ml-1557408726"></a>
### PORT_STAGE

```ml
const PORT_STAGE = "integrated-runtime-foundation"
```

Defines the port stage constant used by the main module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L24)

<a id="function-function-printcapabilities-function-printcapabilities-src-main-ml-1671081157"></a>
### printCapabilities

```ml
function printCapabilities()
```

Print capabilities.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L134)

<a id="function-function-printdiagnostics-function-printdiagnostics-src-main-ml-1875502239"></a>
### printDiagnostics

```ml
function printDiagnostics()
```

Report capabilities that must remain usable without proprietary assets.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L121)

<a id="function-function-printusage-function-printusage-src-main-ml-954114287"></a>
### printUsage

```ml
function printUsage()
```

Print the small bootstrap command surface.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L27)

<a id="function-function-printversion-function-printversion-src-main-ml-517999447"></a>
### printVersion

```ml
function printVersion()
```

Print stable build and compatibility identifiers for scripts and humans.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L113)

<a id="constant-constant-quake2-protocol-version-const-quake2-protocol-version-34-src-main-ml-1566535503"></a>
### QUAKE2_PROTOCOL_VERSION

```ml
const QUAKE2_PROTOCOL_VERSION = 34
```

Defines the quake2 protocol version constant used by the main module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L22)

<a id="constant-constant-quake2-reference-version-const-quake2-reference-version-3-19-src-main-ml-861259743"></a>
### QUAKE2_REFERENCE_VERSION

```ml
const QUAKE2_REFERENCE_VERSION = "3.19"
```

Defines the quake2 reference version constant used by the main module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L20)

<a id="function-function-runassetsmoke-function-runassetsmoke-args-src-main-ml-47100056"></a>
### runAssetSmoke

```ml
function runAssetSmoke(args)
```

Run asset smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L143)

<a id="function-function-runcampaignsessionsmoke-function-runcampaignsessionsmoke-args-src-main-ml-1656639156"></a>
### runCampaignSessionSmoke

```ml
function runCampaignSessionSmoke(args)
```

Run campaign session smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L168)

<a id="function-function-runchangelevelsmoke-function-runchangelevelsmoke-args-src-main-ml-417977868"></a>
### runChangeLevelSmoke

```ml
function runChangeLevelSmoke(args)
```

Run change level smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L181)

<a id="function-function-runcinematic-function-runcinematic-args-src-main-ml-29155272"></a>
### runCinematic

```ml
function runCinematic(args)
```

Run cinematic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L334)

<a id="function-function-runclismoke-function-runclismoke-args-src-main-ml-1848400424"></a>
### runCliSmoke

```ml
function runCliSmoke(args)
```

Exercise argv transport with an optional caller-provided token.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L489)

<a id="function-function-rundataroot-function-rundataroot-args-src-main-ml-692229234"></a>
### runDataRoot

```ml
function runDataRoot(args)
```

Run data root.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L75)

<a id="function-function-rundedicated-function-rundedicated-args-src-main-ml-1521921024"></a>
### runDedicated

```ml
function runDedicated(args)
```

Runs dedicated for the main workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L448)

<a id="function-function-rundefaultproduct-function-rundefaultproduct-root-src-main-ml-909373401"></a>
### runDefaultProduct

```ml
function runDefaultProduct(root)
```

Run default product.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `root` | `dynamic` | — | root value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L59)

<a id="function-function-rundemo-function-rundemo-args-src-main-ml-617982476"></a>
### runDemo

```ml
function runDemo(args)
```

Run demo.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L365)

<a id="function-function-runheadlessclient-function-runheadlessclient-args-src-main-ml-1894341746"></a>
### runHeadlessClient

```ml
function runHeadlessClient(args)
```

Run headless client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L462)

<a id="function-function-runlisten-function-runlisten-args-src-main-ml-1072631792"></a>
### runListen

```ml
function runListen(args)
```

Run listen.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L477)

<a id="function-function-runmappreview-function-runmappreview-args-src-main-ml-1197447178"></a>
### runMapPreview

```ml
function runMapPreview(args)
```

Run map preview.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L157)

<a id="function-function-runmediaaudit-function-runmediaaudit-args-src-main-ml-816341320"></a>
### runMediaAudit

```ml
function runMediaAudit(args)
```

Run media audit.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L388)

<a id="function-function-runmediasequence-function-runmediasequence-args-src-main-ml-1379922384"></a>
### runMediaSequence

```ml
function runMediaSequence(args)
```

Run media sequence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L350)

<a id="function-function-runplay-function-runplay-args-src-main-ml-1750412530"></a>
### runPlay

```ml
function runPlay(args)
```

Run play.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L225)

<a id="function-function-runplayinputsmoke-function-runplayinputsmoke-args-src-main-ml-192861912"></a>
### runPlayInputSmoke

```ml
function runPlayInputSmoke(args)
```

Run play input smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L205)

<a id="function-function-runproductsmoke-function-runproductsmoke-args-src-main-ml-554963670"></a>
### runProductSmoke

```ml
function runProductSmoke(args)
```

Run product smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L83)

<a id="function-function-runprojectilevisualsmoke-function-runprojectilevisualsmoke-args-src-main-ml-653207516"></a>
### runProjectileVisualSmoke

```ml
function runProjectileVisualSmoke(args)
```

Run projectile visual smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L278)

<a id="function-function-runremoteproductsmoke-function-runremoteproductsmoke-args-src-main-ml-1368392646"></a>
### runRemoteProductSmoke

```ml
function runRemoteProductSmoke(args)
```

Run remote product smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L98)

<a id="function-function-runvideorestartsmokecommand-function-runvideorestartsmokecommand-args-src-main-ml-526906454"></a>
### runVideoRestartSmokeCommand

```ml
function runVideoRestartSmokeCommand(args)
```

Run video restart smoke command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L415)

<a id="function-function-runweaponwheelsmoke-function-runweaponwheelsmoke-args-src-main-ml-1591118250"></a>
### runWeaponWheelSmoke

```ml
function runWeaponWheelSmoke(args)
```

Run weapon wheel smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Command-line or caller-supplied arguments. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/main.ml#L307)
