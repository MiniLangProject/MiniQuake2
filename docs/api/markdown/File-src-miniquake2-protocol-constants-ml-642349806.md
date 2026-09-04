# `src/miniquake2/protocol/constants.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 protocol constants facilities for this project.

Package: [`miniquake2.protocol.constants`](Package-miniquake2-protocol-constants-612626192.md)

Reachable from entry: **yes**

## Declarations

<a id="constant-constant-miniquake2-protocol-constants-cm-angle1-const-cm-angle1-1-0-src-miniquake2-protocol-constants-ml-415709758"></a>
### CM_ANGLE1

```ml
const CM_ANGLE1 = 1 << 0
```

usercmd_t delta flags


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L48)

<a id="constant-constant-miniquake2-protocol-constants-cm-angle2-const-cm-angle2-1-1-src-miniquake2-protocol-constants-ml-858659615"></a>
### CM_ANGLE2

```ml
const CM_ANGLE2 = 1 << 1
```

Defines the cm angle2 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L50)

<a id="constant-constant-miniquake2-protocol-constants-cm-angle3-const-cm-angle3-1-2-src-miniquake2-protocol-constants-ml-1189811676"></a>
### CM_ANGLE3

```ml
const CM_ANGLE3 = 1 << 2
```

Defines the cm angle3 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L52)

<a id="constant-constant-miniquake2-protocol-constants-cm-buttons-const-cm-buttons-1-6-src-miniquake2-protocol-constants-ml-1325285134"></a>
### CM_BUTTONS

```ml
const CM_BUTTONS = 1 << 6
```

Defines the cm buttons constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L60)

<a id="constant-constant-miniquake2-protocol-constants-cm-forward-const-cm-forward-1-3-src-miniquake2-protocol-constants-ml-1572368483"></a>
### CM_FORWARD

```ml
const CM_FORWARD = 1 << 3
```

Defines the cm forward constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L54)

<a id="constant-constant-miniquake2-protocol-constants-cm-impulse-const-cm-impulse-1-7-src-miniquake2-protocol-constants-ml-473141195"></a>
### CM_IMPULSE

```ml
const CM_IMPULSE = 1 << 7
```

Defines the cm impulse constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L62)

<a id="constant-constant-miniquake2-protocol-constants-cm-side-const-cm-side-1-4-src-miniquake2-protocol-constants-ml-1788767586"></a>
### CM_SIDE

```ml
const CM_SIDE = 1 << 4
```

Defines the cm side constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L56)

<a id="constant-constant-miniquake2-protocol-constants-cm-up-const-cm-up-1-5-src-miniquake2-protocol-constants-ml-1266315751"></a>
### CM_UP

```ml
const CM_UP = 1 << 5
```

Defines the cm up constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L58)

<a id="constant-constant-miniquake2-protocol-constants-connectionless-sequence-const-connectionless-sequence-4294967295-src-miniquake2-protocol-constants-ml-1812928500"></a>
### CONNECTIONLESS_SEQUENCE

```ml
const CONNECTIONLESS_SEQUENCE = 4294967295
```

Defines the connectionless sequence constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L32)

<a id="constant-constant-miniquake2-protocol-constants-max-edicts-const-max-edicts-1024-src-miniquake2-protocol-constants-ml-1307427248"></a>
### MAX_EDICTS

```ml
const MAX_EDICTS = 1024
```

Defines the max edicts constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L38)

<a id="constant-constant-miniquake2-protocol-constants-max-msglen-const-max-msglen-1400-src-miniquake2-protocol-constants-ml-111838366"></a>
### MAX_MSGLEN

```ml
const MAX_MSGLEN = 1400
```

Defines the max msglen constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L16)

<a id="constant-constant-miniquake2-protocol-constants-max-reliable-queue-bytes-const-max-reliable-queue-bytes-reliable-buffer-size-max-reliable-queue-fragments-src-miniquake2-protocol-constants-ml-1080776309"></a>
### MAX_RELIABLE_QUEUE_BYTES

```ml
const MAX_RELIABLE_QUEUE_BYTES = RELIABLE_BUFFER_SIZE * MAX_RELIABLE_QUEUE_FRAGMENTS
```

Defines the max reliable queue bytes constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L26)

