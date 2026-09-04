# `miniquake2.client.prediction.PredictionWorkspace`

[Home](README.md) · [Source file](File-src-miniquake2-client-prediction-ml-2147101369.md)

<a id="struct-struct-miniquake2-client-prediction-predictionworkspace-struct-predictionworkspace-src-miniquake2-client-prediction-ml-1332359889"></a>
## PredictionWorkspace

```ml
struct PredictionWorkspace
```

Product prediction replays the same bounded command ring every render frame. Keep the Pmove graph, touch array, private slide scratch and result storage owned by the client session instead of rebuilding them at 125 Hz. A predictInto result remains valid until the next call on its workspace.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L36)

## Members

<a id="field-field-miniquake2-client-prediction-predictionworkspace-localstate-localstate-src-miniquake2-client-prediction-ml-1369495765"></a>
### localState

```ml
localState
```

Stores the local state value associated with prediction workspace.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L40)

<a id="field-field-miniquake2-client-prediction-predictionworkspace-pmove-pmove-src-miniquake2-client-prediction-ml-832888345"></a>
### pmove

```ml
pmove
```

Stores the pmove value associated with prediction workspace.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L38)

<a id="field-field-miniquake2-client-prediction-predictionworkspace-result-result-src-miniquake2-client-prediction-ml-389228903"></a>
### result

```ml
result
```

Stores the result value associated with prediction workspace.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L42)
