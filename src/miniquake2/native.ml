/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

The Quake II port deliberately reuses MiniQuake's narrow numeric bridge while
the shared native platform library is being split into a reusable package.
*/
package miniquake2.native

extern function f32FromRaw(rawValue as u64) from "miniquake_native.dll" symbol "mq_f32_from_ml_raw" returns u32
extern function f32ToRaw(bits as u32) from "miniquake_native.dll" symbol "mq_f32_to_ml_raw" returns u64

extern function sysCounter() from "miniquake_native.dll" symbol "mq_sys_counter" returns u64
extern function sysFrequency() from "miniquake_native.dll" symbol "mq_sys_frequency" returns u64
extern function processHandleCount() from "miniquake_native.dll" symbol "mq_process_handle_count" returns u32
extern function winSleep(milliseconds as u32) from "miniquake_native.dll" symbol "mq_win_sleep" returns void

extern function winCreate(title as wstr, width as i32, height as i32, fullscreen as i32) from "miniquake_native.dll" symbol "mq_win_create" returns ptr
extern function winDestroy() from "miniquake_native.dll" symbol "mq_win_destroy" returns void
extern function winPoll() from "miniquake_native.dll" symbol "mq_win_poll" returns i32
extern function winSwap() from "miniquake_native.dll" symbol "mq_win_swap" returns void
extern function winClientWidth() from "miniquake_native.dll" symbol "mq_win_client_width" returns i32
extern function winClientHeight() from "miniquake_native.dll" symbol "mq_win_client_height" returns i32
extern function winHasFocus() from "miniquake_native.dll" symbol "mq_win_has_focus" returns i32
extern function winSetTitle(title as wstr) from "miniquake_native.dll" symbol "mq_win_set_title" returns void
extern function winSetCursorCapture(enabled as i32) from "miniquake_native.dll" symbol "mq_win_set_cursor_capture" returns void
extern function winMouseDx() from "miniquake_native.dll" symbol "mq_win_mouse_dx" returns i32
extern function winMouseDy() from "miniquake_native.dll" symbol "mq_win_mouse_dy" returns i32
extern function winMouseButtons() from "miniquake_native.dll" symbol "mq_win_mouse_buttons" returns i32
extern function winMouseWheel() from "miniquake_native.dll" symbol "mq_win_mouse_wheel" returns i32
extern function winInputEventPop() from "miniquake_native.dll" symbol "mq_win_input_event_pop" returns u32

