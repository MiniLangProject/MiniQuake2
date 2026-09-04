//! Provides miniquake2 client assets types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Generation-owned client model/sound registration records. */
package miniquake2.client.assets.types

/// Store loader callbacks data.
struct LoaderCallbacks
  /// Stores the load model value associated with loader callbacks.
  loadModel
  /// Stores the load skin value associated with loader callbacks.
  loadSkin
  /// Stores the load sound value associated with loader callbacks.
  loadSound
  /// Stores the on missing value associated with loader callbacks.
  onMissing
end struct

/// Store client info data.
struct ClientInfo
  /// Stores the name value associated with client info.
  name
  /// Stores the cinfo value associated with client info.
  cinfo
  /// Stores the model value associated with client info.
  model
  /// Stores the skin value associated with client info.
  skin
  /// Stores the weapon models value associated with client info.
  weaponModels
  /// Stores the available value associated with client info.
  available
end struct

/// Store asset entry data.
struct AssetEntry
  /// Stores the kind value associated with asset entry.
  kind
  /// Stores the index value associated with asset entry.
  index
  /// Stores the name value associated with asset entry.
  name
  /// Stores the value value associated with asset entry.
  value
  /// Stores the generation value associated with asset entry.
  generation
  /// Stores the available value associated with asset entry.
  available
  /// Stores the reason value associated with asset entry.
  reason
end struct

/// Store missing asset data.
struct MissingAsset
  /// Stores the kind value associated with missing asset.
  kind
  /// Stores the index value associated with missing asset.
  index
  /// Stores the name value associated with missing asset.
  name
  /// Stores the generation value associated with missing asset.
  generation
  /// Stores the reason value associated with missing asset.
  reason
end struct

/// Store resolver bindings data.
struct ResolverBindings
  /// Stores the model index value associated with resolver bindings.
  modelIndex
  /// Stores the model name value associated with resolver bindings.
  modelName
  /// Stores the skin name value associated with resolver bindings.
  skinName
  /// Stores the sound index value associated with resolver bindings.
  soundIndex
  /// Stores the sound name value associated with resolver bindings.
  soundName
  /// Stores the sound entity value associated with resolver bindings.
  soundEntity
  /// Stores the player model value associated with resolver bindings.
  playerModel
  /// Stores the player skin value associated with resolver bindings.
  playerSkin
  /// Stores the player weapon value associated with resolver bindings.
  playerWeapon
end struct

/// Store registry data.
struct Registry
  /// Stores the loaders value associated with registry.
  loaders
  /// Stores the generation value associated with registry.
  generation
  /// Stores the map name value associated with registry.
  mapName
  /// Stores the model entries value associated with registry.
  modelEntries
  /// Stores the sound entries value associated with registry.
  soundEntries
  /// Stores the named models value associated with registry.
  namedModels
  /// Stores the named skins value associated with registry.
  namedSkins
  /// Stores the named sounds value associated with registry.
  namedSounds
  /// Stores the client infos value associated with registry.
  clientInfos
  /// Stores the client config strings value associated with registry.
  clientConfigStrings
  /// Stores the base client info value associated with registry.
  baseClientInfo
  /// Stores the weapon model names value associated with registry.
  weaponModelNames
  /// Stores the weapon model count value associated with registry.
  weaponModelCount
  /// Stores the missing value associated with registry.
  missing
end struct