<a id="constant-constant-miniquake2-protocol-constants-max-reliable-queue-fragments-const-max-reliable-queue-fragments-64-src-miniquake2-protocol-constants-ml-1269859455"></a>
### MAX_RELIABLE_QUEUE_FRAGMENTS

```ml
const MAX_RELIABLE_QUEUE_FRAGMENTS = 64
```

Protocol 34 has no wire-level fragment header.  Larger reliable tails are


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L24)

<a id="constant-constant-miniquake2-protocol-constants-max-stats-const-max-stats-32-src-miniquake2-protocol-constants-ml-265550510"></a>
### MAX_STATS

```ml
const MAX_STATS = 32
```

Defines the max stats constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L40)

<a id="constant-constant-miniquake2-protocol-constants-ns-client-const-ns-client-0-src-miniquake2-protocol-constants-ml-1232813153"></a>
### NS_CLIENT

```ml
const NS_CLIENT = 0
```

Defines the ns client constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L34)

<a id="constant-constant-miniquake2-protocol-constants-ns-server-const-ns-server-1-src-miniquake2-protocol-constants-ml-1265818848"></a>
### NS_SERVER

```ml
const NS_SERVER = 1
```

Defines the ns server constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L36)

<a id="constant-constant-miniquake2-protocol-constants-packet-header-client-const-packet-header-client-10-src-miniquake2-protocol-constants-ml-1596922432"></a>
### PACKET_HEADER_CLIENT

```ml
const PACKET_HEADER_CLIENT = 10
```

Defines the packet header client constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L18)

<a id="constant-constant-miniquake2-protocol-constants-packet-header-server-const-packet-header-server-8-src-miniquake2-protocol-constants-ml-1356713819"></a>
### PACKET_HEADER_SERVER

```ml
const PACKET_HEADER_SERVER = 8
```

Defines the packet header server constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L20)

<a id="constant-constant-miniquake2-protocol-constants-protocol-version-const-protocol-version-34-src-miniquake2-protocol-constants-ml-788387384"></a>
### PROTOCOL_VERSION

```ml
const PROTOCOL_VERSION = 34
```

Defines the protocol version constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L14)

<a id="constant-constant-miniquake2-protocol-constants-ps-all-const-ps-all-32767-src-miniquake2-protocol-constants-ml-882050710"></a>
### PS_ALL

```ml
const PS_ALL = 32767
```

Defines the ps all constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L95)

<a id="constant-constant-miniquake2-protocol-constants-ps-blend-const-ps-blend-1-10-src-miniquake2-protocol-constants-ml-668982987"></a>
### PS_BLEND

```ml
const PS_BLEND = 1 << 10
```

Defines the ps blend constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L85)

<a id="constant-constant-miniquake2-protocol-constants-ps-fov-const-ps-fov-1-11-src-miniquake2-protocol-constants-ml-1105315442"></a>
### PS_FOV

```ml
const PS_FOV = 1 << 11
```

Defines the ps fov constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L87)

<a id="constant-constant-miniquake2-protocol-constants-ps-kickangles-const-ps-kickangles-1-9-src-miniquake2-protocol-constants-ml-1009593635"></a>
### PS_KICKANGLES

```ml
const PS_KICKANGLES = 1 << 9
```

Defines the ps kickangles constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L83)

<a id="constant-constant-miniquake2-protocol-constants-ps-m-delta-angles-const-ps-m-delta-angles-1-6-src-miniquake2-protocol-constants-ml-243730328"></a>
### PS_M_DELTA_ANGLES

```ml
const PS_M_DELTA_ANGLES = 1 << 6
```

Defines the ps m delta angles constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L77)

<a id="constant-constant-miniquake2-protocol-constants-ps-m-flags-const-ps-m-flags-1-4-src-miniquake2-protocol-constants-ml-779500482"></a>
### PS_M_FLAGS

```ml
const PS_M_FLAGS = 1 << 4
```

Defines the ps m flags constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L73)

<a id="constant-constant-miniquake2-protocol-constants-ps-m-gravity-const-ps-m-gravity-1-5-src-miniquake2-protocol-constants-ml-236135441"></a>
### PS_M_GRAVITY

```ml
const PS_M_GRAVITY = 1 << 5
```

Defines the ps m gravity constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L75)

