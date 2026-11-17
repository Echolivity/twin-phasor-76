# Twin Phasor 76: Practical Improvement Sprint (S1), with RC1 remediation record

> **S3/S4 (2026-11-17).** The owner confirmed the S2/S3 build **loads in Live** (L1 PASS). S3 recoloured the panel from a photo of an original unit. S4 reordered the Push banks so the performance controls come first. Neither changes the sound or saved values. The remaining owner tests are in `docs/OWNER_TESTS.md`; the release decision stays **conditional** until they're back.
>
> **S2 hotfix (2026-11-15).** Owner test L1 **FAILED**: Live 12.4.15 / Max 9.1.5 on Windows 11 crashed (EXCEPTION_ACCESS_VIOLATION) as soon as the S1 device was dropped on a track.
> - **Evidence:** in the owner's crash report, the minidump's faulting thread is inside `maxclang.mxe64` (the gen~ code compiler) called from Max's patch loader, reading address 0x0 in a memory copy. No Max console output preceded the crash.
> - **Changes in S2.** These are structural only; the DSP is unchanged (DSP suite 31/31; T15 shows output identical to RC1 for pre-sprint settings):
>   - object ids `obj-N` at both patcher levels;
>   - the gen~ inner patcher reduced to the keys Max writes;
>   - root `parameters` table and 8-slot banks;
>   - `parameter_mmax` on enum parameters;
>   - `live.text` set back to toggle mode. S1's mode 0 made every on/off button momentary, a separate confirmed defect.
> - **Root cause: not yet confirmed.** `tools/make_bisect.py` builds a 5-step diagnostic ladder (no gen~ → minimal gen~ → declarations → full gen~ → UI only) to isolate it if S2 still crashes.

Status key: **PASS** verified · **FAIL** confirmed defect · **PARTIAL** some evidence · **UNVERIFIED** needs Ableton Live or listening · **N/A**.
Decision key: **IMPLEMENT / DEFER / REJECT**.

Environment: Linux, Python 3.13, node 22, m4l-builder 0.7.0. No Max, no Ableton Live and no listening setup were available. Every "PASS" below is from the offline model (a JS translation of the exact gen~ code) or from static inspection of the patchers.

---

## 1. Audit of existing functionality (RC1, before this sprint)

| Capability | Present? | Evidence (`twinphasor.genexpr`, RC1) |
|---|---|---|
| Independent A/B LFO rates | **Yes.** B can follow Gen 2 (own rate and shape); A follows Gen 1 | `sB = … lfo2 …`; Params `g1_rate`, `g2_rate` |
| Independent modulation depth | **Yes** | `a_depth`, `b_depth` |
| LFO phase relationships | **Partial.** Only 0° (NORM) or 180° (REV) when both follow Gen 1; free-running when B is on Gen 2; no sync or reset | `sB = (b_sync > 0.5) ? -sB : sB` |
| Stereo positioning | **Partial.** Out A\|B hard L/R, or three mono modes; no pan or width | `oL/oR` from `wo0..3` |
| Manual sweep control | **Yes.** PEDAL, scaled by Depth (no effect at Depth 0) | `pv = 2*ped_s-1` |
| Envelope following | **No** | none |
| External sidechain modulation | **No.** IN B accepts a second audio source but not modulation | none |
| Stable feedback control | **Yes.** Loop gain ≤ 0.862; T2 impulse tails reach 0; T1b bounded | tests T1b, T2 |

Measured stereo baseline (dub-chord material, `tests/stereo_metrics.js`). The last column is the mono-sum level relative to the stereo average. Bypass gives 3.01 dB, so any shortfall from that is mono loss.

| Config | L/R correlation | Mono sum vs stereo avg | Mono loss vs bypass |
|---|---|---|---|
| bypass | 1.000 | 3.01 dB | 0 |
| A\|B NORM | 0.999 | 3.01 dB | 0 |
| A\|B REV | 0.688 | 2.27 dB | **0.74 dB** |
| A\|B free (B on Gen 2) | 0.801 | 2.56 dB | 0.45 dB |
| A\|B QUAD (new) | 0.752 | 2.43 dB | 0.58 dB |

---

## 2. Improvement assessment

