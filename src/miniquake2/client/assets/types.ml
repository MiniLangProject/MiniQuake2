/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Generation-owned client model/sound registration records. */
package miniquake2.client.assets.types

// Store loader callbacks data.
struct LoaderCallbacks
  loadModel
  loadSkin
  loadSound
  onMissing
end struct

// Store client info data.
struct ClientInfo
  name
  cinfo
  model
  skin
  weaponModels
  available
end struct

// Store asset entry data.
struct AssetEntry
  kind
  index
  name
  value
  generation
  available
  reason
end struct

// Store missing asset data.
struct MissingAsset
  kind
  index
  name
  generation
  reason
end struct

// Store resolver bindings data.
struct ResolverBindings
  modelIndex
  modelName
  skinName
  soundIndex
  soundName
  soundEntity
  playerModel
  playerSkin
  playerWeapon
end struct

// Store registry data.
struct Registry
  loaders
  generation
  mapName
  modelEntries
  soundEntries
  namedModels
  namedSkins
  namedSounds
  clientInfos
  clientConfigStrings
  baseClientInfo
  weaponModelNames
  weaponModelCount
  missing
end struct
