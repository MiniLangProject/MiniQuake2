/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Generation-owned client model/sound registration records. */
package miniquake2.client.assets.types

struct LoaderCallbacks
  loadModel
  loadSkin
  loadSound
  onMissing
end struct

struct ClientInfo
  name
  cinfo
  model
  skin
  weaponModels
  available
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
  skinName
  soundIndex
  soundName
  soundEntity
  playerModel
  playerSkin
  playerWeapon
end struct

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
