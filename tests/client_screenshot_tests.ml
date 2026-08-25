import miniquake2.client.screenshot as screenshottest
import miniquake2.renderer.capture as screenshottestcapture
import std.fs as screenshottestfs

function screenshotAssert(actual, expected, label)
  if actual != expected then return error(9972, label + ": expected " + expected + ", got " + actual) end if
end function

screenshotAssert(screenshottest.fileName(0), "mq2_0000.tga", "first screenshot")
screenshotAssert(screenshottest.fileName(42), "mq2_0042.tga", "padded screenshot")
screenshotAssert(screenshottest.fileName(9999), "mq2_9999.tga", "last screenshot")
screenshotAssert(typeof(try(screenshottest.fileName(10000))), "error", "overflow rejected")
screenshotState = screenshottest.create("build/client_screenshot_output")
screenshotImage = screenshottestcapture.image(1, 1, bytes([1, 2, 3, 255]))
screenshotPath = screenshottest.writeImage(screenshotState, screenshotImage)
screenshotAssert(screenshottestfs.isFile(screenshotPath), true,
  "screenshot file written")
screenshotAssert(screenshotState.nextIndex, 1, "screenshot index advanced")
screenshottestfs.delete(screenshotPath)
print "MiniQuake2 client screenshot tests passed: 1"
