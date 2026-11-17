# Changelog: Twin Phasor 76

## S4 (2026-11-17)
- Push/bank order is now performance-first, with named banks (Perform, Switch, Envelope, Output, Quirks 1–2). Saved values and sound are unchanged; only the Push layout differs.
- README: MIDI/key mapping and Push section, colour notes. `docs/OWNER_TESTS.md` results sheet.

## S3 (2026-11-17)
- Panel recoloured from a photo of an original unit: face #3750a9, white outlines and legends, charcoal blocks, light-blue/grey/red/cream lever colours, black knob caps, brighter red LEDs. No layout, sound or parameter change.

## S2 (2026-11-15): crash hotfix
- **Fixed:** Live 12.4.15 / Max 9.1.5 crashed on loading S1. The crash was inside Max's gen~ compiler while the patch loaded. The patch structure now follows Max's own conventions:
  - `obj-N` ids at both levels;
  - the gen~ inner patcher trimmed to the keys Max writes;
  - root parameter table and banks;
  - enum `parameter_mmax`.

  The owner confirmed S2/S3 load.
- **Fixed:** on/off buttons (footswitches, FULL WET, quirks) were momentary; they latch again.
- `tools/make_bisect.py`: a diagnostic ladder for any future load crash.

## S1 (2026-11-14): practical improvement sprint
- Added **ENV** sweep source (Amount, Attack, Release, UP/DOWN) and **QUAD** Sweep Sync. Settings from before S1 render bit-identically.
- Rejected an in-device stereo pan/width control (Live already covers it).

## RC1 (2026-11-14): remediation
- Working test suite with assertions; reproducible builds; sweep range 0.1–18 Hz everywhere.
- Fixed clicks on switches; fixed denormals.
- Native outputs 3/4 for routing to a separate channel. The `send~` Return device is kept as legacy.

## 0.1 (2026-11-14)
- First build.
