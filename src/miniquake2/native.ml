//! Provides miniquake2 native facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

The Quake II port deliberately reuses MiniQuake's narrow numeric bridge while
the shared native platform library is being split into a reusable package.
*/
package miniquake2.native

/// Invokes the native f32FromRaw entry point used by the miniquake2 native module.
/// @param rawValue rawValue value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function f32FromRaw(rawValue as u64) from "miniquake_native.dll" symbol "mq_f32_from_ml_raw" returns u32
/// Invokes the native f32ToRaw entry point used by the miniquake2 native module.
/// @param bits bits value consumed by this operation.
/// @returns Native u64 result produced by the call.
extern function f32ToRaw(bits as u32) from "miniquake_native.dll" symbol "mq_f32_to_ml_raw" returns u64
/// Invokes the native f32Sin entry point used by the miniquake2 native module.
/// @param bits bits value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function f32Sin(bits as u32) from "miniquake_native.dll" symbol "mq_f32_sin" returns u32
/// Invokes the native f32Cos entry point used by the miniquake2 native module.
/// @param bits bits value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function f32Cos(bits as u32) from "miniquake_native.dll" symbol "mq_f32_cos" returns u32
/// Invokes the native f32Atan2 entry point used by the miniquake2 native module.
/// @param yBits yBits value consumed by this operation.
/// @param xBits xBits value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function f32Atan2(yBits as u32, xBits as u32) from "miniquake_native.dll" symbol "mq_f32_atan2" returns u32

/// Invokes the native sysCounter entry point used by the miniquake2 native module.
/// @returns Native u64 result produced by the call.
extern function sysCounter() from "miniquake_native.dll" symbol "mq_sys_counter" returns u64
/// Invokes the native sysFrequency entry point used by the miniquake2 native module.
/// @returns Native u64 result produced by the call.
extern function sysFrequency() from "miniquake_native.dll" symbol "mq_sys_frequency" returns u64
/// Invokes the native processHandleCount entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function processHandleCount() from "miniquake_native.dll" symbol "mq_process_handle_count" returns u32
/// Invokes the native winSleep entry point used by the miniquake2 native module.
/// @param milliseconds milliseconds value consumed by this operation.
extern function winSleep(milliseconds as u32) from "miniquake_native.dll" symbol "mq_win_sleep" returns void
/// Invokes the native sysConsoleAlloc entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function sysConsoleAlloc() from "miniquake_native.dll" symbol "mq_sys_console_alloc" returns i32
/// Invokes the native sysConsoleFree entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function sysConsoleFree() from "miniquake_native.dll" symbol "mq_sys_console_free" returns i32
/// Invokes the native sysConsoleEventPop entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function sysConsoleEventPop() from "miniquake_native.dll" symbol "mq_sys_console_event_pop" returns u32
/// Invokes the native sysConsoleWrite entry point used by the miniquake2 native module.
/// @param text Text consumed by the operation.
/// @returns Native i32 result produced by the call.
extern function sysConsoleWrite(text as cstr) from "miniquake_native.dll" symbol "mq_sys_console_write" returns i32
/// Invokes the native sysSleepUntilInput entry point used by the miniquake2 native module.
/// @param milliseconds milliseconds value consumed by this operation.
extern function sysSleepUntilInput(milliseconds as u32) from "miniquake_native.dll" symbol "mq_sys_sleep_until_input" returns void

