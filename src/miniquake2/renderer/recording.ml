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

struct RenderCommand
  sequence
  operation
  arguments
end struct

struct RendererState
  mode
  imports
  initialized
  registrationOpen
  registrationGeneration
  nextResourceId
  models
  skins
  pictures
  commands
  frameOpen
  frameCount
  lastRefDef
  appActive
  palette
  skyName
  skyRotate
  skyAxis
end struct

function createState(mode, imports)
  return RendererState(mode, imports, false, false, 0, 1, [], [], [], [], false, 0, void, true, void, "", 0.0, qtypes.zeroVec3())
end function

function record(state, operation, arguments)
  if state.mode == "recording" then
    state.commands = state.commands + [RenderCommand(len(state.commands), operation, arguments)]
  end if
end function

function requireInitialized(state, operation)
  if not state.initialized then return error(9600, operation + " called before renderer Init") end if
  return true
end function

function findResource(resources, name, generation)
  index = 0
  while index < len(resources)
    handle = resources[index]
    if handle.name == name and handle.generation == generation then return handle end if
    index = index + 1
  end while
  return void
end function

function resourceOperation(kind)
  if kind == "model" then return "RegisterModel" end if
  if kind == "skin" then return "RegisterSkin" end if
  return "RegisterPic"
end function

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

