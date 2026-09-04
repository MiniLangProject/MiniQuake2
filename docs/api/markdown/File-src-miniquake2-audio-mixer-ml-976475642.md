# `src/miniquake2/audio/mixer.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 audio mixer facilities for this project.

Package: [`miniquake2.audio.mixer`](Package-miniquake2-audio-mixer-2031527964.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/native.ml` as `amnative` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)
- `miniquake2/qcommon/byteio.ml` as `ambio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/filesystem.ml` as `amfilesystem` → [src/miniquake2/qcommon/filesystem.ml](File-src-miniquake2-qcommon-filesystem-ml-828451784.md)
- `std/bytes.ml` as `ambytes` → `../MiniLangCompilerML/std/bytes.ml` — external dependency
- `std/math.ml` as `ammath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

- [miniquake2.audio.mixer.Channel](Type-miniquake2-audio-mixer-channel-81449649.md) — struct
<a id="function-function-miniquake2-audio-mixer-channellifeleft-inline-function-channellifeleft-mixer-channel-src-miniquake2-audio-mixer-ml-1118637607"></a>
### channelLifeLeft

```ml
inline function channelLifeLeft(mixer, channel)
```

Return the channel life left value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `channel` | `dynamic` | — | channel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L382)

<a id="function-function-miniquake2-audio-mixer-clamp16-inline-function-clamp16-value-src-miniquake2-audio-mixer-ml-399194874"></a>
### clamp16

```ml
inline function clamp16(value)
```

Clamp 16.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L332)

<a id="function-function-miniquake2-audio-mixer-clearautosounds-function-clearautosounds-mixer-src-miniquake2-audio-mixer-ml-649472731"></a>
### clearAutoSounds

```ml
function clearAutoSounds(mixer)
```

EntityState.sound values are Quake "autosounds": they are rebuilt from the current snapshot every client frame and loop even when the WAV has no cue chunk.  Their phase follows painted time so a refreshed channel does not restart at sample zero on every rendered frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L753)

<a id="function-function-miniquake2-audio-mixer-create-function-create-samplerate-src-miniquake2-audio-mixer-ml-1268966460"></a>
### create

```ml
function create(sampleRate)
```

