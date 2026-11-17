# Owner tests: Twin Phasor 76

Fill in the Result column and send it back. A plain list ("1 pass, 2 click on Route…") is fine too.
Setup: Live 12.4.15 / Max 9.1.5, Windows 11, RME Fireface UCX II.

## A. Live checks

| # | Test | How | Pass if | Result |
|---|---|---|---|---|
| L1 | Loads | Drag the .amxd onto an audio track | No crash, panel shows | **PASS (2026-11-17)** |
| L2 | Plays | Default settings on a loop | Slow sweep, A light pulses, no clicks | |
| L3 | Switch while playing | Flip VINTAGE↔MODERN, FULL WET, Out Mode, Route, A Sweep→ENV, Sweep Sync→QUAD | No clicks | |
| L4 | Buttons latch | Click PHASOR A/B and a quirk button | Stays on after one click | |
| L5 | Automation | Draw fast automation on A Depth, B Feedback, Mix, Env Amount | No zipper noise | |
| L6 | MIDI map | Ctrl+M, map Pedal and Mix to KeyLab knobs | Controls follow | |
| L7 | Save / reopen | Set knobs off default, save the set, quit, reopen | All values restored | |
| L8 | Preset | Save a device preset, reset, recall | All values return | |
| L9 | Separate channel | See below | Near silence | |
| L10 | CPU | 4 instances, A+B on, full feedback | Note the CPU meter; no dropouts at 256 samples | |
| L11 | Push (if connected) | Open the device on Push | Bank 1 = "Perform" | |

**L9 setup:**
- Track 1: Twin Phasor with both PHASOR buttons off, Route = Dry + Bus.
- Track 2: Audio From = Track 1 → "Twin Phasor 76 | 3/4", Monitor In, Utility with phase invert (Ø) on.

Play, then note silent / quieter / no change at buffer sizes 128 and 512.

## B. Listening (your own material)

| Material | Question | Notes |
|---|---|---|
| Dub chord / pad | Out A\|B, both on Gen 1: does QUAD add movement REV doesn't? | |
| Skank guitar or organ | A Sweep → ENV (UP, Amount ~60 %, Atk 4 ms, Rel 150 ms): does it feel played? Keep ENV? | |
| Drum loop | ENV vs Gen 1: useful or distracting? | |
| Bass line | Any mud or level jump at high feedback? Does VINTAGE vs MODERN matter? | |
| Anything | Settings that sound harsh, broken or unusable | |
