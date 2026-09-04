# `src/miniquake2/client/effects/parser.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client effects parser facilities for this project.

Package: [`miniquake2.client.effects.parser`](Package-miniquake2-client-effects-parser-1926728249.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/effects/audio.ml` as `ceaudio` → [src/miniquake2/client/effects/audio.ml](File-src-miniquake2-client-effects-audio-ml-242663153.md)
- `miniquake2/client/effects/constants.ml` as `ceconstants` → [src/miniquake2/client/effects/constants.ml](File-src-miniquake2-client-effects-constants-ml-55259948.md)
- `miniquake2/client/effects/state.ml` as `cestate` → [src/miniquake2/client/effects/state.ml](File-src-miniquake2-client-effects-state-ml-140719308.md)
- `miniquake2/client/effects/types.ml` as `cetypes` → [src/miniquake2/client/effects/types.ml](File-src-miniquake2-client-effects-types-ml-621918960.md)
- `miniquake2/physics/vector.ml` as `pvector` → [src/miniquake2/physics/vector.ml](File-src-miniquake2-physics-vector-ml-1287862571.md)
- `miniquake2/protocol/checked.ml` as `pchecked` → [src/miniquake2/protocol/checked.ml](File-src-miniquake2-protocol-checked-ml-1828862158.md)
- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/directions.ml` as `qdirections` → [src/miniquake2/qcommon/directions.ml](File-src-miniquake2-qcommon-directions-ml-1980852047.md)
- `miniquake2/qcommon/monster_flash_offsets.ml` as `ceflash` → [src/miniquake2/qcommon/monster_flash_offsets.ml](File-src-miniquake2-qcommon-monster-flash-offsets-ml-1256832337.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/renderer/constants.ml` as `rc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)
- `std/math.ml` as `cemath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-client-effects-parser-blasterexplosion-function-blasterexplosion-state-type-position-direction-src-miniquake2-client-effects-parser-ml-2051643358"></a>
### blasterExplosion

```ml
function blasterExplosion(state, type, position, direction)
```

Return the blaster explosion value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `type` | `dynamic` | — | type value consumed by this operation. |
| `position` | `dynamic` | — | position value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L423)

<a id="function-function-miniquake2-client-effects-parser-emitplayermuzzlesounds-function-emitplayermuzzlesounds-state-entitynumber-weapon-volume-src-miniquake2-client-effects-parser-ml-1920911970"></a>
### emitPlayerMuzzleSounds

```ml
function emitPlayerMuzzleSounds(state, entityNumber, weapon, volume)
```

Emit player muzzle sounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `entityNumber` | `dynamic` | — | entityNumber value consumed by this operation. |
| `weapon` | `dynamic` | — | weapon value consumed by this operation. |
| `volume` | `dynamic` | — | volume value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L172)

<a id="function-function-miniquake2-client-effects-parser-entityangles-function-entityangles-entitystate-src-miniquake2-client-effects-parser-ml-588763833"></a>
### entityAngles

```ml
function entityAngles(entityState)
```

Return the entity angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entityState` | `dynamic` | — | entityState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L107)

<a id="function-function-miniquake2-client-effects-parser-entityorigin-function-entityorigin-entitystate-src-miniquake2-client-effects-parser-ml-560455661"></a>
### entityOrigin

```ml
function entityOrigin(entityState)
```

