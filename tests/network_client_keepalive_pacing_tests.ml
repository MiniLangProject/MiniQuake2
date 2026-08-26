/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* CL_SendCmd connected-state one-second idle pacing. */
import miniquake2.platform.udp as nckpudp
import miniquake2.qcommon.types as nckpqt
import miniquake2.protocol.constants as nckppc
import miniquake2.protocol.netchan as nckpnetchan
import miniquake2.network.constants as nckpnc
import miniquake2.network.client as nckpclient
import miniquake2.network.runtime.types as nckptypes
import miniquake2.network.runtime.pump as nckppump

function nckpAssert(value, name)
  if not value then return error(7285, "client keepalive pacing: " + name) end if
  return true
end function

nckpReceiver = nckpudp.open("127.0.0.1", 0)
nckpSender = nckpudp.open("127.0.0.1", 0)
nckpAddress = nckpqt.NetAddress(nckpnc.NA_IP, [127, 0, 0, 1],
  array(10, 0), nckpReceiver.port)
nckpClient = nckpclient.create(17, 5000)
nckpClient.state = nckpnc.CA_CONNECTED
nckpClient.channel = nckpnetchan.setup(nckppc.NS_CLIENT, nckpAddress, 17, 0)
nckpRuntime = nckptypes.createClient(nckpClient)
nckpStats = nckptypes.stats()

nckpAssert(not nckppump.flushClientForPump(nckpRuntime, nckpSender, 500,
  nckpStats) and not nckpudp.pending(nckpReceiver),
  "idle signon packet emitted before one second")
nckpAssert(nckppump.flushClientForPump(nckpRuntime, nckpSender, 1001,
  nckpStats) and nckpudp.pending(nckpReceiver),
  "one-second idle signon keepalive missing")
nckpudp.receive(nckpReceiver, nckppc.MAX_MSGLEN)
nckpnetchan.queueReliable(nckpClient.channel, bytes([1]))
nckpAssert(nckppump.flushClientForPump(nckpRuntime, nckpSender, 1002,
  nckpStats) and nckpudp.pending(nckpReceiver),
  "reliable signon work was incorrectly throttled")

nckpudp.close(nckpSender)
nckpudp.close(nckpReceiver)
print("network_client_keepalive_pacing_tests: PASS")
