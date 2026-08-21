/* Typed bounded GameImport sound queue and Protocol-34 fragment codec. */
package miniquake2.server.sound_events

import miniquake2.qcommon.constants as sseqc
import miniquake2.qcommon.byteio as ssebio
import miniquake2.qcommon.message as sseqmsg
import miniquake2.qcommon.sizebuf as sseqsz
import miniquake2.qcommon.types as sseqtypes
import miniquake2.protocol.constants as ssepc
import miniquake2.server.types as ssetypes

const MAX_PENDING_SOUND_EVENTS = 256
const MAX_SOUND_FRAGMENT_BYTES = 14

function numeric(value)
  return typeof(value) == "int" or typeof(value) == "float"
end function

function validUnit(value, minimum, maximum)
  return numeric(value) and value == value and value >= minimum and value <= maximum
end function

function copiedPosition(position)
  if position is void then return void end if
  if typeof(position) != "struct" or not numeric(position.x) or not numeric(position.y) or not numeric(position.z) then
    return error(3910, "sound position must be a Vec3")
  end if
  for each coordinate in [position.x, position.y, position.z]
    if coordinate != coordinate or coordinate < -4096.0 or coordinate > 4095.875 then
      return error(3911, "sound position outside Protocol-34 coord range")
    end if
  end for
  return sseqtypes.Vec3(position.x * 1.0, position.y * 1.0, position.z * 1.0)
end function

function entityFields(entity)
  if entity is void then return [false, 0] end if
  if typeof(entity) != "struct" or typeof(entity.state) != "struct" or
      typeof(entity.state.number) != "int" or entity.state.number < 0 or
      entity.state.number >= ssepc.MAX_EDICTS then
    return error(3912, "sound entity outside Protocol-34 range")
  end if
  return [true, entity.state.number]
end function

function validateFields(hasEntity, entityNumber, channel, channelFlags, soundIndex,
    volume, attenuation, timeOffset, position)
  if typeof(hasEntity) != "bool" or typeof(entityNumber) != "int" or entityNumber < 0 or
      entityNumber >= ssepc.MAX_EDICTS then return error(3912, "sound entity outside Protocol-34 range") end if
  if not hasEntity and entityNumber != 0 then return error(3912, "sound without entity has a nonzero entity number") end if
  if typeof(channel) != "int" or channel < 0 or channel > 7 or typeof(channelFlags) != "int" or
      channelFlags < 0 or (channelFlags & ~31) != 0 then return error(3913, "sound channel outside supported range") end if
  if hasEntity and (channelFlags & 7) != channel then return error(3913, "sound channel fields are inconsistent") end if
  if typeof(soundIndex) != "int" or soundIndex < 1 or soundIndex > 255 then
    return error(3914, "sound index outside Protocol-34 byte range")
  end if
  if not validUnit(volume, 0.0, 1.0) then return error(3915, "sound volume outside [0,1]") end if
  if not validUnit(attenuation, 0.0, 4.0) then return error(3916, "sound attenuation outside [0,4]") end if
  if not validUnit(timeOffset, 0.0, 0.255) then return error(3917, "sound time offset outside byte milliseconds") end if
  copiedPosition(position)
  return true
end function

function enqueue(runtime, position, entity, channelFlags, soundIndex, volume, attenuation, timeOffset)
  if len(runtime.pendingSounds) >= MAX_PENDING_SOUND_EVENTS then
    return error(3918, "pending server sound queue is full")
  end if
  entityInfo = entityFields(entity)
  if typeof(channelFlags) != "int" then return error(3913, "sound channel outside supported range") end if
  channel = channelFlags & 7
  ownedPosition = copiedPosition(position)
  validateFields(entityInfo[0], entityInfo[1], channel, channelFlags, soundIndex,
    volume, attenuation, timeOffset, ownedPosition)
  event = ssetypes.PendingSoundEvent(runtime.nextSoundSerial, entityInfo[0], entityInfo[1],
    channel, channelFlags, soundIndex, volume * 1.0, attenuation * 1.0,
    timeOffset * 1.0, ownedPosition)
  runtime.pendingSounds = runtime.pendingSounds + [event]
  runtime.nextSoundSerial = runtime.nextSoundSerial + 1
  return event
end function

function encode(event)
  validateFields(event.hasEntity, event.entity, event.channel, event.channelFlags,
    event.soundIndex, event.volume, event.attenuation, event.timeOffset, event.position)
  flags = 0
  if event.volume != sseqc.DEFAULT_SOUND_PACKET_VOLUME then flags = flags | sseqc.SND_VOLUME end if
  if event.attenuation != sseqc.DEFAULT_SOUND_PACKET_ATTENUATION then flags = flags | sseqc.SND_ATTENUATION end if
  if event.timeOffset != 0.0 then flags = flags | sseqc.SND_OFFSET end if
  if event.hasEntity then flags = flags | sseqc.SND_ENT end if
  if event.position is not void then flags = flags | sseqc.SND_POS end if
  buffer = sseqsz.alloc(MAX_SOUND_FRAGMENT_BYTES)
  sseqmsg.writeByte(buffer, sseqc.SVC_SOUND)
  sseqmsg.writeByte(buffer, flags)
  sseqmsg.writeByte(buffer, event.soundIndex)
  if (flags & sseqc.SND_VOLUME) != 0 then sseqmsg.writeByte(buffer, ssebio.truncInt(event.volume * 255.0)) end if
  if (flags & sseqc.SND_ATTENUATION) != 0 then sseqmsg.writeByte(buffer, ssebio.truncInt(event.attenuation * 64.0)) end if
  if (flags & sseqc.SND_OFFSET) != 0 then sseqmsg.writeByte(buffer, ssebio.truncInt(event.timeOffset * 1000.0)) end if
  if (flags & sseqc.SND_ENT) != 0 then sseqmsg.writeShort(buffer, (event.entity << 3) | event.channel) end if
  if (flags & sseqc.SND_POS) != 0 then sseqmsg.writePos(buffer, event.position) end if
  return sseqsz.dataSlice(buffer)
end function

function encodeAll(events)
  fragments = []
  previousSerial = -1
  for each event in events
    if typeof(event.serial) != "int" or event.serial <= previousSerial then
      return error(3919, "pending sound ordering is malformed")
    end if
    fragments = fragments + [encode(event)]
    previousSerial = event.serial
  end for
  return fragments
end function

function packetize(fragments, maximumPayload)
  if typeof(maximumPayload) != "int" or maximumPayload < MAX_SOUND_FRAGMENT_BYTES then
    return error(3920, "sound packet payload capacity is too small")
  end if
  packets = []
  buffer = sseqsz.alloc(maximumPayload)
  for each fragment in fragments
    if typeof(fragment) != "bytes" or len(fragment) < 3 or len(fragment) > maximumPayload then
      return error(3921, "malformed encoded sound fragment")
    end if
    if buffer.curSize + len(fragment) > maximumPayload then
      packets = packets + [sseqsz.dataSlice(buffer)]
      sseqsz.clear(buffer)
    end if
    sseqsz.writeBytes(buffer, fragment)
  end for
  if buffer.curSize > 0 then packets = packets + [sseqsz.dataSlice(buffer)] end if
  return packets
end function