Return the entity origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entityState` | `dynamic` | — | entityState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L100)

<a id="function-function-miniquake2-client-effects-parser-handleentityevent-function-handleentityevent-state-entitystate-src-miniquake2-client-effects-parser-ml-1162904420"></a>
### handleEntityEvent

```ml
function handleEntityEvent(state, entityState)
```

Handle entity event.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `entityState` | `dynamic` | — | entityState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L755)

<a id="function-function-miniquake2-client-effects-parser-impactangles-function-impactangles-direction-src-miniquake2-client-effects-parser-ml-2027315750"></a>
### impactAngles

```ml
function impactAngles(direction)
```

Return the impact angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L404)

<a id="function-function-miniquake2-client-effects-parser-indexedsound-function-indexedsound-state-position-entity-channel-index-volume-attenuation-offset-src-miniquake2-client-effects-parser-ml-555261748"></a>
### indexedSound

```ml
function indexedSound(state, position, entity, channel, index, volume, attenuation, offset)
```

Return the indexed sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `position` | `dynamic` | — | position value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `volume` | `dynamic` | — | volume value consumed by this operation. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L66)

<a id="function-function-miniquake2-client-effects-parser-machinegunsound-function-machinegunsound-state-src-miniquake2-client-effects-parser-ml-202847010"></a>
### machineGunSound

```ml
function machineGunSound(state)
```

Return the machine gun sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L158)

<a id="function-function-miniquake2-client-effects-parser-monstergreenblaster-inline-function-monstergreenblaster-flash-src-miniquake2-client-effects-parser-ml-262476576"></a>
### monsterGreenBlaster

```ml
inline function monsterGreenBlaster(flash)
```

Return the monster green blaster value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flash` | `dynamic` | — | flash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L288)

<a id="function-function-miniquake2-client-effects-parser-monstermachinegun-inline-function-monstermachinegun-flash-src-miniquake2-client-effects-parser-ml-2146802132"></a>
### monsterMachineGun

```ml
inline function monsterMachineGun(flash)
```

Return the monster machine gun value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flash` | `dynamic` | — | flash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L264)

<a id="function-function-miniquake2-client-effects-parser-monstermuzzlecolor-function-monstermuzzlecolor-flash-src-miniquake2-client-effects-parser-ml-453507763"></a>
### monsterMuzzleColor

```ml
function monsterMuzzleColor(flash)
```

Return the monster muzzle color value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flash` | `dynamic` | — | flash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L300)

<a id="function-function-miniquake2-client-effects-parser-monstermuzzlesound-function-monstermuzzlesound-state-flash-src-miniquake2-client-effects-parser-ml-1179898428"></a>
### monsterMuzzleSound

```ml
function monsterMuzzleSound(state, flash)
```

Return the monster muzzle sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `flash` | `dynamic` | — | flash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L328)

<a id="function-function-miniquake2-client-effects-parser-monsterplasmabeam-inline-function-monsterplasmabeam-flash-src-miniquake2-client-effects-parser-ml-1898586972"></a>
### monsterPlasmaBeam

```ml
inline function monsterPlasmaBeam(flash)
```

Return the monster plasma beam value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flash` | `dynamic` | — | flash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L294)

<a id="function-function-miniquake2-client-effects-parser-monsterrail-inline-function-monsterrail-flash-src-miniquake2-client-effects-parser-ml-2067927572"></a>
### monsterRail

```ml
inline function monsterRail(flash)
```

Return the monster rail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flash` | `dynamic` | — | flash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L282)

<a id="function-function-miniquake2-client-effects-parser-monsterrocket-inline-function-monsterrocket-flash-src-miniquake2-client-effects-parser-ml-1528459772"></a>
### monsterRocket

```ml
inline function monsterRocket(flash)
```

