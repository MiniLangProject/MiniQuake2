/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Product-level import closure and asset-free capability diagnostics. */
package miniquake2.runtime.diagnostics

import miniquake2.qcommon.checksum as dchecksum
import miniquake2.qcommon.cmd as dcmd
import miniquake2.qcommon.filesystem as dfs
import miniquake2.qcommon.directions as ddirections
import miniquake2.format.bsp as dbsp
import miniquake2.format.md2 as dmd2
import miniquake2.format.cinematic as dcin
import miniquake2.collision.model as dcollision
import miniquake2.platform.system as dsystem
import miniquake2.platform.udp as dudp
import miniquake2.platform.window as dwindow
import miniquake2.audio.device as daudio
import miniquake2.audio.wav as dwav
import miniquake2.audio.mixer as dmixer
import miniquake2.protocol.netchan as dnetchan
import miniquake2.protocol.entity_delta as dentitydelta
import miniquake2.protocol.player_delta as dplayerdelta
import miniquake2.network.client as dnetclient
import miniquake2.network.server as dnetserver
import miniquake2.network.runtime.pump as dnetpump
import miniquake2.physics.pmove as dpmove
import miniquake2.renderer.opengl as dopengl
import miniquake2.renderer.assets as dassets
import miniquake2.renderer.classic.scene as dclassicscene
import miniquake2.renderer.classic.materials as dclassicmaterials
import miniquake2.game.null_game as dgame
import miniquake2.game.persistence as dpersistence
import miniquake2.game.base.spawn as dbasespawn
import miniquake2.game.gameplay.registry as ditemregistry
import miniquake2.game.world.movers as dmovers
import miniquake2.game.ai.archetypes as darchetypes
import miniquake2.game.integration.baseq2 as dbaseintegration
import miniquake2.game.player.frame as dplayerframe
import miniquake2.game.weapons.core as dweaponcore
import miniquake2.game.weapons.hitscan as dweaponhitscan
import miniquake2.game.weapons.projectiles as dweaponprojectiles
import miniquake2.server.game_bridge as dgamebridge
import miniquake2.server.snapshot as dsnapshot
import miniquake2.client.state as dclientstate
import miniquake2.client.demo as dclientdemo
import miniquake2.client.layout as dclientlayout
import miniquake2.client.effects.state as deffectstate
import miniquake2.client.effects.parser as deffectparser
import miniquake2.client.ui.keys as duikeys
import miniquake2.client.ui.input as duiinput
import miniquake2.client.ui.screen as duiscreen
import miniquake2.client.cinematic.player as dcinplayer
import miniquake2.client.cinematic.audio as dcinaudio
import miniquake2.runtime.server_session as dserversession
import miniquake2.runtime.client_session as dclientsession

function capabilityLines()
  // Referencing the public entry points keeps this file an executable linker
  // closure rather than a documentation-only list.
  linked = [
    typeof(dchecksum.blockChecksum), typeof(dcmd.create), typeof(dfs.create),
    typeof(dbsp.parse), typeof(dmd2.parse), typeof(dcin.parseHeader),
    typeof(dcollision.create), typeof(dsystem.createClock), typeof(dudp.open),
    typeof(dwindow.create), typeof(daudio.open), typeof(dwav.parse), typeof(dmixer.create),
    typeof(dnetchan.setup), typeof(dentitydelta.writeDelta), typeof(dplayerdelta.writeMessage),
    typeof(dnetclient.create), typeof(dnetserver.create), typeof(dnetpump.pumpPair), typeof(dnetpump.pumpIntegratedClient),
    typeof(dpmove.move), typeof(dopengl.createOpenGlRenderer), typeof(dassets.create),
    typeof(dclassicscene.prepareMap), typeof(dclassicmaterials.imageFromWal),
    typeof(dgame.GetGameApi), typeof(dpersistence.encode), typeof(dbasespawn.SpawnEntities),
    typeof(ditemregistry.stockRegistry), typeof(dmovers.moveCalc), typeof(darchetypes.defaultRegistry),
    typeof(dbaseintegration.create), typeof(dplayerframe.RunPlayerFrame),
    typeof(dweaponcore.createContext), typeof(dweaponhitscan.fire_bullet), typeof(dweaponprojectiles.fire_rocket),
    typeof(dgamebridge.createRuntime), typeof(dsnapshot.createHistory), typeof(dclientstate.create),
    typeof(dclientdemo.decodeDemo), typeof(dclientlayout.parse),
    typeof(deffectstate.createSilent), typeof(deffectparser.parseServiceCommand),
    typeof(duikeys.createInputState), typeof(duiinput.createUserCmd), typeof(duiscreen.create),
    typeof(dcinplayer.start), typeof(dcinplayer.update), typeof(dcinaudio.mixerHandoff),
    typeof(dserversession.createRetail), typeof(dserversession.step),
    typeof(dclientsession.create), typeof(dclientsession.step),
  ]
  index = 0
  while index < len(linked)
    if linked[index] != "function" then return error(9900, "runtime linker closure contains a non-function entry") end if
    index = index + 1
  end while
  return [
    "qcommon=messages,cvars,commands,pak,md4,crc,bytedirs",
    "formats=bsp38,md2,sp2,wal,pcx,cin,wav",
    "platform=win32-window,input,udp,pcm,opengl11",
    "network=protocol34,netchan,handshake,snapshots,runtime-pump,demos,downloads,headless-client,dedicated-server",
    "renderer=refapi3,assets,bsp-md2-geometry,classic-surfaces,lightmaps,sprites,opengl,headless",
    "client=prediction,effects,audio-handoff,input,console,screen,menus,cinematic-playback",
    "game=api3,integrated-baseq2,players,items,weapons-ballistics,combat,ai,movers,persistence",
    "physics=pmove,collision-model,area-portals",
    "bytedirs=" + len(ddirections.normals),
  ]
end function

function verifyLinkClosure()
  lines = capabilityLines()
  return len(lines) == 9 and len(ddirections.normals) == 162
end function
