# `src/miniquake2/game/player/rules.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game player rules facilities for this project.

Package: [`miniquake2.game.player.rules`](Package-miniquake2-game-player-rules-199697617.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/constants.ml` as `gpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/player/constants.ml` as `gplayerconstants` → [src/miniquake2/game/player/constants.ml](File-src-miniquake2-game-player-constants-ml-946982646.md)
- `miniquake2/game/player/types.ml` as `gplayertypes` → [src/miniquake2/game/player/types.ml](File-src-miniquake2-game-player-types-ml-1013655302.md)
- `miniquake2/qcommon/info.ml` as `qinfo` → [src/miniquake2/qcommon/info.ml](File-src-miniquake2-qcommon-info-ml-634538165.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `std/math.ml` as `gplayermath` → `../MiniLangCompilerML/std/math.ml` — external dependency
- `std/string.ml` as `gplayerstring` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-player-rules-checkdmrules-function-checkdmrules-context-src-miniquake2-game-player-rules-ml-165091462"></a>
### CheckDMRules

```ml
function CheckDMRules(context)
```

Validate dm rules.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/rules.ml#L285)

<a id="function-function-miniquake2-game-player-rules-clientobituary-function-clientobituary-context-victim-attacker-meansofdeath-src-miniquake2-game-player-rules-ml-1822574898"></a>
### ClientObituary

```ml
function ClientObituary(context, victim, attacker, meansOfDeath)
```

Return the client obituary value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `victim` | `dynamic` | — | victim value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/rules.ml#L95)

<a id="function-function-miniquake2-game-player-rules-enddmlevel-function-enddmlevel-context-reason-src-miniquake2-game-player-rules-ml-135453658"></a>
### EndDMLevel

```ml
function EndDMLevel(context, reason)
```

End dm level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `reason` | `dynamic` | — | reason value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/rules.ml#L270)

<a id="function-function-miniquake2-game-player-rules-environmentmessage-function-environmentmessage-mod-src-miniquake2-game-player-rules-ml-1098567855"></a>
### environmentMessage

```ml
function environmentMessage(mod)
```

Return the environment message value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mod` | `dynamic` | — | mod value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/rules.ml#L32)

<a id="function-function-miniquake2-game-player-rules-genderpronoun-function-genderpronoun-player-neutralword-femaleword-maleword-src-miniquake2-game-player-rules-ml-1844512872"></a>
### genderPronoun

```ml
function genderPronoun(player, neutralWord, femaleWord, maleWord)
```

Return the gender pronoun value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `neutralWord` | `dynamic` | — | neutralWord value consumed by this operation. |
| `femaleWord` | `dynamic` | — | femaleWord value consumed by this operation. |
| `maleWord` | `dynamic` | — | maleWord value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/rules.ml#L23)

<a id="function-function-miniquake2-game-player-rules-lookatkiller-function-lookatkiller-victim-inflictor-attacker-src-miniquake2-game-player-rules-ml-1463651660"></a>
### LookAtKiller

```ml
function LookAtKiller(victim, inflictor, attacker)
```

Return the look at killer value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `victim` | `dynamic` | — | victim value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/rules.ml#L133)

<a id="function-function-miniquake2-game-player-rules-nextlistedmap-function-nextlistedmap-context-src-miniquake2-game-player-rules-ml-1986514374"></a>
### nextListedMap

```ml
function nextListedMap(context)
```

Map next listed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/rules.ml#L242)

<a id="function-function-miniquake2-game-player-rules-player-die-function-player-die-context-victim-inflictor-attacker-damage-point-meansofdeath-src-miniquake2-game-player-rules-ml-1283748477"></a>
### player_die

```ml
function player_die(context, victim, inflictor, attacker, damage, point, meansOfDeath)
```

Handle player.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `victim` | `dynamic` | — | victim value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/rules.ml#L158)

<a id="function-function-miniquake2-game-player-rules-sameplayer-function-sameplayer-first-second-src-miniquake2-game-player-rules-ml-1586720997"></a>
### samePlayer

```ml
function samePlayer(first, second)
```

Return the same player value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/rules.ml#L85)

<a id="function-function-miniquake2-game-player-rules-selfmessage-function-selfmessage-player-mod-src-miniquake2-game-player-rules-ml-969832036"></a>
### selfMessage

```ml
function selfMessage(player, mod)
```

Return the self message value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `mod` | `dynamic` | — | mod value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/rules.ml#L50)

<a id="function-function-miniquake2-game-player-rules-weaponmessage-function-weaponmessage-mod-src-miniquake2-game-player-rules-ml-1411831221"></a>
### weaponMessage

```ml
function weaponMessage(mod)
```

Return the weapon message value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mod` | `dynamic` | — | mod value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/rules.ml#L60)
