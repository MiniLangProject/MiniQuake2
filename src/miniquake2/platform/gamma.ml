/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Hardware gamma lifecycle with a deterministic Quake-compatible fallback table. */
package miniquake2.platform.gamma

import std.math as videogammamath
import miniquake2.qcommon.byteio as videogammabyteio
import miniquake2.native as videogammanative

// Store gamma state data.
struct GammaState
  originalRamp
  supported
  applied
  value
end struct

// Build ramp.
function buildRamp(gamma)
  if (typeof(gamma) != "int" and typeof(gamma) != "float") or gamma != gamma or
      gamma < 0.5 or gamma > 2.0 then
    return error(2923, "vid_gamma outside [0.5,2]")
  end if
  ramp = bytes(1536)
  channel = 0
  while channel < 3
    index = 0
    while index < 256
      fraction = index / 255.0
      value = videogammabyteio.truncInt(
        videogammamath.pow(fraction, gamma) * 65535.0 + 0.5)
      if value < 0 then value = 0 end if
      if value > 65535 then value = 65535 end if
      offset = channel * 512 + index * 2
      ramp[offset] = value & 255
      ramp[offset + 1] = (value >> 8) & 255
      index = index + 1
    end while
    channel = channel + 1
  end while
  return ramp
end function

// GetDeviceGammaRamp may be unavailable under Remote Desktop, HDR compositing
// or a restrictive driver. Keep that a supported fallback state rather than a
// product-start failure, matching the original renderer's software table path.
function create()
  original = bytes(1536)
  supported = videogammanative.winGetGammaRamp(original, len(original)) != 0
  if not supported then original = bytes(0) end if
  return GammaState(original, supported, false, 1.0)
end function

// Apply state.
function apply(state, gamma, active)
  ramp = try(buildRamp(gamma))
  if ramp is error then return ramp end if
  if not state.supported then state.applied = false; return false end if
  if not active or gamma == 1.0 or gamma == 1 then
    restored = videogammanative.winSetGammaRamp(state.originalRamp,
      len(state.originalRamp)) != 0
    if restored then state.value = gamma * 1.0; state.applied = false end if
    return restored
  end if
  applied = videogammanative.winSetGammaRamp(ramp, len(ramp)) != 0
  if applied then state.value = gamma * 1.0; state.applied = true end if
  // A transient HDR/RDP/driver refusal must remain retryable. Do not mark the
  // captured hardware capability permanently unsupported after one failure.
  return applied
end function

// Restore state.
function restore(state)
  if state is void or not state.supported or len(state.originalRamp) != 1536 then
    return false
  end if
  restored = videogammanative.winSetGammaRamp(state.originalRamp,
    len(state.originalRamp)) != 0
  if restored then state.applied = false end if
  return restored
end function

// Update state.
function update(state, gamma, active)
  if state is void then return false end if
  wantedApplied = active and gamma != 1.0 and gamma != 1
  if state.value == gamma and state.applied == wantedApplied then
    return state.applied
  end if
  return apply(state, gamma, active)
end function
