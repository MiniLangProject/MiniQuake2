//! Provides miniquake2 renderer recording facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/*
Deterministic, asset-free implementation of Renderer API v3. Recording mode
captures semantic calls; null mode executes the same validation and state
transitions without retaining commands, making it suitable for headless runs.
*/
package miniquake2.renderer.recording

import miniquake2.qcommon.types as qtypes
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.renderer.validation as validation

/// Store render command data.
struct RenderCommand
  /// Stores the sequence value associated with render command.
  sequence
  /// Stores the operation value associated with render command.
  operation
  /// Stores the arguments value associated with render command.
  arguments
end struct

/// Store renderer state data.
struct RendererState
  /// Stores the mode value associated with renderer state.
  mode
  /// Stores the imports value associated with renderer state.
  imports
  /// Stores the initialized value associated with renderer state.
  initialized
  /// Stores the registration open value associated with renderer state.
  registrationOpen
  /// Stores the registration generation value associated with renderer state.
  registrationGeneration
  /// Stores the next resource id value associated with renderer state.
  nextResourceId
  /// Stores the models value associated with renderer state.
  models
  /// Stores the skins value associated with renderer state.
  skins
  /// Stores the pictures value associated with renderer state.
  pictures
  /// Stores the commands value associated with renderer state.
  commands
  /// Stores the frame open value associated with renderer state.
  frameOpen
  /// Stores the frame count value associated with renderer state.
  frameCount
  /// Stores the last ref def value associated with renderer state.
  lastRefDef
  /// Stores the app active value associated with renderer state.
  appActive
  /// Stores the palette value associated with renderer state.
  palette
  /// Stores the sky name value associated with renderer state.
  skyName
  /// Stores the sky rotate value associated with renderer state.
  skyRotate
  /// Stores the sky axis value associated with renderer state.
  skyAxis
end struct

/// Creates state for the miniquake2 renderer recording module.
/// @param mode Mode selecting the requested behavior.
/// @param imports imports value consumed by this operation.
function createState(mode, imports)
  return RendererState(mode, imports, false, false, 0, 1, [], [], [], [], false, 0, void, true, void, "", 0.0, qtypes.zeroVec3())
end function

/// Record state.
/// @param state Mutable state inspected or updated by the operation.
/// @param operation operation value consumed by this operation.
/// @param arguments arguments value consumed by this operation.
function record(state, operation, arguments)
  if state.mode == "recording" then
    state.commands = state.commands + [RenderCommand(len(state.commands), operation, arguments)]
  end if
end function

/// Require initialized.
/// @param state Mutable state inspected or updated by the operation.
/// @param operation operation value consumed by this operation.
function requireInitialized(state, operation)
  if not state.initialized then return error(9600, operation + " called before renderer Init") end if
  return true
end function

/// Find resource.
/// @param resources resources value consumed by this operation.
/// @param name Name of the affected item.
/// @param generation generation value consumed by this operation.
function findResource(resources, name, generation)
  index = 0
  while index < len(resources)
    handle = resources[index]
    if handle.name == name and handle.generation == generation then return handle end if
    index = index + 1
  end while
  return void
end function

/// Return the resource operation value.
/// @param kind kind value consumed by this operation.
function resourceOperation(kind)
  if kind == "model" then return "RegisterModel" end if
  if kind == "skin" then return "RegisterSkin" end if
  return "RegisterPic"
end function

/// Register resource.
/// @param state Mutable state inspected or updated by the operation.
/// @param kind kind value consumed by this operation.
/// @param name Name of the affected item.
function registerResource(state, kind, name)
  operation = resourceOperation(kind)
  requireInitialized(state, operation)
  if name == "" then return void end if
  resources = state.pictures
  if kind == "model" then resources = state.models
  else if kind == "skin" then resources = state.skins
  end if
  handle = findResource(resources, name, state.registrationGeneration)
  if handle is not void then
    record(state, operation, name + ":" + handle.id)
    return handle
  end if
  handle = rt.ResourceHandle(kind, state.nextResourceId, name, state.registrationGeneration)
  state.nextResourceId = state.nextResourceId + 1
  if kind == "model" then state.models = state.models + [handle]
  else if kind == "skin" then state.skins = state.skins + [handle]
  else state.pictures = state.pictures + [handle]
  end if
  record(state, operation, name + ":" + handle.id)
  return handle
end function