Return the monster rocket value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flash` | `dynamic` | — | flash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L274)

<a id="function-function-miniquake2-client-effects-parser-namedsound-function-namedsound-state-position-entity-channel-name-volume-attenuation-offset-src-miniquake2-client-effects-parser-ml-1752270665"></a>
### namedSound

```ml
function namedSound(state, position, entity, channel, name, volume, attenuation, offset)
```

Return the named sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `position` | `dynamic` | — | position value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `volume` | `dynamic` | — | volume value consumed by this operation. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L51)

<a id="function-function-miniquake2-client-effects-parser-parsebeam-function-parsebeam-state-buffer-modelname-withoffset-playerlinked-src-miniquake2-client-effects-parser-ml-1404540555"></a>
### parseBeam

```ml
function parseBeam(state, buffer, modelName, withOffset, playerLinked)
```

Parse normal beam.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |
| `withOffset` | `dynamic` | — | withOffset value consumed by this operation. |
| `playerLinked` | `dynamic` | — | playerLinked value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L468)

<a id="function-function-miniquake2-client-effects-parser-parselightning-function-parselightning-state-buffer-src-miniquake2-client-effects-parser-ml-74181848"></a>
### parseLightning

```ml
function parseLightning(state, buffer)
```

Parse lightning.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L501)

<a id="function-function-miniquake2-client-effects-parser-parsemuzzleflash-function-parsemuzzleflash-state-buffer-entityresolver-src-miniquake2-client-effects-parser-ml-952066043"></a>
### parseMuzzleFlash

```ml
function parseMuzzleFlash(state, buffer, entityResolver)
```

Parse muzzle flash.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `entityResolver` | `dynamic` | — | entityResolver value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L205)

<a id="function-function-miniquake2-client-effects-parser-parsemuzzleflash2-function-parsemuzzleflash2-state-buffer-entityresolver-src-miniquake2-client-effects-parser-ml-443140683"></a>
### parseMuzzleFlash2

```ml
function parseMuzzleFlash2(state, buffer, entityResolver)
```

Parse muzzle flash 2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `entityResolver` | `dynamic` | — | entityResolver value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L357)

<a id="function-function-miniquake2-client-effects-parser-parseplayerbeam-function-parseplayerbeam-state-buffer-modelname-localentitynumber-src-miniquake2-client-effects-parser-ml-1994211967"></a>
### parsePlayerBeam

```ml
function parsePlayerBeam(state, buffer, modelName, localEntityNumber)
```

Parse Rogue heat/player beam. The dedicated player-beam pool is selected for every source entity, while only the local entity is anchored to the camera.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L485)

<a id="function-function-miniquake2-client-effects-parser-parseservicecommand-function-parseservicecommand-state-buffer-opcode-entityresolver-localentitynumber-src-miniquake2-client-effects-parser-ml-940022970"></a>
### parseServiceCommand

```ml
function parseServiceCommand(state, buffer, opcode, entityResolver, localEntityNumber)
```

Parse service command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `opcode` | `dynamic` | — | opcode value consumed by this operation. |
| `entityResolver` | `dynamic` | — | entityResolver value consumed by this operation. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L787)

<a id="function-function-miniquake2-client-effects-parser-parsesound-function-parsesound-state-buffer-src-miniquake2-client-effects-parser-ml-1006095992"></a>
### parseSound

```ml
function parseSound(state, buffer)
```

Parse sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L75)

<a id="function-function-miniquake2-client-effects-parser-parsesteam-function-parsesteam-state-buffer-src-miniquake2-client-effects-parser-ml-1917960764"></a>
### parseSteam

```ml
function parseSteam(state, buffer)
```

Parse steam.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L526)

<a id="function-function-miniquake2-client-effects-parser-parsetempentity-function-parsetempentity-state-buffer-src-miniquake2-client-effects-parser-ml-301804556"></a>
### parseTempEntity

```ml
function parseTempEntity(state, buffer)
```

Compatibility entry point for parser unit tests without a connected client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L748)

<a id="function-function-miniquake2-client-effects-parser-parsetempentityforplayer-function-parsetempentityforplayer-state-buffer-localentitynumber-src-miniquake2-client-effects-parser-ml-1673371175"></a>
### parseTempEntityForPlayer

```ml
function parseTempEntityForPlayer(state, buffer, localEntityNumber)
```

Decode one svc_temp_entity payload and immediately publish its bounded client-side representation. Each branch consumes exactly the bytes defined by the original CL_ParseTEnt switch so the next server command stays aligned.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L547)

<a id="function-function-miniquake2-client-effects-parser-playermuzzlecolor-function-playermuzzlecolor-weapon-src-miniquake2-client-effects-parser-ml-1220112245"></a>
### playerMuzzleColor

```ml
function playerMuzzleColor(weapon)
```

Return the player muzzle color value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `weapon` | `dynamic` | — | weapon value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L133)

<a id="function-function-miniquake2-client-effects-parser-playermuzzlesound-function-playermuzzlesound-weapon-src-miniquake2-client-effects-parser-ml-1909364181"></a>
### playerMuzzleSound

```ml
function playerMuzzleSound(weapon)
```

Return the player muzzle sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `weapon` | `dynamic` | — | weapon value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L114)

<a id="function-function-miniquake2-client-effects-parser-polyexplosion-function-polyexplosion-state-type-position-src-miniquake2-client-effects-parser-ml-1377447981"></a>
### polyExplosion

```ml
function polyExplosion(state, type, position)
```

Return the poly explosion value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `type` | `dynamic` | — | type value consumed by this operation. |
| `position` | `dynamic` | — | position value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L438)

<a id="function-function-miniquake2-client-effects-parser-readdirection-function-readdirection-buffer-operation-src-miniquake2-client-effects-parser-ml-1421854398"></a>
### readDirection

```ml
function readDirection(buffer, operation)
```

Read direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L38)

<a id="function-function-miniquake2-client-effects-parser-readposition-function-readposition-buffer-operation-src-miniquake2-client-effects-parser-ml-618319288"></a>
### readPosition

```ml
function readPosition(buffer, operation)
```

Read position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L30)

<a id="function-function-miniquake2-client-effects-parser-smokeandflash-function-smokeandflash-state-position-src-miniquake2-client-effects-parser-ml-1787218271"></a>
### smokeAndFlash

```ml
function smokeAndFlash(state, position)
```

Return the smoke and flash value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `position` | `dynamic` | — | position value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L389)

<a id="function-function-miniquake2-client-effects-parser-soldierblaster-inline-function-soldierblaster-flash-src-miniquake2-client-effects-parser-ml-1828117544"></a>
### soldierBlaster

```ml
inline function soldierBlaster(flash)
```

Return the soldier blaster value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flash` | `dynamic` | — | flash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L258)

