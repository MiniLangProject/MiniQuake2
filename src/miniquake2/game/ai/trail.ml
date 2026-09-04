//! Provides miniquake2 game ai trail facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Fixed eight-marker PlayerTrail port from p_trail.c. Markers and vectors are
allocated once per level; frame updates mutate the circular storage in place.
*/
package miniquake2.game.ai.trail

import miniquake2.game.ai.types as aitrailtypes
import std.math as aitrailmath

/// Defines the trail length constant used by the miniquake2 game ai trail module.
const TRAIL_LENGTH = 8

/// Store player trail data.
struct PlayerTrail
  /// Stores the markers value associated with player trail.
  markers
  /// Stores the head value associated with player trail.
  head
  /// Stores the active value associated with player trail.
  active
end struct

/// Creates create for the miniquake2 game ai trail module.
/// @param active active value consumed by this operation.
function create(active)
  markers = array(TRAIL_LENGTH)
  index = 0
  while index < TRAIL_LENGTH
    marker = aitrailtypes.createActor(-1000 - index, "player_trail")
    marker.isMonster = false
    marker.isClient = false
    marker.viewHeight = 0.0
    marker.timestamp = 0.0
    markers[index] = marker
    index = index + 1
  end while
  return PlayerTrail(markers, 0, active)
end function

/// Performs the Reset operation for the miniquake2 game ai trail module.
/// @param trail trail value consumed by this operation.
/// @param active active value consumed by this operation.
function Reset(trail, active)
  trail.head = 0
  trail.active = active
  for each marker in trail.markers
    marker.edict.state.origin.x = 0.0
    marker.edict.state.origin.y = 0.0
    marker.edict.state.origin.z = 0.0
    marker.edict.state.angles.y = 0.0
    marker.timestamp = 0.0
  end for
  return trail
end function

/// Adds add to the state managed by the miniquake2 game ai trail module.
/// @param trail trail value consumed by this operation.
/// @param spot spot value consumed by this operation.
/// @param time time value consumed by this operation.
function Add(trail, spot, time)
  if not trail.active then return false end if
  marker = trail.markers[trail.head]
  marker.edict.state.origin.x = spot.x
  marker.edict.state.origin.y = spot.y
  marker.edict.state.origin.z = spot.z
  marker.timestamp = time
  previous = trail.markers[(trail.head + TRAIL_LENGTH - 1) &
    (TRAIL_LENGTH - 1)]
  deltaX = spot.x - previous.edict.state.origin.x
  deltaY = spot.y - previous.edict.state.origin.y
  yaw = aitrailmath.radToDeg(aitrailmath.atan2(deltaY, deltaX))
  if yaw < 0.0 then yaw = yaw + 360.0 end if
  marker.edict.state.angles.y = yaw
  trail.head = (trail.head + 1) & (TRAIL_LENGTH - 1)
  return true
end function

/// Return the new value.
/// @param trail trail value consumed by this operation.
/// @param spot spot value consumed by this operation.
/// @param time time value consumed by this operation.
function New(trail, spot, time)
  if not trail.active then return false end if
  Reset(trail, true)
  return Add(trail, spot, time)
end function

/// Choose first.
/// @param trail trail value consumed by this operation.
/// @param actor actor value consumed by this operation.
/// @param visible visible value consumed by this operation.
function PickFirst(trail, actor, visible)
  if not trail.active then return void end if
  markerIndex = trail.head
  remaining = TRAIL_LENGTH
  while remaining > 0
    if trail.markers[markerIndex].timestamp <= actor.info.trailTime then
      markerIndex = (markerIndex + 1) & (TRAIL_LENGTH - 1)
    else break
    end if
    remaining = remaining - 1
  end while
  marker = trail.markers[markerIndex]
  if typeof(visible) != "function" or visible(actor, marker) then return marker end if
  previous = trail.markers[(markerIndex + TRAIL_LENGTH - 1) &
    (TRAIL_LENGTH - 1)]
  if visible(actor, previous) then return previous end if
  return marker
end function

/// Choose next.
/// @param trail trail value consumed by this operation.
/// @param actor actor value consumed by this operation.
function PickNext(trail, actor)
  if not trail.active then return void end if
  markerIndex = trail.head
  remaining = TRAIL_LENGTH
  while remaining > 0
    if trail.markers[markerIndex].timestamp <= actor.info.trailTime then
      markerIndex = (markerIndex + 1) & (TRAIL_LENGTH - 1)
    else break
    end if
    remaining = remaining - 1
  end while
  return trail.markers[markerIndex]
end function

/// Return the last spot value.
/// @param trail trail value consumed by this operation.
function LastSpot(trail)
  if not trail.active then return void end if
  return trail.markers[(trail.head + TRAIL_LENGTH - 1) &
    (TRAIL_LENGTH - 1)]
end function