Creates create for the miniquake2 audio mixer module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sampleRate` | `dynamic` | — | sampleRate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L131)

<a id="function-function-miniquake2-audio-mixer-decodemusicchunk-function-decodemusicchunk-track-restart-src-miniquake2-audio-mixer-ml-1523566034"></a>
### decodeMusicChunk

```ml
function decodeMusicChunk(track, restart)
```

Decode music chunk.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `track` | `dynamic` | — | track value consumed by this operation. |
| `restart` | `dynamic` | — | restart value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L273)

<a id="function-function-miniquake2-audio-mixer-divide255positive-inline-function-divide255positive-value-src-miniquake2-audio-mixer-ml-189425194"></a>
### divide255Positive

```ml
inline function divide255Positive(value)
```

Divide 255 positive.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L354)

<a id="function-function-miniquake2-audio-mixer-enableoptimizedstorage-function-enableoptimizedstorage-mixer-src-miniquake2-audio-mixer-ml-990628191"></a>
### enableOptimizedStorage

```ml
function enableOptimizedStorage(mixer)
```

Disable the compact compatibility view in latency-sensitive product paths. The fixed queue remains authoritative and avoids copying every future sound whenever a new playsound is inserted or issued.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L142)

<a id="function-function-miniquake2-audio-mixer-issuepending-function-issuepending-mixer-absoluteframe-src-miniquake2-audio-mixer-ml-1232645667"></a>
### issuePending

```ml
function issuePending(mixer, absoluteFrame)
```

Report whether issue pending.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `absoluteFrame` | `dynamic` | — | absoluteFrame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L507)

<a id="constant-constant-miniquake2-audio-mixer-max-channels-const-max-channels-32-src-miniquake2-audio-mixer-ml-1927931406"></a>
### MAX_CHANNELS

```ml
const MAX_CHANNELS = 32
```

Defines the max channels constant used by the miniquake2 audio mixer module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L17)

<a id="constant-constant-miniquake2-audio-mixer-max-playsounds-const-max-playsounds-128-src-miniquake2-audio-mixer-ml-1649755878"></a>
### MAX_PLAYSOUNDS

```ml
const MAX_PLAYSOUNDS = 128
```

Defines the max playsounds constant used by the miniquake2 audio mixer module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L19)

<a id="function-function-miniquake2-audio-mixer-mix-function-mix-mixer-framecount-src-miniquake2-audio-mixer-ml-1515932367"></a>
### mix

```ml
function mix(mixer, frameCount)
```

Mix state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `frameCount` | `dynamic` | — | Number of frame to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L731)

<a id="constant-constant-miniquake2-audio-mixer-mix-frac-bits-const-mix-frac-bits-16-src-miniquake2-audio-mixer-ml-1907532348"></a>
### MIX_FRAC_BITS

```ml
const MIX_FRAC_BITS = 16
```

Defines the mix frac bits constant used by the miniquake2 audio mixer module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L23)

<a id="constant-constant-miniquake2-audio-mixer-mix-frac-one-const-mix-frac-one-65536-src-miniquake2-audio-mixer-ml-1936772480"></a>
### MIX_FRAC_ONE

```ml
const MIX_FRAC_ONE = 65536
```

Defines the mix frac one constant used by the miniquake2 audio mixer module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L25)

<a id="constant-constant-miniquake2-audio-mixer-mix-volume-bits-const-mix-volume-bits-16-src-miniquake2-audio-mixer-ml-544337052"></a>
### MIX_VOLUME_BITS

```ml
const MIX_VOLUME_BITS = 16
```

Defines the mix volume bits constant used by the miniquake2 audio mixer module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L27)

<a id="constant-constant-miniquake2-audio-mixer-mix-volume-one-const-mix-volume-one-65536-src-miniquake2-audio-mixer-ml-570723932"></a>
### MIX_VOLUME_ONE

```ml
const MIX_VOLUME_ONE = 65536
```

Defines the mix volume one constant used by the miniquake2 audio mixer module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L29)

- [miniquake2.audio.mixer.Mixer](Type-miniquake2-audio-mixer-mixer-2120662871.md) — struct
<a id="function-function-miniquake2-audio-mixer-mixinto-function-mixinto-mixer-output-framecount-src-miniquake2-audio-mixer-ml-217181484"></a>
### mixInto

```ml
function mixInto(mixer, output, frameCount)
```

Paint exactly frameCount interleaved signed-16 stereo frames into caller- owned storage. Pending sounds are issued in timestamp order and every active channel advances once, preserving deterministic mixer time across reuse.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `frameCount` | `dynamic` | — | Number of frame to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L604)

<a id="function-function-miniquake2-audio-mixer-mixreusable-function-mixreusable-mixer-framecount-src-miniquake2-audio-mixer-ml-679223869"></a>
### mixReusable

```ml
function mixReusable(mixer, frameCount)
```

The waveOut bridge copies submitted PCM into its own ring.  The real-time product can therefore reuse one mixer-owned block and avoid a fresh bytes allocation (and later GC scan) for every audio submission.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `frameCount` | `dynamic` | — | Number of frame to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L741)

<a id="constant-constant-miniquake2-audio-mixer-music-decode-frames-const-music-decode-frames-4096-src-miniquake2-audio-mixer-ml-1724492540"></a>
### MUSIC_DECODE_FRAMES

```ml
const MUSIC_DECODE_FRAMES = 4096
```

Defines the music decode frames constant used by the miniquake2 audio mixer module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L21)

- [miniquake2.audio.mixer.MusicTrack](Type-miniquake2-audio-mixer-musictrack-1538527652.md) — struct
<a id="function-function-miniquake2-audio-mixer-pausemusic-function-pausemusic-mixer-src-miniquake2-audio-mixer-ml-1049070563"></a>
### pauseMusic

```ml
function pauseMusic(mixer)
```

Pause music.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L204)

<a id="function-function-miniquake2-audio-mixer-pendingat-function-pendingat-mixer-index-src-miniquake2-audio-mixer-ml-1126794805"></a>
### pendingAt

```ml
function pendingAt(mixer, index)
```

Return one pending sound from the authoritative fixed queue.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L159)

<a id="function-function-miniquake2-audio-mixer-pendingcount-function-pendingcount-mixer-src-miniquake2-audio-mixer-ml-917910747"></a>
### pendingCount

```ml
function pendingCount(mixer)
```

Return the number of pending sounds without exposing queue capacity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L151)

<a id="function-function-miniquake2-audio-mixer-pickchannelslot-function-pickchannelslot-mixer-entitynumber-entitychannel-src-miniquake2-audio-mixer-ml-138964349"></a>
### pickChannelSlot

```ml
function pickChannelSlot(mixer, entityNumber, entityChannel)
```

S_PickChannel: explicit entity channels override themselves; otherwise the shortest-lived channel is replaced. A non-player sound may never evict a live channel owned by the view entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `entityNumber` | `dynamic` | — | entityNumber value consumed by this operation. |
| `entityChannel` | `dynamic` | — | entityChannel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L398)

<a id="function-function-miniquake2-audio-mixer-playmusic-function-playmusic-mixer-filesystem-track-looping-src-miniquake2-audio-mixer-ml-227735521"></a>
### playMusic

```ml
function playMusic(mixer, filesystem, track, looping)
```

Play music.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `filesystem` | `dynamic` | — | filesystem value consumed by this operation. |
| `track` | `dynamic` | — | track value consumed by this operation. |
| `looping` | `dynamic` | — | looping value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L223)

<a id="function-function-miniquake2-audio-mixer-refreshpendingview-function-refreshpendingview-mixer-src-miniquake2-audio-mixer-ml-1383447175"></a>
### refreshPendingView

```ml
function refreshPendingView(mixer)
```

Rebuild the legacy compact view only for component tests and API clients that explicitly retain it. Product mixers disable this allocation path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L168)

<a id="function-function-miniquake2-audio-mixer-resumemusic-function-resumemusic-mixer-src-miniquake2-audio-mixer-ml-1241573867"></a>
### resumeMusic

```ml
function resumeMusic(mixer)
```

Resume music.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L212)

<a id="function-function-miniquake2-audio-mixer-sampleat-inline-function-sampleat-sound-frame-channel-src-miniquake2-audio-mixer-ml-147914776"></a>
### sampleAt

```ml
inline function sampleAt(sound, frame, channel)
```

Sample at.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sound` | `dynamic` | — | sound value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `channel` | `dynamic` | — | channel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L342)

