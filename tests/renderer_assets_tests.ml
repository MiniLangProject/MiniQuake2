/* RefImport-backed model/picture registry tests without retail assets. */
import miniquake2.qcommon.byteio as tbio
import miniquake2.format.constants as fc
import miniquake2.renderer.assets as rassets

struct TestImports
  fsLoadFile
end struct

function assertEqual(actual, expected, name)
  if actual != expected then return error(7997, name + ": expected " + expected + ", got " + actual) end if
end function

function spriteBytes()
  data = bytes(92)
  tbio.putU32(data, 0, fc.IDSPRITEHEADER); tbio.putI32(data, 4, fc.SPRITE_VERSION); tbio.putI32(data, 8, 1)
  tbio.putI32(data, 12, 32); tbio.putI32(data, 16, 16); tbio.putI32(data, 20, 4); tbio.putI32(data, 24, 8)
  name = bytes("sprites/frame.pcx"); tbio.copyInto(data, 28, name, 0, len(name))
  return data
end function

function pcxBytes()
  data = bytes(129)
  data[0] = 0x0a; data[1] = 5; data[2] = 1; data[3] = 8
  data[65] = 1; tbio.putU16(data, 66, 1); data[128] = 7
  return data
end function

function loadFile(name)
  if name == "sprites/test.sp2" then return spriteBytes() end if
  if name == "pics/test.pcx" then return pcxBytes() end if
  return void
end function

registry = rassets.create()
imports = TestImports(loadFile)
sprite = rassets.registerModel(registry, imports, "sprites/test.sp2")
assertEqual(sprite.kind, "sprite", "sprite kind")
assertEqual(sprite.source.frames[0].width, 32, "sprite width")
assertEqual(rassets.registerModel(registry, imports, "sprites/test.sp2").handle.id, sprite.handle.id, "model dedupe")
picture = rassets.registerPicture(registry, imports, "pics/test.pcx")
assertEqual(picture.kind, "pcx", "picture kind")
assertEqual(picture.source.pixels[0], 7, "picture pixels")
shortPicture = rassets.registerPicture(registry, imports, "test")
assertEqual(shortPicture.kind, "pcx", "extension-less picture kind")
assertEqual(shortPicture.handle.name, "test", "public picture name retained")
assertEqual(typeof(try(rassets.registerModel(registry, imports, "models/missing.md2"))), "error", "missing model rejected")
print("MiniQuake2 renderer asset tests passed: 1")
