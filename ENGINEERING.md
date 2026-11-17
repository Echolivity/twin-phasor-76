# Twin Phasor 76: engineering reference

This document collects what the model is built on: the original unit's published specs and the circuit values used in the DSP. It also covers each vintage quirk, what it models and how sure we are of it.

## 1. Sources and how they are used

| Source | What it gives | Status |
|---|---|---|
| Original Bi-Phase owner's manual (full text reproduced by Soundgas) — https://soundgas.com/blogs/resources/mutron-biphase-owners-manual | Controls, modes, rate range, specs, setups | Primary. Not redistributed here; read at the link |
| Original Musitronics ad/spec sheet — https://mu-tron.com/vintage-musitronics/mu-tron-bi-phase/ | Signal-handling vs feedback, I/O impedances | Primary |
| Original factory schematics (photos), Patroche's blog — http://www.crazy-patroche.com/article-mu-tron-biphase-musitronic-plans-et-clonage-108652497.html | Factory drawings | Primary but low-res photos. **Not yet checked line by line; see §6** |
| J. Aceto "semi-clone" KiCad + PDF — https://github.com/JordanAceto/bi_phase_semi_clone | Full audio-path schematic, "very faithful" per author | Used for topology and values. No licence, so linked rather than bundled |
| f.aiseur clone KiCad (CC0) — https://github.com/faiseur-cz/Mutron-BiPhase-clone | Independent clone, full BOM | **Bundled in `reference/`**. Used to cross-check values |
| M. Bareille clone notes — http://m.bareille.free.fr/biphase/biphase.htm | LFO description (triangle-based), optical bypass VCAs | Secondary |
| madbean forum — 1 diffused LED : 3 LDRs in a black canister, 4 canisters | Opto topology | Secondary (builder report) |

Both clones independently agree on the core audio path: 6.8 nF all-pass caps (×12), 220k shunts (×12+), 4k7 all-pass resistor pairs and RC4558 op-amps.

**The service manual itself is not in this package.** I couldn't obtain a redistributable copy. When you get the PDF (mu-tron.com links one), drop it in `reference/` and check §6.

## 2. Published specifications (owner's manual / ad)

- Two independent **6-stage** phasors (A, B) and two sweep generators (Gen 1, Gen 2)
- Sweep rate **0.1 Hz – 18 Hz**; shape **sine or square** per generator
- Gen 1 rate: panel knob (MAN) or pedal (PED). In PED with no pedal connected, it sweeps very slowly
- Phasor A sweep: Gen 1 / Pedal. Phasor B sweep: Gen 1 / Gen 2 / Pedal; Sweep Sync NORM / REV
- Phasor B input: **In A** (Y-split, stereo) / **Out A** (series, "double depth") / **In B** (separate source)
- Feedback adds peaks between the notches; at full it picks out individual harmonics; with the pedal it acts like a wah
- Signal handling: 4 V RMS (one phasor, no feedback) → 2 V RMS (series, 50 % fb) → **1 V RMS (series, 100 % fb)**. This is the source of the CLIP quirk
- SNR 86 dB below 2 V input; output 600 Ω; insertion loss < 1 dB; 115 V / 60 Hz, 15 W
- The phasors don't run unless the footswitch box is connected. Bypass is per phasor on a dual footswitch

## 3. Audio path per phasor (values from clone schematics)

```
IN ─C2 47n─┬─R6 3k9─┬─ U2A buffer ──────────────────────────────── DRY ─R32 12k─┐
        R4 390k   C3 22p                                                         │
                         U2B inverting summer: v1 = −DRY + K·FB                  │
                         (R14/R17 4k7; FB enters + via R11 6k2 / R13 4k7, C6 3n3) │
             ┌── 6 × all-pass: 4k7/4k7 op-amp, C 6n8 series, LDR ∥ 220k to gnd    │
             │   H(s) = −(1 − sRC)/(1 + sRC), R = LDR ∥ 220k                      │
             └─ v6 ─C10 470n─┬─ R22 6k8 / RV1 feedback pot → FB                   │
                              └─ R25 → U5A inverter (4k7/4k7 ∥ 1n) → WET          │
                                 WET ─ bypass LDR ─ C13 220n ─ mix trim 10k ──────┴─ U5B ─ 560 ─ 10µ ─ OUT
```

