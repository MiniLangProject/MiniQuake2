/* Product-facing record/stop DM2 lifecycle with original startup state. */
package miniquake2.client.demo_recording

import std.fs as demorecordfs
import miniquake2.qcommon.constants as demorecordqc
import miniquake2.qcommon.sizebuf as demorecordsizebuf
import miniquake2.network.constants as demorecordnetworkconstants
import miniquake2.network.runtime.messages as demorecordmessages
import miniquake2.client.demo as demorecorddemo
import miniquake2.client.runtime.dispatcher as demorecorddispatcher

extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool

struct DemoRecording
  runtime
  directory
  name
  path
  demo
  active
end struct

function create(runtime, directory)
  if runtime is void or typeof(directory) != "string" or directory == "" then
    return error(7710, "demo recording runtime/directory unavailable")
  end if
  return DemoRecording(runtime, directory, "", "", void, false)
end function

function safeName(name)
  if typeof(name) != "string" or len(bytes(name)) < 1 or len(bytes(name)) > 48 then
    return false
  end if
  for each value in bytes(name)
    allowed = (value >= 48 and value <= 57) or
      (value >= 65 and value <= 90) or (value >= 97 and value <= 122) or
      value == 45 or value == 95
    if not allowed then return false end if
  end for
  return true
end function

function ensureDirectory(path)
  if demorecordfs.isDir(path) then return true end if
  if demorecordfs.exists(path) then return error(7711, "demo directory path is not a directory") end if
  if not CreateDirectoryW(path, 0) and not demorecordfs.isDir(path) then
    return error(7712, "could not create demo directory")
  end if
  return true
end function

function appendBuffer(demo, buffer)
  data = demorecordsizebuf.dataSlice(buffer)
  if len(data) > 0 then demorecorddemo.append(demo, data) end if
  return true
end function

function appendStartup(recording)
  runtime = recording.runtime
  network = runtime.network
  startup = demorecordsizebuf.alloc(demorecordqc.MAX_MSGLEN)
  // Original CL_Record_f creates an attract-loop epoch distinct from the live
  // server count while preserving the current player slot and level name.
  demorecordmessages.writeServerData(startup,
    0x10000 + network.spawnCount, true, network.gameDir,
    network.playerNumber, network.levelName)
  appendBuffer(recording.demo, startup)

  index = 0
  while index < len(network.configStrings)
    value = network.configStrings[index]
    if value != "" then
      buffer = demorecordsizebuf.alloc(demorecordqc.MAX_MSGLEN)
      demorecordmessages.writeConfigString(buffer, index, value)
      appendBuffer(recording.demo, buffer)
    end if
    index = index + 1
  end while
  index = 1
  while index < len(network.baselines)
    baseline = network.baselines[index]
    if baseline.modelIndex != 0 then
      buffer = demorecordsizebuf.alloc(512)
      demorecordmessages.writeSpawnBaseline(buffer, baseline)
      appendBuffer(recording.demo, buffer)
    end if
    index = index + 1
  end while
  precache = demorecordsizebuf.alloc(32)
  demorecordmessages.writeStuffText(precache, "precache\n")
  appendBuffer(recording.demo, precache)
  return true
end function

function start(recording, name)
  if recording.active then return error(7713, "already recording a demo") end if
  if not safeName(name) then return error(7714, "demo name must use letters, digits, '-' or '_'") end if
  if recording.runtime.network.client.state != demorecordnetworkconstants.CA_ACTIVE or
      recording.runtime.client.current is void then
    return error(7715, "a demo can only be recorded in an active level")
  end if
  ensureDirectory(recording.directory)
  recording.name = name
  recording.path = demorecordfs.joinPath(recording.directory, name + ".dm2")
  recording.demo = demorecorddemo.create()
  appendStartup(recording)
  demorecorddemo.beginLiveRecording(recording.demo)
  demorecorddispatcher.setDemoRecorder(recording.runtime, recording.demo)
  recording.active = true
  return recording.path
end function

function stop(recording)
  if not recording.active then return error(7716, "not recording a demo") end if
  demorecorddispatcher.setDemoRecorder(recording.runtime, void)
  recording.active = false
  encoded = demorecorddemo.encodeDemo(recording.demo)
  temporary = recording.path + ".tmp"
  written = try(demorecordfs.writeAllBytes(temporary, encoded))
  if written is error then return written end if
  verified = try(demorecorddemo.decodeDemo(demorecordfs.readAllBytes(temporary)))
  if verified is error or len(verified.packets) !=
      demorecorddemo.packetCount(recording.demo) then
    demorecordfs.delete(temporary)
    return error(7717, "temporary demo verification failed")
  end if
  moved = try(demorecordfs.moveFile(temporary, recording.path, true))
  if moved is error then demorecordfs.delete(temporary); return moved end if
  return recording.path
end function

function shutdown(recording)
  if recording is void then return false end if
  if recording.active then return stop(recording) end if
  return false
end function