<a id="constant-constant-miniquake2-protocol-constants-ps-m-origin-const-ps-m-origin-1-1-src-miniquake2-protocol-constants-ml-981735699"></a>
### PS_M_ORIGIN

```ml
const PS_M_ORIGIN = 1 << 1
```

Defines the ps m origin constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L67)

<a id="constant-constant-miniquake2-protocol-constants-ps-m-time-const-ps-m-time-1-3-src-miniquake2-protocol-constants-ml-1353838761"></a>
### PS_M_TIME

```ml
const PS_M_TIME = 1 << 3
```

Defines the ps m time constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L71)

<a id="constant-constant-miniquake2-protocol-constants-ps-m-type-const-ps-m-type-1-0-src-miniquake2-protocol-constants-ml-1239948582"></a>
### PS_M_TYPE

```ml
const PS_M_TYPE = 1 << 0
```

player_state_t delta flags


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L65)

<a id="constant-constant-miniquake2-protocol-constants-ps-m-velocity-const-ps-m-velocity-1-2-src-miniquake2-protocol-constants-ml-1440861068"></a>
### PS_M_VELOCITY

```ml
const PS_M_VELOCITY = 1 << 2
```

Defines the ps m velocity constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L69)

<a id="constant-constant-miniquake2-protocol-constants-ps-rdflags-const-ps-rdflags-1-14-src-miniquake2-protocol-constants-ml-1552839683"></a>
### PS_RDFLAGS

```ml
const PS_RDFLAGS = 1 << 14
```

Defines the ps rdflags constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L93)

<a id="constant-constant-miniquake2-protocol-constants-ps-viewangles-const-ps-viewangles-1-8-src-miniquake2-protocol-constants-ml-402743314"></a>
### PS_VIEWANGLES

```ml
const PS_VIEWANGLES = 1 << 8
```

Defines the ps viewangles constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L81)

<a id="constant-constant-miniquake2-protocol-constants-ps-viewoffset-const-ps-viewoffset-1-7-src-miniquake2-protocol-constants-ml-476298029"></a>
### PS_VIEWOFFSET

```ml
const PS_VIEWOFFSET = 1 << 7
```

Defines the ps viewoffset constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L79)

<a id="constant-constant-miniquake2-protocol-constants-ps-weaponframe-const-ps-weaponframe-1-13-src-miniquake2-protocol-constants-ml-433698904"></a>
### PS_WEAPONFRAME

```ml
const PS_WEAPONFRAME = 1 << 13
```

Defines the ps weaponframe constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L91)

<a id="constant-constant-miniquake2-protocol-constants-ps-weaponindex-const-ps-weaponindex-1-12-src-miniquake2-protocol-constants-ml-99784315"></a>
### PS_WEAPONINDEX

```ml
const PS_WEAPONINDEX = 1 << 12
```

Defines the ps weaponindex constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L89)

<a id="constant-constant-miniquake2-protocol-constants-reliable-buffer-size-const-reliable-buffer-size-max-msglen-16-src-miniquake2-protocol-constants-ml-648769016"></a>
### RELIABLE_BUFFER_SIZE

```ml
const RELIABLE_BUFFER_SIZE = MAX_MSGLEN - 16
```

Defines the reliable buffer size constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L22)

<a id="constant-constant-miniquake2-protocol-constants-rf-beam-const-rf-beam-128-src-miniquake2-protocol-constants-ml-2051095982"></a>
### RF_BEAM

```ml
const RF_BEAM = 128
```

Defines the rf beam constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L42)

<a id="constant-constant-miniquake2-protocol-constants-sequence-mask-const-sequence-mask-2147483647-src-miniquake2-protocol-constants-ml-2146346081"></a>
### SEQUENCE_MASK

```ml
const SEQUENCE_MASK = 2147483647
```

Defines the sequence mask constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L28)

<a id="constant-constant-miniquake2-protocol-constants-sequence-reliable-bit-const-sequence-reliable-bit-2147483648-src-miniquake2-protocol-constants-ml-1273047910"></a>
### SEQUENCE_RELIABLE_BIT

```ml
const SEQUENCE_RELIABLE_BIT = 2147483648
```

Defines the sequence reliable bit constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L30)

