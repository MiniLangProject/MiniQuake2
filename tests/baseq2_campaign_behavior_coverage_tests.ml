/* Read-only executable behavior matrix for the 39 Classic baseq2 SP maps. */
import miniquake2.qcommon.filesystem as campaigncoveragefilesystem
import miniquake2.format.bsp as campaigncoveragebsp
import miniquake2.game.base.entity_parser as campaigncoverageparser
import std.string as campaigncoveragestring

struct CampaignCoverageEntry
  className
  instances
  maps
  lastMap
  objective
  monster
  boss
  simplified
  behavior
end struct

function campaignCoverageMaps()
  return [
    "base1", "base2", "base3", "biggun", "boss1", "boss2", "bunk1",
    "city1", "city2", "city3", "command", "cool1", "fact1", "fact2",
    "fact3", "hangar1", "hangar2", "jail1", "jail2", "jail3", "jail4",
    "jail5", "lab", "mine1", "mine2", "mine3", "mine4", "mintro",
    "power1", "power2", "security", "space", "strike", "train", "ware1",
    "ware2", "waste1", "waste2", "waste3",
  ]
end function

function campaignCoverageContains(values, value)
  for each candidate in values
    if candidate == value then return true end if
  end for
  return false
end function

function campaignCoverageBoss(name)
  return campaignCoverageContains([
    "monster_supertank", "monster_boss2", "monster_jorg",
    "monster_boss3_stand", "monster_commander_body", "monster_makron",
  ], name)
end function

function campaignCoverageObjective(name)
  if campaigncoveragestring.startsWith(name, "target_") or campaigncoveragestring.startsWith(name, "trigger_") then return true end if
  return campaignCoverageContains(["func_clock", "func_killbox", "path_corner", "point_combat"], name)
end function

function campaignCoverageSimplified(name)
  return campaignCoverageContains([
    "monster_boss3_stand", "monster_commander_body",
    "turret_base", "turret_breach", "turret_driver",
  ], name)
end function

function campaignCoverageBehavior(name, isMonster, isBoss, isSimplified)
  if isSimplified then return "generic/simplified" end if
  if name == "misc_insane" then return "ai:misc-insane" end if
  if isMonster then
    if name == "monster_jorg" then return "boss-ai+makron-successor" end if
    if campaignCoverageContains([
      "monster_soldier_light", "monster_soldier", "monster_soldier_ss",
      "monster_infantry", "monster_gunner",
    ], name) then return "ai+combat" end if
    if isBoss then return "generic-boss-ai" end if
    return "generic-ai"
  end if
  return "functional-world"
end function

function campaignCoverageFind(entries, name)
  for each entry in entries
    if entry.className == name then return entry end if
  end for
  return void
end function

function campaignCoverageAdd(entries, name, mapName)
  entry = campaignCoverageFind(entries, name)
  if entry is void then
    isMonster = (campaigncoveragestring.startsWith(name, "monster_") and
      name != "monster_boss3_stand" and name != "monster_commander_body") or name == "misc_insane"
    isBoss = campaignCoverageBoss(name)
    isObjective = campaignCoverageObjective(name)
    isSimplified = campaignCoverageSimplified(name)
    entry = CampaignCoverageEntry(name, 0, 0, "", isObjective, isMonster,
      isBoss, isSimplified, campaignCoverageBehavior(name, isMonster, isBoss, isSimplified))
    entries = entries + [entry]
  end if
  entry.instances = entry.instances + 1
  if entry.lastMap != mapName then entry.maps = entry.maps + 1; entry.lastMap = mapName end if
  return entries
end function

