# `src/miniquake2/platform/system.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 platform system facilities for this project.

Package: [`miniquake2.platform.system`](Package-miniquake2-platform-system-1531234715.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/native.ml` as `native` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)

## Declarations

- [miniquake2.platform.system.Clock](Type-miniquake2-platform-system-clock-1055355435.md) — struct
<a id="function-function-miniquake2-platform-system-counter-function-counter-clock-src-miniquake2-platform-system-ml-356109494"></a>
### counter

```ml
function counter(clock)
```

Return the counter value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clock` | `dynamic` | — | clock value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/system.ml#L29)

<a id="function-function-miniquake2-platform-system-createclock-function-createclock-src-miniquake2-platform-system-ml-1242125554"></a>
### createClock

```ml
function createClock()
```

Create clock.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/system.ml#L21)

<a id="function-function-miniquake2-platform-system-handlecount-function-handlecount-src-miniquake2-platform-system-ml-952508392"></a>
### handleCount

```ml
function handleCount()
```

Handle count.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/system.ml#L48)

<a id="function-function-miniquake2-platform-system-milliseconds-function-milliseconds-clock-src-miniquake2-platform-system-ml-1168974470"></a>
### milliseconds

```ml
function milliseconds(clock)
```

Return the milliseconds value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clock` | `dynamic` | — | clock value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/system.ml#L35)

<a id="function-function-miniquake2-platform-system-sleep-function-sleep-millisecondstowait-src-miniquake2-platform-system-ml-418004566"></a>
### sleep

```ml
function sleep(millisecondsToWait)
```

Return the sleep value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `millisecondsToWait` | `dynamic` | — | millisecondsToWait value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/system.ml#L41)
