# UI and Audio Product Acceptance

The interactive `--play` loop now consumes all three client command sources:
key bindings, console input and menu actions. Generated `+`/`-` binding text
remains local because the corresponding `UserCmd` state was already changed;
game commands such as chat and weapon selection are sent as reliable
Protocol-34 `clc_stringcmd` messages.

## Product behavior

- `sensitivity` and `cl_run` update live `UserCmd` generation;
- `s_volume` changes a true mixer-wide gain and therefore affects channels
  that are already playing as well as future sounds;
- `I` toggles the inventory assembled from the exact 256-short
  `svc_inventory` handoff and the `CS_ITEMS` names;
- Escape releases relative mouse capture while the menu is active;
- `quit` exits through the normal audio, renderer, window and UDP shutdown;
- Load, Save and Controls are real menu pages rather than invalid page links;
- three in-session save slots call the failure-atomic `WriteGame` +
  `WriteLevel` session adapter, and load preserves the active Netchan epoch.

The save images are written to the user's existing `baseq2` directory as
`miniquake2_slotN_{game,level}.sav`. The current application intentionally
keeps the validated `SessionCheckpoint` metadata in memory, so a slot is
loadable during the running process. Discovering and validating those files
after a fresh process start remains a separate save-browser task.

## Executable evidence

- `audio_mixer_tests.ml`: live master gain and strict range;
- `client_ui_command_tests.ml`: three-source drain, local/forward policy,
  settings, save request, quit and compact inventory conversion;
- `client_ui_menu_tests.ml`: seven-page navigation and slot commands;
- `client_ui_input_tests.ml`: key destinations, release safety and UserCmd;
- `client_runtime_ui_messages_tests.ml`: strict Protocol-34 UI framing;
- `runtime_active_session_persistence_tests.ml`: atomic live save/restore.

## Remaining boundary

Video choices are retained locally and `vid_restart` is acknowledged, but an
existing Win32/OpenGL window is not recreated yet. The Controls page documents
the default bindings; it does not capture arbitrary rebinding input. New Game
difficulty selection is still forwarded to the game command boundary rather
than rebuilding the current retail session. Finally, automatic
`nextserver`/loading-plaque orchestration of CIN and PCX media remains the
campaign application-state task described in
[`CINEMATIC_ACCEPTANCE.md`](CINEMATIC_ACCEPTANCE.md).
