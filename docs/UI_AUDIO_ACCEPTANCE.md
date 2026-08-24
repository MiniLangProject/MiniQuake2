# UI and Audio Product Acceptance

The interactive `--play` loop now consumes all three client command sources:
key bindings, console input and menu actions. Generated `+`/`-` binding text
remains local because the corresponding `UserCmd` state was already changed;
game commands such as chat and weapon selection are sent as reliable
Protocol-34 `clc_stringcmd` messages.

## Product behavior

- `sensitivity` and `cl_run` update live `UserCmd` generation;
- Player Setup persists right/left/center handedness, applies it live to the
  view-weapon renderer and sends the same value through reliable
  `clc_userinfo` to the Game API;
- `s_volume` changes a true mixer-wide gain and therefore affects channels
  that are already playing as well as future sounds;
- `I` toggles the inventory assembled from the exact 256-short
  `svc_inventory` handoff and the `CS_ITEMS` names;
- Escape releases relative mouse capture while the menu is active;
- `quit` exits through the normal audio, renderer, window and UDP shutdown;
- the Controls page captures the next keyboard, mouse-button or wheel press,
  replaces the previous binding for that command and treats Escape as cancel;
- `vid_restart` recreates the selected window mode and OpenGL renderer, then
  re-registers the current BSP, textures, models and sounds without replacing
  the live network/Game session;
- New Game Easy/Medium/Hard constructs a fresh `base1` Game API at skill 0/1/2
  in the existing product host;
- sensitivity, always-run, handedness, volume, video choices and the complete binding table
  round-trip through the bounded, strictly parsed `miniquake2.cfg` format;
- three save slots call the failure-atomic `WriteGame` + `WriteLevel` session
  adapter. Existing pairs are validated after process start, labelled with
  their map and loaded through same-map or cross-map re-signon as required.

The save images are written to the user's existing `baseq2` directory as
`miniquake2_slotN_{game,level}.sav`. Private-Save v8 retains the selected
difficulty; v7 images remain readable and default to Medium.

## Executable evidence

- `audio_mixer_tests.ml`: live master gain and strict range;
- `audio_replay_tests.ml`: two independent 512-frame, multi-rate,
  multi-channel replacement/loop replays produce the same 2,048 PCM bytes and
  fixed FNV-1a checksum `630146404` under a 4-MB GC limit;
- `client_ui_command_tests.ml`: three-source drain, local/forward policy,
  settings, save request, quit and compact inventory conversion;
- `client_ui_menu_tests.ml`: eleven-page navigation, Player Setup and slot commands;
- `client_ui_input_tests.ml`: key destinations, release safety and UserCmd;
- `client_ui_config_tests.ml`: disk roundtrip, live apply and malformed config;
- `runtime_product_host_tests.ml`: one shared lifecycle, loading frames and
  exact restart ownership;
- `runtime_new_game_skill_tests.ml`: fresh Easy/Hard session construction;
- `client_runtime_ui_messages_tests.ml`: strict Protocol-34 UI framing;
- `runtime_active_session_persistence_tests.ml`: atomic live save/restore.
- `play_session_loopback_tests.ml`: live handedness userinfo reaches both the
  server slot and `ClientUserinfoChanged`.

`scripts/renderer_audio_acceptance.ps1` combines the PCM gate with three
installed-original renderer pairs and four exact MiniQuake2 renderer replays,
emitting one JSON acceptance report below `build/`.

## Remaining boundary

`vid_gamma` is persisted but does not yet drive a hardware gamma ramp. Save
slots intentionally show map names only; classic screenshots/timestamps are a
presentation enhancement, not a restore gap. The current host passes real
fullscreen GL restart and default-device cinematic audio; additional GPUs,
explicit endpoint selection, hot-unplug and manual latency remain external as
listed in [`HARDWARE_ACCEPTANCE.md`](HARDWARE_ACCEPTANCE.md).
