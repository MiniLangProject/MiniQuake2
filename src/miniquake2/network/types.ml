//! Provides miniquake2 network types facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
package miniquake2.network.types

/// Store connectionless request data.
struct ConnectionlessRequest
  /// Stores the command value associated with connectionless request.
  command
  /// Stores the arguments value associated with connectionless request.
  arguments
  /// Stores the line value associated with connectionless request.
  line
  /// Stores the remainder value associated with connectionless request.
  remainder
end struct

/// Store network action data.
struct NetworkAction
  /// Stores the kind value associated with network action.
  kind
  /// Stores the address value associated with network action.
  address
  /// Stores the data value associated with network action.
  data
  /// Stores the slot value associated with network action.
  slot
  /// Stores the text value associated with network action.
  text
end struct

/// Store handle result data.
struct HandleResult
  /// Stores the accepted value associated with handle result.
  accepted
  /// Stores the slot value associated with handle result.
  slot
  /// Stores the actions value associated with handle result.
  actions
  /// Stores the message value associated with handle result.
  message
  /// Stores the payload value associated with handle result.
  payload
end struct

/// Store challenge data.
struct Challenge
  /// Stores the address value associated with challenge.
  address
  /// Stores the value value associated with challenge.
  value
  /// Stores the time value associated with challenge.
  time
end struct

/// Store frame data.
struct Frame
  /// Stores the valid value associated with frame.
  valid
  /// Stores the server frame value associated with frame.
  serverFrame
  /// Stores the delta frame value associated with frame.
  deltaFrame
  /// Stores the server time value associated with frame.
  serverTime
  /// Stores the suppress count value associated with frame.
  suppressCount
  /// Stores the area bits value associated with frame.
  areaBits
  /// Stores the player state value associated with frame.
  playerState
  /// Stores the entities value associated with frame.
  entities
end struct

/// Store server client data.
struct ServerClient
  /// Stores the slot value associated with server client.
  slot
  /// Stores the state value associated with server client.
  state
  /// Stores the user info value associated with server client.
  userInfo
  /// Stores the name value associated with server client.
  name
  /// Stores the score value associated with server client.
  score
  /// Stores the ping value associated with server client.
  ping
  /// Stores the address value associated with server client.
  address
  /// Stores the qport value associated with server client.
  qport
  /// Stores the last message value associated with server client.
  lastMessage
  /// Stores the last connect value associated with server client.
  lastConnect
  /// Stores the challenge value associated with server client.
  challenge
  /// Stores the channel value associated with server client.
  channel
  /// Stores the frames value associated with server client.
  frames
  /// Stores the last frame value associated with server client.
  lastFrame
  /// Stores the suppress count value associated with server client.
  suppressCount
  /// Stores the frame latencies value associated with server client.
  frameLatencies
  /// Stores the frame sent times value associated with server client.
  frameSentTimes
  /// Stores the rate value associated with server client.
  rate
  /// Stores the message sizes value associated with server client.
  messageSizes
end struct

/// Store server state data.
struct ServerState
  /// Stores the real time value associated with server state.
  realTime
  /// Stores the hostname value associated with server state.
  hostname
  /// Stores the map name value associated with server state.
  mapName
  /// Stores the server info value associated with server state.
  serverInfo
  /// Stores the max clients value associated with server state.
  maxClients
  /// Stores the clients value associated with server state.
  clients
  /// Stores the challenges value associated with server state.
  challenges
  /// Stores the last heartbeat value associated with server state.
  lastHeartbeat
  /// Stores the dedicated value associated with server state.
  dedicated
  /// Stores the public server value associated with server state.
  publicServer
  /// Stores the attract loop value associated with server state.
  attractLoop
  /// Stores the timeout msec value associated with server state.
  timeoutMsec
  /// Stores the zombie msec value associated with server state.
  zombieMsec
  /// Stores the reconnect msec value associated with server state.
  reconnectMsec
  /// Stores the challenge seed value associated with server state.
  challengeSeed
end struct

/// Store client state data.
struct ClientState
  /// Stores the state value associated with client state.
  state
  /// Stores the server name value associated with client state.
  serverName
  /// Stores the server address value associated with client state.
  serverAddress
  /// Stores the qport value associated with client state.
  qport
  /// Stores the challenge value associated with client state.
  challenge
  /// Stores the user info value associated with client state.
  userInfo
  /// Stores the connect time value associated with client state.
  connectTime
  /// Stores the real time value associated with client state.
  realTime
  /// Stores the channel value associated with client state.
  channel
  /// Stores the timeout count value associated with client state.
  timeoutCount
  /// Stores the timeout msec value associated with client state.
  timeoutMsec
  /// Stores the frames value associated with client state.
  frames
  /// Stores the current frame value associated with client state.
  currentFrame
  /// Stores the last print value associated with client state.
  lastPrint
  /// Stores the last info value associated with client state.
  lastInfo
end struct

/// Performs the action operation for the miniquake2 network types module.
/// @param kind kind value consumed by this operation.
/// @param address address value consumed by this operation.
/// @param data Input data consumed by the operation.
/// @param slot slot value consumed by this operation.
/// @param text Text consumed by the operation.
function action(kind, address, data, slot, text)
  return NetworkAction(kind, address, data, slot, text)
end function

/// Performs the result operation for the miniquake2 network types module.
/// @param accepted accepted value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param actions actions value consumed by this operation.
/// @param message Human-readable message associated with the operation.
/// @param payload payload value consumed by this operation.
function result(accepted, slot, actions, message, payload)
  return HandleResult(accepted, slot, actions, message, payload)
end function
