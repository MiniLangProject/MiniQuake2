# `miniquake2.game.player.transition.PlayerLevelHandover`

[Home](README.md) · [Source file](File-src-miniquake2-game-player-transition-ml-1211895412.md)

<a id="struct-struct-miniquake2-game-player-transition-playerlevelhandover-struct-playerlevelhandover-src-miniquake2-game-player-transition-ml-745992788"></a>
## PlayerLevelHandover

```ml
struct PlayerLevelHandover
```

The original game keeps this data in game.clients and game.serverflags while TAG_LEVEL allocations are replaced.  The product host replaces the complete Game API graph instead, so an owned value snapshot must cross that boundary.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L20)

## Members

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-currentweaponindex-currentweaponindex-src-miniquake2-game-player-transition-ml-358264020"></a>
### currentWeaponIndex

```ml
currentWeaponIndex
```

Stores the current weapon index value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L42)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-gamehelpchanged-gamehelpchanged-src-miniquake2-game-player-transition-ml-625904910"></a>
### gameHelpChanged

```ml
gameHelpChanged
```

Stores the game help changed value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L54)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-health-health-src-miniquake2-game-player-transition-ml-1657836530"></a>
### health

```ml
health
```

Stores the health value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L22)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-helpchanged-helpchanged-src-miniquake2-game-player-transition-ml-463769934"></a>
### helpChanged

```ml
helpChanged
```

Stores the help changed value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L64)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-helpmessage1-helpmessage1-src-miniquake2-game-player-transition-ml-146723716"></a>
### helpMessage1

```ml
helpMessage1
```

Stores the help message1 value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L60)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-helpmessage2-helpmessage2-src-miniquake2-game-player-transition-ml-257596054"></a>
### helpMessage2

```ml
helpMessage2
```

Stores the help message2 value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L62)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-inventorycounts-inventorycounts-src-miniquake2-game-player-transition-ml-1715269514"></a>
### inventoryCounts

```ml
inventoryCounts
```

Stores the inventory counts value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L26)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-lastweaponindex-lastweaponindex-src-miniquake2-game-player-transition-ml-1530485546"></a>
### lastWeaponIndex

```ml
lastWeaponIndex
```

Stores the last weapon index value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L44)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-maxbullets-maxbullets-src-miniquake2-game-player-transition-ml-455157132"></a>
### maxBullets

```ml
maxBullets
```

Stores the max bullets value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L28)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-maxcells-maxcells-src-miniquake2-game-player-transition-ml-390214204"></a>
### maxCells

```ml
maxCells
```

Stores the max cells value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L36)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-maxgrenades-maxgrenades-src-miniquake2-game-player-transition-ml-607599722"></a>
### maxGrenades

```ml
maxGrenades
```

Stores the max grenades value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L34)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-maxhealth-maxhealth-src-miniquake2-game-player-transition-ml-548843446"></a>
### maxHealth

```ml
maxHealth
```

Stores the max health value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L24)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-maxrockets-maxrockets-src-miniquake2-game-player-transition-ml-1815606964"></a>
### maxRockets

```ml
maxRockets
```

Stores the max rockets value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L32)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-maxshells-maxshells-src-miniquake2-game-player-transition-ml-1394045634"></a>
### maxShells

```ml
maxShells
```

Stores the max shells value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L30)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-maxslugs-maxslugs-src-miniquake2-game-player-transition-ml-854531854"></a>
### maxSlugs

```ml
maxSlugs
```

Stores the max slugs value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L38)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-persistentscore-persistentscore-src-miniquake2-game-player-transition-ml-1427495766"></a>
### persistentScore

```ml
persistentScore
```

Stores the persistent score value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L50)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-playerhelpchanged-playerhelpchanged-src-miniquake2-game-player-transition-ml-306214982"></a>
### playerHelpChanged

```ml
playerHelpChanged
```

Stores the player help changed value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L56)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-powercubes-powercubes-src-miniquake2-game-player-transition-ml-116140900"></a>
### powerCubes

```ml
powerCubes
```

Stores the power cubes value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L48)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-respawnscore-respawnscore-src-miniquake2-game-player-transition-ml-268047954"></a>
### respawnScore

```ml
respawnScore
```

Stores the respawn score value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L52)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-savedflags-savedflags-src-miniquake2-game-player-transition-ml-87965430"></a>
### savedFlags

```ml
savedFlags
```

Stores the saved flags value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L46)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-selecteditem-selecteditem-src-miniquake2-game-player-transition-ml-438215090"></a>
### selectedItem

```ml
selectedItem
```

Stores the selected item value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L40)

<a id="field-field-miniquake2-game-player-transition-playerlevelhandover-serverflags-serverflags-src-miniquake2-game-player-transition-ml-1983188086"></a>
### serverFlags

```ml
serverFlags
```

Stores the server flags value associated with player level handover.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L58)
