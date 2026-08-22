/* Real UDP UserCmd -> PMove/weapon/snapshot physical playtest gate. */
import miniquake2.runtime.campaign_playtest as physicalinputplaytest
import miniquake2.runtime.play_session as physicalinputsession

function physicalInputAssert(value, message)
  if value != true then return error(8494, message) end if
  return true
end function

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

function physicalInputRetail(baseDirectory)
  physicalInputRetailSession = physicalinputsession.createRetailAtSkill(baseDirectory,
    "base1", "", "\\name\\PhysicalRetail\\skin\\male/grunt\\rate\\25000", 0)
  physicalinputsession.runUntilActive(physicalInputRetailSession, 512)
  physicalInputRetailReport = physicalinputplaytest.drive(physicalInputRetailSession, 48)
  physicalInputCheck(physicalInputRetailReport, "retail base1 physical input")
  print("runtime_campaign_physical_input_tests: retail base1 PASS" +
    " displacement2=" + physicalInputRetailReport.planarDisplacement +
    " fire=" + physicalInputRetailReport.fireCount +
    " items=" + physicalInputRetailReport.itemDelta +
    " health=" + physicalInputRetailReport.health +
    " snapshots=" + physicalInputRetailReport.snapshots +
    " packets=" + physicalInputRetailReport.packets)
  physicalinputsession.shutdown(physicalInputRetailSession)
  return true
end function

function main(args)
  if len(args) > 1 then return error(8495, "expected optional Quake II install root") end if
  physicalInputCore()
  if len(args) == 1 then physicalInputRetail(args[0]) end if
  print("runtime_campaign_physical_input_tests: PASS")
  return 0
end function
