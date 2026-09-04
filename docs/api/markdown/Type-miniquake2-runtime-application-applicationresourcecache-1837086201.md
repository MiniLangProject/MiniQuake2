# `miniquake2.runtime.application.ApplicationResourceCache`

[Home](README.md) · [Source file](File-src-miniquake2-runtime-application-ml-1538219473.md)

<a id="struct-struct-miniquake2-runtime-application-applicationresourcecache-struct-applicationresourcecache-src-miniquake2-runtime-application-ml-634453797"></a>
## ApplicationResourceCache

```ml
struct ApplicationResourceCache
```

Store the process-wide read-only retail filesystem and decoded sound cache. A product session visits many media and map states, but all of them address the same immutable PAK data. Keeping one index avoids re-reading every PAK and retains commonly shared WAV decodes across map and video transitions.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L165)

## Members

<a id="field-field-miniquake2-runtime-application-applicationresourcecache-filesystem-filesystem-src-miniquake2-runtime-application-ml-593767029"></a>
### filesystem

```ml
filesystem
```

Stores the filesystem value associated with application resource cache.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L169)

<a id="field-field-miniquake2-runtime-application-applicationresourcecache-root-root-src-miniquake2-runtime-application-ml-1277930659"></a>
### root

```ml
root
```

Stores the root value associated with application resource cache.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L167)

<a id="field-field-miniquake2-runtime-application-applicationresourcecache-soundcount-soundcount-src-miniquake2-runtime-application-ml-831217463"></a>
### soundCount

```ml
soundCount
```

Stores the sound count value associated with application resource cache.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L175)

<a id="field-field-miniquake2-runtime-application-applicationresourcecache-soundnames-soundnames-src-miniquake2-runtime-application-ml-97105769"></a>
### soundNames

```ml
soundNames
```

Stores the sound names value associated with application resource cache.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L171)

<a id="field-field-miniquake2-runtime-application-applicationresourcecache-sounds-sounds-src-miniquake2-runtime-application-ml-496498219"></a>
### sounds

```ml
sounds
```

Stores the sounds value associated with application resource cache.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L173)
