# `miniquake2.runtime.client_session.ClientSession`

[Home](README.md) · [Source file](File-src-miniquake2-runtime-client-session-ml-1072602311.md)

<a id="struct-struct-miniquake2-runtime-client-session-clientsession-struct-clientsession-src-miniquake2-runtime-client-session-ml-13610153"></a>
## ClientSession

```ml
struct ClientSession
```

Store client session data.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L38)

## Members

<a id="field-field-miniquake2-runtime-client-session-clientsession-clock-clock-src-miniquake2-runtime-client-session-ml-1951441760"></a>
### clock

```ml
clock
```

Stores the clock value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L44)

<a id="field-field-miniquake2-runtime-client-session-clientsession-closed-closed-src-miniquake2-runtime-client-session-ml-1847633792"></a>
### closed

```ml
closed
```

Stores the closed value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L76)

<a id="field-field-miniquake2-runtime-client-session-clientsession-commandhistory-commandhistory-src-miniquake2-runtime-client-session-ml-595510006"></a>
### commandHistory

```ml
commandHistory
```

Stores the command history value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L60)

<a id="field-field-miniquake2-runtime-client-session-clientsession-commandindex-commandindex-src-miniquake2-runtime-client-session-ml-1096810510"></a>
### commandIndex

```ml
commandIndex
```

Stores the command index value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L48)

<a id="field-field-miniquake2-runtime-client-session-clientsession-commandsequences-commandsequences-src-miniquake2-runtime-client-session-ml-102941142"></a>
### commandSequences

```ml
commandSequences
```

Stores the command sequences value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L62)

<a id="field-field-miniquake2-runtime-client-session-clientsession-idlecommand-idlecommand-src-miniquake2-runtime-client-session-ml-1505657812"></a>
### idleCommand

```ml
idleCommand
```

Stores the idle command value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L84)

<a id="field-field-miniquake2-runtime-client-session-clientsession-integrated-integrated-src-miniquake2-runtime-client-session-ml-1330484858"></a>
### integrated

```ml
integrated
```

Stores the integrated value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L40)

<a id="field-field-miniquake2-runtime-client-session-clientsession-lastcommand-lastcommand-src-miniquake2-runtime-client-session-ml-1228383288"></a>
### lastCommand

```ml
lastCommand
```

Stores the last command value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L52)

<a id="field-field-miniquake2-runtime-client-session-clientsession-lastpredictionack-lastpredictionack-src-miniquake2-runtime-client-session-ml-1234435456"></a>
### lastPredictionAck

```ml
lastPredictionAck
```

Stores the last prediction ack value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L68)

<a id="field-field-miniquake2-runtime-client-session-clientsession-movebuffer-movebuffer-src-miniquake2-runtime-client-session-ml-890485802"></a>
### moveBuffer

```ml
moveBuffer
```

Stores the move buffer value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L86)

<a id="field-field-miniquake2-runtime-client-session-clientsession-packetsreceived-packetsreceived-src-miniquake2-runtime-client-session-ml-768745792"></a>
### packetsReceived

```ml
packetsReceived
```

Stores the packets received value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L70)

<a id="field-field-miniquake2-runtime-client-session-clientsession-packetsrejected-packetsrejected-src-miniquake2-runtime-client-session-ml-428764668"></a>
### packetsRejected

```ml
packetsRejected
```

Stores the packets rejected value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L74)

<a id="field-field-miniquake2-runtime-client-session-clientsession-packetssent-packetssent-src-miniquake2-runtime-client-session-ml-353899264"></a>
### packetsSent

```ml
packetsSent
```

Stores the packets sent value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L72)

<a id="field-field-miniquake2-runtime-client-session-clientsession-pendingcommandcount-pendingcommandcount-src-miniquake2-runtime-client-session-ml-1044440020"></a>
### pendingCommandCount

```ml
pendingCommandCount
```

Stores the pending command count value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L58)

<a id="field-field-miniquake2-runtime-client-session-clientsession-pendingcommandhead-pendingcommandhead-src-miniquake2-runtime-client-session-ml-2089316640"></a>
### pendingCommandHead

```ml
pendingCommandHead
```

Stores the pending command head value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L56)

<a id="field-field-miniquake2-runtime-client-session-clientsession-pendingcommands-pendingcommands-src-miniquake2-runtime-client-session-ml-210946972"></a>
### pendingCommands

```ml
pendingCommands
```

Stores the pending commands value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L54)

<a id="field-field-miniquake2-runtime-client-session-clientsession-predictedorigins-predictedorigins-src-miniquake2-runtime-client-session-ml-1545195622"></a>
### predictedOrigins

```ml
predictedOrigins
```

Stores the predicted origins value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L64)

<a id="field-field-miniquake2-runtime-client-session-clientsession-predictedsequences-predictedsequences-src-miniquake2-runtime-client-session-ml-108045744"></a>
### predictedSequences

```ml
predictedSequences
```

Stores the predicted sequences value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L66)

<a id="field-field-miniquake2-runtime-client-session-clientsession-predictioncommandscratch-predictioncommandscratch-src-miniquake2-runtime-client-session-ml-1778424"></a>
### predictionCommandScratch

```ml
predictionCommandScratch
```

Stores the prediction command scratch value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L78)

<a id="field-field-miniquake2-runtime-client-session-clientsession-predictionworkspace-predictionworkspace-src-miniquake2-runtime-client-session-ml-790152128"></a>
### predictionWorkspace

```ml
predictionWorkspace
```

Stores the prediction workspace value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L82)

<a id="field-field-miniquake2-runtime-client-session-clientsession-predictionworld-predictionworld-src-miniquake2-runtime-client-session-ml-254526692"></a>
### predictionWorld

```ml
predictionWorld
```

Stores the prediction world value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L80)

<a id="field-field-miniquake2-runtime-client-session-clientsession-previouscommand-previouscommand-src-miniquake2-runtime-client-session-ml-68510304"></a>
### previousCommand

```ml
previousCommand
```

Stores the previous command value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L50)

<a id="field-field-miniquake2-runtime-client-session-clientsession-signonspawncount-signonspawncount-src-miniquake2-runtime-client-session-ml-846549616"></a>
### signonSpawnCount

```ml
signonSpawnCount
```

Stores the signon spawn count value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L46)

<a id="field-field-miniquake2-runtime-client-session-clientsession-socket-socket-src-miniquake2-runtime-client-session-ml-1883626246"></a>
### socket

```ml
socket
```

Stores the socket value associated with client session.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L42)