How each part maps into the DSP (`twinphasor.genexpr`):

| Circuit | DSP |
|---|---|
| C2/R4 input coupling, fc = 8.7 Hz | one-pole HPF (BW quirk) |
| U2B summer, K_max = 2·4k7/(4k7+6k2) = **0.862** | `u = −x + 0.862·fb·fbin` |
| R11∥R13 with C6 3n3 → ~18 kHz | one-pole LPF in the feedback path (BW quirk) |
| C10 470n into the ~10k feedback network → ~34 Hz | one-pole HPF in the feedback path (always on; stops LF build-up) |
| 6 all-passes, C = 6n8, R = LDR ∥ 220k | bilinear first-order all-pass, prewarped, per stage |
| U5A inversion | `wet = −v6`. Six inverting stages plus two inverters, so wet is in phase at DC |
| Passive mix of DRY (12k) and WET (bypass LDR + trim) | `out = dry·(1 − m·b) + wet·m·b`, m = 0.5 for the vintage trim |
| Bypass LDR | per-phasor bypass envelope (FADE quirk) |

Notches fall where the six-stage phase reaches −180°, at ωRC = tan 15°, tan 45°, tan 75°: **three notches at 0.27·fc, fc and 3.73·fc**. Offline test at mid-sweep: 1.03 k / 3.86 k / 11.9 k Hz. With full feedback, the peaks between notches rise by +10 to +12 dB.

## 4. Light path

Sweep generator → LED driver (depth sets the current swing) → **1 LED : 3 CdS cells**, two canisters per phasor (cells 1–3 and 4–6).

DSP model:
- LED current `I = 0.004 + 0.996·L` (linear, **LAW** on) or exponential (LAW off)
- CdS conductance `g ∝ I^0.85`; `R = 3.3 kΩ / g`, then ∥ 220k (**RANGE**). Range: fc ≈ 170 Hz – 7 kHz (lowest notch ≈ 46 Hz, highest ≈ 26 kHz)
- Dynamics (**LAG**): rise τ ≈ 4 ms; decay τ = 20 ms/√g, clamped to 20–350 ms. Dark cells recover slowly. This rounds the square wave into the "lurch" and makes a sine sweep rise faster than it falls
- Mismatch (**CELLS**): LED efficiency ±18 % per canister, cell resistance ±12 %, decay time ±25 %. Fixed seed (1976), so every instance behaves like the same unit and recalls stay identical

These photocell constants are typical CdS figures. **They have not been measured on an original unit.** They are the first thing to calibrate (see §6).

## 5. Quirk switches (all disabled by MODERN)

| Button | Models | Audible result | Confidence |
|---|---|---|---|
| LAG | CdS asymmetric response and memory | Square sweep becomes a snap-then-slide; sine sweep becomes lopsided; LED-lag "ghost" | High (physics), constants estimated |
| CELLS | Unmatched LDRs and LEDs | Notches spread and soften, less "perfect" | High (qualitative) |
| LAW | Linear LED current into a power-law cell | Sweep lingers high and dives fast at the bottom | Medium |
| RANGE | 220k shunt on each cell | Low-end floor: notches can't go below ~46 Hz | High (from schematic) |
| CLIP | RC4558 rails (~±13.5 V) in the feedback summer | Grit at high feedback and hot input, as the 1 V RMS spec implies. DRIVE sets how hard | High |
| HISS | −86 dB noise injected before the stages | Becomes audible when feedback amplifies it | High (spec) |
| HUM | 50/60 Hz mains with 3rd harmonic (off by default) | Jamaica runs 50 Hz; the US unit was built for 60 Hz | Speculative, for flavour |
| FADE | Optical bypass LDR | Click-free switch-in (~10 ms); slow tail-out (~150 ms) | Medium |
| LFO | Shaped-triangle "sine" (clones use triangle cores) | Slightly flattened sine | **Low: verify on the factory drawing** |
| BW | Input HPF and feedback LPF | Subtle top/bottom rounding | High |