### 2.1 Independent A/B modulation: **IMPLEMENT (QUAD only)**, DEFER sync and reset
- **Current:** independent rates already exist (B on Gen 2, free-running), as do independent depths and NORM/REV.
- **Limitation:** when A and B share Gen 1 (the usual stereo setup), the only phase choices are 0° (no stereo motion) and 180° (hard ping-pong). The in-between "rotating" relationship isn't available.
- **Modification:** a third option on the existing Sweep Sync switch: **QUAD** (B = Gen 1 shifted +90°). No new control.
  - **Rejected alternatives:** a continuous phase knob (new control, not needed for the musical case); Gen 2 sync or reset (DEFER: free-running is the original's character, and no scenario showed a need).
- **Expected benefit:** smoother circular stereo movement on pads and chords, less extreme than REV. Measured correlation 0.75 vs 0.69 for REV; mono loss 0.58 dB.
- **Effort:** low (one extra LFO shape evaluation, one enum entry).
- **Regression risk:** low. The new value is appended (index 2), so stored NORM/REV values keep their meaning.
- **Evidence:**
  - T16 measures QUAD at 90.0° and REV at 180.0°.
  - T15 shows all pre-sprint settings render bit-identically to RC1.
  - T12 covers switching to QUAD with no clicks; T1 covers QUAD + square sweep at 18 Hz + full feedback (finite, bounded).
  - Audible benefit: **UNVERIFIED** (no listening yet).

### 2.2 Envelope-controlled sweep: **IMPLEMENT**
- **Current:** none. The sweep can only come from an LFO or the pedal.
- **Limitation:** the phasing can't react to playing dynamics. That's the main missing tool for skank guitar/organ and percussion in dub, where you want the phase to "speak" with each hit instead of drifting independently.
- **Modification:** **ENV** is added as a sweep source on both phasors (appended enum values). One shared follower watches the device input, with the four required controls (Amount, Attack, Release, UP/DOWN), placed in the previously empty lower half of the Gen 2 panel. Depth keeps its existing role as sweep range. No matrix and no new routing; VINTAGE's photocell lag acts on the envelope as it does on the LFO.
- **Expected benefit:** sweep follows the music. Measured sweep-to-input-envelope correlation: organ skank **0.86** with ENV vs 0.04 with LFO; percussion **0.73** vs 0.38.
- **Limitation found:** on a sustained bass line the envelope barely moves (sweep SD 0.045 vs 0.263 for the LFO), so ENV adds little on bass. Use the LFO there.
- **Effort:** moderate: 4 Params, about 8 lines of DSP, 5 UI objects.
- **Regression risk:** low to moderate.
  - Low: T15 shows old settings are bit-identical; T7 shows the follower state is denormal-safe.
  - Moderate: there's new UI in an existing panel, and Live display is untested.
- **Evidence:**
  - T17: tracks the input envelope (r = 0.998); DOWN inverts (−0.998); Amount 0 holds the sweep still.
  - T17b: the release 63 % point is 202 ms for 100 ms and 1992 ms for 1000 ms, as predicted by the √ law (2×).
  - T12: switching to ENV and flipping polarity are click-free.
  - T13: 20 Hz square automation of Amount, Attack and Release produces no steps.
  - T1: ENV with the fastest attack/release and full feedback stays finite and bounded.
  - Audible benefit: **UNVERIFIED.**

### 2.3 Stereo control (A/B pan, width, phase offset): **REJECT** (phase offset covered by 2.1)
- **Current:** Out A\|B hard L/R plus mono modes.
- **Limitation examined:** hard-panned A/B might be too wide, or might not survive mono.
- **Finding:** it survives mono. The worst mono loss is 0.74 dB (REV); there are no collapses or cancellations. Width and pan are available on every Live track (Utility's Width, the mixer pan) at no CPU or complexity cost to this device. The only stereo gap with musical value, an intermediate phase relationship, is filled by QUAD.
- **Modification:** none. **Effort / risk:** zero.
- **Dub Organiser ruling:** rejected. Width and pan inside the device duplicate Live and add controls without improving a production session.

---

## 3. Implementation (traceable changes, S1)

| File | Change |
|---|---|
| `src/gen_dsp.py` | Params: `a_sweep` max 1→2, `b_sweep` 2→3, `b_sync` 1→2 (appended values); new `env_amt` (0–1, default 0.5), `env_att` (1–100 ms, 10), `env_rel` (20–2000 ms, 250), `env_pol` (0/1, 0); state `envf`, `eamt_s`; quadrature Gen 1 copy; envelope follower; source selection for ENV and QUAD |
| `src/build_device.py` | A Sweep "GEN 1·PED·ENV"; B Sweep labels shortened to "G1·G2·PED·ENV" to fit the existing block; Sweep Sync "NORM·REV·QUAD"; ENVELOPE sub-section (3 small dials, UP/DOWN tab) in the Gen 2 panel. Nothing else moved. |
| `tests/` | `material.js`, `stereo_metrics.js`, `render_auditions.js`, `cpu_proxy.js`, `preview_layout.py`; T15–T17b added; ENV/QUAD cases added to T1, T12 and T13; `fixtures/rc1_twinphasor.genexpr` (pre-sprint DSP, used for compatibility tests) |
| Artifacts | `.amxd`, `.maxpat` and `twinphasor.genexpr` regenerated; B2 confirms they're byte-identical to a clean rebuild |

---

## 4. Automated test results

`python3 tests/run_tests.py` → **46/46 PASS, exit 0** (static 15/15, DSP 31/31). Machine-readable results are in `tests/results/`.

The suite catches deliberate defects. I sabotaged a copy of the gen code four ways and each was caught, with a non-zero exit:

| Sabotage | Caught by |
|---|---|
| Loop gain 1.05 | T1, T1b, T2, T3c, T6c, T8, T14 |
| Switch smoothing removed | T12 |
| fixdenorm removed on one stage | T7 (after strengthening T7 to scan every sample) |
| Route outputs swapped | T10 |

What the DSP suite covers (offline model):
- NaN/Inf across 16 configs × 7 signals; gain within theoretical bounds.
- Feedback decay at maximum feedback.
- Notch positions, plus null depth verified in the time domain.
- Full-wet all-pass flatness; bypass transparency.
- DC behaviour; denormals.
- Every parameter at min, max and out of range.
- Rate range 0.1–18 Hz (measured).
- Routing and output-mode semantics.
- LDR lag asymmetry.
- Clicks across 26 switches × 2 modes; zipper noise under 20 Hz automation.
- Level change engaged vs bypassed.
- Preset compatibility, QUAD phase, ENV behaviour and timing.

---

## 5. Performance

| | Result | Status |
|---|---|---|
| JS-model throughput, RC1 → S1 (`tests/cpu_proxy.js`) | default 4.7→4.5 × realtime; A+B at full feedback 4.3→4.0; A+B on ENV 4.1. About 5–7 % added cost per sample. | PARTIAL (relative proxy only) |
| Actual Live CPU, 1 and 8 instances, high feedback | not measured | **UNVERIFIED** |

The added work is one LFO shape, one envelope follower and two `exp` calls per sample. RC1 had already removed six redundant `pow` calls per phasor.

---

## 6. Ableton Live validation: all **UNVERIFIED**

None of this has run in Live. The owner test below takes about 15 minutes in Live 11/12 with Max 8.6+. Record PASS or FAIL in the last column.

| # | Test | Pass condition | Result |
|---|---|---|---|
| L1 | Drag both .amxd files onto audio tracks | Both load with no Max console errors (open the editor, check the console); panel matches `docs/panel_layout_preview.png` | |
| L2 | Play a loop, default settings | Audible slow phasing, LED moves, no clicks, no dropouts | |
| L3 | Mono source on a mono-input track; stereo source with Out A\|B and B Input IN A | Both channels carry signal; IN A = L+R behaves as labelled | |
| L4 | Automate A Depth, B Feedback, Mix and Env Amount with fast breakpoints; also switch A Sweep→ENV, Sweep Sync→QUAD and VINTAGE↔MODERN during playback | No clicks or zipper noise; automation lanes show the new parameter names | |
| L5 | Set every control off-default, save a preset; reset; recall it | All values return, including the new ENV and QUAD settings | |
| L6 | Save the Live set, close Live, reopen | All values restored; audio identical | |
| L7 | Device on/off (Live's own power button) and each PHASOR footswitch | Live bypass is clean; the footswitch fades (slow tail in VINTAGE) | |
| L8 | **Latency/null test, outputs 3/4.** Track 1: Twin Phasor with both phasors OFF, Route = Dry + Bus. Track 2: Audio From = Track 1 → "Twin Phasor 76 \| 3/4", Monitor In, Utility with phase invert. Track 1 at unity. | Master nulls (below −60 dB) at buffer sizes 64, 256 and 1024. If not, record the residual level; that measures the delay. | |
| L9 | Same null test using the **legacy Return** (bus 1) instead of 3/4 | Record the residual at 64, 256 and 1024. Expected not to null, per Cycling '74; this documents the misalignment. | |
| L10 | Four instances on four tracks, all at full feedback, A+B on | CPU meter reading recorded; no dropouts at a 256-sample buffer | |
| L11 | Load a set saved with RC1 (if you have one) | Old settings unchanged; Sweep Sync REV still REV | |

---

## 7. Musical evaluation: **OPEN**

No listening tests have been carried out, and none are reported. Instead, `auditions/` contains A/B renders from the exact DSP model. The material is synthetic stand-ins: dub chord, organ skank, one-drop percussion, roots bass. Each scenario has three files: bypass, existing (RC1 behaviour) and the improvement. A scenario's files share one level trim, so level differences are real.

Objective metrics (`auditions/metrics.json`):

| Scenario | Comparison | Measured difference |
|---|---|---|
| Dub chord | REV vs QUAD | L/R correlation 0.62 → 0.73; same level and sweep range |
| Organ skank | LFO vs ENV | Sweep follows the playing (r 0.04 → 0.86); level vs bypass −1.9 → −0.1 dB |
| Percussion | LFO vs ENV | r 0.38 → 0.73; level unchanged (+1.8/+1.7 dB) |
| Bass | LFO vs ENV | ENV barely moves (sweep SD 0.263 → 0.045). Low band < 120 Hz is +1.2 dB in both: feedback adds a slight bass lift, limited by the 34 Hz coupling. |

**For the listener (Dub Organiser).** Judge each pair on four questions:
1. Does QUAD give movement on the chord that REV doesn't, without smearing?
2. Does ENV make the skank and the hats feel played rather than drifting?
3. Are any ENV settings in the defaults or README unmusical?
4. Is the bass lift welcome or muddy?

If ENV or QUAD isn't an audible improvement in real material, the decision should be revisited. Both are isolated and can be hidden without touching other settings.

---

## 8. RC1 remediation record (preceding stage, first documented here)

Baseline defects found in the delivered package, and how each was fixed:

| ID | Finding | Class | Fix |
|---|---|---|---|
| R1 | `genjs.py` wrote `dsp_test.js` to the working directory, while `t1.js` loaded it from `tests/`, so the tests couldn't run from a checkout | FAIL→fixed | Paths resolved from the file; output in `tests/build/` |
| R2 | `t1.js` had no assertions, always exited 0 and wrote a 31 MB JSON file | FAIL→fixed | `test_dsp.js` with assertions and exit codes; `test_build.py`; `run_tests.py` |
| R3 | Build wrote into the working directory, embedded the current time and used an unpinned dependency, so builds weren't reproducible | FAIL→fixed | Root-relative paths, fixed `SOURCE_DATE_EPOCH`, `requirements.txt` pin; B2 byte check |
| R4 | Sweep rate was 0.05–20 Hz in the UI and DSP but 0.1–18 Hz in the docs and the original spec | FAIL→fixed | 0.1–18 everywhere; B8 checks UI vs DSP; T9 checks measured rate |
| R5 | Hard switches clicked (Full Wet, Route, Out Mode, B Input, VINTAGE↔MODERN, BW, CLIP); in VINTAGE with LAG off, a square sweep stepped the filters | FAIL→fixed | Two-pole ~15 ms crossfades; vintage branch kept running so VINTAGE↔MODERN only crossfades; sweep slewed 3 ms before the cells. Side effect: VINTAGE rise time 7.5 → 11 ms. |
| R6 | Subnormal values in filter states after silence (MODERN) | FAIL→fixed | `fixdenorm` on recursive states (inaudible) |
| R7 | Feedback stability | PASS | No change needed; no limiter added |
| R8 | The Return device relies on `send~`/`receive~` between devices, which Cycling '74 doesn't support (latency varies) | FAIL→mitigated | Added native outputs 3/4 (`plugout~ 1 2 3 4`); Return kept as legacy and labelled as such |
| R9 | Series configuration at full feedback reaches about +25 dB peak in MODERN (CLIP off) | By design | Documented in README "Levels"; no hidden limiter |
| R10 | An expensive `pow` was evaluated 6× per phasor per sample | Fixed | Hoisted out of the stage loop (no sound change) |

---

## 9. Release decision: **CONDITIONAL. Not release-ready.**

| Criterion | Status |
|---|---|
| Reproducible build | PASS |
| Meaningful automated tests | PASS (46/46; sabotage runs caught) |
| DSP stability | PASS (offline model) |
| Loads and operates in Live | **UNVERIFIED** (§6) |
| Routing and latency documented | PARTIAL (mechanism documented; null test L8/L9 pending) |
| Parameter consistency | PASS (B8, T9, T15) |
| Musical validation | **OPEN** (§7) |
| Limitations disclosed | PASS (README "Levels", §2.2 bass, §8 R8/R9, ENGINEERING §8–9) |

The decision can become "release-ready" once L1–L11 pass in Live and a listening session on real material confirms ENV and QUAD.

Remaining known limitations:
- Photocell constants are estimates.
- Panel colours are approximations.
- The JS CPU figures are a proxy only.
- The legacy Return is unsupported by Cycling '74.
- The ENV follower watches the device input, not a sidechain. A sidechain was deliberately deferred.
