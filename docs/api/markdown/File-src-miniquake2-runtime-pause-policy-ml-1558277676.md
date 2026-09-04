# `src/miniquake2/runtime/pause_policy.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime pause policy facilities for this project.

Package: [`miniquake2.runtime.pause_policy`](Package-miniquake2-runtime-pause-policy-705405784.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/ui/constants.ml` as `pauseconstants` → [src/miniquake2/client/ui/constants.ml](File-src-miniquake2-client-ui-constants-ml-1004124106.md)

## Declarations

<a id="function-function-miniquake2-runtime-pause-policy-shouldpause-function-shouldpause-maxclients-serveractive-destination-src-miniquake2-runtime-pause-policy-ml-741613433"></a>
### shouldPause

```ml
function shouldPause(maxClients, serverActive, destination)
```

Report whether should pause.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `serverActive` | `dynamic` | — | serverActive value consumed by this operation. |
| `destination` | `dynamic` | — | destination value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/pause_policy.ml#L16)
