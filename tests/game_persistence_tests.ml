/* Pointer-free game/level save image roundtrip. */
import miniquake2.game.types as gt
import miniquake2.game.persistence as gpersist

struct TestExport
  edicts
  numEdicts
  maxEdicts
end struct

function assertEqual(actual, expected, name)
  if actual != expected then return error(7990, name + ": expected " + expected + ", got " + actual) end if
end function

function testRoundtrip()
  edicts = array(4)
  index = 0
  while index < 4
    edicts[index] = gt.zeroEdict(index)
    index = index + 1
  end while
  edicts[0].inUse = true
  edicts[1].inUse = true
  edicts[1].state.origin.x = 12.5
  edicts[1].state.modelIndex = 7
  edicts[1].client = gt.zeroGameClient()
  edicts[1].client.ping = 42
  edicts[1].client.playerState.stats[0] = 100
  edicts[2].inUse = true
  edicts[2].owner = edicts[1]
  source = TestExport(edicts, 3, 4)
  encoded = gpersist.encode(source, "level", "unit_test", 123)
  image = gpersist.decode(encoded, 4)
  assertEqual(image.kind, "level", "save kind")
  assertEqual(image.mapName, "unit_test", "map name")
  assertEqual(image.frameNumber, 123, "frame number")
  assertEqual(image.numEdicts, 3, "edict count")
  assertEqual(image.edicts[1].state.origin.x, 12.5, "entity origin")
  assertEqual(image.edicts[1].client.ping, 42, "client ping")
  assertEqual(image.edicts[1].client.playerState.stats[0], 100, "player stats")
  assertEqual(image.edicts[2].owner.state.number, 1, "owner relink")
  broken = bytes(encoded)
  broken[0] = 0
  assertEqual(typeof(try(gpersist.decode(broken, 4))), "error", "bad magic rejected")
end function

testRoundtrip()
print("MiniQuake2 game persistence tests passed: 1")
