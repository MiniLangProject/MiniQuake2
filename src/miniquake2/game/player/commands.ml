/* Stock g_cmds.c player weapon-selection commands. */
package miniquake2.game.player.commands

import miniquake2.game.gameplay.constants as gpcconstants
import miniquake2.game.gameplay.item_rules as gpcitems

function ownedWeapon(player, item)
  return item is not void and item.use is not void and
    (item.flags & gpcconstants.IT_WEAPON) != 0 and
    item.index > 0 and item.index < len(player.gameplay.inventory.counts) and
    player.gameplay.inventory.counts[item.index] > 0
end function

function useWeapon(player, registry, pickupName)
  item = gpcitems.findByPickupName(registry, pickupName)
  if not ownedWeapon(player, item) then return false end if
  result = item.use(player.gameplay, item, registry, false)
  return result.success
end function

// g_cmds.c intentionally traverses the item table in opposite directions for
// WeapPrev and WeapNext.  Keep that externally visible order, while stopping
// at the first owned weapon whose ammo policy accepts the selection.
function cycleWeapon(player, registry, step)
  if step != -1 and step != 1 then return error(9700, "weapon cycle step must be -1 or 1") end if
  current = player.gameplay.currentWeapon
  if current is void then return false end if
  slots = len(player.gameplay.inventory.counts)
  offset = 1
  while offset <= slots
    index = current.index + step * offset
    while index < 0
      index = index + slots
    end while
    while index >= slots
      index = index - slots
    end while
    item = gpcitems.getByIndex(registry, index)
    if ownedWeapon(player, item) then
      result = item.use(player.gameplay, item, registry, false)
      if result.success then return true end if
    end if
    offset = offset + 1
  end while
  return false
end function

function weaponPrevious(player, registry)
  return cycleWeapon(player, registry, 1)
end function

function weaponNext(player, registry)
  return cycleWeapon(player, registry, -1)
end function

function weaponLast(player, registry)
  item = player.gameplay.lastWeapon
  if not ownedWeapon(player, item) then return false end if
  result = item.use(player.gameplay, item, registry, false)
  return result.success
end function