<a id="function-function-miniquake2-client-effects-parser-soldiermachinegun-inline-function-soldiermachinegun-flash-src-miniquake2-client-effects-parser-ml-1202255384"></a>
### soldierMachineGun

```ml
inline function soldierMachineGun(flash)
```

Return the soldier machine gun value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flash` | `dynamic` | — | flash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L246)

<a id="function-function-miniquake2-client-effects-parser-soldiershotgun-inline-function-soldiershotgun-flash-src-miniquake2-client-effects-parser-ml-605954346"></a>
### soldierShotgun

```ml
inline function soldierShotgun(flash)
```

Return the soldier shotgun value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flash` | `dynamic` | — | flash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L252)

<a id="constant-constant-miniquake2-client-effects-parser-sound-flag-mask-const-sound-flag-mask-31-src-miniquake2-client-effects-parser-ml-688900064"></a>
### SOUND_FLAG_MASK

```ml
const SOUND_FLAG_MASK = 31
```

Defines the sound flag mask constant used by the miniquake2 client effects parser module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L25)

<a id="function-function-miniquake2-client-effects-parser-splashcolor-inline-function-splashcolor-splash-src-miniquake2-client-effects-parser-ml-1800393459"></a>
### splashColor

```ml
inline function splashColor(splash)
```

Return the splash color value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `splash` | `dynamic` | — | splash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L513)

<a id="function-function-miniquake2-client-effects-parser-tankmachinegunsound-function-tankmachinegunsound-state-src-miniquake2-client-effects-parser-ml-973615218"></a>
### tankMachineGunSound

```ml
function tankMachineGunSound(state)
```

Return the tank machine gun sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/parser.ml#L316)
