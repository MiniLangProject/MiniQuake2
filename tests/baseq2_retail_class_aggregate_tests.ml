/* Golden aggregate for the nine formerly skipped retail base1 classnames. */
import miniquake2.game.base.spawn as rcaspawn

function assertEqual(actual, expected, name)
  if actual != expected then return error(9990, name + ": values differ") end if
  return true
end function

function appendEntities(text, className, count)
  index = 0
  while index < count
    text = text + "{ \"classname\" \"" + className + "\" }\n"
    index = index + 1
  end while
  return text
end function

function classCount(result, className)
  count = 0
  for each edict in result.edicts
    if edict.component.className == className then count = count + 1 end if
  end for
  return count
end function

fixture = "{ \"classname\" \"worldspawn\" }\n"
fixture = appendEntities(fixture, "light", 256)
fixture = appendEntities(fixture, "misc_deadsoldier", 12)
fixture = appendEntities(fixture, "misc_explobox", 9)
fixture = appendEntities(fixture, "misc_strogg_ship", 3)
fixture = appendEntities(fixture, "func_wall", 2)
fixture = appendEntities(fixture, "misc_banner", 2)
fixture = appendEntities(fixture, "func_group", 1)
fixture = appendEntities(fixture, "func_rotating", 1)
fixture = appendEntities(fixture, "misc_gib_head", 1)

result = rcaspawn.SpawnEntities("base1", fixture, "")
assertEqual(result.sourceEntityCount, 288, "retail remainder source count plus world")
assertEqual(len(result.edicts), 31, "C-compatible compact live remainder count")
assertEqual(result.skippedEntityCount, 0, "retail remainder skipped count")
assertEqual(len(result.skippedClasses), 0, "retail remainder skipped aggregate")
assertEqual(classCount(result, "light"), 0, "untargeted static lights freed after BSP bake")
assertEqual(classCount(result, "misc_deadsoldier"), 12, "dead soldier aggregate")
assertEqual(classCount(result, "misc_explobox"), 9, "explobox aggregate")
assertEqual(classCount(result, "misc_strogg_ship"), 3, "strogg ship aggregate")
assertEqual(classCount(result, "func_wall"), 2, "wall aggregate")
assertEqual(classCount(result, "misc_banner"), 2, "banner aggregate")
assertEqual(classCount(result, "func_group"), 0, "editor func_group freed")
assertEqual(classCount(result, "func_rotating"), 1, "rotating aggregate")
assertEqual(classCount(result, "misc_gib_head"), 1, "gib head aggregate")
print "MiniQuake2 BaseQ2 retail class aggregate tests passed: 1"
