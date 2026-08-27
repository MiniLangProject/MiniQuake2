/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
package miniquake2.network.types

// Store connectionless request data.
struct ConnectionlessRequest
  command
  arguments
  line
  remainder
end struct

// Store network action data.
struct NetworkAction
  kind
  address
  data
  slot
  text
end struct

// Store handle result data.
struct HandleResult
  accepted
  slot
  actions
  message
  payload
end struct

// Store challenge data.
struct Challenge
  address
  value
  time
end struct

// Store frame data.
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

// Store server client data.
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

// Store server state data.
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

// Store client state data.
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

// Return the action value.
function action(kind, address, data, slot, text)
  return NetworkAction(kind, address, data, slot, text)
end function

// Return the result value.
function result(accepted, slot, actions, message, payload)
  return HandleResult(accepted, slot, actions, message, payload)
end function