<a id="constant-constant-miniquake2-protocol-constants-svc-playerinfo-const-svc-playerinfo-17-src-miniquake2-protocol-constants-ml-1895878871"></a>
### SVC_PLAYERINFO

```ml
const SVC_PLAYERINFO = 17
```

Defines the svc playerinfo constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L45)

<a id="constant-constant-miniquake2-protocol-constants-u-all-const-u-all-268435455-1-13-src-miniquake2-protocol-constants-ml-1779218634"></a>
### U_ALL

```ml
const U_ALL = 268435455 & ~1 << 13
```

Defines the u all constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L152)

<a id="constant-constant-miniquake2-protocol-constants-u-angle1-const-u-angle1-1-10-src-miniquake2-protocol-constants-ml-489078017"></a>
### U_ANGLE1

```ml
const U_ANGLE1 = 1 << 10
```

Defines the u angle1 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L118)

<a id="constant-constant-miniquake2-protocol-constants-u-angle2-const-u-angle2-1-2-src-miniquake2-protocol-constants-ml-640806824"></a>
### U_ANGLE2

```ml
const U_ANGLE2 = 1 << 2
```

Defines the u angle2 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L102)

<a id="constant-constant-miniquake2-protocol-constants-u-angle3-const-u-angle3-1-3-src-miniquake2-protocol-constants-ml-122888379"></a>
### U_ANGLE3

```ml
const U_ANGLE3 = 1 << 3
```

Defines the u angle3 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L104)

<a id="constant-constant-miniquake2-protocol-constants-u-effects16-const-u-effects16-1-19-src-miniquake2-protocol-constants-ml-1033220074"></a>
### U_EFFECTS16

```ml
const U_EFFECTS16 = 1 << 19
```

Defines the u effects16 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L134)

<a id="constant-constant-miniquake2-protocol-constants-u-effects8-const-u-effects8-1-14-src-miniquake2-protocol-constants-ml-1175774301"></a>
### U_EFFECTS8

```ml
const U_EFFECTS8 = 1 << 14
```

Defines the u effects8 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L124)

<a id="constant-constant-miniquake2-protocol-constants-u-event-const-u-event-1-5-src-miniquake2-protocol-constants-ml-18192419"></a>
### U_EVENT

```ml
const U_EVENT = 1 << 5
```

Defines the u event constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L108)

<a id="constant-constant-miniquake2-protocol-constants-u-frame16-const-u-frame16-1-17-src-miniquake2-protocol-constants-ml-87346364"></a>
### U_FRAME16

```ml
const U_FRAME16 = 1 << 17
```

Defines the u frame16 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L130)

<a id="constant-constant-miniquake2-protocol-constants-u-frame8-const-u-frame8-1-4-src-miniquake2-protocol-constants-ml-323124970"></a>
### U_FRAME8

```ml
const U_FRAME8 = 1 << 4
```

Defines the u frame8 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L106)

<a id="constant-constant-miniquake2-protocol-constants-u-model-const-u-model-1-11-src-miniquake2-protocol-constants-ml-1505046802"></a>
### U_MODEL

```ml
const U_MODEL = 1 << 11
```

Defines the u model constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L120)

<a id="constant-constant-miniquake2-protocol-constants-u-model2-const-u-model2-1-20-src-miniquake2-protocol-constants-ml-1618756862"></a>
### U_MODEL2

```ml
const U_MODEL2 = 1 << 20
```

Defines the u model2 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L136)

<a id="constant-constant-miniquake2-protocol-constants-u-model3-const-u-model3-1-21-src-miniquake2-protocol-constants-ml-1385277701"></a>
### U_MODEL3

```ml
const U_MODEL3 = 1 << 21
```

Defines the u model3 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L138)

<a id="constant-constant-miniquake2-protocol-constants-u-model4-const-u-model4-1-22-src-miniquake2-protocol-constants-ml-240281384"></a>
### U_MODEL4

```ml
const U_MODEL4 = 1 << 22
```

Defines the u model4 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L140)

<a id="constant-constant-miniquake2-protocol-constants-u-morebits1-const-u-morebits1-1-7-src-miniquake2-protocol-constants-ml-1067027785"></a>
### U_MOREBITS1

```ml
const U_MOREBITS1 = 1 << 7
```