/// Invokes the native winCreate entry point used by the miniquake2 native module.
/// @param title Human-readable title presented to the user.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param fullscreen fullscreen value consumed by this operation.
/// @returns Native ptr result produced by the call.
extern function winCreate(title as wstr, width as i32, height as i32, fullscreen as i32) from "miniquake_native.dll" symbol "mq_win_create" returns ptr
/// Invokes the native winTestDisplayMode entry point used by the miniquake2 native module.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param bpp bpp value consumed by this operation.
/// @param frequency frequency value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function winTestDisplayMode(width as i32, height as i32, bpp as i32, frequency as i32) from "miniquake_native.dll" symbol "mq_win_test_display_mode" returns i32
/// Invokes the native winConfigureDisplayMode entry point used by the miniquake2 native module.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param bpp bpp value consumed by this operation.
/// @param frequency frequency value consumed by this operation.
/// @param fullscreen fullscreen value consumed by this operation.
/// @param useCurrent useCurrent value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function winConfigureDisplayMode(width as i32, height as i32, bpp as i32, frequency as i32, fullscreen as i32, useCurrent as i32) from "miniquake_native.dll" symbol "mq_win_configure_display_mode" returns i32
/// Invokes the native winRestoreDisplayMode entry point used by the miniquake2 native module.
extern function winRestoreDisplayMode() from "miniquake_native.dll" symbol "mq_win_restore_display_mode" returns void
/// Invokes the native winDestroy entry point used by the miniquake2 native module.
extern function winDestroy() from "miniquake_native.dll" symbol "mq_win_destroy" returns void
/// Invokes the native winPoll entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winPoll() from "miniquake_native.dll" symbol "mq_win_poll" returns i32
/// Invokes the native winSwap entry point used by the miniquake2 native module.
extern function winSwap() from "miniquake_native.dll" symbol "mq_win_swap" returns void
/// Invokes the native winSetSwapInterval entry point used by the miniquake2 native module.
/// @param interval interval value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function winSetSwapInterval(interval as i32) from "miniquake_native.dll" symbol "mq_win_set_swap_interval" returns i32
/// Invokes the native winClientWidth entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winClientWidth() from "miniquake_native.dll" symbol "mq_win_client_width" returns i32
/// Invokes the native winClientHeight entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winClientHeight() from "miniquake_native.dll" symbol "mq_win_client_height" returns i32
/// Invokes the native winResizeClient entry point used by the miniquake2 native module.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @returns Native i32 result produced by the call.
extern function winResizeClient(width as i32, height as i32) from "miniquake_native.dll" symbol "mq_win_resize_client" returns i32
/// Invokes the native winDesktopWidth entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winDesktopWidth() from "miniquake_native.dll" symbol "mq_win_desktop_width" returns i32
/// Invokes the native winDesktopHeight entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winDesktopHeight() from "miniquake_native.dll" symbol "mq_win_desktop_height" returns i32
/// Invokes the native winHasFocus entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winHasFocus() from "miniquake_native.dll" symbol "mq_win_has_focus" returns i32
/// Invokes the native winSetTitle entry point used by the miniquake2 native module.
/// @param title Human-readable title presented to the user.
extern function winSetTitle(title as wstr) from "miniquake_native.dll" symbol "mq_win_set_title" returns void
/// Invokes the native winSetCursorCapture entry point used by the miniquake2 native module.
/// @param enabled enabled value consumed by this operation.
extern function winSetCursorCapture(enabled as i32) from "miniquake_native.dll" symbol "mq_win_set_cursor_capture" returns void
/// Invokes the native winMouseDx entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winMouseDx() from "miniquake_native.dll" symbol "mq_win_mouse_dx" returns i32
/// Invokes the native winMouseDy entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winMouseDy() from "miniquake_native.dll" symbol "mq_win_mouse_dy" returns i32
/// Invokes the native winMouseButtons entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winMouseButtons() from "miniquake_native.dll" symbol "mq_win_mouse_buttons" returns i32
/// Invokes the native winMouseWheel entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winMouseWheel() from "miniquake_native.dll" symbol "mq_win_mouse_wheel" returns i32
/// Invokes the native winInputEventPop entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function winInputEventPop() from "miniquake_native.dll" symbol "mq_win_input_event_pop" returns u32
/// Invokes the native winGetGammaRamp entry point used by the miniquake2 native module.
/// @param ramp ramp value consumed by this operation.
/// @param byteCount Number of byte to process.
/// @returns Native i32 result produced by the call.
extern function winGetGammaRamp(ramp as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_win_get_gamma_ramp" returns i32
/// Invokes the native winSetGammaRamp entry point used by the miniquake2 native module.
/// @param ramp ramp value consumed by this operation.
/// @param byteCount Number of byte to process.
/// @returns Native i32 result produced by the call.
extern function winSetGammaRamp(ramp as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_win_set_gamma_ramp" returns i32
/// Invokes the native winJoyStartup entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winJoyStartup() from "miniquake_native.dll" symbol "mq_win_joy_startup" returns i32
/// Invokes the native winJoyRead entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winJoyRead() from "miniquake_native.dll" symbol "mq_win_joy_read" returns i32
/// Invokes the native winJoyAxis entry point used by the miniquake2 native module.
/// @param axis axis value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function winJoyAxis(axis as u32) from "miniquake_native.dll" symbol "mq_win_joy_axis" returns u32
/// Invokes the native winJoyButtons entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function winJoyButtons() from "miniquake_native.dll" symbol "mq_win_joy_buttons" returns u32
/// Invokes the native winJoyPov entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function winJoyPov() from "miniquake_native.dll" symbol "mq_win_joy_pov" returns u32
/// Invokes the native winJoyButtonCount entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function winJoyButtonCount() from "miniquake_native.dll" symbol "mq_win_joy_button_count" returns u32
/// Invokes the native winJoyHasPov entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function winJoyHasPov() from "miniquake_native.dll" symbol "mq_win_joy_has_pov" returns i32

/// Invokes the native udpOpenBound entry point used by the miniquake2 native module.
/// @param port port value consumed by this operation.
/// @param address address value consumed by this operation.
/// @returns Native u64 result produced by the call.
extern function udpOpenBound(port as u32, address as cstr) from "miniquake_native.dll" symbol "mq_udp_open_bound" returns u64
/// Invokes the native udpClose entry point used by the miniquake2 native module.
/// @param handle Native or runtime handle used by the operation.
extern function udpClose(handle as u64) from "miniquake_native.dll" symbol "mq_udp_close" returns void
/// Invokes the native udpBoundPort entry point used by the miniquake2 native module.
/// @param handle Native or runtime handle used by the operation.
/// @returns Native u32 result produced by the call.
extern function udpBoundPort(handle as u64) from "miniquake_native.dll" symbol "mq_udp_bound_port" returns u32
/// Invokes the native udpEnableBroadcast entry point used by the miniquake2 native module.
/// @param handle Native or runtime handle used by the operation.
/// @returns Native i32 result produced by the call.
extern function udpEnableBroadcast(handle as u64) from "miniquake_native.dll" symbol "mq_udp_enable_broadcast" returns i32
/// Invokes the native udpPeek entry point used by the miniquake2 native module.
/// @param handle Native or runtime handle used by the operation.
/// @returns Native i32 result produced by the call.
extern function udpPeek(handle as u64) from "miniquake_native.dll" symbol "mq_udp_peek" returns i32
/// Invokes the native udpSend entry point used by the miniquake2 native module.
/// @param handle Native or runtime handle used by the operation.
/// @param address address value consumed by this operation.
/// @param port port value consumed by this operation.
/// @param data Input data consumed by the operation.
/// @param byteCount Number of byte to process.
/// @returns Native i32 result produced by the call.
extern function udpSend(handle as u64, address as cstr, port as u32, data as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_udp_send" returns i32
/// Invokes the native udpReceive entry point used by the miniquake2 native module.
/// @param handle Native or runtime handle used by the operation.
/// @param data Input data consumed by the operation.
/// @param capacity capacity value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function udpReceive(handle as u64, data as bytes, capacity as u32) from "miniquake_native.dll" symbol "mq_udp_receive" returns i32
/// Invokes the native udpLastPort entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function udpLastPort() from "miniquake_native.dll" symbol "mq_udp_last_port" returns u32
/// Invokes the native udpLastError entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function udpLastError() from "miniquake_native.dll" symbol "mq_udp_last_error" returns i32
/// Invokes the native udpLastAddressRaw entry point used by the miniquake2 native module.
/// @param output Output collection or buffer populated by the operation.
/// @param capacity capacity value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function udpLastAddressRaw(output as bytes, capacity as u32) from "miniquake_text.dll" symbol "mqt_udp_last_address" returns u32
/// Invokes the native udpBoundAddressRaw entry point used by the miniquake2 native module.
/// @param handle Native or runtime handle used by the operation.
/// @param output Output collection or buffer populated by the operation.
/// @param capacity capacity value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function udpBoundAddressRaw(handle as u64, output as bytes, capacity as u32) from "miniquake_text.dll" symbol "mqt_udp_bound_address" returns u32
/// Invokes the native udpResolveNameRaw entry point used by the miniquake2 native module.
/// @param name Name of the affected item.
/// @param output Output collection or buffer populated by the operation.
/// @param capacity capacity value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function udpResolveNameRaw(name as cstr, output as bytes, capacity as u32) from "miniquake_text.dll" symbol "mqt_udp_resolve_name" returns u32

/// Invokes the native audioOpen entry point used by the miniquake2 native module.
/// @param sampleRate sampleRate value consumed by this operation.
/// @param channels channels value consumed by this operation.
/// @param bitsPerSample bitsPerSample value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function audioOpen(sampleRate as u32, channels as u32, bitsPerSample as u32) from "miniquake_native.dll" symbol "mq_audio_open" returns i32
/// Invokes the native audioSubmit entry point used by the miniquake2 native module.
/// @param data Input data consumed by the operation.
/// @param byteCount Number of byte to process.
/// @returns Native i32 result produced by the call.
extern function audioSubmit(data as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_audio_submit" returns i32
/// Invokes the native audioClose entry point used by the miniquake2 native module.
extern function audioClose() from "miniquake_native.dll" symbol "mq_audio_close" returns void
/// Invokes the native audioQueued entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function audioQueued() from "miniquake_native.dll" symbol "mq_audio_queued" returns u32
/// Invokes the native audioSubmitted entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function audioSubmitted() from "miniquake_native.dll" symbol "mq_audio_submitted" returns u32
/// Invokes the native audioCompleted entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function audioCompleted() from "miniquake_native.dll" symbol "mq_audio_completed" returns u32
/// Invokes the native audioUnderruns entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function audioUnderruns() from "miniquake_native.dll" symbol "mq_audio_underruns" returns u32
/// Invokes the native audioCapacity entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function audioCapacity() from "miniquake_native.dll" symbol "mq_audio_capacity" returns u32
/// Invokes the native audioReset entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function audioReset() from "miniquake_native.dll" symbol "mq_audio_reset" returns i32
/// Invokes the native audioIsOpen entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function audioIsOpen() from "miniquake_native.dll" symbol "mq_audio_is_open" returns i32
/// Invokes the native oggOpen entry point used by the miniquake2 native module.
/// @param data Input data consumed by the operation.
/// @param byteCount Number of byte to process.
/// @returns Native u32 result produced by the call.
extern function oggOpen(data as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_ogg_open" returns u32
/// Invokes the native oggOpenFile entry point used by the miniquake2 native module.
/// @param filename filename value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function oggOpenFile(filename as wstr) from "miniquake_native.dll" symbol "mq_ogg_open_file" returns u32
/// Invokes the native oggRate entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function oggRate() from "miniquake_native.dll" symbol "mq_ogg_rate" returns u32
/// Invokes the native oggChannels entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function oggChannels() from "miniquake_native.dll" symbol "mq_ogg_channels" returns u32
/// Invokes the native oggFrames entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function oggFrames() from "miniquake_native.dll" symbol "mq_ogg_frames" returns u32
/// Invokes the native oggDecode entry point used by the miniquake2 native module.
/// @param output Output collection or buffer populated by the operation.
/// @param frameCapacity frameCapacity value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function oggDecode(output as bytes, frameCapacity as u32) from "miniquake_native.dll" symbol "mq_ogg_decode" returns u32
/// Invokes the native oggSeekStart entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function oggSeekStart() from "miniquake_native.dll" symbol "mq_ogg_seek_start" returns i32
/// Invokes the native oggClose entry point used by the miniquake2 native module.
extern function oggClose() from "miniquake_native.dll" symbol "mq_ogg_close" returns void

/// Fixed-function OpenGL 1.1 bridge used by the Quake II refexport adapter.
/// Floats cross the ABI as their exact IEEE-754 bit pattern; this is the same
/// narrow bridge used and exercised by MiniQuake's renderer.
/// @param mode Mode selecting the requested behavior.
extern function glBegin(mode as u32) from "miniquake_native.dll" symbol "mq_gl_begin" returns void
/// Invokes the native glEnd entry point used by the miniquake2 native module.
extern function glEnd() from "miniquake_native.dll" symbol "mq_gl_end" returns void
/// Invokes the native glVertex2 entry point used by the miniquake2 native module.
/// @param xBits xBits value consumed by this operation.
/// @param yBits yBits value consumed by this operation.
extern function glVertex2(xBits as u32, yBits as u32) from "miniquake_native.dll" symbol "mq_gl_vertex2" returns void
/// Invokes the native glVertex3 entry point used by the miniquake2 native module.
/// @param xBits xBits value consumed by this operation.
/// @param yBits yBits value consumed by this operation.
/// @param zBits zBits value consumed by this operation.
extern function glVertex3(xBits as u32, yBits as u32, zBits as u32) from "miniquake_native.dll" symbol "mq_gl_vertex3" returns void
/// Invokes the native glTexcoord2 entry point used by the miniquake2 native module.
/// @param sBits sBits value consumed by this operation.
/// @param tBits tBits value consumed by this operation.
extern function glTexcoord2(sBits as u32, tBits as u32) from "miniquake_native.dll" symbol "mq_gl_texcoord2" returns void
/// Invokes the native glColor4ub entry point used by the miniquake2 native module.
/// @param red red value consumed by this operation.
/// @param green green value consumed by this operation.
/// @param blue blue value consumed by this operation.
/// @param alpha alpha value consumed by this operation.
extern function glColor4ub(red as u32, green as u32, blue as u32, alpha as u32) from "miniquake_native.dll" symbol "mq_gl_color4ub" returns void
/// Invokes the native glClearColor entry point used by the miniquake2 native module.
/// @param redBits redBits value consumed by this operation.
/// @param greenBits greenBits value consumed by this operation.
/// @param blueBits blueBits value consumed by this operation.
/// @param alphaBits alphaBits value consumed by this operation.
extern function glClearColor(redBits as u32, greenBits as u32, blueBits as u32, alphaBits as u32) from "miniquake_native.dll" symbol "mq_gl_clear_color" returns void
/// Invokes the native glClear entry point used by the miniquake2 native module.
/// @param mask mask value consumed by this operation.
extern function glClear(mask as u32) from "miniquake_native.dll" symbol "mq_gl_clear" returns void
/// Invokes the native glEnable entry point used by the miniquake2 native module.
/// @param capability capability value consumed by this operation.
extern function glEnable(capability as u32) from "miniquake_native.dll" symbol "mq_gl_enable" returns void
/// Invokes the native glDisable entry point used by the miniquake2 native module.
/// @param capability capability value consumed by this operation.
extern function glDisable(capability as u32) from "miniquake_native.dll" symbol "mq_gl_disable" returns void
/// Invokes the native glBlendFunc entry point used by the miniquake2 native module.
/// @param source source value consumed by this operation.
/// @param destination destination value consumed by this operation.
extern function glBlendFunc(source as u32, destination as u32) from "miniquake_native.dll" symbol "mq_gl_blend_func" returns void
/// Invokes the native glDepthFunc entry point used by the miniquake2 native module.
/// @param functionName functionName value consumed by this operation.
extern function glDepthFunc(functionName as u32) from "miniquake_native.dll" symbol "mq_gl_depth_func" returns void
/// Invokes the native glDepthMask entry point used by the miniquake2 native module.
/// @param enabled enabled value consumed by this operation.
extern function glDepthMask(enabled as i32) from "miniquake_native.dll" symbol "mq_gl_depth_mask" returns void
/// Invokes the native glDepthRange entry point used by the miniquake2 native module.
/// @param nearBits nearBits value consumed by this operation.
/// @param farBits farBits value consumed by this operation.
extern function glDepthRange(nearBits as u32, farBits as u32) from "miniquake_native.dll" symbol "mq_gl_depth_range" returns void
/// Invokes the native glAlphaFunc entry point used by the miniquake2 native module.
/// @param functionName functionName value consumed by this operation.
/// @param referenceBits referenceBits value consumed by this operation.
extern function glAlphaFunc(functionName as u32, referenceBits as u32) from "miniquake_native.dll" symbol "mq_gl_alpha_func" returns void
/// Invokes the native glCullFace entry point used by the miniquake2 native module.
/// @param mode Mode selecting the requested behavior.
extern function glCullFace(mode as u32) from "miniquake_native.dll" symbol "mq_gl_cull_face" returns void
/// Invokes the native glViewport entry point used by the miniquake2 native module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
extern function glViewport(x as i32, y as i32, width as i32, height as i32) from "miniquake_native.dll" symbol "mq_gl_viewport" returns void
/// Invokes the native glMatrixMode entry point used by the miniquake2 native module.
/// @param mode Mode selecting the requested behavior.
extern function glMatrixMode(mode as u32) from "miniquake_native.dll" symbol "mq_gl_matrix_mode" returns void
/// Invokes the native glLoadIdentity entry point used by the miniquake2 native module.
extern function glLoadIdentity() from "miniquake_native.dll" symbol "mq_gl_load_identity" returns void
/// Invokes the native glPushMatrix entry point used by the miniquake2 native module.
extern function glPushMatrix() from "miniquake_native.dll" symbol "mq_gl_push_matrix" returns void
/// Invokes the native glPopMatrix entry point used by the miniquake2 native module.
extern function glPopMatrix() from "miniquake_native.dll" symbol "mq_gl_pop_matrix" returns void
/// Invokes the native glRotate entry point used by the miniquake2 native module.
/// @param angleBits angleBits value consumed by this operation.
/// @param xBits xBits value consumed by this operation.
/// @param yBits yBits value consumed by this operation.
/// @param zBits zBits value consumed by this operation.
extern function glRotate(angleBits as u32, xBits as u32, yBits as u32, zBits as u32) from "miniquake_native.dll" symbol "mq_gl_rotate" returns void
/// Invokes the native glTranslate entry point used by the miniquake2 native module.
/// @param xBits xBits value consumed by this operation.
/// @param yBits yBits value consumed by this operation.
/// @param zBits zBits value consumed by this operation.
extern function glTranslate(xBits as u32, yBits as u32, zBits as u32) from "miniquake_native.dll" symbol "mq_gl_translate" returns void
/// Invokes the native glScale entry point used by the miniquake2 native module.
/// @param xBits xBits value consumed by this operation.
/// @param yBits yBits value consumed by this operation.
/// @param zBits zBits value consumed by this operation.
extern function glScale(xBits as u32, yBits as u32, zBits as u32) from "miniquake_native.dll" symbol "mq_gl_scale" returns void
/// Invokes the native glOrtho entry point used by the miniquake2 native module.
/// @param leftBits leftBits value consumed by this operation.
/// @param rightBits rightBits value consumed by this operation.
/// @param bottomBits bottomBits value consumed by this operation.
/// @param topBits topBits value consumed by this operation.
/// @param nearBits nearBits value consumed by this operation.
/// @param farBits farBits value consumed by this operation.
extern function glOrtho(leftBits as u32, rightBits as u32, bottomBits as u32, topBits as u32, nearBits as u32, farBits as u32) from "miniquake_native.dll" symbol "mq_gl_ortho" returns void
/// Invokes the native glFrustum entry point used by the miniquake2 native module.
/// @param leftBits leftBits value consumed by this operation.
/// @param rightBits rightBits value consumed by this operation.
/// @param bottomBits bottomBits value consumed by this operation.
/// @param topBits topBits value consumed by this operation.
/// @param nearBits nearBits value consumed by this operation.
/// @param farBits farBits value consumed by this operation.
extern function glFrustum(leftBits as u32, rightBits as u32, bottomBits as u32, topBits as u32, nearBits as u32, farBits as u32) from "miniquake_native.dll" symbol "mq_gl_frustum" returns void
/// Invokes the native glBindTexture entry point used by the miniquake2 native module.
/// @param target target value consumed by this operation.
/// @param texture texture value consumed by this operation.
extern function glBindTexture(target as u32, texture as u32) from "miniquake_native.dll" symbol "mq_gl_bind_texture" returns void
/// Invokes the native glDeleteTextures entry point used by the miniquake2 native module.
/// @param count Number of items or units to process.
/// @param textureIds textureIds value consumed by this operation.
extern function glDeleteTextures(count as i32, textureIds as bytes) from "miniquake_native.dll" symbol "mq_gl_delete_textures" returns void
/// Invokes the native glTexParameterI entry point used by the miniquake2 native module.
/// @param target target value consumed by this operation.
/// @param name Name of the affected item.
/// @param value Value consumed or transformed by the operation.
extern function glTexParameterI(target as u32, name as u32, value as i32) from "miniquake_native.dll" symbol "mq_gl_tex_parameter_i" returns void
/// Invokes the native glTexImage2D entry point used by the miniquake2 native module.
/// @param target target value consumed by this operation.
/// @param level level value consumed by this operation.
/// @param internalFormat internalFormat value consumed by this operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param border border value consumed by this operation.
/// @param format format value consumed by this operation.
/// @param type type value consumed by this operation.
/// @param pixels pixels value consumed by this operation.
extern function glTexImage2D(target as u32, level as i32, internalFormat as i32, width as i32, height as i32, border as i32, format as u32, type as u32, pixels as bytes) from "miniquake_native.dll" symbol "mq_gl_tex_image_2d" returns void
/// Invokes the native glTexSubImage2D entry point used by the miniquake2 native module.
/// @param target target value consumed by this operation.
/// @param level level value consumed by this operation.
/// @param xOffset xOffset value consumed by this operation.
/// @param yOffset yOffset value consumed by this operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param format format value consumed by this operation.
/// @param type type value consumed by this operation.
/// @param pixels pixels value consumed by this operation.
extern function glTexSubImage2D(target as u32, level as i32, xOffset as i32, yOffset as i32, width as i32, height as i32, format as u32, type as u32, pixels as bytes) from "miniquake_native.dll" symbol "mq_gl_tex_sub_image_2d" returns void
/// Invokes the native glGetStringRaw entry point used by the miniquake2 native module.
/// @param name Name of the affected item.
/// @param output Output collection or buffer populated by the operation.
/// @param capacity capacity value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function glGetStringRaw(name as u32, output as bytes, capacity as u32) from "miniquake_text.dll" symbol "mqt_gl_get_string" returns u32
/// Invokes the native glGetError entry point used by the miniquake2 native module.
/// @returns Native u32 result produced by the call.
extern function glGetError() from "miniquake_native.dll" symbol "mq_gl_get_error" returns u32
/// Invokes the native glReadPixels entry point used by the miniquake2 native module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param format format value consumed by this operation.
/// @param type type value consumed by this operation.
/// @param pixels pixels value consumed by this operation.
extern function glReadPixels(x as i32, y as i32, width as i32, height as i32, format as u32, type as u32, pixels as bytes) from "miniquake_native.dll" symbol "mq_gl_read_pixels" returns void
/// Invokes the native glFinish entry point used by the miniquake2 native module.
extern function glFinish() from "miniquake_native.dll" symbol "mq_gl_finish" returns void
/// Invokes the native glFlush entry point used by the miniquake2 native module.
extern function glFlush() from "miniquake_native.dll" symbol "mq_gl_flush" returns void
/// Invokes the native glStaticGeometryCall entry point used by the miniquake2 native module.
/// @param keyValue keyValue value consumed by this operation.
/// @param passValue passValue value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function glStaticGeometryCall(keyValue as u64, passValue as i32) from "miniquake_native.dll" symbol "mq_gl_static_geometry_call" returns i32
/// Invokes the native glStaticGeometryCallBatch entry point used by the miniquake2 native module.
/// @param keys keys value consumed by this operation.
/// @param byteCount Number of byte to process.
/// @param passValue passValue value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function glStaticGeometryCallBatch(keys as bytes, byteCount as u32, passValue as i32) from "miniquake_native.dll" symbol "mq_gl_static_geometry_call_batch" returns i32
/// Invokes the native glStaticGeometryCallMultitextureBatch entry point used by the miniquake2 native module.
/// @param records records value consumed by this operation.
/// @param byteCount Number of byte to process.
/// @returns Native i32 result produced by the call.
extern function glStaticGeometryCallMultitextureBatch(records as bytes, byteCount as u32) from "miniquake_native.dll" symbol "mq_gl_static_geometry_call_multitexture_batch" returns i32
/// Invokes the native glStaticGeometryPrepare entry point used by the miniquake2 native module.
/// @param keyValue keyValue value consumed by this operation.
/// @param passValue passValue value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function glStaticGeometryPrepare(keyValue as u64, passValue as i32) from "miniquake_native.dll" symbol "mq_gl_static_geometry_prepare" returns i32
/// Invokes the native glStaticGeometryClear entry point used by the miniquake2 native module.
extern function glStaticGeometryClear() from "miniquake_native.dll" symbol "mq_gl_static_geometry_clear" returns void
/// Invokes the native glMultitextureAvailable entry point used by the miniquake2 native module.
/// @returns Native i32 result produced by the call.
extern function glMultitextureAvailable() from "miniquake_native.dll" symbol "mq_gl_multitexture_available" returns i32
/// Invokes the native glActiveTexture entry point used by the miniquake2 native module.
/// @param unit unit value consumed by this operation.
extern function glActiveTexture(unit as i32) from "miniquake_native.dll" symbol "mq_gl_active_texture" returns void
/// Invokes the native glMultiTexCoord2 entry point used by the miniquake2 native module.
/// @param unit unit value consumed by this operation.
/// @param sBits sBits value consumed by this operation.
/// @param tBits tBits value consumed by this operation.
extern function glMultiTexCoord2(unit as i32, sBits as u32, tBits as u32) from "miniquake_native.dll" symbol "mq_gl_multi_tex_coord2" returns void
/// Invokes the native glTexEnvI entry point used by the miniquake2 native module.
/// @param target target value consumed by this operation.
/// @param name Name of the affected item.
/// @param value Value consumed or transformed by the operation.
extern function glTexEnvI(target as u32, name as u32, value as i32) from "miniquake_native.dll" symbol "mq_gl_tex_env_i" returns void
/// Invokes the native glDrawParticleBatch entry point used by the miniquake2 native module.
/// @param data Input data consumed by the operation.
/// @param byteCount Number of byte to process.
/// @param viewOriginX viewOriginX value consumed by this operation.
/// @param viewOriginY viewOriginY value consumed by this operation.
/// @param viewOriginZ viewOriginZ value consumed by this operation.
/// @param viewForwardX viewForwardX value consumed by this operation.
/// @param viewForwardY viewForwardY value consumed by this operation.
/// @param viewForwardZ viewForwardZ value consumed by this operation.
/// @param viewUpX viewUpX value consumed by this operation.
/// @param viewUpY viewUpY value consumed by this operation.
/// @param viewUpZ viewUpZ value consumed by this operation.
/// @param viewRightX viewRightX value consumed by this operation.
/// @param viewRightY viewRightY value consumed by this operation.
/// @param viewRightZ viewRightZ value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function glDrawParticleBatch(data as bytes, byteCount as u32, viewOriginX as u32, viewOriginY as u32, viewOriginZ as u32, viewForwardX as u32, viewForwardY as u32, viewForwardZ as u32, viewUpX as u32, viewUpY as u32, viewUpZ as u32, viewRightX as u32, viewRightY as u32, viewRightZ as u32) from "miniquake_native.dll" symbol "mq_gl_draw_particle_batch" returns i32
/// Invokes the native glDrawParticleBatchStyled entry point used by the miniquake2 native module.
/// @param data Input data consumed by the operation.
/// @param byteCount Number of byte to process.
/// @param viewOriginX viewOriginX value consumed by this operation.
/// @param viewOriginY viewOriginY value consumed by this operation.
/// @param viewOriginZ viewOriginZ value consumed by this operation.
/// @param viewForwardX viewForwardX value consumed by this operation.
/// @param viewForwardY viewForwardY value consumed by this operation.
/// @param viewForwardZ viewForwardZ value consumed by this operation.
/// @param viewUpX viewUpX value consumed by this operation.
/// @param viewUpY viewUpY value consumed by this operation.
/// @param viewUpZ viewUpZ value consumed by this operation.
/// @param viewRightX viewRightX value consumed by this operation.
/// @param viewRightY viewRightY value consumed by this operation.
/// @param viewRightZ viewRightZ value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function glDrawParticleBatchStyled(data as bytes, byteCount as u32, viewOriginX as u32, viewOriginY as u32, viewOriginZ as u32, viewForwardX as u32, viewForwardY as u32, viewForwardZ as u32, viewUpX as u32, viewUpY as u32, viewUpZ as u32, viewRightX as u32, viewRightY as u32, viewRightZ as u32) from "miniquake_native.dll" symbol "mq_gl_draw_particle_batch_styled" returns i32
/// Invokes the native glDrawMd2Rgb entry point used by the miniquake2 native module.
/// @param data Input data consumed by the operation.
/// @param byteCount Number of byte to process.
/// @param frameIndex Zero-based index of frame.
/// @param oldFrameIndex Zero-based index of old frame.
/// @param backLerp backLerp value consumed by this operation.
/// @param shadeDots shadeDots value consumed by this operation.
/// @param shadeDotCount Number of shade dot to process.
/// @param normalVectors normalVectors value consumed by this operation.
/// @param normalCount Number of normal to process.
/// @param geometryKey geometryKey value consumed by this operation.
/// @param geometryState geometryState value consumed by this operation.
/// @param shadeState shadeState value consumed by this operation.
/// @param shadeRed shadeRed value consumed by this operation.
/// @param shadeGreen shadeGreen value consumed by this operation.
/// @param shadeBlue shadeBlue value consumed by this operation.
/// @param alpha alpha value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function glDrawMd2Rgb(data as bytes, byteCount as u32, frameIndex as u32, oldFrameIndex as u32, backLerp as u32, shadeDots as bytes, shadeDotCount as u32, normalVectors as bytes, normalCount as u32, geometryKey as u64, geometryState as u32, shadeState as u32, shadeRed as u32, shadeGreen as u32, shadeBlue as u32, alpha as u32) from "miniquake_native.dll" symbol "mq_gl_draw_md2_rgb" returns i32
/// Invokes the native glDrawMd2Shadow entry point used by the miniquake2 native module.
/// @param data Input data consumed by the operation.
/// @param byteCount Number of byte to process.
/// @param frameIndex Zero-based index of frame.
/// @param oldFrameIndex Zero-based index of old frame.
/// @param backLerp backLerp value consumed by this operation.
/// @param normalVectors normalVectors value consumed by this operation.
/// @param normalCount Number of normal to process.
/// @param geometryKey geometryKey value consumed by this operation.
/// @param geometryState geometryState value consumed by this operation.
/// @param triangleCount Number of triangle to process.
/// @param shadeX shadeX value consumed by this operation.
/// @param shadeY shadeY value consumed by this operation.
/// @param lightHeight lightHeight value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function glDrawMd2Shadow(data as bytes, byteCount as u32, frameIndex as u32, oldFrameIndex as u32, backLerp as u32, normalVectors as bytes, normalCount as u32, geometryKey as u64, geometryState as u32, triangleCount as u32, shadeX as u32, shadeY as u32, lightHeight as u32) from "miniquake_native.dll" symbol "mq_gl_draw_md2_shadow" returns i32
/// Invokes the native glDrawMd2ShadowSoft entry point used by the miniquake2 native module.
/// @param data Input data consumed by the operation.
/// @param byteCount Number of byte to process.
/// @param frameIndex Zero-based index of frame.
/// @param oldFrameIndex Zero-based index of old frame.
/// @param backLerp backLerp value consumed by this operation.
/// @param normalVectors normalVectors value consumed by this operation.
/// @param normalCount Number of normal to process.
/// @param geometryKey geometryKey value consumed by this operation.
/// @param geometryState geometryState value consumed by this operation.
/// @param triangleCount Number of triangle to process.
/// @param shadeX shadeX value consumed by this operation.
/// @param shadeY shadeY value consumed by this operation.
/// @param lightHeight lightHeight value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function glDrawMd2ShadowSoft(data as bytes, byteCount as u32, frameIndex as u32, oldFrameIndex as u32, backLerp as u32, normalVectors as bytes, normalCount as u32, geometryKey as u64, geometryState as u32, triangleCount as u32, shadeX as u32, shadeY as u32, lightHeight as u32) from "miniquake_native.dll" symbol "mq_gl_draw_md2_shadow_soft" returns i32
/// Invokes the native glDrawAliasRgbEnd entry point used by the miniquake2 native module.
extern function glDrawAliasRgbEnd() from "miniquake_native.dll" symbol "mq_gl_draw_alias_rgb_end" returns void

/// Return the float bits value.
/// @param value Value consumed or transformed by the operation.
function floatBits(value)
  return f32FromRaw(nativeRawValue(value))
end function

/// Return the bits float value.
/// @param bits bits value consumed by this operation.
function bitsFloat(bits)
  return nativeValueFromRaw(f32ToRaw(bits))
end function

/// Return the sin value.
/// @param value Value consumed or transformed by the operation.
function sin(value)
  return bitsFloat(f32Sin(floatBits(value)))
end function

/// Return the cos value.
/// @param value Value consumed or transformed by the operation.
function cos(value)
  return bitsFloat(f32Cos(floatBits(value)))
end function

/// Return the atan 2 value.
/// @param y Vertical coordinate used by the operation.
/// @param x Horizontal coordinate used by the operation.
function atan2(y, x)
  return bitsFloat(f32Atan2(floatBits(y), floatBits(x)))
end function

/// Return the text result value.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param count Number of items or units to process.
function textResult(buffer, count)
  if count <= 0 then return "" end if
  if count > len(buffer) then count = len(buffer) end if
  value = decode(slice(buffer, 0, count))
  if value is void then return "" end if
  return value
end function

/// Return the udp last address value.
function udpLastAddress()
  buffer = bytes(128)
  return textResult(buffer, udpLastAddressRaw(buffer, len(buffer)))
end function

/// Return the udp bound address value.
/// @param handle Native or runtime handle used by the operation.
function udpBoundAddress(handle)
  buffer = bytes(128)
  return textResult(buffer, udpBoundAddressRaw(handle, buffer, len(buffer)))
end function

/// Resolve udp name.
/// @param name Name of the affected item.
function udpResolveName(name)
  buffer = bytes(64)
  return textResult(buffer, udpResolveNameRaw(name, buffer, len(buffer)))
end function

/// Return gl string.
/// @param name Name of the affected item.
function glGetString(name)
  buffer = bytes(4096)
  return textResult(buffer, glGetStringRaw(name, buffer, len(buffer)))
end function
