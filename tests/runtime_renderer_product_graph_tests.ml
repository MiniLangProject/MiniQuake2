/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Regression: renderer factories must survive the complete product link graph. */
import miniquake2.runtime.diagnostics as productdiagnostics
import miniquake2.runtime.application as productapplication
import miniquake2.renderer.opengl as productopengl

function assertTrue(value, label)
  if not value then return error(9981, label) end if
end function

function main(args)
  assertTrue(productdiagnostics.verifyLinkClosure(), "product linker closure")
  assertTrue(typeof(productapplication.previewMap) == "function", "application preview link")
  renderer = productopengl.createOpenGlRenderer(false)
  assertTrue(typeof(renderer) == "struct", "product-graph renderer binding")
  assertTrue(typeof(renderer.state) == "struct", "product-graph renderer state")
  assertTrue(typeof(renderer.exports) == "struct", "product-graph renderer exports")
  renderer.exports.Init(void, void)
  renderer.exports.Shutdown()
  print "MiniQuake2 runtime renderer product-graph tests passed: 1"
  return 0
end function