MODERN mode: matched cells, no lag (3 ms de-click slew only), log-uniform sweep between Modern Lo/Hi, no clipping, no noise, fast bypass.

## 6. Open items for the engineering stage

1. **Factory schematic check.** Compare §3 against the original Musitronics drawing (Patroche's photos, or the service manual PDF): the feedback pot wiring (R22/RV1 law, true zero), mix-trim value and the sweep-generator waveform core.
2. **Calibrate LDR constants** against a real unit: record a square sweep at 0.5 Hz with feedback up. Fit the rise/decay constants and the resistance range. Notch positions at depth 0 give R directly.
3. **Depth/offset law.** The model sweeps symmetrically around mid-light. The original LED driver has offset and depth trims (see Aceto `LED_driver` sheet); confirm where the sweep centre sits.
4. **Sweep-rate taper:** check the 0.1–18 Hz pot law against the panel numbers (manual suggests "3–4" and "6" settings).
5. **Panel colours:** the values here are approximations from descriptions (silver case; grey/blue face that fades in sunlight; silver outlines; black switch blocks). Sample them from a good photo and update `build_device.py`.

## 7. Routing and latency (revised in RC1)

Route = *Dry + Bus* keeps the dry signal on the track and sends the processed signal to the device's **outputs 3/4** (`plugout~ 1 2 3 4`). Another track picks it up with *Audio From → <track> → Twin Phasor 76 | 3/4*. This is native Live routing, which Live delay-compensates. It reproduces the desk-return setup Daniel Boyle describes for the Black Ark.

The same signal still feeds the legacy `send~` bus for **Twin Phasor Return**. Cycling '74 states that sending audio between Max for Live devices with `send~`/`receive~` is not supported and that its latency varies with buffer size. The legacy path is kept only for compatibility and is not recommended.

Neither path has been measured in Live yet; see `docs/SPRINT_REPORT.md` §6 (null test).

## 8. Non-original extensions (sprint S1)

These are deliberate additions with no counterpart on the original unit. They aren't authentic behaviour.
- **QUAD** Sweep Sync (B on Gen 1 shifted +90°).
- **ENV** sweep source: a peak follower on max(|L|,|R|) of the raw device input, with attack/release one-poles. The sweep value is clamp(4 · amount · √env, 0, 1), mapped through the phasor's Depth like the other sources. In VINTAGE the photocell model then adds its own lag.

## 9. Classification of model elements

| Class | Elements |
|---|---|
| Circuit-derived (two independent clone schematics agree) | 6 all-pass stages, 6n8/220k values, feedback gain 0.862, input 8.7 Hz HPF, 34 Hz feedback coupling, 18 kHz feedback LPF, notch positions |
| Published spec | 0.1–18 Hz sweep, sine/square, sweep routing, B input modes, signal-handling vs feedback (basis for CLIP) |
| Estimated photocell behaviour (unmeasured) | CdS law exponent 0.85, 3.3 kΩ lit resistance, 4 ms rise, 20–350 ms level-dependent decay, mismatch spreads |
| Engineering approximation | linear LED law (LAW), shaped-triangle LFO, optical bypass timings, hiss/hum levels, symmetric depth around mid-sweep |
| Sampled from a photo of an original unit (S3) | panel colours: face #3750a9, charcoal blocks, white legends/outlines, light-blue/grey/red/cream levers |
| Subjective interpretation | starting-point settings |

The device has not been compared against an original unit by measurement or listening, and makes no claim of authentic replication.
