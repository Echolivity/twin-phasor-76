"""Emits the GenExpr (gen~ codebox) source for the Twin Phasor DSP.

Circuit model follows the Bi-Phase audio path (per phasor):
  input buffer (C2 47n / R4 390k HPF ~8.7 Hz)  -> DRY
  inverting summer U2B:  v1 = -dry + Kfb * fb      (Kfb max = 2*4k7/(4k7+6k2) = 0.862)
  6 x first-order all-pass (C = 6n8, R = LDR || 220k)
  feedback tap -> one-pole ~18 kHz (R11||R13 with C6 3n3) -> back to U2B
  inverting buffer U5A -> WET = -v6
  bypass LDR + mix trim, passive sum with DRY (R32 12k) -> output buffer
Light path: sweep -> LED current -> 1 LED per 3 LDRs (2 LEDs per phasor) -> CdS cells.
"""

STAGES = 6


def phasor_block(p):
    """Return GenExpr for one phasor (p = 'a' or 'b'). Expects x_{p}, G_{p}, lt_{p} defined."""
    L = []
    # --- light -> per-cell conductance ---------------------------------
    L.append(f"// ===== PHASOR {p.upper()} =====")
    L.append(f"I_{p} = qv_law ? (0.004 + 0.996*ls_{p}) : (0.004*pow(250, ls_{p}));")
    L.append(f"fm_{p} = mlo * pow(mhi / mlo, ls_{p});")  # RC1: hoisted out of the stage loop (was computed 6x)
    L.append(f"gt_{p} = pow(I_{p}, 0.85);")
    L.append(f"gsum_{p} = 0;")
    for i in range(STAGES):
        led = 0 if i < 3 else 1          # cells 1-3 share LED 1, cells 4-6 share LED 2
        L.append(f"tg = gt_{p} * (qv_mis ? eff_{p}{led} : 1);")
        L.append(f"g = g_{p}{i};")
        L.append(f"toff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_{p}{i} : 1);")
        L.append(f"cc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));")
        L.append(f"g = qv_lag ? (g + (tg - g) * cc) : tg;")
        L.append(f"g_{p}{i} = g;")
        L.append(f"gsum_{p} = gsum_{p} + g;")
        # resistance -> corner frequency
        L.append(f"R = 3300 * (qv_mis ? rm_{p}{i} : 1) / max(g, 0.0001);")
        L.append(f"R = qv_rng ? (R * 220000 / (R + 220000)) : R;")
        L.append(f"fv = 1 / (twopi * R * 6.8e-9);")
        # RC1: log-domain crossfade between vintage and modern corner (wV smoothed) instead of a hard switch
        L.append(f"fc = fm_{p} * pow(max(fv, 1) / fm_{p}, wV);")
        L.append(f"fc = clamp(fc, 10, sr * 0.45);")
        L.append(f"t = tan(pi * fc / sr);")
        L.append(f"k_{p}{i} = (t - 1) / (t + 1);")
    # --- audio path -------------------------------------------------------
    # C10 470n coupling into the feedback pot (~34 Hz HPF), then the 18 kHz input network
    L.append(f"fhp_{p} = fixdenorm(c_fhp * (fhy_{p} + fb6_{p} - fhx_{p})); fhx_{p} = fb6_{p}; fhy_{p} = fhp_{p};")
    L.append(f"fbl_{p} = fixdenorm(fbl_{p} + (fhp_{p} - fbl_{p}) * c_fb);")
    L.append(f"fbin_{p} = fhp_{p} + wbw * (fbl_{p} - fhp_{p});")  # RC1: smoothed BW switch
    L.append(f"u = -x_{p} + G_{p} * fbin_{p} + (q_noise ? noise() * 1.7e-4 : 0);")
    L.append(f"u = u + wcl * (13.5 * tanh(u / 13.5) - u);")  # RC1: smoothed CLIP switch
    for i in range(STAGES):
        L.append(f"y = fixdenorm(k_{p}{i} * u + x1_{p}{i} - k_{p}{i} * y1_{p}{i});")
        L.append(f"x1_{p}{i} = u; y1_{p}{i} = y; u = y;")
    L.append(f"fb6_{p} = u;")
    L.append(f"wet_{p} = -(u + wcl * (13.5 * tanh(u / 13.5) - u));")
    # --- optical bypass / mix -------------------------------------------------
    L.append(f"bt = {p}_on;")
    L.append(f"cb = q_fade ? ((bt > bp_{p}) ? c_bon : c_boff) : c_fast;")
    L.append(f"bp_{p} = fixdenorm(bp_{p} + (bt - bp_{p}) * cb);")
    L.append(f"mm = mix_s;")  # RC1: FULL WET folded into the smoothed mix target
    L.append(f"o_{p} = x_{p} * (1 - mm * bp_{p}) + wet_{p} * mm * bp_{p};")
    L.append(f"led_{p} = (wV * pow(gsum_{p} / {STAGES}, 1.1765) + (1 - wV) * ls_{p}) * bp_{p};")
    return "\n".join(L)


