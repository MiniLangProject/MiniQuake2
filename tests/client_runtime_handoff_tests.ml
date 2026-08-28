/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Atomic snapshot/effects/UI handoff and replay guard coverage. */
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.qcommon.message as qmsg
import miniquake2.qcommon.types as qt
import miniquake2.protocol.types as pt
import miniquake2.network.constants as nc
import miniquake2.network.client as nclient
import miniquake2.network.runtime.types as nrtypes
import miniquake2.client.effects.state as cestate
import miniquake2.client.runtime.dispatcher as crdispatcher
import miniquake2.client.runtime.handoff as crhandoff
import miniquake2.client.runtime.types as crtypes
import miniquake2.client.state as cstate

// Assert the handoff test condition.
function handoffAssert(value, name)
  if not value then return error(8395, name) end if
  return true
end function

networkClient = nclient.create(0x4321, 5000)
networkClient.state = nc.CA_ACTIVE
runtime = crdispatcher.create(nrtypes.createClient(networkClient), cstate.create(), cestate.createSilent(23))

snapshot = crtypes.Snapshot(7, -1, 0, bytes([3]), pt.zeroPlayerState(), [])
cstate.acceptSnapshot(runtime.client, snapshot)
runtime.network.configStrings[qc.CS_NAME] = "Atomic Unit"
cestate.addDLight(runtime.effects, 7, qt.vec3(1.0, 2.0, 3.0), 120.0,
  [1.0, 0.5, 0.25], 1000.0, 0.0)
cestate.addExplosion(runtime.effects, "unit", qt.vec3(4.0, 5.0, 6.0),
  "models/unit.md2", 8, 200.0, [1.0, 0.5, 0.0], 0, 1.0)
runtime.effects.soundEvents = runtime.effects.soundEvents + [
  miniquake2.client.effects.types.SoundEvent(qt.vec3(7.0, 8.0, 9.0), 1, 0, 3, "unit.wav", 1.0, 1.0, 0.0)]
runtime.prints = [crtypes.PrintHandoff(qc.PRINT_HIGH, "atomic print", 90, false)]
runtime.centerPrints = [crtypes.CenterPrintHandoff("atomic center", 91)]
runtime.layouts = [crtypes.LayoutHandoff("xv 0 string atomic", 92)]
inventory = array(qc.MAX_ITEMS, 0)
inventory[3] = 17
runtime.inventories = [crtypes.InventoryHandoff(inventory, 93)]

frame = crhandoff.commit(runtime, 100)
handoffAssert(frame is not void, "new snapshot was not committed")
handoffAssert(frame.frameNumber == 7 and frame.snapshot.number == 7, "snapshot identity missing")
handoffAssert(frame.configStrings[qc.CS_NAME] == "Atomic Unit", "configstrings missing")
handoffAssert(len(frame.dLights) == 1 and len(frame.explosions) == 1,
  "persistent effect view missing")
handoffAssert(len(frame.sounds) == 1 and frame.sounds[0].soundName == "unit.wav", "audio handoff missing")
handoffAssert(len(frame.prints) == 1 and len(frame.centerPrints) == 1 and
  len(frame.layouts) == 1 and len(frame.inventories) == 1, "UI handoff missing")
handoffAssert(frame.inventories[0].values[3] == 17, "inventory data missing")
handoffAssert(len(runtime.effects.soundEvents) == 0 and len(runtime.prints) == 0,
  "transient queues were not drained")
handoffAssert(len(runtime.effects.dLights) == 1 and len(runtime.effects.explosions) == 1,
  "persistent effects were drained")

// Published snapshots are immutable, config strings are a current same-thread
// view, and transient queues transfer ownership without copying renderer state.
runtime.network.configStrings[qc.CS_NAME] = "mutated"
runtime.effects.dLights[0].origin.x = 99.0
runtime.effects.explosions[0].origin.y = 99.0
handoffAssert(frame.configStrings[qc.CS_NAME] == "mutated", "configstring view went stale")
handoffAssert(frame.inventories[0].values[3] == 17, "inventory copy was aliased")

handoffAssert(crhandoff.commit(runtime, 101) is void, "same snapshot committed twice")
handoffAssert(crhandoff.pending(runtime) == 1, "duplicate commit changed queue")

// Dispatcher-level stale packets are rejected before one-shot state changes.
nop = qsz.alloc(8)
qmsg.writeByte(nop, qc.SVC_NOP)
accepted = crdispatcher.dispatch(runtime, qsz.dataSlice(nop), 20, 102)
handoffAssert(accepted.accepted, "fresh dispatcher packet rejected")
duplicate = crdispatcher.dispatch(runtime, qsz.dataSlice(nop), 20, 103)
handoffAssert(not duplicate.accepted and duplicate.reason == "stale-or-duplicate",
  "duplicate dispatcher packet accepted")
late = crdispatcher.dispatch(runtime, qsz.dataSlice(nop), 19, 104)
handoffAssert(not late.accepted and late.reason == "stale-or-duplicate", "late dispatcher packet accepted")
handoffAssert(crhandoff.pending(runtime) == 1, "replay changed handoff queue")
handoffAssert(crhandoff.take(runtime).serial == 0 and crhandoff.pending(runtime) == 0,
  "handoff take order is not deterministic")

// Latest consumption must select the newest immutable snapshot while merging
// every transient packet event in receive order.
second = crtypes.Snapshot(8, 7, 0, bytes(), pt.zeroPlayerState(), [])
cstate.acceptSnapshot(runtime.client, second)
runtime.effects.soundEvents = [
  miniquake2.client.effects.types.SoundEvent(void, 1, 0, 1, "first.wav", 1.0, 1.0, 0.0)]
runtime.prints = [crtypes.PrintHandoff(qc.PRINT_HIGH, "first", 110, false)]
crhandoff.commit(runtime, 110)
third = crtypes.Snapshot(9, 8, 0, bytes(), pt.zeroPlayerState(), [])
cstate.acceptSnapshot(runtime.client, third)
runtime.effects.soundEvents = [
  miniquake2.client.effects.types.SoundEvent(void, 1, 0, 2, "second.wav", 1.0, 1.0, 0.0)]
runtime.prints = [crtypes.PrintHandoff(qc.PRINT_HIGH, "second", 120, false)]
crhandoff.commit(runtime, 120)
latest = crhandoff.takeLatest(runtime)
handoffAssert(latest.frameNumber == 9 and latest.snapshot.number == 9,
  "takeLatest returned an old snapshot")
handoffAssert(len(latest.sounds) == 2 and latest.sounds[0].soundName == "first.wav" and
  latest.sounds[1].soundName == "second.wav", "takeLatest lost or reordered sounds")
handoffAssert(len(latest.prints) == 2 and latest.prints[0].text == "first" and
  latest.prints[1].text == "second", "takeLatest lost or reordered UI events")
handoffAssert(crhandoff.pending(runtime) == 0, "takeLatest retained stale handoffs")

print("client_runtime_handoff_tests: PASS")