<a id="function-function-miniquake2-audio-mixer-scalechannelsamplefixed-inline-function-scalechannelsamplefixed-sample-volume-src-miniquake2-audio-mixer-ml-360157323"></a>
### scaleChannelSampleFixed

```ml
inline function scaleChannelSampleFixed(sample, volume)
```

Scale channel sample fixed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sample` | `dynamic` | — | sample value consumed by this operation. |
| `volume` | `dynamic` | — | volume value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L363)

<a id="function-function-miniquake2-audio-mixer-setlistenerentity-function-setlistenerentity-mixer-number-src-miniquake2-audio-mixer-ml-1488457150"></a>
### setListenerEntity

```ml
function setListenerEntity(mixer, number)
```

Set listener entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L309)

<a id="function-function-miniquake2-audio-mixer-setmastervolume-function-setmastervolume-mixer-value-src-miniquake2-audio-mixer-ml-389734126"></a>
### setMasterVolume

```ml
function setMasterVolume(mixer, value)
```

Set master volume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L320)

<a id="function-function-miniquake2-audio-mixer-setmusicvolume-function-setmusicvolume-mixer-value-src-miniquake2-audio-mixer-ml-756590138"></a>
### setMusicVolume

```ml
function setMusicVolume(mixer, value)
```

Set music volume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L183)

<a id="function-function-miniquake2-audio-mixer-spatialvolumes-function-spatialvolumes-listenerorigin-listenerright-sourceorigin-mastervolume-attenuation-src-miniquake2-audio-mixer-ml-1957890291"></a>
### spatialVolumes

```ml
function spatialVolumes(listenerOrigin, listenerRight, sourceOrigin, masterVolume, attenuation)
```

Return the spatial volumes value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `listenerOrigin` | `dynamic` | — | listenerOrigin value consumed by this operation. |
| `listenerRight` | `dynamic` | — | listenerRight value consumed by this operation. |
| `sourceOrigin` | `dynamic` | — | sourceOrigin value consumed by this operation. |
| `masterVolume` | `dynamic` | — | masterVolume value consumed by this operation. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L592)

<a id="function-function-miniquake2-audio-mixer-spatialvolumesinto-function-spatialvolumesinto-output-listenerorigin-listenerright-sourceorigin-mastervolume-attenuation-src-miniquake2-audio-mixer-ml-1146949148"></a>
### spatialVolumesInto

```ml
function spatialVolumesInto(output, listenerOrigin, listenerRight, sourceOrigin, masterVolume, attenuation)
```

Populate the spatial volumes destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `listenerOrigin` | `dynamic` | — | listenerOrigin value consumed by this operation. |
| `listenerRight` | `dynamic` | — | listenerRight value consumed by this operation. |
| `sourceOrigin` | `dynamic` | — | sourceOrigin value consumed by this operation. |
| `masterVolume` | `dynamic` | — | masterVolume value consumed by this operation. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L553)

<a id="function-function-miniquake2-audio-mixer-startautosound-function-startautosound-mixer-sound-leftvolume-rightvolume-src-miniquake2-audio-mixer-ml-720135711"></a>
### startAutoSound

```ml
function startAutoSound(mixer, sound, leftVolume, rightVolume)
```

Start auto sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `sound` | `dynamic` | — | sound value consumed by this operation. |
| `leftVolume` | `dynamic` | — | leftVolume value consumed by this operation. |
| `rightVolume` | `dynamic` | — | rightVolume value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L765)

<a id="function-function-miniquake2-audio-mixer-startsound-function-startsound-mixer-sound-entitynumber-entitychannel-leftvolume-rightvolume-src-miniquake2-audio-mixer-ml-2107942007"></a>
### startSound

```ml
function startSound(mixer, sound, entityNumber, entityChannel, leftVolume, rightVolume)
```

Start sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `sound` | `dynamic` | — | sound value consumed by this operation. |
| `entityNumber` | `dynamic` | — | entityNumber value consumed by this operation. |
| `entityChannel` | `dynamic` | — | entityChannel value consumed by this operation. |
| `leftVolume` | `dynamic` | — | leftVolume value consumed by this operation. |
| `rightVolume` | `dynamic` | — | rightVolume value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L441)

<a id="function-function-miniquake2-audio-mixer-startsoundat-function-startsoundat-mixer-sound-entitynumber-entitychannel-leftvolume-rightvolume-startframe-src-miniquake2-audio-mixer-ml-659468752"></a>
### startSoundAt

```ml
function startSoundAt(mixer, sound, entityNumber, entityChannel, leftVolume, rightVolume, startFrame)
```

Start sound at.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `sound` | `dynamic` | — | sound value consumed by this operation. |
| `entityNumber` | `dynamic` | — | entityNumber value consumed by this operation. |
| `entityChannel` | `dynamic` | — | entityChannel value consumed by this operation. |
| `leftVolume` | `dynamic` | — | leftVolume value consumed by this operation. |
| `rightVolume` | `dynamic` | — | rightVolume value consumed by this operation. |
| `startFrame` | `dynamic` | — | startFrame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L468)

<a id="function-function-miniquake2-audio-mixer-stopall-function-stopall-mixer-src-miniquake2-audio-mixer-ml-260704317"></a>
### stopAll

```ml
function stopAll(mixer)
```

Stop all.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L809)

<a id="function-function-miniquake2-audio-mixer-stopmusic-function-stopmusic-mixer-src-miniquake2-audio-mixer-ml-112645181"></a>
### stopMusic

```ml
function stopMusic(mixer)
```

Stop music.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L195)

<a id="function-function-miniquake2-audio-mixer-synchronizemusictrack-function-synchronizemusictrack-mixer-filesystem-configvalue-src-miniquake2-audio-mixer-ml-1436544955"></a>
### synchronizeMusicTrack

```ml
function synchronizeMusicTrack(mixer, filesystem, configValue)
```

Synchronize music track.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `filesystem` | `dynamic` | — | filesystem value consumed by this operation. |
| `configValue` | `dynamic` | — | configValue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/mixer.ml#L294)