function main(args)
  if len(args) > 1 then return error(9840, "expected optional Quake II install root") end if
  maps = campaignCoverageMaps()
  if len(maps) != 39 then return error(9841, "campaign map inventory changed") end if
  if len(args) == 0 then
    // The canonical build must remain asset-free. Exercise the matrix rules
    // with representative campaign classes; passing a legal install root adds
    // the full read-only 39-map aggregate below.
    syntheticEntries = []
    syntheticEntries = campaignCoverageAdd(syntheticEntries, "monster_jorg", "boss2")
    syntheticEntries = campaignCoverageAdd(syntheticEntries, "trigger_counter", "boss2")
    syntheticEntries = campaignCoverageAdd(syntheticEntries, "point_combat", "base1")
    syntheticEntries = campaignCoverageAdd(syntheticEntries, "misc_insane", "jail2")
    jorg = campaignCoverageFind(syntheticEntries, "monster_jorg")
    counter = campaignCoverageFind(syntheticEntries, "trigger_counter")
    point = campaignCoverageFind(syntheticEntries, "point_combat")
    insane = campaignCoverageFind(syntheticEntries, "misc_insane")
    if jorg is void or not jorg.monster or not jorg.boss or jorg.simplified or
        jorg.behavior != "boss-ai+makron-successor" then
      return error(9842, "synthetic boss coverage classification failed")
    end if
    if counter is void or not counter.objective or counter.simplified then
      return error(9843, "synthetic objective coverage classification failed")
    end if
    if point is void or not point.objective or point.simplified or point.behavior != "functional-world" then
      return error(9844, "synthetic point_combat coverage classification failed")
    end if
    if insane is void or not insane.monster or insane.simplified or insane.behavior != "ai:misc-insane" then
      return error(9845, "synthetic misc_insane coverage classification failed")
    end if
    print("baseq2_campaign_behavior_coverage_tests: PASS (asset-free rules)")
    return 0
  end if
  filesystem = campaigncoveragefilesystem.initialize(args[0], "")
  entries = []
  raw = 0
  for each mapName in maps
    path = "maps/" + mapName + ".bsp"
    map = campaigncoveragebsp.parse(campaigncoveragefilesystem.readFile(filesystem, path), path)
    entities = campaigncoverageparser.parseMaterializedEntities(map.entityText)
    raw = raw + len(entities)
    for each entity in entities
      entries = campaignCoverageAdd(entries, entity.className, mapName)
      if campaignCoverageBoss(entity.className) then
        print("  boss-instance map=" + mapName + " class=" + entity.className +
          " target=" + entity.target + " deathtarget=" + entity.deathTarget)
      end if
      if mapName == "boss2" and (entity.target == "t26" or entity.targetName == "t26") then
        print("  endgame-link class=" + entity.className + " target=" + entity.target +
          " targetname=" + entity.targetName + " map=" + entity.map)
      end if
    end for
  end for
  if raw != 34298 then return error(9845, "campaign coverage retail aggregate changed") end if

  objectiveInstances = 0; objectiveClasses = 0
  monsterInstances = 0; monsterClasses = 0
  bossInstances = 0; bossClasses = 0
  simplifiedInstances = 0; simplifiedClasses = 0
  print("baseq2_campaign_behavior_coverage_tests: MATRIX")
  for each entry in entries
    if entry.objective then objectiveInstances = objectiveInstances + entry.instances; objectiveClasses = objectiveClasses + 1 end if
    if entry.monster then monsterInstances = monsterInstances + entry.instances; monsterClasses = monsterClasses + 1 end if
    if entry.boss then bossInstances = bossInstances + entry.instances; bossClasses = bossClasses + 1 end if
    if entry.simplified then simplifiedInstances = simplifiedInstances + entry.instances; simplifiedClasses = simplifiedClasses + 1 end if
    if entry.objective or entry.monster or entry.boss or entry.simplified then
      print("  class=" + entry.className + " count=" + entry.instances + " maps=" + entry.maps +
        " behavior=" + entry.behavior)
    end if
  end for
  print("  summary maps=39 raw=" + raw + " objective=" + objectiveInstances + "/" + objectiveClasses +
    " monster=" + monsterInstances + "/" + monsterClasses + " boss=" + bossInstances + "/" + bossClasses +
    " simplified=" + simplifiedInstances + "/" + simplifiedClasses)
  print("baseq2_campaign_behavior_coverage_tests: PASS")
  return 0
end function
