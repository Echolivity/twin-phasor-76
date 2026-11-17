# Twin Phasor 76: Max for Live

A dual six-stage optical phasor modelled on the 1975 Bi-Phase circuit that Lee "Scratch" Perry used at the Black Ark. The original's quirks can each be switched on or off; MODERN mode gives a clean, matched output.

**Status: release candidate S4 (conditional).** Offline DSP and build tests pass. The device **loads in Live 12.4.15 / Max 9.1.5 (Windows)**, confirmed by the owner on 2026-11-17. The remaining Live checks and listening tests are in `docs/OWNER_TESTS.md`. See `CHANGELOG.md` for version history.

## Install
1. Copy `Twin Phasor 76.amxd` (and optionally `Twin Phasor Return.amxd`) into your Live User Library, e.g. `User Library/Presets/Audio Effects/Max Audio Effect/`.
2. Drop **Twin Phasor 76** on an audio track.

If Live refuses an .amxd, open the matching `.maxpat` in Max and save it as a Max Audio Effect.

## Panel
- **SWEEP GEN 1 / 2:** Rate 0.1–18 Hz (the original's range), Shape SINE/SQR. Gen 1 rate can follow the Pedal (MAN/PED).
- **PHASOR A / B:** Depth, Feedback, Sweep source, on/off "footswitch" with an LED that follows the sweep.
  - A Sweep: GEN 1 · PED · **ENV**
  - B Sweep: G1 · G2 · PED · **ENV**
  - B Sweep Sync: NORM · REV · **QUAD**. QUAD runs B a quarter-cycle (90°) ahead of A when both follow Gen 1. That gives a rotating stereo movement, between NORM (same) and REV (opposite). *QUAD is not on the original unit.*
  - B Input: IN A · OUT A · IN B
- **ENVELOPE (ENV),** in the lower half of the Gen 2 panel: a sweep source that follows how loud you play. *Not on the original unit.*
  - **Env Amount:** sensitivity. 0 % holds the sweep still; at 100 % a −12 dBFS peak reaches full sweep.
  - **Attack** 1–100 ms, **Release** 20–2000 ms.
  - **UP / DOWN:** UP rests low and opens up as you play louder; DOWN rests high and dives as you play louder.
  - The phasor's **Depth** sets how far the envelope can move the sweep, as it does for the LFO and pedal. In VINTAGE mode the photocell lag also smooths the envelope.
- **PEDAL:** manual sweep position (stands in for the C-100 pedal). Map it to an expression pedal or macro. It moves the sweep within the Depth range, so at Depth 0 it does nothing.
- **OUTPUT:** Mix (50 % = the original's fixed blend), **FULL WET**, Drive, Output, Out Mode (Out A | Out B stereo · Out B mono · Out A mono · A + B mono), IN A = L / L+R.
- **ROUTE:**
  - *Track:* normal insert.
  - *Dry + Bus:* dry stays on this track; the processed signal goes to the device's **outputs 3/4** (and the legacy bus).
  - *Bus only:* this track is silent.
- **CHARACTER:** VINTAGE enables the lit quirk buttons; MODERN disables all of them and sweeps cleanly between Modern Lo and Hi.

## Sending the phaser to a separate channel
1. On the phaser's track set **Route** to *Dry + Bus* (or *Bus only*).
2. On another audio track set **Audio From** to the phaser's track, then in the lower chooser pick **Twin Phasor 76 | 3/4**. Set Monitor to **In**.

This uses Live's own routing, which Live delay-compensates. **Twin Phasor Return** (legacy) does the same through `send~`/`receive~`. Cycling '74 doesn't support that between devices and its latency varies with buffer size, so use it only if outputs 3/4 aren't available.

## MIDI mapping, keys and Push
Every control is a standard Live parameter, so the device needs no MIDI setup of its own.
- **MIDI Map:** Ctrl+M (Cmd+M on Mac), click a control, move a knob or pedal on your controller, then Ctrl+M again. Map **Pedal** to an expression pedal for wah-style sweeps.
- **Key Map:** Ctrl+K. Handy for the PHASOR A/B footswitches and FULL WET.
- **Automation and macros:** all 42 controls appear in automation lanes and can be mapped to Rack macros.
- **Push banks:**

  | Bank | Controls |
  |---|---|
  | 1 Perform | A Depth, A Feedback, B Depth, B Feedback, Gen1 Rate, Gen2 Rate, Pedal, Mix |
  | 2 Switch | A On, B On, Full Wet, A Sweep, B Sweep, B Sync, B Input, Character |
  | 3 Envelope | Env Amount/Attack/Release/Polarity, Gen1/Gen2 Shape, Gen1 Rate Src, Drive |
  | 4 Output | Output, Out Mode, In A Sum, Route, Bus, Modern Lo/Hi, Hum Freq |
  | 5–6 Quirks | the ten CHARACTER buttons |

The device doesn't receive MIDI itself; it's an audio effect.

## Colours
The panel colours are sampled from a photo of an original unit: the face blue (#3750a9), white section outlines and legends, and charcoal switch blocks. The switch colours follow the original's lever switches: light blue for rate control and Phasor A Sweep, grey for Shape, red for Sweep Sync, and cream for Phasor B Input and Sweep.

## Levels
Feedback is stable at every setting (loop gain ≤ 0.862), but it adds gain. With one phasor at full feedback, peaks can reach about **+12 dB** (+17 dB with FULL WET). Two in series can reach about **+25 dB**. With CLIP on (VINTAGE) the modelled op-amps saturate first, as on the original; in MODERN nothing limits the level, so use Output or Drive.

## Starting points
- **Black Ark wash:** B Input OUT A, Out B (mono), both on Gen 1, NORM, feedback 0.
- **Stereo swirl:** B Input IN A, Out A|B, both on Gen 1, REV (opposite) or QUAD (rotating), feedback ~60–80.
- **Skank that reacts:** A Sweep ENV, UP, Amount ~60 %, Attack 4 ms, Release 150 ms, Feedback ~50.
- **Two-speed:** B on G2; Gen 1 slow on A at full depth and feedback, Gen 2 faster on B at 50 %.

## Build and test
```
pip install -r requirements.txt      # m4l-builder==0.7.0
python3 src/build_device.py          # rebuilds both devices (byte-reproducible)
python3 tests/run_tests.py           # static + DSP suites, exit 1 on any failure (needs node >= 18)
node tests/render_auditions.js out/  # renders the A/B audition WAVs
```
See `docs/SPRINT_REPORT.md` (this sprint, plus the RC1 remediation) and `ENGINEERING.md` (circuit model).