def build():
    H = []
    P = []
    # ---- parameters -------------------------------------------------------
    params = [
        ("g1_rate", 0.6, 0.1, 18), ("g1_shape", 0, 0, 1), ("g1_src", 0, 0, 1),
        ("g2_rate", 3.5, 0.1, 18), ("g2_shape", 0, 0, 1),
        ("a_on", 1, 0, 1), ("a_depth", 0.8, 0, 1), ("a_fb", 0.35, 0, 1), ("a_sweep", 0, 0, 2),
        ("b_on", 0, 0, 1), ("b_depth", 0.8, 0, 1), ("b_fb", 0.35, 0, 1), ("b_sweep", 0, 0, 3),
        ("b_sync", 0, 0, 2), ("b_input", 1, 0, 2),
        ("pedal", 0.5, 0, 1),
        ("mixamt", 0.5, 0, 1), ("fullwet", 0, 0, 1),
        ("outmode", 1, 0, 3), ("insum", 1, 0, 1),
        ("drive", 0, -24, 24), ("outgain", 0, -24, 12), ("route", 0, 0, 2),
        ("vintage", 1, 0, 1),
        ("q_lag_p", 1, 0, 1), ("q_mis_p", 1, 0, 1), ("q_law_p", 1, 0, 1), ("q_rng_p", 1, 0, 1),
        ("q_clip_p", 1, 0, 1), ("q_noise_p", 1, 0, 1), ("q_hum_p", 0, 0, 1), ("hum_hz", 0, 0, 1),
        ("q_fade_p", 1, 0, 1), ("q_lfo_p", 1, 0, 1), ("q_bw_p", 1, 0, 1),
        ("mod_lo", 150, 20, 2000), ("mod_hi", 9000, 500, 18000),
        # S1 envelope sweep source (shared follower on the device input)
        ("env_amt", 0.5, 0, 1), ("env_att", 10, 1, 100), ("env_rel", 250, 20, 2000), ("env_pol", 0, 0, 1),
    ]
    for n, d, lo, hi in params:
        P.append(f"Param {n}({d}, min={lo}, max={hi});")

    # ---- state ------------------------------------------------------------
    hist = ["ph1", "ph2", "ped_s", "mix_s", "da_s", "db_s", "fa_s", "fb_s", "drv_s", "og_s",
            "lsa", "lsb", "envf", "eamt_s", "hp_xa", "hp_ya", "hp_xb", "hp_yb", "humph",
            "fb6_a", "fb6_b", "fhx_a", "fhy_a", "fhx_b", "fhy_b", "fbl_a", "fbl_b", "bp_a", "bp_b",
            "wV", "wbw", "wcl", "wr0", "wr1", "wr2", "wo0", "wo1", "wo2", "wo3", "wi0", "wi1", "wi2",
            "wV1", "wbw1", "wcl1", "wr0a", "wr1a", "wr2a", "wo0a", "wo1a", "wo2a", "wo3a", "wi0a", "wi1a", "wi2a"]
    # one-hot switch weights start at the parameter defaults so a fresh instance does not fade in
    init1 = {"wV": 1, "wbw": 1, "wcl": 1, "wr0": 1, "wo1": 1, "wi1": 1,
             "wV1": 1, "wbw1": 1, "wcl1": 1, "wr0a": 1, "wo1a": 1, "wi1a": 1}
    for p in "ab":
        for i in range(STAGES):
            hist += [f"g_{p}{i}", f"x1_{p}{i}", f"y1_{p}{i}"]
            init1[f"g_{p}{i}"] = 0.3
    for h in hist:
        H.append(f"History {h}({init1.get(h, 0)});")

    # fixed component-tolerance spread of one "unit" (deterministic, so recalls match)
    import random
    rnd = random.Random(1976)
    consts = []
    for p in "ab":
        for led in range(2):
            consts.append(f"eff_{p}{led} = {1 + rnd.uniform(-0.18, 0.18):.4f};")
        for i in range(STAGES):
            consts.append(f"rm_{p}{i} = {1 + rnd.uniform(-0.12, 0.12):.4f};")
            consts.append(f"tk_{p}{i} = {1 + rnd.uniform(-0.25, 0.25):.4f};")

    B = []
    B.append("sr = samplerate;")
    B.append("V = vintage > 0.5;")
    for q in ["lag", "mis", "law", "rng", "clip", "noise", "hum", "fade", "lfo", "bw"]:
        B.append(f"q_{q} = V && (q_{q}_p > 0.5);")
    for q in ["lag", "mis", "law", "rng"]:
        B.append(f"qv_{q} = q_{q}_p > 0.5;")
    B += consts
    # coefficients
    B.append("c_sm  = 1 - exp(-twopi * 15 / sr);")   # control smoothing (~10 ms)
    B.append("c_on  = 1 - exp(-1 / (0.004 * sr));")  # CdS rise ~4 ms
    B.append("c_fb  = 1 - exp(-twopi * 18000 / sr);") # feedback-path LPF (6k2||4k7, 3n3)
    B.append("c_bon = 1 - exp(-1 / (0.010 * sr));")  # bypass LDR lighting
    B.append("c_boff= 1 - exp(-1 / (0.150 * sr));")  # bypass LDR going dark (slow tail)
    B.append("c_fast= 1 - exp(-1 / (0.006 * sr));")  # RC1: 3 -> 6 ms (modern bypass ramp)
    B.append("c_sw  = 1 - exp(-1 / (0.003 * sr));")  # RC1: 2-pole de-click for discrete switches (~15 ms to 99 %)
    B.append("c_ls  = 1 - exp(-1 / (0.003 * sr));")  # modern-mode sweep slew (de-click squares)
    B.append("c_hp  = exp(-twopi * 8.7 / sr);")
    B.append("c_fhp = exp(-twopi * 34 / sr);")      # input coupling C2/R4
    # smoothed controls
    B.append("mix_t = (fullwet > 0.5) ? 1 : mixamt;")
    for src, dst in [("pedal", "ped_s"), ("mix_t", "mix_s"), ("a_depth", "da_s"), ("b_depth", "db_s"),
                     ("a_fb", "fa_s"), ("b_fb", "fb_s")]:
        B.append(f"{dst} = {dst} + ({src} - {dst}) * c_sm;")
    B.append("drv_s = drv_s + (dbtoa(drive) - drv_s) * c_sm;")
    B.append("og_s = og_s + (dbtoa(outgain) - og_s) * c_sm;")
    B.append("mlo = min(mod_lo, mod_hi * 0.9); mhi = mod_hi;")
    # RC1: smoothed weights for every discrete switch that sits directly in the audio path
    for w, t in [("wV", "V"), ("wbw", "q_bw"), ("wcl", "q_clip")]:
        B.append(f"{w}1 = fixdenorm({w}1 + ({t} - {w}1) * c_sw); {w} = fixdenorm({w} + ({w}1 - {w}) * c_sw);")
    for k in range(3):
        B.append(f"wr{k}a = fixdenorm(wr{k}a + ((abs(route - {k}) < 0.5) - wr{k}a) * c_sw); wr{k} = fixdenorm(wr{k} + (wr{k}a - wr{k}) * c_sw);")
        B.append(f"wi{k}a = fixdenorm(wi{k}a + ((abs(b_input - {k}) < 0.5) - wi{k}a) * c_sw); wi{k} = fixdenorm(wi{k} + (wi{k}a - wi{k}) * c_sw);")
    for k in range(4):
        B.append(f"wo{k}a = fixdenorm(wo{k}a + ((abs(outmode - {k}) < 0.5) - wo{k}a) * c_sw); wo{k} = fixdenorm(wo{k} + (wo{k}a - wo{k}) * c_sw);")
    # LFOs
    B.append("r1 = (g1_src > 0.5) ? (0.1 * pow(180, ped_s)) : g1_rate;")
    def shape(n, ph, sh):
        B.append(f"tri{n} = 1 - 4 * abs({ph} - 0.5);")
        B.append(f"sn{n} = q_lfo ? (1.5 * tri{n} - 0.5 * tri{n} * tri{n} * tri{n}) : sin(halfpi * tri{n});")
        B.append(f"lfo{n} = ({sh} > 0.5) ? (({ph} < 0.5) ? -1 : 1) : sn{n};")
    for n, r, sh in [("1", "r1", "g1_shape"), ("2", "g2_rate", "g2_shape")]:
        B.append(f"ph{n} = wrap(ph{n} + {r} / sr, 0, 1);")
        shape(n, f"ph{n}", sh)
    # S1: Gen 1 shifted +90 deg, used only when B follows Gen 1 with Sweep Sync = QUAD
    B.append("ph1q = wrap(ph1 + 0.25, 0, 1);")
    shape("1q", "ph1q", "g1_shape")
    # S1: envelope follower (peak, attack/release in ms) on the raw device input; amount = sensitivity
    B.append("det = max(abs(in1), abs(in2));")
    B.append("ca = 1 - exp(-1 / (env_att * 0.001 * sr)); cr = 1 - exp(-1 / (env_rel * 0.001 * sr));")
    B.append("envf = fixdenorm(envf + (det - envf) * ((det > envf) ? ca : cr));")
    B.append("eamt_s = eamt_s + (env_amt - eamt_s) * c_sm;")
    B.append("ev = clamp(4 * eamt_s * sqrt(envf), 0, 1);")   # 100 % reaches full sweep at -12 dBFS peak
    B.append("se = (env_pol > 0.5) ? (1 - 2 * ev) : (2 * ev - 1);")
    B.append("pv = 2 * ped_s - 1;")
    B.append("sA = (a_sweep < 0.5) ? lfo1 : ((a_sweep < 1.5) ? pv : se);")
    B.append("g1b = (b_sync > 1.5) ? lfo1q : lfo1;")
    B.append("sB = (b_sweep < 0.5) ? g1b : ((b_sweep < 1.5) ? lfo2 : ((b_sweep < 2.5) ? pv : se));")
    B.append("sB = (abs(b_sync - 1) < 0.5) ? -sB : sB;")
    B.append("lt_a = clamp(0.5 + 0.5 * sA * da_s, 0, 1);")
    B.append("lt_b = clamp(0.5 + 0.5 * sB * db_s, 0, 1);")
    B.append("lsa = fixdenorm(lsa + (lt_a - lsa) * c_ls); ls_a = lsa;")
    B.append("lsb = fixdenorm(lsb + (lt_b - lsb) * c_ls); ls_b = lsb;")
    B.append("G_a = fa_s * 0.862; G_b = fb_s * 0.862;")
    # inputs -> volts (0 dBFS peak = 2 V, the manual's reference level)
    B.append("vs = 2 * drv_s;")
    B.append("inA = ((insum > 0.5) ? 0.5 * (in1 + in2) : in1) * vs;")
    B.append("inB = in2 * vs;")
    B.append("hA = fixdenorm(c_hp * (hp_ya + inA - hp_xa)); hp_xa = inA; hp_ya = hA;")
    B.append("hB = fixdenorm(c_hp * (hp_yb + inB - hp_xb)); hp_xb = inB; hp_yb = hB;")
    B.append("x_a = inA + wbw * (hA - inA);")
    B.append(phasor_block("a"))
    B.append("srcB = inB + wbw * (hB - inB);")
    B.append("x_b = wi0 * x_a + wi1 * o_a + wi2 * srcB;")
    B.append(phasor_block("b"))
    # hum (mains: 60 Hz US unit, 50 Hz Jamaica)
    B.append("hz = (hum_hz > 0.5) ? 60 : 50;")
    B.append("humph = wrap(humph + hz / sr, 0, 1);")
    B.append("hum = q_hum ? (2e-4 * sin(twopi * humph) + 6e-5 * sin(3 * twopi * humph)) : 0;")
    # output modes: 0 A|B stereo, 1 B mono, 2 A mono, 3 A+B mono
    B.append("mono = wo1 * o_b + wo2 * o_a + wo3 * 0.5 * (o_a + o_b);")
    B.append("oL = wo0 * o_a + mono; oR = wo0 * o_b + mono;")
    B.append("sc = og_s / vs;")
    B.append("pL = (oL + hum) * sc; pR = (oR + hum) * sc;")
    # routing: 0 normal, 1 dry on track + processed to bus, 2 processed to bus only
    B.append("out1 = wr0 * pL + wr1 * in1; out2 = wr0 * pR + wr1 * in2;")
    B.append("out3 = (wr1 + wr2) * pL; out4 = (wr1 + wr2) * pR;")
    B.append("out5 = led_a;")
    B.append("out6 = led_b;")

    return "\n".join(P + [""] + H + [""] + B) + "\n"


if __name__ == "__main__":
    from pathlib import Path
    code = build()
    (Path(__file__).resolve().parent.parent / "twinphasor.genexpr").write_text(code)
    print(len(code.splitlines()), "lines")
