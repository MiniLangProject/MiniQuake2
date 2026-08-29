/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Real UDP UserCmd -> PMove/weapon/snapshot physical playtest gate. */
import miniquake2.runtime.campaign_playtest as physicalinputplaytest
import miniquake2.runtime.play_session as physicalinputsession
import miniquake2.runtime.server_session as physicalinputserversession
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
  physicalInputRetailCanalButton = void
  physicalInputRetailCanalDoor = void
  physicalInputRetailButtonCount = 0
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
    else if physicalInputRetailEntity.className == "func_button" then
      physicalInputRetailButtonCount = physicalInputRetailButtonCount + 1
      if physicalInputRetailEntity.model == "*34" then
        physicalInputRetailCanalButton = physicalInputRetailEntity
      end if
    else if physicalInputRetailEntity.className == "func_door" and
        physicalInputRetailEntity.model == "*31" then
      physicalInputRetailCanalDoor = physicalInputRetailEntity
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

  // base1 owns two authored func_button inline brushes.  Model *34 is the
  // visible wall switch whose target t4 opens the canal door *31.  Validate
  // the complete retail path: spawn, setmodel bounds, protocol snapshot and
  // touch activation.  A synthetic *1 button cannot catch missing switches in
  // the shipped BSP because it does not exercise its real PVS/area linkage.
  physicalInputAssert(physicalInputRetailButtonCount == 2 and
    physicalInputRetailCanalButton is not void and
    physicalInputRetailCanalDoor is not void,
    "retail base1 canal button or target door is missing")
  physicalInputRetailButtonEdict = physicalInputRetailSession.server.gameExport.edicts[
    physicalInputRetailCanalButton.number]
  physicalInputAssert(physicalInputRetailCanalButton.solid ==
      physicalinputworldconstants.SOLID_BSP and
    physicalInputRetailCanalButton.modelIndex > 0 and
    physicalInputRetailButtonEdict.state.modelIndex ==
      physicalInputRetailCanalButton.modelIndex and
    physicalInputRetailButtonEdict.state.solid == 31 and
    physicalInputRetailButtonEdict.absoluteMaxs.x >
      physicalInputRetailButtonEdict.absoluteMins.x and
    physicalInputRetailButtonEdict.numClusters != 0,
    "retail base1 canal button lost its inline BSP network state" +
    " solid=" + physicalInputRetailCanalButton.solid +
    " model=" + physicalInputRetailCanalButton.modelIndex +
    " state-model=" + physicalInputRetailButtonEdict.state.modelIndex +
    " state-solid=" + physicalInputRetailButtonEdict.state.solid +
    " clusters=" + physicalInputRetailButtonEdict.numClusters +
    " min-x=" + physicalInputRetailButtonEdict.absoluteMins.x +
    " max-x=" + physicalInputRetailButtonEdict.absoluteMaxs.x)
  physicalInputRetailPlayerEdict = physicalInputRetailPlayer.edict
  physicalInputRetailSavedOrigin = physicalInputRetailPlayerEdict.state.origin
  physicalInputRetailButtonCenter = physicalinputqtypes.Vec3(
    (physicalInputRetailButtonEdict.absoluteMins.x +
      physicalInputRetailButtonEdict.absoluteMaxs.x) * 0.5,
    (physicalInputRetailButtonEdict.absoluteMins.y +
      physicalInputRetailButtonEdict.absoluteMaxs.y) * 0.5,
    (physicalInputRetailButtonEdict.absoluteMins.z +
      physicalInputRetailButtonEdict.absoluteMaxs.z) * 0.5)
  physicalInputRetailButtonVisible = false
  physicalInputRetailButtonPacket = []
  physicalInputRetailButtonOffsets = [
    physicalinputqtypes.Vec3(-64.0, 0.0, 0.0),
    physicalinputqtypes.Vec3(64.0, 0.0, 0.0),
    physicalinputqtypes.Vec3(0.0, -64.0, 0.0),
    physicalinputqtypes.Vec3(0.0, 64.0, 0.0),
    physicalinputqtypes.Vec3(0.0, 0.0, 64.0)
  ]
  for each physicalInputRetailButtonOffset in physicalInputRetailButtonOffsets
    physicalInputRetailPlayerEdict.state.origin = physicalinputqtypes.Vec3(
      physicalInputRetailButtonCenter.x + physicalInputRetailButtonOffset.x,
      physicalInputRetailButtonCenter.y + physicalInputRetailButtonOffset.y,
      physicalInputRetailButtonCenter.z + physicalInputRetailButtonOffset.z)
    physicalInputRetailButtonPacket = physicalinputserversession.packetEntitiesForClient(
      physicalInputRetailSession.server, physicalInputRetailPlayerEdict)
    for each physicalInputRetailButtonState in physicalInputRetailButtonPacket
      if physicalInputRetailButtonState.number == physicalInputRetailCanalButton.number then
        physicalInputRetailButtonVisible = true
      end if
    end for
  end for
  physicalInputRetailPlayerEdict.state.origin = physicalInputRetailSavedOrigin
  physicalInputAssert(physicalInputRetailButtonVisible,
    "retail base1 canal button is absent from nearby client snapshots")
  physicalInputRetailCanalDoorStart = physicalinputqtypes.Vec3(
    physicalInputRetailCanalDoor.origin.x,
    physicalInputRetailCanalDoor.origin.y,
    physicalInputRetailCanalDoor.origin.z)
  physicalInputAssert(physicalinputintegration.touchWorld(
      physicalInputRetailRuntime, physicalInputRetailCanalButton,
      physicalInputRetailPlayer) and
    physicalInputRetailCanalButton.moveInfo.state ==
      physicalinputworldconstants.STATE_UP,
    "retail base1 canal button did not react to player touch")
  physicalInputRetailButtonStep = 0
  while physicalInputRetailButtonStep < 20
    physicalinputgame.RunFrame()
    physicalInputRetailButtonStep = physicalInputRetailButtonStep + 1
  end while
  physicalInputAssert(physicalInputRetailCanalDoor.origin.x !=
      physicalInputRetailCanalDoorStart.x or
    physicalInputRetailCanalDoor.origin.y != physicalInputRetailCanalDoorStart.y or
    physicalInputRetailCanalDoor.origin.z != physicalInputRetailCanalDoorStart.z,
    "retail base1 canal button did not open target door t4")

  // Every living base1 monster must remain advertised as damageable and be
  // reachable by the same integrated MASK_SHOT path used by player weapons.
  physicalInputRetailDamageableMonsters = 0
  for each physicalInputRetailActor in physicalInputRetailRuntime.monsters
    if physicalInputRetailActor.edict.inUse and
        physicalInputRetailActor.health > 0 then
      physicalInputRetailTarget = physicalinputintegration.monsterWeaponTarget(
        physicalInputRetailActor)
      physicalInputAssert(physicalInputRetailActor.takeDamage != 0 and
        physicalInputRetailTarget.combatant.takeDamage,
        "retail base1 living monster lost its damageable state")
      physicalInputAssert(physicalInputMonsterReachable(
        physicalInputRetailActor),
        "retail base1 living monster is unreachable by MASK_SHOT")
      physicalInputRetailDamageableMonsters = physicalInputRetailDamageableMonsters + 1
    end if
  end for
  physicalInputAssert(physicalInputRetailDamageableMonsters >= 8,
    "retail base1 exposed too few live monster damage proxies")

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
  physicalInputRetailExplosion = void
  physicalInputRetailMulticastIndex = physicalInputRetailMulticastBefore
  while physicalInputRetailMulticastIndex < len(physicalInputRetailMulticasts)
    physicalInputRetailCandidate = physicalInputRetailMulticasts[
      physicalInputRetailMulticastIndex]
    if len(physicalInputRetailCandidate.payload) >= 2 and
        physicalInputRetailCandidate.payload[0] ==
          physicalinputqconstants.SVC_TEMP_ENTITY and
        physicalInputRetailCandidate.payload[1] ==
          physicalinputweaponconstants.TE_EXPLOSION2 then
      physicalInputRetailExplosion = physicalInputRetailCandidate
    end if
    physicalInputRetailMulticastIndex = physicalInputRetailMulticastIndex + 1
  end while
  physicalInputAssert(physicalInputRetailExplosion is not void,
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

  // The single-player weapon enclosure is authored as a 20-health
  // func_explosive grate (*21). It has no animation flags: the grate must
  // block while intact and open by being shot, not animate as a door. The
  // nearby *11 func_wall owns all three NOT_EASY/MEDIUM/HARD flags and is
  // correctly inhibited outside deathmatch, so it is not part of this gate.
  physicalInputBase2Grate = void
  for each physicalInputBase2Entity in physicalInputElevatorRuntime.world.entities
    if physicalInputBase2Entity.className == "func_explosive" and
        physicalInputBase2Entity.model == "*21" then
      physicalInputBase2Grate = physicalInputBase2Entity
    end if
  end for
  physicalInputAssert(physicalInputBase2Grate is not void and
    physicalInputBase2Grate.solid == physicalinputworldconstants.SOLID_BSP and
    physicalInputBase2Grate.takeDamage == physicalinputworldconstants.DAMAGE_YES,
    "retail base2 weapon grate is not a solid shootable BSP")
  physicalInputBase2GrateTrace = physicalInputElevatorRuntime.playerContext.imports.trace(
    physicalinputqtypes.Vec3(-160.0, -384.0, -128.0),
    physicalinputqtypes.zeroVec3(), physicalinputqtypes.zeroVec3(),
    physicalinputqtypes.Vec3(-112.0, -384.0, -128.0), void,
    physicalinputqconstants.MASK_SOLID)
  physicalInputAssert(physicalInputBase2GrateTrace.entity is not void and
    physicalInputBase2GrateTrace.entity.state.number ==
      physicalInputBase2Grate.number,
    "retail base2 shootable weapon grate does not block movement")
  physicalinputintegration.integratedWorldDamage(physicalInputBase2Grate,
    physicalInputElevatorProxy, physicalInputElevatorProxy, 25,
    physicalinputworldconstants.MOD_EXPLOSIVE)
  physicalinputgame.RunFrame()
  physicalInputAssert(not physicalInputBase2Grate.inUse,
    "retail base2 weapon grate did not open after lethal damage")
  print("runtime_campaign_physical_input_tests: retail base2 elevator PASS" +
    " start-z=" + physicalInputElevatorStartZ +
    " minimum-z=" + physicalInputElevatorMinimumZ +
    " end-z=" + physicalInputElevatorPlayer.edict.state.origin.z +
    " brush-z=" + physicalInputElevator.origin.z)
  physicalinputsession.shutdown(physicalInputElevatorSession)
  return true
end function

// Report whether a short axis-aligned MASK_SHOT ray can reach one live retail
// monster. Trying all six faces distinguishes a broken damage proxy from a
// monster authored flush against nearby BSP geometry.
function physicalInputMonsterReachable(actor)
  center = physicalinputqtypes.Vec3(
    actor.edict.state.origin.x + (actor.edict.mins.x + actor.edict.maxs.x) * 0.5,
    actor.edict.state.origin.y + (actor.edict.mins.y + actor.edict.maxs.y) * 0.5,
    actor.edict.state.origin.z + (actor.edict.mins.z + actor.edict.maxs.z) * 0.5)
  starts = [
    physicalinputqtypes.Vec3(actor.edict.state.origin.x + actor.edict.mins.x - 2.0, center.y, center.z),
    physicalinputqtypes.Vec3(actor.edict.state.origin.x + actor.edict.maxs.x + 2.0, center.y, center.z),
    physicalinputqtypes.Vec3(center.x, actor.edict.state.origin.y + actor.edict.mins.y - 2.0, center.z),
    physicalinputqtypes.Vec3(center.x, actor.edict.state.origin.y + actor.edict.maxs.y + 2.0, center.z),
    physicalinputqtypes.Vec3(center.x, center.y, actor.edict.state.origin.z + actor.edict.mins.z - 2.0),
    physicalinputqtypes.Vec3(center.x, center.y, actor.edict.state.origin.z + actor.edict.maxs.z + 2.0)]
  for each start in starts
    trace = physicalinputintegration.integratedWeaponTrace(start,
      physicalinputqtypes.zeroVec3(), physicalinputqtypes.zeroVec3(), center,
      void, physicalinputqconstants.MASK_SHOT)
    if trace.entity is not void and trace.entity.number ==
        actor.edict.state.number then return true end if
  end for
  return false
end function

// Run this source file's command-line entry point.
function main(args)
  if len(args) > 1 then return error(8495, "expected optional Quake II install root") end if
  physicalInputCore()
  if len(args) == 1 then physicalInputRetail(args[0]) end if
  print("runtime_campaign_physical_input_tests: PASS")
  return 0
end function
