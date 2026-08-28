/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Real UDP UserCmd -> PMove/weapon/snapshot physical playtest gate. */
import miniquake2.runtime.campaign_playtest as physicalinputplaytest
import miniquake2.runtime.play_session as physicalinputsession
import miniquake2.game.null_game as physicalinputgame
import miniquake2.game.integration.baseq2 as physicalinputintegration
import miniquake2.game.world.constants as physicalinputworldconstants
import miniquake2.qcommon.constants as physicalinputqconstants
import miniquake2.qcommon.types as physicalinputqtypes
import miniquake2.game.weapons.constants as physicalinputweaponconstants

// Assert the physical input test condition.
function physicalInputAssert(value, message)
  if value != true then return error(8494, message) end if
  return true
end function

// Validate physical input.
function physicalInputCheck(report, label)
  physicalInputAssert(report.planarDisplacement > 64.0,
    label + " did not move through PMove")
  physicalInputAssert(report.fireCount > 0,
    label + " did not fire through decoded UserCmd")
  physicalInputAssert(report.snapshots > 0,
    label + " did not publish snapshots")
  physicalInputAssert(report.packets > 0 and report.rejectedPackets == 0,
    label + " transport rejected packets")
  return true
end function

// Return the physical input core value.
function physicalInputCore()
  physicalInputEntities = "{\"classname\" \"worldspawn\"}" +
    "{\"classname\" \"info_player_start\" \"origin\" \"0 0 64\" \"angle\" \"0\"}" +
    "{\"classname\" \"ammo_shells\" \"origin\" \"64 0 64\"}"
  physicalInputCoreSession = physicalinputsession.createCoreAtSkill("physical-input",
    physicalInputEntities, void, "",
    "\\name\\PhysicalInput\\skin\\male/grunt\\rate\\25000", 0)
  physicalinputsession.runUntilActive(physicalInputCoreSession, 512)
  physicalInputCoreReport = physicalinputplaytest.drive(physicalInputCoreSession, 48)
  physicalInputCheck(physicalInputCoreReport, "core physical input")
  physicalinputsession.shutdown(physicalInputCoreSession)
  return true
end function

