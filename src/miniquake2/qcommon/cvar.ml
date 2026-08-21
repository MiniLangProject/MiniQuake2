/* Quake II cvar registry including NOSET/LATCH and info-string semantics. */
package miniquake2.qcommon.cvar

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt

function numericValue(text)
  converted = try(toNumber(text))
  if converted is error then return 0.0 end if
  return converted
end function

function createRegistry()
  return qt.CvarRegistry([], false)
end function

function find(registry, name)
  for each variable in registry.variables
    if variable.name == name then return variable end if
  end for
  return void
end function

function infoValueValid(value)
  data = bytes(value)
  i = 0
  while i < len(data)
    if data[i] == 92 or data[i] == 34 or data[i] == 59 then return false end if
    i = i + 1
  end while
  return true
end function

function get(registry, name, defaultValue, flags)
  if name == "" then return error(3210, "empty cvar name") end if
  variable = find(registry, name)
  if variable is not void then
    variable.flags = variable.flags | flags
    return variable
  end if
  if (flags & (qc.CVAR_USERINFO | qc.CVAR_SERVERINFO)) != 0 then
    if infoValueValid(name) == false or infoValueValid(defaultValue) == false then return error(3211, "invalid info cvar") end if
  end if
  variable = qt.Cvar(name, defaultValue, void, flags, true, numericValue(defaultValue))
  registry.variables = [variable] + registry.variables
  if (flags & qc.CVAR_USERINFO) != 0 then registry.userInfoModified = true end if
  return variable
end function

function set2(registry, name, value, force)
  variable = find(registry, name)
  if variable is void then return get(registry, name, value, 0) end if
  if (variable.flags & (qc.CVAR_USERINFO | qc.CVAR_SERVERINFO)) != 0 and infoValueValid(value) == false then return error(3212, "invalid info cvar value") end if
  if force == false and (variable.flags & qc.CVAR_NOSET) != 0 then return error(3213, name + " is write protected") end if
  if force == false and (variable.flags & qc.CVAR_LATCH) != 0 then
    if value == variable.string then variable.latchedString = void; return variable end if
    variable.latchedString = value
    return variable
  end if
  changed = variable.string != value
  variable.string = value
  variable.latchedString = void
  variable.value = numericValue(value)
  variable.modified = changed
  if changed and (variable.flags & qc.CVAR_USERINFO) != 0 then registry.userInfoModified = true end if
  return variable
end function

function set(registry, name, value)
  return set2(registry, name, value, false)
end function

function forceSet(registry, name, value)
  return set2(registry, name, value, true)
end function

function fullSet(registry, name, value, flags)
  variable = forceSet(registry, name, value)
  variable.flags = flags
  return variable
end function

function applyLatched(registry)
  count = 0
  for each variable in registry.variables
    if variable.latchedString is not void then
      value = variable.latchedString
      variable.latchedString = void
      forceSet(registry, variable.name, value)
      count = count + 1
    end if
  end for
  return count
end function

function variableString(registry, name)
  variable = find(registry, name)
  if variable is void then return "" end if
  return variable.string
end function

function variableValue(registry, name)
  variable = find(registry, name)
  if variable is void then return 0.0 end if
  return variable.value
end function

function bitInfo(registry, flags)
  result = ""
  for each variable in registry.variables
    if (variable.flags & flags) != 0 then
      addition = "\\" + variable.name + "\\" + variable.string
      if len(bytes(result)) + len(bytes(addition)) >= qc.MAX_INFO_STRING then return error(3214, "cvar info string length exceeded") end if
      result = result + addition
    end if
  end for
  return result
end function

function command(registry, arguments)
  if len(arguments) == 0 then return [false, ""] end if
  variable = find(registry, arguments[0])
  if variable is void then return [false, ""] end if
  if len(arguments) == 1 then return [true, "\"" + variable.name + "\" is \"" + variable.string + "\""] end if
  set(registry, variable.name, arguments[1])
  return [true, ""]
end function