extern function udpOpenBound(port as u32, address as cstr) from "miniquake_native.dll" symbol "mq_udp_open_bound" returns u64
extern function udpClose(handle as u64) from "miniquake_native.dll" symbol "mq_udp_close" returns void
extern function udpBoundPort(handle as u64) from "miniquake_native.dll" symbol "mq_udp_bound_port" returns u32
extern function udpPeek(handle as u64) from "miniquake_native.dll" symbol "mq_udp_peek" returns i32
extern function udpSend(handle as u64, address as cstr, port as u32, data as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_udp_send" returns i32
extern function udpReceive(handle as u64, data as bytes, capacity as u32) from "miniquake_native.dll" symbol "mq_udp_receive" returns i32
extern function udpLastPort() from "miniquake_native.dll" symbol "mq_udp_last_port" returns u32
extern function udpLastError() from "miniquake_native.dll" symbol "mq_udp_last_error" returns i32
extern function udpLastAddressRaw(output as bytes, capacity as u32) from "miniquake_text.dll" symbol "mqt_udp_last_address" returns u32
extern function udpBoundAddressRaw(handle as u64, output as bytes, capacity as u32) from "miniquake_text.dll" symbol "mqt_udp_bound_address" returns u32

extern function audioOpen(sampleRate as u32, channels as u32, bitsPerSample as u32) from "miniquake_native.dll" symbol "mq_audio_open" returns i32
extern function audioSubmit(data as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_audio_submit" returns i32
extern function audioClose() from "miniquake_native.dll" symbol "mq_audio_close" returns void
extern function audioQueued() from "miniquake_native.dll" symbol "mq_audio_queued" returns u32
extern function audioReset() from "miniquake_native.dll" symbol "mq_audio_reset" returns i32
extern function audioIsOpen() from "miniquake_native.dll" symbol "mq_audio_is_open" returns i32

// Fixed-function OpenGL 1.1 bridge used by the Quake II refexport adapter.
// Floats cross the ABI as their exact IEEE-754 bit pattern; this is the same
// narrow bridge used and exercised by MiniQuake's renderer.
extern function glBegin(mode as u32) from "miniquake_native.dll" symbol "mq_gl_begin" returns void
extern function glEnd() from "miniquake_native.dll" symbol "mq_gl_end" returns void
extern function glVertex2(xBits as u32, yBits as u32) from "miniquake_native.dll" symbol "mq_gl_vertex2" returns void
extern function glVertex3(xBits as u32, yBits as u32, zBits as u32) from "miniquake_native.dll" symbol "mq_gl_vertex3" returns void
extern function glTexcoord2(sBits as u32, tBits as u32) from "miniquake_native.dll" symbol "mq_gl_texcoord2" returns void
extern function glColor4ub(red as u32, green as u32, blue as u32, alpha as u32) from "miniquake_native.dll" symbol "mq_gl_color4ub" returns void
extern function glClearColor(redBits as u32, greenBits as u32, blueBits as u32, alphaBits as u32) from "miniquake_native.dll" symbol "mq_gl_clear_color" returns void
extern function glClear(mask as u32) from "miniquake_native.dll" symbol "mq_gl_clear" returns void
extern function glEnable(capability as u32) from "miniquake_native.dll" symbol "mq_gl_enable" returns void
extern function glDisable(capability as u32) from "miniquake_native.dll" symbol "mq_gl_disable" returns void
extern function glBlendFunc(source as u32, destination as u32) from "miniquake_native.dll" symbol "mq_gl_blend_func" returns void
extern function glDepthFunc(functionName as u32) from "miniquake_native.dll" symbol "mq_gl_depth_func" returns void
extern function glDepthMask(enabled as i32) from "miniquake_native.dll" symbol "mq_gl_depth_mask" returns void
extern function glViewport(x as i32, y as i32, width as i32, height as i32) from "miniquake_native.dll" symbol "mq_gl_viewport" returns void
extern function glMatrixMode(mode as u32) from "miniquake_native.dll" symbol "mq_gl_matrix_mode" returns void
extern function glLoadIdentity() from "miniquake_native.dll" symbol "mq_gl_load_identity" returns void
extern function glPushMatrix() from "miniquake_native.dll" symbol "mq_gl_push_matrix" returns void
extern function glPopMatrix() from "miniquake_native.dll" symbol "mq_gl_pop_matrix" returns void
extern function glRotate(angleBits as u32, xBits as u32, yBits as u32, zBits as u32) from "miniquake_native.dll" symbol "mq_gl_rotate" returns void
extern function glTranslate(xBits as u32, yBits as u32, zBits as u32) from "miniquake_native.dll" symbol "mq_gl_translate" returns void
extern function glOrtho(leftBits as u32, rightBits as u32, bottomBits as u32, topBits as u32, nearBits as u32, farBits as u32) from "miniquake_native.dll" symbol "mq_gl_ortho" returns void
extern function glFrustum(leftBits as u32, rightBits as u32, bottomBits as u32, topBits as u32, nearBits as u32, farBits as u32) from "miniquake_native.dll" symbol "mq_gl_frustum" returns void
extern function glBindTexture(target as u32, texture as u32) from "miniquake_native.dll" symbol "mq_gl_bind_texture" returns void
extern function glDeleteTextures(count as i32, textureIds as bytes) from "miniquake_native.dll" symbol "mq_gl_delete_textures" returns void
extern function glTexParameterI(target as u32, name as u32, value as i32) from "miniquake_native.dll" symbol "mq_gl_tex_parameter_i" returns void
extern function glTexImage2D(target as u32, level as i32, internalFormat as i32, width as i32, height as i32, border as i32, format as u32, type as u32, pixels as bytes) from "miniquake_native.dll" symbol "mq_gl_tex_image_2d" returns void
extern function glGetStringRaw(name as u32, output as bytes, capacity as u32) from "miniquake_text.dll" symbol "mqt_gl_get_string" returns u32
extern function glGetError() from "miniquake_native.dll" symbol "mq_gl_get_error" returns u32
extern function glReadPixels(x as i32, y as i32, width as i32, height as i32, format as u32, type as u32, pixels as bytes) from "miniquake_native.dll" symbol "mq_gl_read_pixels" returns void
extern function glFinish() from "miniquake_native.dll" symbol "mq_gl_finish" returns void
extern function glFlush() from "miniquake_native.dll" symbol "mq_gl_flush" returns void

function floatBits(value)
  return f32FromRaw(nativeRawValue(value))
end function

function bitsFloat(bits)
  return nativeValueFromRaw(f32ToRaw(bits))
end function

function textResult(buffer, count)
  if count <= 0 then return "" end if
  if count > len(buffer) then count = len(buffer) end if
  value = decode(slice(buffer, 0, count))
  if value is void then return "" end if
  return value
end function

function udpLastAddress()
  buffer = bytes(128)
  return textResult(buffer, udpLastAddressRaw(buffer, len(buffer)))
end function

function udpBoundAddress(handle)
  buffer = bytes(128)
  return textResult(buffer, udpBoundAddressRaw(handle, buffer, len(buffer)))
end function

function glGetString(name)
  buffer = bytes(4096)
  return textResult(buffer, glGetStringRaw(name, buffer, len(buffer)))
end function
