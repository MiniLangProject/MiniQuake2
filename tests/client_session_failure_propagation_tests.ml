/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Fatal precache errors must escape the remote client pump. */
import miniquake2.qcommon.constants as csfpqc
import miniquake2.qcommon.types as csfpqt
import miniquake2.protocol.types as csfppt
import miniquake2.client.downloads as csfpdownloads
import miniquake2.client.runtime.types as csfpcrtypes
import miniquake2.runtime.client_session as csfpsession

// Assert the csfp test condition.
function csfpAssert(value, name)
  if not value then return error(9990, "client session failure: " + name) end if
  return true
end function

// Report whether csfp missing.
function csfpMissing(name)
  return false
end function

// Read csfp.
function csfpRead(name)
  return error(9991, "unexpected asset read")
end function

// Reject csfp registration.
function csfpRejectRegistration(kind, name)
  if kind == "precache" then return error(9992, "registration failed") end if
  return true
end function

csfpClient = csfpsession.create("127.0.0.1", 27999,
  "\\name\\failure-test\\skin\\male/grunt", 0)
csfpManager = csfpdownloads.create("build", csfpqc.BASEDIRNAME,
  csfpdownloads.DownloadPolicy(false, false, false, false, false, false),
  csfpMissing, csfpRead, csfpRejectRegistration)
csfpsession.configureDownloads(csfpClient, csfpManager)
csfpClient.integrated.network.gameDir = csfpqc.BASEDIRNAME
csfpClient.integrated.network.stuffedTexts = ["precache 7\n"]
csfpResult = try(csfpsession.poll(csfpClient))
csfpAssert(csfpResult is error, "precache registration error propagated")
csfpAssert(not csfpManager.complete,
  "failed registration did not publish precache completion")

csfpPlayer = csfppt.zeroPlayerState()
csfpPlayer.pmove.flags = csfpqc.PMF_NO_PREDICTION
csfpPlayer.pmove.deltaAngles = [0, 16384, 0]
csfpClient.integrated.client.current = csfpcrtypes.Snapshot(1, -1, 0,
  bytes(), csfpPlayer, [])
csfpPreview = csfpqt.UserCmd(16, 0, [0, 8192, 0], 0, 0, 0, 0, 0)
csfpPredicted = csfpsession.predictRemote(csfpClient, csfpPreview, void)
csfpAssert(not csfpPredicted and csfpClient.integrated.client.predictionValid and
  csfpClient.integrated.client.predictedAngles.y == 135.0,
  "PMF_NO_PREDICTION still updates command-space view angles")
csfpsession.shutdown(csfpClient)

print("client_session_failure_propagation_tests: PASS")
