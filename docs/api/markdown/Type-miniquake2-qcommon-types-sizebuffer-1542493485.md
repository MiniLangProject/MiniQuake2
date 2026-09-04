# `miniquake2.qcommon.types.SizeBuffer`

[Home](README.md) · [Source file](File-src-miniquake2-qcommon-types-ml-1663266398.md)

<a id="struct-struct-miniquake2-qcommon-types-sizebuffer-struct-sizebuffer-src-miniquake2-qcommon-types-ml-998009649"></a>
## SizeBuffer

```ml
struct SizeBuffer
```

MiniLang owns the backing bytes. maxSize may intentionally be smaller than len(data), matching SZ_Init over a caller-owned C array.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/types.ml#L24)

## Members

<a id="field-field-miniquake2-qcommon-types-sizebuffer-allowoverflow-allowoverflow-src-miniquake2-qcommon-types-ml-1848571656"></a>
### allowOverflow

```ml
allowOverflow
```

Stores the allow overflow value associated with size buffer.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/types.ml#L26)

<a id="field-field-miniquake2-qcommon-types-sizebuffer-cursize-cursize-src-miniquake2-qcommon-types-ml-38074152"></a>
### curSize

```ml
curSize
```

Stores the cur size value associated with size buffer.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/types.ml#L34)

<a id="field-field-miniquake2-qcommon-types-sizebuffer-data-data-src-miniquake2-qcommon-types-ml-701884012"></a>
### data

```ml
data
```

Stores the data value associated with size buffer.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/types.ml#L30)

<a id="field-field-miniquake2-qcommon-types-sizebuffer-maxsize-maxsize-src-miniquake2-qcommon-types-ml-1843169832"></a>
### maxSize

```ml
maxSize
```

Stores the max size value associated with size buffer.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/types.ml#L32)

<a id="field-field-miniquake2-qcommon-types-sizebuffer-overflowed-overflowed-src-miniquake2-qcommon-types-ml-2035759670"></a>
### overflowed

```ml
overflowed
```

Stores the overflowed value associated with size buffer.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/types.ml#L28)

<a id="field-field-miniquake2-qcommon-types-sizebuffer-readcount-readcount-src-miniquake2-qcommon-types-ml-896920776"></a>
### readCount

```ml
readCount
```

Stores the read count value associated with size buffer.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/types.ml#L36)