/// Build a complete Renderer API v3 recorder around one shared lifecycle state.
/// Nested callbacks deliberately retain that state instead of copying resources.
/// @param state Mutable state inspected or updated by the operation.
function makeExports(state)
  /// Performs the rendererInit operation for the miniquake2 renderer recording module.
  /// @param hinstance hinstance value consumed by this operation.
  /// @param wndproc wndproc value consumed by this operation.
  function rendererInit(hinstance, wndproc)
    if state.initialized then return true end if
    state.initialized = true
    record(state, "Init", "api=3")
    return true
  end function

  /// Performs the rendererShutdown operation for the miniquake2 renderer recording module.
  function rendererShutdown()
    if not state.initialized then return void end if
    if state.frameOpen then return error(9601, "Shutdown called inside a frame") end if
    record(state, "Shutdown", "")
    state.registrationOpen = false
    state.initialized = false
  end function

  /// Performs the beginRegistration operation for the miniquake2 renderer recording module.
  /// @param mapName mapName value consumed by this operation.
  function beginRegistration(mapName)
    requireInitialized(state, "BeginRegistration")
    if mapName == "" then return error(9602, "BeginRegistration requires a map name") end if
    state.registrationGeneration = state.registrationGeneration + 1
    state.registrationOpen = true
    state.models = []
    state.skins = []
    state.pictures = []
    state.lastRefDef = void
    record(state, "BeginRegistration", mapName + ":" + state.registrationGeneration)
  end function

  /// Performs the registerModel operation for the miniquake2 renderer recording module.
  /// @param name Name of the affected item.
  function registerModel(name)
    return registerResource(state, "model", name)
  end function

  /// Performs the registerSkin operation for the miniquake2 renderer recording module.
  /// @param name Name of the affected item.
  function registerSkin(name)
    return registerResource(state, "skin", name)
  end function

  /// Performs the registerPic operation for the miniquake2 renderer recording module.
  /// @param name Name of the affected item.
  function registerPic(name)
    return registerResource(state, "pic", name)
  end function

  /// Updates sky maintained by the miniquake2 renderer recording module.
  /// @param name Name of the affected item.
  /// @param rotate rotate value consumed by this operation.
  /// @param axis axis value consumed by this operation.
  function setSky(name, rotate, axis)
    requireInitialized(state, "SetSky")
    checked = validation.validateVec3(axis, "sky axis")
    if not checked.valid then return error(9603, checked.message) end if
    state.skyName = name
    state.skyRotate = rotate
    state.skyAxis = axis
    record(state, "SetSky", name + ":" + rotate + ":" + axis.x + "," + axis.y + "," + axis.z)
  end function

  /// Performs the endRegistration operation for the miniquake2 renderer recording module.
  function endRegistration()
    requireInitialized(state, "EndRegistration")
    state.registrationOpen = false
    record(state, "EndRegistration", "generation=" + state.registrationGeneration)
  end function

  /// Renders frame through the miniquake2 renderer recording rendering path.
  /// @param frame frame value consumed by this operation.
  function renderFrame(frame)
    requireInitialized(state, "RenderFrame")
    checked = validation.validateRefDef(frame)
    if not checked.valid then return error(9604, checked.code + ": " + checked.message) end if
    state.lastRefDef = frame
    state.frameCount = state.frameCount + 1
    record(state, "RenderFrame", frame.x + "," + frame.y + "," + frame.width + "," + frame.height + ":e=" + frame.numEntities + ":d=" + frame.numDLights + ":p=" + frame.numParticles)
  end function

  /// Draws get pic size through the miniquake2 renderer recording rendering path.
  /// @param name Name of the affected item.
  function drawGetPicSize(name)
    requireInitialized(state, "DrawGetPicSize")
    record(state, "DrawGetPicSize", name)
    return rt.PicSize(0, 0)
  end function

  /// Draws pic through the miniquake2 renderer recording rendering path.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param name Name of the affected item.
  function drawPic(x, y, name)
    requireInitialized(state, "DrawPic")
    record(state, "DrawPic", x + "," + y + ":" + name)
  end function

  /// Draws stretch pic through the miniquake2 renderer recording rendering path.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param width Width in the coordinate or storage units used by the caller.
  /// @param height Height in the coordinate or storage units used by the caller.
  /// @param name Name of the affected item.
  function drawStretchPic(x, y, width, height, name)
    requireInitialized(state, "DrawStretchPic")
    if width < 0 or height < 0 then return error(9605, "DrawStretchPic dimensions must not be negative") end if
    record(state, "DrawStretchPic", x + "," + y + "," + width + "," + height + ":" + name)
  end function

  /// Draws char through the miniquake2 renderer recording rendering path.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param character character value consumed by this operation.
  function drawChar(x, y, character)
    requireInitialized(state, "DrawChar")
    record(state, "DrawChar", x + "," + y + ":" + character)
  end function

  /// Draws tile clear through the miniquake2 renderer recording rendering path.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param width Width in the coordinate or storage units used by the caller.
  /// @param height Height in the coordinate or storage units used by the caller.
  /// @param name Name of the affected item.
  function drawTileClear(x, y, width, height, name)
    requireInitialized(state, "DrawTileClear")
    if width < 0 or height < 0 then return error(9606, "DrawTileClear dimensions must not be negative") end if
    record(state, "DrawTileClear", x + "," + y + "," + width + "," + height + ":" + name)
  end function

  /// Draws fill through the miniquake2 renderer recording rendering path.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param width Width in the coordinate or storage units used by the caller.
  /// @param height Height in the coordinate or storage units used by the caller.
  /// @param color color value consumed by this operation.
  function drawFill(x, y, width, height, color)
    requireInitialized(state, "DrawFill")
    if width < 0 or height < 0 then return error(9607, "DrawFill dimensions must not be negative") end if
    if color < 0 or color > 255 then return error(9608, "DrawFill palette index must be in [0,255]") end if
    record(state, "DrawFill", x + "," + y + "," + width + "," + height + ":" + color)
  end function

  /// Draws fade screen through the miniquake2 renderer recording rendering path.
  function drawFadeScreen()
    requireInitialized(state, "DrawFadeScreen")
    record(state, "DrawFadeScreen", "")
  end function

  /// Draws stretch raw through the miniquake2 renderer recording rendering path.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param width Width in the coordinate or storage units used by the caller.
  /// @param height Height in the coordinate or storage units used by the caller.
  /// @param columns columns value consumed by this operation.
  /// @param rows rows value consumed by this operation.
  /// @param data Input data consumed by the operation.
  function drawStretchRaw(x, y, width, height, columns, rows, data)
    requireInitialized(state, "DrawStretchRaw")
    if width < 0 or height < 0 or columns < 0 or rows < 0 then return error(9609, "DrawStretchRaw dimensions must not be negative") end if
    if typeof(data) != "bytes" or len(data) < columns * rows then return error(9610, "DrawStretchRaw source data is truncated") end if
    record(state, "DrawStretchRaw", x + "," + y + "," + width + "," + height + ":" + columns + "x" + rows)
  end function

  /// Performs the cinematicSetPalette operation for the miniquake2 renderer recording module.
  /// @param palette palette value consumed by this operation.
  function cinematicSetPalette(palette)
    requireInitialized(state, "CinematicSetPalette")
    if palette is not void and (typeof(palette) != "bytes" or len(palette) != 768) then return error(9611, "cinematic palette must contain 768 bytes or be void") end if
    state.palette = palette
    if palette is void then record(state, "CinematicSetPalette", "game")
    else record(state, "CinematicSetPalette", "cinematic")
    end if
  end function

  /// Performs the beginFrame operation for the miniquake2 renderer recording module.
  /// @param cameraSeparation cameraSeparation value consumed by this operation.
  function beginFrame(cameraSeparation)
    requireInitialized(state, "BeginFrame")
    if state.frameOpen then return error(9612, "BeginFrame called twice") end if
    state.frameOpen = true
    record(state, "BeginFrame", "separation=" + cameraSeparation)
  end function

  /// Performs the endFrame operation for the miniquake2 renderer recording module.
  function endFrame()
    requireInitialized(state, "EndFrame")
    if not state.frameOpen then return error(9613, "EndFrame called without BeginFrame") end if
    record(state, "EndFrame", "")
    state.frameOpen = false
  end function

  /// Performs the appActivate operation for the miniquake2 renderer recording module.
  /// @param activate activate value consumed by this operation.
  function appActivate(activate)
    requireInitialized(state, "AppActivate")
    state.appActive = activate
    record(state, "AppActivate", "active=" + activate)
  end function

  return rt.RefExport(rc.API_VERSION, rendererInit, rendererShutdown, beginRegistration, registerModel, registerSkin, registerPic, setSky, endRegistration, renderFrame, drawGetPicSize, drawPic, drawStretchPic, drawChar, drawTileClear, drawFill, drawFadeScreen, drawStretchRaw, cinematicSetPalette, beginFrame, endFrame, appActivate)
