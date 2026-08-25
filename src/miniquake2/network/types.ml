/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
package miniquake2.network.types

struct ConnectionlessRequest
  command
  arguments
  line
  remainder
end struct

struct NetworkAction
  kind
  address
  data
  slot
  text
end struct

struct HandleResult
  accepted
  slot
  actions
  message
  payload
end struct

struct Challenge
  address
  value
  time
end struct

struct Frame
  valid
  serverFrame
  deltaFrame
  serverTime
  suppressCount
  areaBits
  playerState
  entities
end struct

struct ServerClient
  slot
  state
  userInfo
  name
  score
  ping
  address
  qport
  lastMessage
  lastConnect
  challenge
  channel
  frames
  lastFrame
  suppressCount
  frameLatencies
  frameSentTimes
  rate
  messageSizes
end struct

struct ServerState
  realTime
  hostname
  mapName
  serverInfo
  maxClients
  clients
  challenges
  lastHeartbeat
  dedicated
  publicServer
  attractLoop
  timeoutMsec
  zombieMsec
  reconnectMsec
  challengeSeed
end struct

struct ClientState
  state
  serverName
  serverAddress
  qport
  challenge
  userInfo
  connectTime
  realTime
  channel
  timeoutCount
  timeoutMsec
  frames
  currentFrame
  lastPrint
  lastInfo
end struct

function action(kind, address, data, slot, text)
  return NetworkAction(kind, address, data, slot, text)
end function

function result(accepted, slot, actions, message, payload)
  return HandleResult(accepted, slot, actions, message, payload)
end function
