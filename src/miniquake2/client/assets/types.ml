/* Generation-owned client model/sound registration records. */
package miniquake2.client.assets.types

struct LoaderCallbacks
  loadModel
  loadSound
  onMissing
end struct

struct AssetEntry
  kind
  index
  name
  value
  generation
  available
  reason
end struct

struct MissingAsset
  kind
  index
  name
  generation
  reason
end struct

struct ResolverBindings
  modelIndex
  modelName
  soundIndex
  soundName
end struct

struct Registry
  loaders
  generation
  mapName
  modelEntries
  soundEntries
  namedModels
  namedSounds
  missing
end struct
