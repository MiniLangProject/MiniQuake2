# `src/miniquake2/client/ui/menu.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client ui menu facilities for this project.

Package: [`miniquake2.client.ui.menu`](Package-miniquake2-client-ui-menu-681508289.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/ui/constants.ml` as `cuic` → [src/miniquake2/client/ui/constants.ml](File-src-miniquake2-client-ui-constants-ml-1004124106.md)
- `miniquake2/client/ui/types.ml` as `cuitypes` → [src/miniquake2/client/ui/types.ml](File-src-miniquake2-client-ui-types-ml-24306002.md)
- `miniquake2/qcommon/byteio.ml` as `cuimenubyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/types.ml` as `cuimenuqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/renderer/constants.ml` as `cuimenurc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)
- `miniquake2/renderer/types.ml` as `cuimenurtypes` → [src/miniquake2/renderer/types.ml](File-src-miniquake2-renderer-types-ml-975707623.md)

## Declarations

<a id="function-function-miniquake2-client-ui-menu-action-function-action-id-label-command-src-miniquake2-client-ui-menu-ml-2028628409"></a>
### action

```ml
function action(id, label, command)
```

Performs the action operation for the miniquake2 client ui menu module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Stable identifier of the affected item. |
| `label` | `dynamic` | — | label value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L29)

<a id="function-function-miniquake2-client-ui-menu-activate-function-activate-menu-src-miniquake2-client-ui-menu-ml-656960148"></a>
### activate

```ml
function activate(menu)
```

Performs the activate operation for the miniquake2 client ui menu module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L452)

<a id="function-function-miniquake2-client-ui-menu-adjust-function-adjust-menu-direction-src-miniquake2-client-ui-menu-ml-790647033"></a>
### adjust

```ml
function adjust(menu, direction)
```

Adjust state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L430)

<a id="function-function-miniquake2-client-ui-menu-bannername-function-bannername-pageid-src-miniquake2-client-ui-menu-ml-119158913"></a>
### bannerName

```ml
function bannerName(pageId)
```

Return the banner name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pageId` | `dynamic` | — | Identifier of page. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L609)

<a id="function-function-miniquake2-client-ui-menu-choice-function-choice-id-label-value-choices-command-src-miniquake2-client-ui-menu-ml-577111412"></a>
### choice

```ml
function choice(id, label, value, choices, command)
```

Return the choice value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Stable identifier of the affected item. |
| `label` | `dynamic` | — | label value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `choices` | `dynamic` | — | choices value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L60)

<a id="function-function-miniquake2-client-ui-menu-create-function-create-src-miniquake2-client-ui-menu-ml-1166729711"></a>
### create

```ml
function create()
```

Creates create for the miniquake2 client ui menu module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L238)

<a id="function-function-miniquake2-client-ui-menu-defaultpages-function-defaultpages-src-miniquake2-client-ui-menu-ml-940284435"></a>
### defaultPages

```ml
function defaultPages()
```

Return the default pages value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L84)

<a id="function-function-miniquake2-client-ui-menu-draincommands-function-draincommands-menu-src-miniquake2-client-ui-menu-ml-1300241444"></a>
### drainCommands

```ml
function drainCommands(menu)
```

Performs the drainCommands operation for the miniquake2 client ui menu module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L717)

<a id="function-function-miniquake2-client-ui-menu-draw-function-draw-menu-screenwidth-screenheight-now-exports-src-miniquake2-client-ui-menu-ml-1409231300"></a>
### draw

```ml
function draw(menu, screenWidth, screenHeight, now, exports)
```

Draws draw through the miniquake2 client ui menu rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L674)

<a id="function-function-miniquake2-client-ui-menu-drawalttext-function-drawalttext-exports-x-y-text-src-miniquake2-client-ui-menu-ml-1664818670"></a>
### drawAltText

```ml
function drawAltText(exports, x, y, text)
```

Draw alt text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exports` | `dynamic` | — | exports value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L599)

<a id="function-function-miniquake2-client-ui-menu-drawmain-function-drawmain-menu-screenwidth-screenheight-now-exports-src-miniquake2-client-ui-menu-ml-457713520"></a>
### drawMain

```ml
function drawMain(menu, screenWidth, screenHeight, now, exports)
```

Draw main.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L640)

<a id="function-function-miniquake2-client-ui-menu-drawplayerpreview-function-drawplayerpreview-menu-screenwidth-screenheight-now-exports-src-miniquake2-client-ui-menu-ml-234821886"></a>
### drawPlayerPreview