// Return the physical input retail value.
function physicalInputRetail(baseDirectory)
  physicalInputRetailSession = physicalinputsession.createRetailAtSkill(baseDirectory,
    "base1", "", "\\name\\PhysicalRetail\\skin\\male/grunt\\rate\\25000", 0)
  physicalinputsession.runUntilActive(physicalInputRetailSession, 512)
  physicalInputRetailReport = physicalinputplaytest.drive(physicalInputRetailSession, 48)
  physicalInputCheck(physicalInputRetailReport, "retail base1 physical input")
  // Exercise the shipped base1 entity graph, not only synthetic doors and
  // barrels. Untargeted func_door teams must own linked touch fields around
  // their real BSP bounds, and a stock explobox must publish BecomeExplosion2.
  physicalInputRetailRuntime = physicalinputgame.baseRuntime()
  physicalInputRetailPlayer = physicalinputgame.playerContext().players[0]
  physicalInputRetailDoorTrigger = void
  physicalInputRetailBarrel = void
  physicalInputRetailDoorTriggerCount = 0
  for each physicalInputRetailEntity in physicalInputRetailRuntime.world.entities
    if physicalInputRetailEntity.className == "door_trigger" then
      physicalInputRetailDoorTriggerCount = physicalInputRetailDoorTriggerCount + 1
      if physicalInputRetailDoorTrigger is void then
        physicalInputRetailDoorTrigger = physicalInputRetailEntity
      end if
    else if physicalInputRetailEntity.className == "misc_explobox" and
        physicalInputRetailBarrel is void then
      physicalInputRetailBarrel = physicalInputRetailEntity
    end if
  end for
  physicalInputAssert(physicalInputRetailDoorTriggerCount >= 2 and
    physicalInputRetailDoorTrigger is not void and
    physicalInputRetailDoorTrigger.owner is not void,
    "retail base1 did not create its automatic door touch fields")
  physicalInputRetailDoor = physicalInputRetailDoorTrigger.owner
  physicalInputAssert(physicalInputRetailDoor.absoluteMaxs.x >
      physicalInputRetailDoor.absoluteMins.x and
    physicalInputRetailDoorTrigger.mins.x <=
      physicalInputRetailDoor.absoluteMins.x - 60.0,
    "retail base1 door touch field does not enclose its linked BSP bounds")
  physicalInputAssert(physicalinputintegration.touchWorld(
      physicalInputRetailRuntime, physicalInputRetailDoorTrigger,
      physicalInputRetailPlayer) and
    physicalInputRetailDoor.moveInfo.state ==
      physicalinputworldconstants.STATE_UP,
    "retail base1 automatic door did not open on player touch")

  physicalInputAssert(physicalInputRetailBarrel is not void,
    "retail base1 contains no explobox regression target")
  physicalInputRetailPlayerProxy = physicalinputintegration.playerWorldProxy(
    physicalInputRetailPlayer)
  physicalInputRetailMulticastBefore = len(
    physicalInputRetailSession.server.bridgeRuntime.pendingMulticasts)
  physicalinputintegration.integratedWorldDamage(physicalInputRetailBarrel,
    physicalInputRetailPlayerProxy, physicalInputRetailPlayerProxy, 15,
    physicalinputworldconstants.MOD_EXPLOSIVE)
  physicalInputAssert(physicalInputRetailBarrel.health <= 0 and
    physicalInputRetailBarrel.inUse,
    "retail base1 barrel did not enter its delayed explosion")
  physicalinputgame.RunFrame()
  physicalinputgame.RunFrame()
  physicalInputRetailMulticasts = physicalInputRetailSession.server.bridgeRuntime.pendingMulticasts
  physicalInputAssert(not physicalInputRetailBarrel.inUse and
    len(physicalInputRetailMulticasts) > physicalInputRetailMulticastBefore,
    "retail base1 barrel did not complete a visible explosion")
  physicalInputRetailExplosion = physicalInputRetailMulticasts[
    len(physicalInputRetailMulticasts) - 1]
  physicalInputAssert(physicalInputRetailExplosion.payload[0] ==
      physicalinputqconstants.SVC_TEMP_ENTITY and
    physicalInputRetailExplosion.payload[1] ==
      physicalinputweaponconstants.TE_EXPLOSION2,
    "retail base1 barrel emitted the wrong explosion protocol event")
  print("runtime_campaign_physical_input_tests: retail base1 PASS" +
    " displacement2=" + physicalInputRetailReport.planarDisplacement +
    " fire=" + physicalInputRetailReport.fireCount +
    " items=" + physicalInputRetailReport.itemDelta +
    " health=" + physicalInputRetailReport.health +
    " snapshots=" + physicalInputRetailReport.snapshots +
    " packets=" + physicalInputRetailReport.packets)
  physicalinputsession.shutdown(physicalInputRetailSession)

  // base1 exits through a downward shaft into base2$base1. The named base2
  // spawn sits inside the receiving func_door elevator, so real zero-input
  // PMove frames must settle on that inline brush instead of falling through
  // it while the new level finishes its first server frames.
  physicalInputElevatorSession = physicalinputsession.createRetailAtSkill(
    baseDirectory, "base2", "base1",
    "\\name\\ElevatorRetail\\skin\\male/grunt\\rate\\25000", 0)
  physicalinputsession.runUntilActive(physicalInputElevatorSession, 512)
  physicalInputElevatorRuntime = physicalinputgame.baseRuntime()
  physicalInputElevatorPlayer = physicalinputgame.playerContext().players[0]
  physicalInputElevator = void
  for each physicalInputElevatorEntity in physicalInputElevatorRuntime.world.entities
    if physicalInputElevatorEntity.className == "func_door" and
        physicalInputElevatorEntity.targetName == "t7" then
      physicalInputElevator = physicalInputElevatorEntity
    end if
  end for
  physicalInputAssert(physicalInputElevator is not void,
    "retail base2 receiving elevator is missing")
  physicalInputElevatorStartZ = physicalInputElevatorPlayer.edict.state.origin.z
  physicalInputElevatorMinimumZ = physicalInputElevatorStartZ
  physicalInputElevatorStep = 0
  while physicalInputElevatorStep < 40
    physicalinputsession.setUserCmd(physicalInputElevatorSession,
      physicalinputqtypes.UserCmd(100, 0, [0, 0, 0], 0, 0, 0, 0, 0))
    physicalinputsession.step(physicalInputElevatorSession)
    if physicalInputElevatorPlayer.edict.state.origin.z <
        physicalInputElevatorMinimumZ then
      physicalInputElevatorMinimumZ = physicalInputElevatorPlayer.edict.state.origin.z
    end if
    physicalInputElevatorStep = physicalInputElevatorStep + 1
  end while
  physicalInputAssert(physicalInputElevatorPlayer.health > 0 and
    physicalInputElevatorMinimumZ >= -263.0 and
    physicalInputElevatorPlayer.edict.state.origin.z >= -263.0,
    "retail base2 player fell through the receiving elevator")
  physicalInputElevatorRestZ = physicalInputElevatorPlayer.edict.state.origin.z
  physicalInputElevatorBrushStartZ = physicalInputElevator.origin.z
  physicalInputElevatorProxy = physicalinputintegration.playerWorldProxy(
    physicalInputElevatorPlayer)
  physicalInputElevator.use(physicalInputElevator, physicalInputElevatorProxy,
    physicalInputElevatorProxy, physicalInputElevatorRuntime.world)
  physicalInputElevatorStep = 0
  while physicalInputElevatorStep < 90
    physicalinputsession.setUserCmd(physicalInputElevatorSession,
      physicalinputqtypes.UserCmd(100, 0, [0, 0, 0], 0, 0, 0, 0, 0))
    physicalinputsession.step(physicalInputElevatorSession)
    physicalInputElevatorStep = physicalInputElevatorStep + 1
  end while
  print("runtime_campaign_physical_input_tests: retail base2 elevator cycle" +
    " rest-z=" + physicalInputElevatorRestZ +
    " player-z=" + physicalInputElevatorPlayer.edict.state.origin.z +
    " start-brush-z=" + physicalInputElevatorBrushStartZ +
    " brush-z=" + physicalInputElevator.origin.z)
  physicalInputAssert(physicalInputElevator.origin.z ==
      physicalInputElevatorBrushStartZ and
    physicalInputElevatorPlayer.edict.state.origin.z >=
      physicalInputElevatorRestZ - 1.0 and
    physicalInputElevatorPlayer.edict.state.origin.z <=
      physicalInputElevatorRestZ + 1.0,
    "retail base2 elevator moved through its player rider")
  print("runtime_campaign_physical_input_tests: retail base2 elevator PASS" +
    " start-z=" + physicalInputElevatorStartZ +
    " minimum-z=" + physicalInputElevatorMinimumZ +
    " end-z=" + physicalInputElevatorPlayer.edict.state.origin.z +
    " brush-z=" + physicalInputElevator.origin.z)
  physicalinputsession.shutdown(physicalInputElevatorSession)
  return true
end function

// Run this source file's command-line entry point.
function main(args)
  if len(args) > 1 then return error(8495, "expected optional Quake II install root") end if
  physicalInputCore()
  if len(args) == 1 then physicalInputRetail(args[0]) end if
  print("runtime_campaign_physical_input_tests: PASS")
  return 0
end function
