/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II command buffer, tokenizer, aliases and cvar fallback. */
package miniquake2.qcommon.cmd

import miniquake2.qcommon.types as qt
import miniquake2.qcommon.text as text
import miniquake2.qcommon.cvar as cvar

const MAX_ARGS = 80
const COMMAND_BUFFER_SIZE = 8192
const MAX_ALIAS_NAME = 32

function create(cvars)
  return qt.CommandSystem([], [], [], "", "", false, cvars)
end function

function addCommand(system, name, callback)
  for each command in system.commands
    if text.equalInsensitive(command[0], name) then return error(3220, "command already exists: " + name) end if
  end for
  if cvar.find(system.cvars, name) is not void then return error(3221, "command shadows cvar: " + name) end if
  system.commands = [[name, callback]] + system.commands
  return true
end function

function removeCommand(system, name)
  result = []
  for each command in system.commands
    if text.equalInsensitive(command[0], name) == false then result = result + [command] end if
  end for
  system.commands = result
  return true
end function

function tokenize(value)
  source = bytes(value)
  result = []
  index = 0
  while index < len(source) and len(result) < MAX_ARGS
    while index < len(source) and source[index] <= 32
      if source[index] == 10 then return result end if
      index = index + 1
    end while
    if index >= len(source) then break end if
    if source[index] == 47 and index + 1 < len(source) and source[index + 1] == 47 then break end if
    output = bytes(len(source) - index)
    count = 0
    if source[index] == 34 then
      index = index + 1
      while index < len(source) and source[index] != 34
        output[count] = source[index]
        count = count + 1
        index = index + 1
      end while
      if index < len(source) then index = index + 1 end if
    else
      while index < len(source) and source[index] > 32
        if source[index] == 47 and index + 1 < len(source) and source[index + 1] == 47 then break end if
        output[count] = source[index]
        count = count + 1
        index = index + 1
      end while
    end if
    result = result + [decode(slice(output, 0, count))]
  end while
  return result
end function

function argumentTail(value)
  tokens = tokenize(value)
  if len(tokens) <= 1 then return "" end if
  result = ""
  i = 1
  while i < len(tokens)
    if result != "" then result = result + " " end if
    result = result + tokens[i]
    i = i + 1
  end while
  return result
end function

function addAlias(system, name, value)
  if len(bytes(name)) >= MAX_ALIAS_NAME then return error(3222, "alias name too long") end if
  for each alias in system.aliases
    if text.equalInsensitive(alias.name, name) then alias.value = value + "\n"; return alias end if
  end for
  alias = qt.CommandAlias(name, value + "\n")
  system.aliases = [alias] + system.aliases
  return alias
end function

function addText(system, value)
  if len(bytes(system.buffer)) + len(bytes(value)) >= COMMAND_BUFFER_SIZE then return error(3223, "command buffer overflow") end if
  system.buffer = system.buffer + value
  return true
end function

function insertText(system, value)
  if len(bytes(system.buffer)) + len(bytes(value)) >= COMMAND_BUFFER_SIZE then return error(3224, "command buffer overflow") end if
  system.buffer = value + system.buffer
  return true
end function

function splitFirst(value)
  source = bytes(value)
  quoted = false
  i = 0
  while i < len(source)
    if source[i] == 34 then quoted = not quoted end if
    if quoted == false and (source[i] == 10 or source[i] == 59) then break end if
    i = i + 1
  end while
  first = decode(slice(source, 0, i))
  if i < len(source) then i = i + 1 end if
  rest = ""
  if i < len(source) then rest = decode(slice(source, i, len(source) - i)) end if
  return [first, rest]
end function

function executeString(system, value)
  system.arguments = tokenize(value)
  system.argumentTail = argumentTail(value)
  if len(system.arguments) == 0 then return false end if
  name = system.arguments[0]
  if text.equalInsensitive(name, "wait") then system.wait = true; return true end if
  for each command in system.commands
    if text.equalInsensitive(command[0], name) then command[1](system.arguments); return true end if
  end for
  for each alias in system.aliases
    if text.equalInsensitive(alias.name, name) then insertText(system, alias.value); return true end if
  end for
  handled = cvar.command(system.cvars, system.arguments)
  return handled[0]
end function

function executeBuffer(system)
  executed = 0
  while system.buffer != ""
    parts = splitFirst(system.buffer)
    system.buffer = parts[1]
    if len(tokenize(parts[0])) > 0 then executeString(system, parts[0]); executed = executed + 1 end if
    if system.wait then system.wait = false; break end if
  end while
  return executed
end function