```ml
function drawPlayerPreview(menu, screenWidth, screenHeight, now, exports)
```

PlayerConfig_MenuDraw renders the selected player as a full-bright alias model in a world-less 144x168 view. Register calls are intentionally made here: the renderer deduplicates current-generation resources, while a map registration invalidates old handles and the next menu frame reacquires them.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L553)

<a id="function-function-miniquake2-client-ui-menu-drawtext-function-drawtext-exports-x-y-text-src-miniquake2-client-ui-menu-ml-633445594"></a>
### drawText

```ml
function drawText(exports, x, y, text)
```

Draws text through the miniquake2 client ui menu rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exports` | `dynamic` | — | exports value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L586)

<a id="function-function-miniquake2-client-ui-menu-field-function-field-id-label-value-maximumlength-command-src-miniquake2-client-ui-menu-ml-293919626"></a>
### field

```ml
function field(id, label, value, maximumLength, command)
```

Return the field value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Stable identifier of the affected item. |
| `label` | `dynamic` | — | label value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `maximumLength` | `dynamic` | — | maximumLength value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L70)

<a id="function-function-miniquake2-client-ui-menu-handlekey-function-handlekey-menu-key-src-miniquake2-client-ui-menu-ml-1908889469"></a>
### handleKey

```ml
function handleKey(menu, key)
```

Handle key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L472)

<a id="function-function-miniquake2-client-ui-menu-itembyid-function-itembyid-menu-pageid-itemid-src-miniquake2-client-ui-menu-ml-1956635592"></a>
### itemById

```ml
function itemById(menu, pageId, itemId)
```

Return the item by id value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `pageId` | `dynamic` | — | Identifier of page. |
| `itemId` | `dynamic` | — | Identifier of item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L375)

<a id="function-function-miniquake2-client-ui-menu-itemvalue-function-itemvalue-item-src-miniquake2-client-ui-menu-ml-405470216"></a>
### itemValue

```ml
function itemValue(item)
```

Return the item value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L509)

<a id="function-function-miniquake2-client-ui-menu-label-function-label-id-text-src-miniquake2-client-ui-menu-ml-1240372361"></a>
### label

```ml
function label(id, text)
```

Return the label value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Stable identifier of the affected item. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L79)

<a id="function-function-miniquake2-client-ui-menu-maincursorname-function-maincursorname-now-src-miniquake2-client-ui-menu-ml-1659602913"></a>
### mainCursorName

```ml
function mainCursorName(now)
```

Return the main cursor name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L622)

<a id="constant-constant-miniquake2-client-ui-menu-max-menu-commands-const-max-menu-commands-16-src-miniquake2-client-ui-menu-ml-203651611"></a>
### MAX_MENU_COMMANDS

```ml
const MAX_MENU_COMMANDS = 16
```

Defines the max menu commands constant used by the miniquake2 client ui menu module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L18)

<a id="function-function-miniquake2-client-ui-menu-menucursorglyph-function-menucursorglyph-now-src-miniquake2-client-ui-menu-ml-267730459"></a>
### menuCursorGlyph

```ml
function menuCursorGlyph(now)
```

Return the menu cursor glyph value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L629)

<a id="global-global-miniquake2-client-ui-menu-menuemptycommands-menuemptycommands-src-miniquake2-client-ui-menu-ml-389256917"></a>
### menuEmptyCommands

```ml
menuEmptyCommands
```

Stores module-wide menu empty commands state for the miniquake2 client ui menu module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L23)

<a id="global-global-miniquake2-client-ui-menu-menuplayerpreviewlightstyles-menuplayerpreviewlightstyles-src-miniquake2-client-ui-menu-ml-1651034505"></a>
### menuPlayerPreviewLightStyles

```ml
menuPlayerPreviewLightStyles
```

Stores module-wide menu player preview light styles state for the miniquake2 client ui menu module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L21)

<a id="function-function-miniquake2-client-ui-menu-move-function-move-menu-direction-src-miniquake2-client-ui-menu-ml-86284189"></a>
### move

```ml
function move(menu, direction)
```

Move state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L418)

<a id="function-function-miniquake2-client-ui-menu-open-function-open-menu-id-src-miniquake2-client-ui-menu-ml-2089196257"></a>
### open

```ml
function open(menu, id)
```

Opens open for the miniquake2 client ui menu module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `id` | `dynamic` | — | Stable identifier of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L265)

<a id="function-function-miniquake2-client-ui-menu-page-function-page-menu-src-miniquake2-client-ui-menu-ml-39688332"></a>
### page

```ml
function page(menu)
```

Return the page value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L255)

<a id="function-function-miniquake2-client-ui-menu-playerpreviewmodelpath-function-playerpreviewmodelpath-menu-src-miniquake2-client-ui-menu-ml-1609942608"></a>
### playerPreviewModelPath

```ml
function playerPreviewModelPath(menu)
```

Return the player preview model path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L528)

<a id="function-function-miniquake2-client-ui-menu-playerpreviewpath-function-playerpreviewpath-menu-src-miniquake2-client-ui-menu-ml-1420342396"></a>
### playerPreviewPath

```ml
function playerPreviewPath(menu)
```

Return the player preview path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L518)

<a id="function-function-miniquake2-client-ui-menu-playerpreviewskinpath-function-playerpreviewskinpath-menu-src-miniquake2-client-ui-menu-ml-1662549330"></a>
### playerPreviewSkinPath

```ml
function playerPreviewSkinPath(menu)
```

Return the player preview skin path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L536)

<a id="function-function-miniquake2-client-ui-menu-playerskinchoices-function-playerskinchoices-modelname-src-miniquake2-client-ui-menu-ml-1781545311"></a>
### playerSkinChoices

```ml
function playerSkinChoices(modelName)
```

Return the player skin choices value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L389)

<a id="function-function-miniquake2-client-ui-menu-queuecommand-function-queuecommand-menu-command-src-miniquake2-client-ui-menu-ml-328379321"></a>
### queueCommand

```ml
function queueCommand(menu, command)
```

Queue command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L246)

<a id="function-function-miniquake2-client-ui-menu-setactioncommand-function-setactioncommand-menu-pageid-itemid-text-command-enabled-src-miniquake2-client-ui-menu-ml-1806886685"></a>
### setActionCommand

```ml
function setActionCommand(menu, pageId, itemId, text, command, enabled)
```

Set action command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `pageId` | `dynamic` | — | Identifier of page. |
| `itemId` | `dynamic` | — | Identifier of item. |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |
| `enabled` | `dynamic` | — | enabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L350)

<a id="function-function-miniquake2-client-ui-menu-setitemlabel-function-setitemlabel-menu-pageid-itemid-text-src-miniquake2-client-ui-menu-ml-419343687"></a>
### setItemLabel

```ml
function setItemLabel(menu, pageId, itemId, text)
```

Set item label.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `pageId` | `dynamic` | — | Identifier of page. |
| `itemId` | `dynamic` | — | Identifier of item. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L277)

<a id="function-function-miniquake2-client-ui-menu-setitemtext-function-setitemtext-menu-pageid-itemid-value-src-miniquake2-client-ui-menu-ml-2147406677"></a>
### setItemText

```ml
function setItemText(menu, pageId, itemId, value)
```

Set item text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `pageId` | `dynamic` | — | Identifier of page. |
| `itemId` | `dynamic` | — | Identifier of item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L325)

<a id="function-function-miniquake2-client-ui-menu-setitemvalue-function-setitemvalue-menu-pageid-itemid-value-src-miniquake2-client-ui-menu-ml-645584793"></a>
### setItemValue

```ml
function setItemValue(menu, pageId, itemId, value)
```

Set item value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `pageId` | `dynamic` | — | Identifier of page. |
| `itemId` | `dynamic` | — | Identifier of item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L295)

<a id="function-function-miniquake2-client-ui-menu-slider-function-slider-id-label-value-minimum-maximum-step-command-src-miniquake2-client-ui-menu-ml-28939210"></a>
### slider

```ml
function slider(id, label, value, minimum, maximum, step, command)
```

Return the slider value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Stable identifier of the affected item. |
| `label` | `dynamic` | — | label value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `minimum` | `dynamic` | — | minimum value consumed by this operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |
| `step` | `dynamic` | — | step value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L50)

<a id="function-function-miniquake2-client-ui-menu-synchronizeplayerskins-function-synchronizeplayerskins-menu-src-miniquake2-client-ui-menu-ml-139604328"></a>
### synchronizePlayerSkins

```ml
function synchronizePlayerSkins(menu)
```

Synchronize player skins.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L402)

<a id="function-function-miniquake2-client-ui-menu-toggle-function-toggle-id-label-value-command-src-miniquake2-client-ui-menu-ml-553031542"></a>
### toggle

```ml
function toggle(id, label, value, command)
```

Toggle state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Stable identifier of the affected item. |
| `label` | `dynamic` | — | label value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/menu.ml#L38)
