//! Provides miniquake2 qcommon cmd facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II command buffer, tokenizer, aliases and cvar fallback. */
package miniquake2.qcommon.cmd

import miniquake2.qcommon.types as qt
import miniquake2.qcommon.text as text
import miniquake2.qcommon.cvar as cvar

/// Defines the max args constant used by the miniquake2 qcommon cmd module.
const MAX_ARGS = 80
/// Defines the command buffer size constant used by the miniquake2 qcommon cmd module.
const COMMAND_BUFFER_SIZE = 8192
/// Defines the max alias name constant used by the miniquake2 qcommon cmd module.
const MAX_ALIAS_NAME = 32
/// Defines the max string chars constant used by the miniquake2 qcommon cmd module.
const MAX_STRING_CHARS = 1024

/// Creates create for the miniquake2 qcommon cmd module.
/// @param cvars cvars value consumed by this operation.
function create(cvars)
  return qt.CommandSystem([], [], [], "", "", false, cvars)
end function

/// Add command.
/// @param system system value consumed by this operation.
/// @param name Name of the affected item.
/// @param callback Callback invoked when the operation completes or the event occurs.
function addCommand(system, name, callback)
  for each command in system.commands
    if text.equalInsensitive(command[0], name) then return error(3220, "command already exists: " + name) end if
  end for
  if cvar.find(system.cvars, name) is not void then return error(3221, "command shadows cvar: " + name) end if
  system.commands = [[name, callback]] + system.commands
  return true
end function

/// Remove command.
/// @param system system value consumed by this operation.
/// @param name Name of the affected item.
function removeCommand(system, name)
  result = []
  for each command in system.commands
    if text.equalInsensitive(command[0], name) == false then result = result + [command] end if
  end for
  system.commands = result
  return true
end function

/// Return the tokenize value.
/// @param value Value consumed or transformed by the operation.
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

/// Return the argument tail value.
/// @param value Value consumed or transformed by the operation.
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

/// Add alias.
/// @param system system value consumed by this operation.
/// @param name Name of the affected item.
/// @param value Value consumed or transformed by the operation.
function addAlias(system, name, value)
  if len(bytes(name)) >= MAX_ALIAS_NAME then return error(3222, "alias name too long") end if
  for each alias in system.aliases
    if text.equalInsensitive(alias.name, name) then alias.value = value + "\n"; return alias end if
  end for
  alias = qt.CommandAlias(name, value + "\n")
  system.aliases = [alias] + system.aliases
  return alias
end function

/// Add text.
/// @param system system value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
function addText(system, value)
  if len(bytes(system.buffer)) + len(bytes(value)) >= COMMAND_BUFFER_SIZE then return error(3223, "command buffer overflow") end if
  system.buffer = system.buffer + value
  return true
end function

/// Insert text.
/// @param system system value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
function insertText(system, value)
  if len(bytes(system.buffer)) + len(bytes(value)) >= COMMAND_BUFFER_SIZE then return error(3224, "command buffer overflow") end if
  system.buffer = value + system.buffer
  return true
end function

/// Split first.
/// @param value Value consumed or transformed by the operation.
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

/// Expand unquoted `$cvar` references with the same bounded repeated-scan
/// policy as Cmd_MacroExpandString. Keeping this in qcommon makes config,
/// client-console and dedicated-console command parsing agree.
/// @param system system value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
function macroExpand(system, value)
  // Validate the initial bound, rescan substituted text with a loop guard,
  // then reject an unmatched quoted region before tokenization.
  if len(bytes(value)) >= MAX_STRING_CHARS then
    return error(3225, "command line exceeds MAX_STRING_CHARS")
  end if
  expanded = value
  replacements = 0
  scan = 0
  quoted = false
  while scan < len(bytes(expanded))
    source = bytes(expanded)
    if source[scan] == 34 then quoted = not quoted; scan = scan + 1
    else if not quoted and source[scan] == 36 then
      nameStart = scan + 1
      nameEnd = nameStart
      while nameEnd < len(source) and source[nameEnd] > 32 and
          source[nameEnd] != 34 and source[nameEnd] != 59
        nameEnd = nameEnd + 1
      end while
      if nameEnd == nameStart then scan = scan + 1
      else
        name = decode(slice(source, nameStart, nameEnd - nameStart))
        replacement = cvar.variableString(system.cvars, name)
        prefix = decode(slice(source, 0, scan))
        suffix = decode(slice(source, nameEnd, len(source) - nameEnd))
        expanded = prefix + replacement + suffix
        if len(bytes(expanded)) >= MAX_STRING_CHARS then
          return error(3226, "expanded command line exceeds MAX_STRING_CHARS")
        end if
        replacements = replacements + 1
        if replacements >= 100 then return error(3227, "command macro expansion loop") end if
      end if
    else scan = scan + 1
    end if
  end while
  if quoted then return error(3228, "command line has unmatched quote") end if
  return expanded
end function

/// Execute string.
/// @param system system value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
function executeString(system, value)
  expanded = macroExpand(system, value)
  system.arguments = tokenize(expanded)
  system.argumentTail = argumentTail(expanded)
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

/// Execute buffer.
/// @param system system value consumed by this operation.
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
