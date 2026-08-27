/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-free DM2 session timing, dispatch and malformed coverage. */
import miniquake2.qcommon.constants as demosessiontestqc
import miniquake2.qcommon.message as demosessiontestmessage
import miniquake2.qcommon.sizebuf as demosessiontestsizebuf
import miniquake2.network.runtime.messages as demosessiontestmessages
import miniquake2.protocol.types as demosessiontestprotocoltypes
import miniquake2.server.snapshot as demosessiontestsnapshot
import miniquake2.client.demo as demosessiontestdemo
import miniquake2.runtime.demo_session as demosessiontestsession
import miniquake2.qcommon.filesystem as demosessiontestfilesystem

// Assert the demo session test condition.
function demoSessionAssert(value, name)
  if not value then return error(9946, name) end if
  return true
end function

// Return the demo session packet value.
function demoSessionPacket(buffer)
  return demosessiontestsizebuf.dataSlice(buffer)
end function

// Return the demo session fixture value.
function demoSessionFixture()
  demoSessionFixtureDemo = demosessiontestdemo.create()
  demoSessionFixtureSetup = demosessiontestsizebuf.alloc(1400)
  demosessiontestmessages.writeServerData(demoSessionFixtureSetup,
    7, true, "baseq2", -1, "Demo Unit")
  demosessiontestmessages.writeConfigString(demoSessionFixtureSetup,
    demosessiontestqc.CS_MODELS + 1, "maps/demo.bsp")
  demosessiontestmessages.writeConfigString(demoSessionFixtureSetup,
    demosessiontestqc.CS_NAME, "Demo Unit")
  demosessiontestdemo.append(demoSessionFixtureDemo,
    demoSessionPacket(demoSessionFixtureSetup))

  demoSessionFixtureHistory = demosessiontestsnapshot.createHistory(1)
  demoSessionFixturePlayer = demosessiontestprotocoltypes.zeroPlayerState()
  demoSessionFixturePlayer.fov = 90.0
  demoSessionFixturePlayer.stats[0] = 100
  demoSessionFixtureEntity = demosessiontestprotocoltypes.zeroEntityState()
  demoSessionFixtureEntity.number = 1
  demoSessionFixtureEntity.modelIndex = 1
  demoSessionFixtureFrame = demosessiontestsnapshot.addFrame(
    demoSessionFixtureHistory, 1, bytes(), demoSessionFixturePlayer,
    [demoSessionFixtureEntity])
  demoSessionFixtureWire = demosessiontestsizebuf.alloc(1400)
  demosessiontestsnapshot.writeFrame(demoSessionFixtureHistory,
    demoSessionFixtureFrame, -1, 0, demoSessionFixtureWire)
  demosessiontestdemo.append(demoSessionFixtureDemo,
    demoSessionPacket(demoSessionFixtureWire))
  return demosessiontestdemo.encodeDemo(demoSessionFixtureDemo)
end function

// Return the demo session retail value.
function demoSessionRetail(root)
  demoSessionRetailFileSystem = demosessiontestfilesystem.initialize(root, "")
  demoSessionRetailNames = ["demo1.dm2", "demo2.dm2"]
  demoSessionRetailIndex = 0
  while demoSessionRetailIndex < len(demoSessionRetailNames)
    demoSessionRetailName = demoSessionRetailNames[demoSessionRetailIndex]
    demoSessionRetailData = demosessiontestfilesystem.readFile(
      demoSessionRetailFileSystem, "demos/" + demoSessionRetailName)
    demoSessionRetailRuntime = demosessiontestsession.create(
      demoSessionRetailData, 100 + demoSessionRetailIndex)
    demoSessionRetailSteps = 0
    demoSessionRetailNow = 0
    while not demoSessionRetailRuntime.finished
      demoSessionRetailStep = demosessiontestsession.step(
        demoSessionRetailRuntime, demoSessionRetailNow)
      demoSessionAssert(demoSessionRetailStep is not void,
        "retail demo ended without a terminal step")
      demoSessionRetailSteps = demoSessionRetailSteps + demoSessionRetailStep.frames
      demoSessionRetailNow = demoSessionRetailNow + 100
    end while
    demoSessionAssert(demoSessionRetailRuntime.framesRead > 100 and
      demoSessionRetailSteps == demoSessionRetailRuntime.framesRead,
      "retail demo did not replay its snapshots")
    demoSessionAssert(demosessiontestsession.mapModelPath(
      demoSessionRetailRuntime) != "", "retail demo map model")
    print "  " + demoSessionRetailName + " packets=" +
      demoSessionRetailRuntime.packetsRead + " frames=" +
      demoSessionRetailRuntime.framesRead + " map=" +
      demosessiontestsession.mapModelPath(demoSessionRetailRuntime)
    demoSessionRetailIndex = demoSessionRetailIndex + 1
  end while
  return true
end function

// Run this source file's command-line entry point.
function main(args)
  demoSessionRuntime = demosessiontestsession.create(demoSessionFixture(), 17)
  demoSessionStep = demosessiontestsession.step(demoSessionRuntime, 100)
  demoSessionAssert(demoSessionStep.packets == 2 and demoSessionStep.frames == 1,
    "setup packets were not consumed through the first frame")
  demoSessionAssert(demoSessionStep.handoff is not void and
    demoSessionStep.handoff.snapshot.number == 1 and
    demoSessionStep.handoff.snapshot.playerState.stats[0] == 100,
    "first atomic frame handoff")
  demoSessionAssert(demosessiontestsession.mapModelPath(demoSessionRuntime) ==
    "maps/demo.bsp" and demosessiontestsession.levelName(demoSessionRuntime) ==
    "Demo Unit", "demo metadata")
  demoSessionAssert(demoSessionRuntime.finished and
    demosessiontestsession.step(demoSessionRuntime, 200) is void,
    "demo terminal state")
  demoSessionAssert(try(demosessiontestsession.create(bytes([1, 2, 3]), 1)) is error,
    "malformed demo rejected")
  if len(args) == 1 then
    demoSessionRetail(args[0])
    print "runtime_demo_session_tests: PASS (synthetic + retail)"
  else
    if len(args) != 0 then return error(9947, "expected optional Quake II install root") end if
    print "runtime_demo_session_tests: PASS (synthetic)"
  end if
  return 0
end function