end function

/// Create recording renderer.
function createRecordingRenderer()
  state = createState("recording", void)
  return rt.RendererBinding(state, makeExports(state))
end function

/// Create null renderer.
function createNullRenderer()
  state = createState("null", void)
  return rt.RendererBinding(state, makeExports(state))
end function

/// Internal equivalent of GetRefAPI_t. It binds a validated refimport_t table
/// to the renderer while returning both the export table and inspectable state.
/// @param imports imports value consumed by this operation.
/// @param mode Mode selecting the requested behavior.
function getRefAPI(imports, mode)
  checked = validation.validateRefImport(imports)
  if not checked.valid then return error(9614, checked.code + ": " + checked.message) end if
  if mode != "recording" and mode != "null" then return error(9615, "renderer mode must be recording or null") end if
  state = createState(mode, imports)
  return rt.RendererBinding(state, makeExports(state))
end function

/// Clear commands.
/// @param binding binding value consumed by this operation.
function clearCommands(binding)
  binding.state.commands = []
end function

/// Trace command.
/// @param binding binding value consumed by this operation.
function commandTrace(binding)
  result = ""
  index = 0
  while index < len(binding.state.commands)
    command = binding.state.commands[index]
    if index > 0 then result = result + "\n" end if
    result = result + command.sequence + ":" + command.operation + ":" + command.arguments
    index = index + 1
  end while
  return result
end function

/// Report whether is handle current.
/// @param binding binding value consumed by this operation.
/// @param handle Native or runtime handle used by the operation.
function isHandleCurrent(binding, handle)
  if handle is void then return false end if
  return handle.generation == binding.state.registrationGeneration
end function