function makeExports(state)
  function rendererInit(hinstance, wndproc)
    if state.initialized then return true end if
    state.initialized = true
    record(state, "Init", "api=3")
    return true
  end function

  function rendererShutdown()
    if not state.initialized then return void end if
    if state.frameOpen then return error(9601, "Shutdown called inside a frame") end if
    record(state, "Shutdown", "")
    state.registrationOpen = false
    state.initialized = false
  end function

  function beginRegistration(mapName)
    requireInitialized(state, "BeginRegistration")
    if mapName == "" then return error(9602, "BeginRegistration requires a map name") end if
    state.registrationGeneration = state.registrationGeneration + 1
    state.registrationOpen = true
    state.models = []
    state.skins = []
    state.pictures = []
    record(state, "BeginRegistration", mapName + ":" + state.registrationGeneration)
  end function

  function registerModel(name)
    return registerResource(state, "model", name)
  end function

  function registerSkin(name)
    return registerResource(state, "skin", name)
  end function

  function registerPic(name)
    return registerResource(state, "pic", name)
  end function

  function setSky(name, rotate, axis)
    requireInitialized(state, "SetSky")
    checked = validation.validateVec3(axis, "sky axis")
    if not checked.valid then return error(9603, checked.message) end if
    state.skyName = name
    state.skyRotate = rotate
    state.skyAxis = axis
    record(state, "SetSky", name + ":" + rotate + ":" + axis.x + "," + axis.y + "," + axis.z)
  end function

  function endRegistration()
    requireInitialized(state, "EndRegistration")
    state.registrationOpen = false
    record(state, "EndRegistration", "generation=" + state.registrationGeneration)
  end function

  function renderFrame(frame)
    requireInitialized(state, "RenderFrame")
    checked = validation.validateRefDef(frame)
    if not checked.valid then return error(9604, checked.code + ": " + checked.message) end if
    state.lastRefDef = frame
    state.frameCount = state.frameCount + 1
    record(state, "RenderFrame", frame.x + "," + frame.y + "," + frame.width + "," + frame.height + ":e=" + frame.numEntities + ":d=" + frame.numDLights + ":p=" + frame.numParticles)
  end function

  function drawGetPicSize(name)
    requireInitialized(state, "DrawGetPicSize")
    record(state, "DrawGetPicSize", name)
    return rt.PicSize(0, 0)
  end function

  function drawPic(x, y, name)
    requireInitialized(state, "DrawPic")
    record(state, "DrawPic", x + "," + y + ":" + name)
  end function

  function drawStretchPic(x, y, width, height, name)
    requireInitialized(state, "DrawStretchPic")
    if width < 0 or height < 0 then return error(9605, "DrawStretchPic dimensions must not be negative") end if
    record(state, "DrawStretchPic", x + "," + y + "," + width + "," + height + ":" + name)
  end function

  function drawChar(x, y, character)
    requireInitialized(state, "DrawChar")
    record(state, "DrawChar", x + "," + y + ":" + character)
  end function

  function drawTileClear(x, y, width, height, name)
    requireInitialized(state, "DrawTileClear")
    if width < 0 or height < 0 then return error(9606, "DrawTileClear dimensions must not be negative") end if
    record(state, "DrawTileClear", x + "," + y + "," + width + "," + height + ":" + name)
  end function

  function drawFill(x, y, width, height, color)
    requireInitialized(state, "DrawFill")
    if width < 0 or height < 0 then return error(9607, "DrawFill dimensions must not be negative") end if
    if color < 0 or color > 255 then return error(9608, "DrawFill palette index must be in [0,255]") end if
    record(state, "DrawFill", x + "," + y + "," + width + "," + height + ":" + color)
  end function

  function drawFadeScreen()
    requireInitialized(state, "DrawFadeScreen")
    record(state, "DrawFadeScreen", "")
  end function

  function drawStretchRaw(x, y, width, height, columns, rows, data)
    requireInitialized(state, "DrawStretchRaw")
    if width < 0 or height < 0 or columns < 0 or rows < 0 then return error(9609, "DrawStretchRaw dimensions must not be negative") end if
    if typeof(data) != "bytes" or len(data) < columns * rows then return error(9610, "DrawStretchRaw source data is truncated") end if
    record(state, "DrawStretchRaw", x + "," + y + "," + width + "," + height + ":" + columns + "x" + rows)
  end function

  function cinematicSetPalette(palette)
    requireInitialized(state, "CinematicSetPalette")
    if palette is not void and (typeof(palette) != "bytes" or len(palette) != 768) then return error(9611, "cinematic palette must contain 768 bytes or be void") end if
    state.palette = palette
    if palette is void then record(state, "CinematicSetPalette", "game")
    else record(state, "CinematicSetPalette", "cinematic")
    end if
  end function

  function beginFrame(cameraSeparation)
    requireInitialized(state, "BeginFrame")
    if state.frameOpen then return error(9612, "BeginFrame called twice") end if
    state.frameOpen = true
    record(state, "BeginFrame", "separation=" + cameraSeparation)
  end function

  function endFrame()
    requireInitialized(state, "EndFrame")
    if not state.frameOpen then return error(9613, "EndFrame called without BeginFrame") end if
    record(state, "EndFrame", "")
    state.frameOpen = false
  end function

  function appActivate(activate)
    requireInitialized(state, "AppActivate")
    state.appActive = activate
    record(state, "AppActivate", "active=" + activate)
  end function

  return rt.RefExport(rc.API_VERSION, rendererInit, rendererShutdown, beginRegistration, registerModel, registerSkin, registerPic, setSky, endRegistration, renderFrame, drawGetPicSize, drawPic, drawStretchPic, drawChar, drawTileClear, drawFill, drawFadeScreen, drawStretchRaw, cinematicSetPalette, beginFrame, endFrame, appActivate)
end function

function createRecordingRenderer()
  state = createState("recording", void)
  return rt.RendererBinding(state, makeExports(state))
end function

function createNullRenderer()
  state = createState("null", void)
  return rt.RendererBinding(state, makeExports(state))
end function

// Internal equivalent of GetRefAPI_t. It binds a validated refimport_t table
// to the renderer while returning both the export table and inspectable state.
function getRefAPI(imports, mode)
  checked = validation.validateRefImport(imports)
  if not checked.valid then return error(9614, checked.code + ": " + checked.message) end if
  if mode != "recording" and mode != "null" then return error(9615, "renderer mode must be recording or null") end if
  state = createState(mode, imports)
  return rt.RendererBinding(state, makeExports(state))
end function

function clearCommands(binding)
  binding.state.commands = []
end function

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

function isHandleCurrent(binding, handle)
  if handle is void then return false end if
  return handle.generation == binding.state.registrationGeneration
end function