Defines the u morebits1 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L112)

<a id="constant-constant-miniquake2-protocol-constants-u-morebits2-const-u-morebits2-1-15-src-miniquake2-protocol-constants-ml-1183286294"></a>
### U_MOREBITS2

```ml
const U_MOREBITS2 = 1 << 15
```

Defines the u morebits2 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L126)

<a id="constant-constant-miniquake2-protocol-constants-u-morebits3-const-u-morebits3-1-23-src-miniquake2-protocol-constants-ml-1490647969"></a>
### U_MOREBITS3

```ml
const U_MOREBITS3 = 1 << 23
```

Defines the u morebits3 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L142)

<a id="constant-constant-miniquake2-protocol-constants-u-number16-const-u-number16-1-8-src-miniquake2-protocol-constants-ml-666556928"></a>
### U_NUMBER16

```ml
const U_NUMBER16 = 1 << 8
```

Defines the u number16 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L114)

<a id="constant-constant-miniquake2-protocol-constants-u-oldorigin-const-u-oldorigin-1-24-src-miniquake2-protocol-constants-ml-1675087026"></a>
### U_OLDORIGIN

```ml
const U_OLDORIGIN = 1 << 24
```

Defines the u oldorigin constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L144)

<a id="constant-constant-miniquake2-protocol-constants-u-origin1-const-u-origin1-1-0-src-miniquake2-protocol-constants-ml-1582352134"></a>
### U_ORIGIN1

```ml
const U_ORIGIN1 = 1 << 0
```

entity_state_t delta flags; protocol 34 deliberately has no bit 13.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L98)

<a id="constant-constant-miniquake2-protocol-constants-u-origin2-const-u-origin2-1-1-src-miniquake2-protocol-constants-ml-1526643259"></a>
### U_ORIGIN2

```ml
const U_ORIGIN2 = 1 << 1
```

Defines the u origin2 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L100)

<a id="constant-constant-miniquake2-protocol-constants-u-origin3-const-u-origin3-1-9-src-miniquake2-protocol-constants-ml-282463575"></a>
### U_ORIGIN3

```ml
const U_ORIGIN3 = 1 << 9
```

Defines the u origin3 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L116)

<a id="constant-constant-miniquake2-protocol-constants-u-remove-const-u-remove-1-6-src-miniquake2-protocol-constants-ml-693221330"></a>
### U_REMOVE

```ml
const U_REMOVE = 1 << 6
```

Defines the u remove constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L110)

<a id="constant-constant-miniquake2-protocol-constants-u-renderfx16-const-u-renderfx16-1-18-src-miniquake2-protocol-constants-ml-204569987"></a>
### U_RENDERFX16

```ml
const U_RENDERFX16 = 1 << 18
```

Defines the u renderfx16 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L132)

<a id="constant-constant-miniquake2-protocol-constants-u-renderfx8-const-u-renderfx8-1-12-src-miniquake2-protocol-constants-ml-401429093"></a>
### U_RENDERFX8

```ml
const U_RENDERFX8 = 1 << 12
```

Defines the u renderfx8 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L122)

<a id="constant-constant-miniquake2-protocol-constants-u-skin16-const-u-skin16-1-25-src-miniquake2-protocol-constants-ml-1423049005"></a>
### U_SKIN16

```ml
const U_SKIN16 = 1 << 25
```

Defines the u skin16 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L146)

<a id="constant-constant-miniquake2-protocol-constants-u-skin8-const-u-skin8-1-16-src-miniquake2-protocol-constants-ml-75151181"></a>
### U_SKIN8

```ml
const U_SKIN8 = 1 << 16
```

Defines the u skin8 constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L128)

<a id="constant-constant-miniquake2-protocol-constants-u-solid-const-u-solid-1-27-src-miniquake2-protocol-constants-ml-743117445"></a>
### U_SOLID

```ml
const U_SOLID = 1 << 27
```

Defines the u solid constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L150)

<a id="constant-constant-miniquake2-protocol-constants-u-sound-const-u-sound-1-26-src-miniquake2-protocol-constants-ml-1012765296"></a>
### U_SOUND

```ml
const U_SOUND = 1 << 26
```

Defines the u sound constant used by the miniquake2 protocol constants module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/constants.ml#L148)
