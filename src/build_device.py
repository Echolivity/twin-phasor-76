"""Builds Twin Phasor 76.amxd (+ return device) from the gen code.

Run from anywhere:  python3 src/build_device.py [--out DIR]
Output is byte-reproducible (fixed timestamps; override with SOURCE_DATE_EPOCH).
"""
import json, copy, os, sys
from pathlib import Path
ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(Path(__file__).resolve().parent))
OUTDIR = Path(sys.argv[sys.argv.index("--out") + 1]) if "--out" in sys.argv else ROOT
EPOCH = int(os.environ.get("SOURCE_DATE_EPOCH", "1763078400"))  # 2025-11-14T00:00:00Z, fixed for reproducible builds


def stamp(patch):
    pr = patch["patcher"]["project"]
    pr["creationdate"] = EPOCH
    pr["modificationdate"] = EPOCH
    return finalize(patch)


BANKS = [  # S4: Push / bank order, most-played first (8 per bank)
    ("Perform", ["A Depth", "A Feedback", "B Depth", "B Feedback", "Gen1 Rate", "Gen2 Rate", "Pedal", "Mix"]),
    ("Switch", ["A On", "B On", "Full Wet", "A Sweep", "B Sweep", "B Sync", "B Input", "Character"]),
    ("Envelope", ["Env Amount", "Env Attack", "Env Release", "Env Polarity", "Gen1 Shape", "Gen2 Shape", "Gen1 Rate Src", "Drive"]),
    ("Output", ["Output", "Out Mode", "In A Sum", "Route", "Bus", "Modern Lo", "Modern Hi", "Hum Freq"]),
    ("Quirks 1", ["Photocell lag", "Cell mismatch", "LED sweep law", "220k range", "Op-amp clip"]),
    ("Quirks 2", ["Hiss", "Mains hum", "Optical bypass", "Shaped tri LFO", "Circuit bandwidth"]),
    ("Return", ["Return Bus", "Return Level", "Track Thru"]),
]


DEV_NAME = ["Twin Phasor 76"]
PIN_IDS = json.loads((Path(__file__).resolve().parent / "param_ids_s4.json").read_text())


def finalize(patch):
    """S2: bring the generated patch in line with what Max itself writes (compared against
    Ableton's maxdevtools sample devices). Live crashed on load of the S1 build."""
    P = patch["patcher"]
    # 1. Max-style object ids (obj-N); remap patchlines. Parameter objects keep their S4 ids
    #    (UI redesign, 2026-11-18) so saved sets, presets and automation still find them.
    pins = PIN_IDS.get(DEV_NAME[0], {})
    idmap, used = {}, {v[0] for v in pins.values()}
    for b in P["boxes"]:
        v = b["box"].get("saved_attribute_attributes", {}).get("valueof")
        if v and v["parameter_longname"] in pins:
            idmap[b["box"]["id"]] = pins[v["parameter_longname"]][0]
    n = 0
    for b in P["boxes"]:
        if b["box"]["id"] not in idmap:
            n += 1
            while f"obj-{n}" in used:
                n += 1
            idmap[b["box"]["id"]] = f"obj-{n}"
    for b in P["boxes"]:
        b["box"]["id"] = idmap[b["box"]["id"]]
    for l in P["lines"]:
        l["patchline"]["source"][0] = idmap[l["patchline"]["source"][0]]
        l["patchline"]["destination"][0] = idmap[l["patchline"]["destination"][0]]
    # 1b. same for patchers embedded in boxes (gen~): obj-N ids, and only the keys Max writes for dsp.gen
    for b in P["boxes"]:
        sub = b["box"].get("patcher")
        if not sub:
            continue
        sm = {x["box"]["id"]: f"obj-{i + 1}" for i, x in enumerate(sub["boxes"])}
        for x in sub["boxes"]:
            x["box"]["id"] = sm[x["box"]["id"]]
        for l in sub["lines"]:
            l["patchline"]["source"][0] = sm[l["patchline"]["source"][0]]
            l["patchline"]["destination"][0] = sm[l["patchline"]["destination"][0]]
        if sub.get("classnamespace") == "dsp.gen":
            keep = {"fileversion", "appversion", "classnamespace", "rect", "boxes", "lines"}
            for k in list(sub):
                if k not in keep:
                    del sub[k]
    params, longs = {}, []
    for b in P["boxes"]:
        bx = b["box"]
        v = bx.get("saved_attribute_attributes", {}).get("valueof")
        if not v:
            continue
        # 2. enum parameters carry their range, as Max writes it
        if v.get("parameter_type") == 2:
            v["parameter_mmax"] = len(v["parameter_enum"]) - 1
        v.setdefault("parameter_modmode", 0)
        # 3. live.text: our buttons are latching toggles (mode 0 = momentary button in live.text)
        if bx["maxclass"] == "live.text":
            bx.pop("mode", None)
        bx.pop("tabs", None)  # not a live.tab attribute
        params[bx["id"]] = [v["parameter_longname"], v["parameter_shortname"], 0]
        longs.append(v["parameter_longname"])
    # 4. root parameter table + 8-slot banks (Push), as Max saves them.
    #    S4: named, performance-first banks; any parameter not listed is appended in panel order.
    banks, order = {}, []
    named = [b for b in BANKS if any(x in longs for x in b[1])]
    for name, members in named:
        order.append((name, [x for x in members if x in longs]))
    rest = [x for x in longs if not any(x in m for _, m in order)]
    for i in range(0, len(rest), 8):
        order.append(("More" if i == 0 else f"More {i // 8 + 1}", rest[i:i + 8]))
    for i, (name, chunk) in enumerate(order):
        banks[str(i)] = {"index": i, "name": name, "parameters": chunk + ["-"] * (8 - len(chunk))}
    # keep the S4 parameter order
    porder = {v[0]: v[1] for v in pins.values()}
    params = dict(sorted(params.items(), key=lambda kv: porder.get(kv[0], 10 ** 6)))
    params["parameterbanks"] = banks
    params["inherited_shortname"] = 1
    P["parameters"] = params
    # 5. root keys present in current Max-saved devices
    P.update({"assistshowspatchername": 0, "is_mpe": 0, "external_mpe_tuning_enabled": 0, "minimum_live_version": "",
              "minimum_max_version": "", "platform_compatibility": 0, "openrectmode": 0})
    P["project"]["includepackages"] = 0
    return patch
from m4l_builder.container import build_amxd
from m4l_builder.patcher import build_patcher
from m4l_builder.objects import newobj, patchline
from m4l_builder import ui
from m4l_builder.constants import AUDIO_EFFECT
import gen_dsp

# ---------------- palette ----------------
# UI redesign (2026-11-18): graphite body, functional accents. The S3 Bi-Phase palette is kept
# as THEME "classic" (python3 src/build_device.py --theme classic).
THEME = sys.argv[sys.argv.index("--theme") + 1] if "--theme" in sys.argv else "graphite"
h = lambda x, a=1.0: [round(int(x[i:i + 2], 16) / 255, 3) for i in (1, 3, 5)] + [a]
if THEME == "classic":
    FACE_DARK, FACE_LITE, CASE = h("#3750a9"), h("#3d58b2"), h("#c9cacc")
    SECTION, SECTION_LINE = h("#33499c"), h("#f4f4f1")
    INK, INK2, CTRL, CTRL_LINE = h("#f4f4f1"), h("#dfe6f5"), h("#2f3134"), h("#f4f4f1")
    ACC_A, ACC_B, ACC_N = h("#a8cae8"), h("#d8d3c0"), h("#e8e9ea")
    ON_N = ACC_N
    ON_N_INK = h("#151618")
    ON_INK = h("#151618")
else:
    FACE_DARK, FACE_LITE, CASE = h("#1b1c1f"), h("#1b1c1f"), h("#121315")
    SECTION, SECTION_LINE = h("#232529"), h("#2e3136")
    INK, INK2, CTRL, CTRL_LINE = h("#ebebe8"), h("#8e939b"), h("#2b2e33"), h("#3a3e45")
    ACC_A = h("#6aa2dc")   # Phasor A: restrained cool blue
    ACC_B = h("#e0a250")   # Phasor B: restrained warm amber
    ACC_N = h("#c7cbd1")   # shared / global: neutral (arcs, focus)
    ON_N = h("#5b616b")    # neutral switch "on" fill: lifted grey, not white
    ON_N_INK = h("#ebebe8")
    ON_INK = h("#141517")
TRACK = h("#3a3d43")       # unlit part of dial arcs
CLEAR = [0, 0, 0, 0]
FONT, FONT_B = "Ableton Sans Medium", "Ableton Sans Bold"

W, H = 1144, 169
boxes, lines = [], []
_n = [0]


def nid(prefix="o"):
    _n[0] += 1
    return f"{prefix}-{_n[0]}"


def add(b):
    boxes.append(b)
    return b["box"]["id"]


def line(a, ao, b, bi):
    lines.append(patchline(a, ao, b, bi))


def set_init(box_id, value, shortname=None, longname=None):
    for b in boxes:
        if b["box"]["id"] == box_id:
            v = b["box"]["saved_attribute_attributes"]["valueof"]
            v["parameter_initial_enable"] = 1
            v["parameter_initial"] = [value]
            if shortname:
                v["parameter_shortname"] = shortname
            if longname:
                v["parameter_longname"] = longname


# --------------------------- gen~ with embedded codebox ---------------------------
code = gen_dsp.build()
(OUTDIR / "twinphasor.genexpr").write_text(code)
NOUT = 6
gen_boxes = [{"box": {"id": "cb", "maxclass": "codebox", "code": code, "fontface": 0,
                      "fontname": "<Monospaced>", "fontsize": 12.0, "numinlets": 2,
                      "numoutlets": NOUT, "outlettype": [""] * NOUT,
                      "patching_rect": [50.0, 80.0, 700.0, 600.0]}}]
gen_lines = []
for i in (1, 2):
    gen_boxes.append({"box": {"id": f"in{i}", "maxclass": "newobj", "text": f"in {i}", "numinlets": 0,
                              "numoutlets": 1, "outlettype": [""], "patching_rect": [50.0 + 100 * i, 30.0, 30.0, 22.0]}})
    gen_lines.append({"patchline": {"source": [f"in{i}", 0], "destination": ["cb", i - 1]}})
for i in range(1, NOUT + 1):
    gen_boxes.append({"box": {"id": f"out{i}", "maxclass": "newobj", "text": f"out {i}", "numinlets": 1,
                              "numoutlets": 0, "patching_rect": [50.0 + 90 * i, 700.0, 37.0, 22.0]}})
    gen_lines.append({"patchline": {"source": ["cb", i - 1], "destination": [f"out{i}", 0]}})
gen_patcher = {"fileversion": 1, "appversion": {"major": 8, "minor": 6, "revision": 5, "architecture": "x64", "modernui": 1},
               "classnamespace": "dsp.gen", "rect": [100.0, 100.0, 900.0, 800.0], "bglocked": 0,
               "openinpresentation": 0, "default_fontsize": 12.0, "default_fontface": 0,
               "default_fontname": "Arial", "gridonopen": 1, "gridsize": [15.0, 15.0], "gridsnaponopen": 1,
               "objectsnaponopen": 1, "statusbarvisible": 2, "toolbarvisible": 1, "boxes": gen_boxes,
               "lines": gen_lines}
GEN = add(newobj("gen", "gen~", numinlets=2, numoutlets=NOUT, outlettype=["signal"] * NOUT,
                 patching_rect=[30, 300, 400, 22], patcher=gen_patcher))
PIN = add(newobj("plugin", "plugin~", numinlets=1, numoutlets=2, outlettype=["signal", "signal"], patching_rect=[30, 250, 60, 22]))
# RC1: outputs 3/4 are exposed to Live, so another track can take them via Audio From (supported, delay-compensated)
POUT = add(newobj("plugout", "plugout~ 1 2 3 4", numinlets=4, numoutlets=0, patching_rect=[30, 400, 100, 22]))
line(PIN, 0, GEN, 0); line(PIN, 1, GEN, 1)
line(GEN, 0, POUT, 0); line(GEN, 1, POUT, 1)
SL = add(newobj("sendL", "send~ tpx_bus1_L", numinlets=1, numoutlets=0, patching_rect=[150, 400, 110, 22]))
SR = add(newobj("sendR", "send~ tpx_bus1_R", numinlets=1, numoutlets=0, patching_rect=[270, 400, 110, 22]))
line(GEN, 2, SL, 0); line(GEN, 3, SR, 0)  # legacy bus for Twin Phasor Return (send~ between devices: not supported by Cycling '74)
line(GEN, 2, POUT, 2); line(GEN, 3, POUT, 3)

_py = [500]


def to_gen(ctrl_id, param, scale=None):
    """Wire a control's value into gen~ as 'param value'."""
    y = _py[0]; _py[0] += 26
    src = ctrl_id
    if scale is not None:
        m = add(newobj(nid("sc"), f"* {scale}", numinlets=2, numoutlets=1, outlettype=["float"], patching_rect=[500, y, 50, 22]))
        line(src, 0, m, 0); src = m
    p = add(newobj(nid("pp"), f"prepend {param}", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[560, y, 120, 22]))
    line(src, 0, p, 0); line(p, 0, GEN, 0)


# ------------------------------------ panel ------------------------------------
# UI redesign 2026-11-18. Layout only: every control keeps its S4 parameter name, range, default,
# enum and object id (see src/param_ids_s4.json, enforced by tests/test_build.py B14).


def deco(b):
    """Decorative panels/labels sit in the background layer so they never cover a control."""
    b["box"]["background"] = 1
    return add(b)


def fill(c):
    return {"type": "color", "color": c}


def rect(x, y, w, h_, color, r=0, border=None):
    kw = dict(bgcolor=color, rounded=r, bgfillcolor=fill(color))
    if border:
        kw.update(border=1, bordercolor=border)
    return deco(ui.panel(nid("p"), [x, y, w, h_], **kw))


def label(x, y, w, text, size=8.5, just=0, color=None, bold=False):
    return deco(ui.comment(nid("lb"), [x, y, w, 13], text, textcolor=color or INK2, fontsize=size,
                           fontname=FONT_B if bold else FONT, justification=just))


def section(x, w, title, acc):
    rect(x, TOP, w, BOT - TOP, SECTION, r=6, border=SECTION_LINE)
    rect(x + 8, TOP + 7, 3, 11, acc, r=1)
    label(x + 15, TOP + 5, w - 20, title, size=10, color=INK, bold=True)


def dial(x, y, var, short, mn, mx, init, unit, param, scale=None, exp=1.0, w=46, h=50, acc=None, tip=""):
    d = add(ui.dial(nid("d"), var, [x, y, w, h], min_val=mn, max_val=mx, initial=init, shortname=short,
                    unitstyle=unit, parameter_exponent=exp, activedialcolor=acc or ACC_N, dialcolor=TRACK,
                    needlecolor=INK, activeneedlecolor=INK, textcolor=INK, focusbordercolor=acc or ACC_N,
                    fontname=FONT, fontsize=9.0, annotation=tip, annotation_name=var))
    to_gen(d, param, scale)
    return d


def tab(x, y, w, h, var, short, options, init, param, acc=None, tip="", fs=8.5):
    a = acc or ON_N
    ink_on = ON_INK if acc else ON_N_INK
    t = add(ui.tab(nid("t"), var, [x, y, w, h], options=options, bgcolor=CTRL, activebgcolor=CTRL,
                   bgoncolor=a, activebgoncolor=a, textcolor=INK2, activetextcolor=INK2, textoncolor=ink_on,
                   activetextoncolor=ink_on, bordercolor=CTRL_LINE, focusbordercolor=a,
                   fontname=FONT_B, fontsize=fs, annotation=tip, annotation_name=var))
    set_init(t, init, shortname=short)
    to_gen(t, param)
    return t


def txt(x, y, w, h, var, short, off, on, init, param, acc=None, tip=""):
    a = acc or ON_N
    ink_on = ON_INK if acc else ON_N_INK
    t = add(ui.live_text(nid("x"), var, [x, y, w, h], text_off=off, text_on=on, shortname=short,
                         bgcolor=CTRL, bgoncolor=a, textcolor=INK2, textoncolor=ink_on, rounded=3.0,
                         fontname=FONT_B, fontsize=8.5, activebgcolor=CTRL, activebgoncolor=a,
                         activetextcolor=INK2, activetextoncolor=ink_on, bordercolor=CTRL_LINE,
                         annotation=tip, annotation_name=var))
    set_init(t, init)
    to_gen(t, param)
    return t


def menu(x, y, w, var, short, options, init, param=None, tip=""):
    m = add(ui.menu(nid("m"), var, [x, y, w, 15], options=options, shortname=short,
                    bgcolor=CTRL, activebgcolor=CTRL, textcolor=INK, activetextcolor=INK,
                    tricolor=INK2, bordercolor=CTRL_LINE, fontname=FONT, fontsize=9.0,
                    annotation=tip, annotation_name=var))
    set_init(m, init)
    if param:
        to_gen(m, param)
    return m


def led(x, y, gen_outlet, acc):
    """Sweep-position lamp: brightness follows the modelled light level, in the section's accent."""
    lp = add(ui.panel(nid("led"), [x, y, 9, 9], bgcolor=TRACK, rounded=9, bgfillcolor=fill(TRACK)))
    y0 = _py[0]; _py[0] += 26
    s = add(newobj(nid("snap"), "snapshot~ 33", numinlets=2, numoutlets=1, outlettype=["float"], patching_rect=[800, y0, 80, 22]))
    t = add(newobj(nid("tff"), "t f f f", numinlets=1, numoutlets=3, outlettype=["float"] * 3, patching_rect=[890, y0, 50, 22]))
    pk = add(newobj(nid("pk"), "pack 0. 0. 0. 1.", numinlets=4, numoutlets=1, outlettype=[""], patching_rect=[1300, y0, 100, 22]))
    for k in range(3):
        lo, hi = TRACK[k], acc[k]
        e = add(newobj(nid("e"), f"expr {lo}+{round(hi - lo, 3)}*$f1", numinlets=1, numoutlets=1, outlettype=[""],
                       patching_rect=[950 + 115 * k, y0, 110, 22]))
        line(t, 2 - k, e, 0); line(e, 0, pk, k)
    pr = add(newobj(nid("pr"), "prepend bgfillcolor", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[1410, y0, 110, 22]))
    line(GEN, gen_outlet, s, 0); line(s, 0, t, 0); line(pk, 0, pr, 0); line(pr, 0, lp, 0)


TOP, BOT = 24, 165
add(ui.panel("bg_face", [0, 0, W, H], bgcolor=FACE_DARK, bgfillcolor=fill(FACE_DARK)))
boxes[-1]["box"]["background"] = 1
# header strip
label(10, 4, 140, "TWIN PHASOR 76", size=11, color=INK, bold=True)
label(128, 5, 300, "ECHOLIVITY  ·  DUAL OPTICAL PHASER", size=8.5)

# ---- controls are created in the same order as S4 (ids are pinned anyway) ----
XA, XM, XB, XO, XC = 6, 180, 504, 760, 942
section(XA, 168, "PHASOR A", ACC_A)
section(XM, 318, "MODULATION", ACC_N)
section(XB, 250, "PHASOR B", ACC_B)
section(XO, 176, "OUTPUT", ACC_N)
section(XC, 196, "CHARACTER", ACC_N)

# SWEEP GENERATOR 1  (Modulation, left column)
x = XM
label(x + 60, 41, 60, "GEN 1", size=8, bold=True)
dial(x + 6, 42, "Gen1 Rate", "G1 Rate", 0.1, 18.0, 0.6, 3, "g1_rate", exp=3.0, w=46, h=48,
     tip="Sweep generator 1 speed, 0.1-18 Hz. Drives Phasor A, and Phasor B when B Sweep = G1.")
tab(x + 58, 55, 62, 15, "Gen1 Shape", "G1 Shape", ["SINE", "SQR"], 0, "g1_shape", tip="Gen 1 waveform.")
tab(x + 58, 74, 62, 15, "Gen1 Rate Src", "G1 Src", ["MAN", "PED"], 0, "g1_src",
    tip="MAN: Rate knob sets the speed. PED: the Pedal sets the speed (0.1-18 Hz).")

# PHASOR A
x = XA
dial(x + 8, 44, "A Depth", "A Depth", 0, 100, 80, 5, "a_depth", scale=0.01, w=74, h=70, acc=ACC_A,
     tip="How far the sweep moves Phasor A's notches.")
dial(x + 86, 44, "A Feedback", "A Fdbk", 0, 100, 35, 5, "a_fb", scale=0.01, w=74, h=70, acc=ACC_A,
     tip="Resonance between the notches. Adds level at high settings.")
label(x + 10, 118, 80, "SWEEP")
tab(x + 8, 132, 152, 17, "A Sweep", "A Sweep", ["GEN 1", "PED", "ENV"], 0, "a_sweep", acc=ACC_A,
    tip="What moves Phasor A: Gen 1, the Pedal, or the input envelope.")
txt(x + 116, TOP + 4, 44, 15, "A On", "A On", "OFF", "ON", 1, "a_on", acc=ACC_A,
    tip="Phasor A footswitch. Optical fade in VINTAGE (FADE).")
led(x + 103, TOP + 7, 4, ACC_A)

# PHASOR B
x = XB
dial(x + 8, 44, "B Depth", "B Depth", 0, 100, 80, 5, "b_depth", scale=0.01, w=68, h=70, acc=ACC_B,
     tip="How far the sweep moves Phasor B's notches.")
dial(x + 76, 44, "B Feedback", "B Fdbk", 0, 100, 35, 5, "b_fb", scale=0.01, w=68, h=70, acc=ACC_B,
     tip="Resonance between the notches. Two phasors in series add up to about +25 dB at full feedback.")
label(x + 150, 43, 92, "SWEEP SYNC")
tab(x + 150, 56, 94, 15, "B Sync", "B Sync", ["NORM", "REV", "QUAD"], 0, "b_sync", acc=ACC_B,
    tip="B's sweep relative to A on Gen 1: NORM in phase, REV opposite, QUAD 90 degrees ahead.")
label(x + 150, 78, 92, "INPUT")
B_INPUT = tab(x + 150, 91, 94, 15, "B Input", "B Input", ["IN A", "OUT A", "IN B"], 1, "b_input", acc=ACC_B,
    tip="IN A: parallel with A. OUT A: series after A (double depth). IN B: right input channel.")
label(x + 10, 118, 80, "SWEEP")
tab(x + 8, 132, 236, 17, "B Sweep", "B Sweep", ["G1", "G2", "PED", "ENV"], 0, "b_sweep", acc=ACC_B,
    tip="What moves Phasor B: Gen 1, Gen 2, the Pedal, or the input envelope.")
txt(x + 198, TOP + 4, 46, 15, "B On", "B On", "OFF", "ON", 0, "b_on", acc=ACC_B,
    tip="Phasor B footswitch.")
led(x + 185, TOP + 7, 5, ACC_B)

# SWEEP GENERATOR 2 (Modulation, left column, lower row)
x = XM
rect(x + 8, 98, 112, 1, SECTION_LINE)
label(x + 60, 104, 60, "GEN 2", size=8, bold=True)
dial(x + 6, 104, "Gen2 Rate", "G2 Rate", 0.1, 18.0, 3.5, 3, "g2_rate", exp=3.0, w=46, h=48,
     tip="Sweep generator 2 speed, 0.1-18 Hz. Used by Phasor B when B Sweep = G2.")
tab(x + 58, 118, 62, 15, "Gen2 Shape", "G2 Shape", ["SINE", "SQR"], 0, "g2_shape", tip="Gen 2 waveform.")
rect(x + 126, 44, 1, 112, SECTION_LINE)
label(x + 186, 43, 120, "ENVELOPE", bold=True)
dial(x + 182, 55, "Env Amount", "Env Amt", 0, 100, 50, 5, "env_amt", scale=0.01, w=44, h=48,
     tip="Envelope sensitivity. 100 % reaches full sweep at -12 dBFS peaks.")
dial(x + 226, 55, "Env Attack", "Env Atk", 1, 100, 10, 2, "env_att", exp=2.0, w=44, h=48, tip="Envelope rise time.")
dial(x + 270, 55, "Env Release", "Env Rel", 20, 2000, 250, 2, "env_rel", exp=2.0, w=44, h=48, tip="Envelope fall time.")
tab(x + 184, 110, 128, 15, "Env Polarity", "Env Pol", ["UP", "DOWN"], 0, "env_pol",
    tip="UP: louder opens the sweep. DOWN: louder closes it.")
label(x + 184, 130, 130, "Active when a Sweep is ENV", size=8)
rect(x + 176, 44, 1, 112, SECTION_LINE)

# PEDAL
label(x + 134, 43, 40, "PEDAL", bold=True)
dial(x + 130, 55, "Pedal", "Pedal", 0, 100, 50, 5, "pedal", scale=0.01, w=44, h=48,
     tip="Manual sweep position (or Gen 1 speed when Rate Src = PED). Map it to an expression pedal.")
label(x + 132, 108, 44, "map to", size=8)
label(x + 132, 120, 44, "expr.", size=8)
label(x + 132, 132, 44, "pedal", size=8)

# OUTPUT / ROUTING
x = XO
dial(x + 6, 44, "Mix", "Mix", 0, 100, 50, 5, "mixamt", scale=0.01, w=54, h=56,
     tip="Dry/phased blend. 50 % is the original's fixed blend.")
dial(x + 62, 44, "Drive", "Drive", -24, 24, 0, 4, "drive", w=54, h=56,
     tip="Level into the circuit. With CLIP on (VINTAGE) this sets how hard the op-amps are hit.")
dial(x + 118, 44, "Output", "Output", -24, 12, 0, 4, "outgain", w=54, h=56, tip="Output level.")
txt(x + 6, 104, 80, 15, "Full Wet", "FullWet", "FULL WET", "FULL WET", 0, "fullwet",
    tip="Phased signal only, whatever the Mix setting.")
menu(x + 90, 104, 80, "Out Mode", "OutMode", ["Out A | Out B", "Out B (mono)", "Out A (mono)", "A + B (mono)"], 1, "outmode",
     tip="Which phasor reaches which output channel.")
txt(x + 6, 124, 80, 15, "In A Sum", "InSum", "IN A = L", "IN A = L+R", 1, "insum",
    tip="Phasor A input: left channel, or left and right summed.")
menu(x + 90, 124, 80, "Route", "Route", ["Track", "Dry + Bus", "Bus only"], 0, "route",
     tip="Dry + Bus: dry stays on this track, phased signal goes to outputs 3/4 (pick them with Audio From on another track).")
label(x + 8, 145, 40, "BUS", size=8)
bus = menu(x + 36, 144, 50, "Bus", "Bus", [f"Bus {i}" for i in range(1, 9)], 0,
           tip="Legacy bus number for the Twin Phasor Return device.")
label(x + 90, 145, 84, "+ outputs 3/4", size=8)
# bus -> send~ set
y0 = 1500
p1 = add(newobj("bus_add", "+ 1", numinlets=2, numoutlets=1, outlettype=["int"], patching_rect=[150, y0, 40, 22]))
tt = add(newobj("bus_t", "t i i", numinlets=1, numoutlets=2, outlettype=["int", "int"], patching_rect=[150, y0 + 26, 40, 22]))
fl = add(newobj("bus_fl", "sprintf tpx_bus%ld_L", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[150, y0 + 52, 130, 22]))
fr = add(newobj("bus_fr", "sprintf tpx_bus%ld_R", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[290, y0 + 52, 130, 22]))
sl = add(newobj("bus_sl", "prepend set", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[150, y0 + 78, 80, 22]))
sr_ = add(newobj("bus_sr", "prepend set", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[290, y0 + 78, 80, 22]))
line(bus, 0, p1, 0); line(p1, 0, tt, 0); line(tt, 0, fl, 0); line(tt, 1, fr, 0)
line(fl, 0, sl, 0); line(fr, 0, sr_, 0); line(sl, 0, SL, 0); line(sr_, 0, SR, 0)

# CHARACTER / QUIRKS
x = XC
tab(x + 94, TOP + 4, 96, 15, "Character", "Character", ["VINTAGE", "MODERN"], 0, "vintage_inv",
    tip="VINTAGE: the lit quirks below are active. MODERN: all quirks off, matched cells, clean sweep between Lo and Hi.")
quirks = [("LAG", "Photocell lag", "q_lag_p", 1, "Cells light fast, darken slowly."),
          ("CELLS", "Cell mismatch", "q_mis_p", 1, "Unmatched cells and LEDs."),
          ("LAW", "LED sweep law", "q_law_p", 1, "Sweep lingers high, dives at the bottom."),
          ("RANGE", "220k range", "q_rng_p", 1, "Low-end floor around 46 Hz."),
          ("CLIP", "Op-amp clip", "q_clip_p", 1, "Op-amp saturation in the feedback loop."),
          ("HISS", "Hiss", "q_noise_p", 1, "Circuit noise floor."),
          ("HUM", "Mains hum", "q_hum_p", 0, "Mains hum at the frequency below."),
          ("FADE", "Optical bypass", "q_fade_p", 1, "Soft switch-in, slow tail-out."),
          ("LFO", "Shaped tri LFO", "q_lfo_p", 1, "Triangle-based 'sine' sweep."),
          ("BW", "Circuit bandwidth", "q_bw_p", 1, "Input and feedback bandwidth limits.")]
for i, (short, longn, param, init, tip) in enumerate(quirks):
    txt(x + 6 + (i % 5) * 37, 46 + (i // 5) * 19, 35, 15, longn, short, short, short, init, param,
        tip=tip + " Active in VINTAGE.")
label(x + 8, 89, 40, "HUM Hz", size=8)
tab(x + 50, 87, 60, 14, "Hum Freq", "Hum Hz", ["50", "60"], 0, "hum_hz", tip="Mains frequency for HUM.")
label(x + 8, 107, 120, "MODERN RANGE", size=8)
dial(x + 6, 117, "Modern Lo", "Mod Lo", 20, 2000, 150, 3, "mod_lo", exp=3.0, w=44, h=44,
     tip="MODERN mode: lowest corner frequency of the sweep.")
dial(x + 52, 117, "Modern Hi", "Mod Hi", 500, 18000, 9000, 3, "mod_hi", exp=3.0, w=44, h=44,
     tip="MODERN mode: highest corner frequency of the sweep.")
label(x + 104, 118, 88, "Lit quirks act", size=8)
label(x + 104, 130, 88, "in VINTAGE only", size=8)

# ---- live routing readout in the header: one line per B Input setting, only the active one shown ----
label(640, 5, 50, "SIGNAL", size=8, bold=True)
flows = ["IN  →  A  ∥  B  →  OUT        (parallel)", "IN  →  A  →  B  →  OUT        (series)",
         "L  →  A        R  →  B        (separate)"]
sel = add(newobj(nid("sel"), "sel 0 1 2", numinlets=2, numoutlets=4, outlettype=["bang"] * 3 + [""], patching_rect=[30, 1700, 70, 22]))
line(B_INPUT, 0, sel, 0)
fids = []
for k, ftxt in enumerate(flows):
    c = ui.comment(nid("flow"), [688, 5, 300, 13], ftxt, textcolor=INK, fontsize=8.5, fontname=FONT, justification=0)
    c["box"]["hidden"] = 0 if k == 1 else 1      # default B Input = OUT A
    fids.append(add(c))
for k in range(3):
    show = add(newobj(nid("msg"), f"t b b", numinlets=1, numoutlets=2, outlettype=["bang", "bang"], patching_rect=[30 + 120 * k, 1730, 40, 22]))
    line(sel, k, show, 0)
    for j, fid in enumerate(fids):
        m = add({"box": {"id": nid("m"), "maxclass": "message", "text": f"hidden {0 if j == k else 1}", "numinlets": 2,
                         "numoutlets": 1, "outlettype": [""], "patching_rect": [30 + 120 * k, 1760 + 26 * j, 60, 22]}})
        line(show, 0 if j == k else 1, m, 0); line(m, 0, fid, 0)

# the Character tab sends 0=VINTAGE, 1=MODERN: invert into gen's 'vintage'
for b in boxes:
    if b["box"].get("text") == "prepend vintage_inv":
        b["box"]["text"] = "prepend vintage"
        vid = b["box"]["id"]
        src = [l for l in lines if l["patchline"]["destination"] == [vid, 0]][0]
        inv = add(newobj("char_inv", "!- 1", numinlets=2, numoutlets=1, outlettype=["int"], patching_rect=[440, 1600, 40, 22]))
        orig = src["patchline"]["source"]
        src["patchline"]["source"] = [inv, 0]
        line(orig[0], orig[1], inv, 0)

# compatibility names used by the Return device below
BLACK, LEGEND, SILVER = CTRL, INK, ACC_N
DIAL_STYLE = dict(activedialcolor=ACC_N, dialcolor=TRACK, needlecolor=INK, activeneedlecolor=INK, textcolor=INK,
                  focusbordercolor=ACC_N, fontname=FONT, fontsize=9.0)


def group(x, w, title):
    section(x, w, title, ACC_N)

patch = build_patcher(boxes, lines, name="Twin Phasor 76", width=W, height=H)
patch["patcher"]["description"] = "Dual 6-stage optical phasor modelled on the 1975 Bi-Phase circuit, with switchable vintage quirks."
stamp(patch)
(OUTDIR / "Twin Phasor 76.amxd").write_bytes(build_amxd(patch, AUDIO_EFFECT))
(OUTDIR / "Twin Phasor 76.maxpat").write_text(json.dumps(patch, indent=1))

# ================================ RETURN DEVICE ================================
boxes, lines = [], []
_py[0] = 500
RW = 200
deco(ui.panel("bg_face", [0, 0, RW, H], bgcolor=FACE_DARK, bgfillcolor=fill(FACE_DARK)))
label(10, 4, 180, "TWIN PHASOR RETURN", size=11, color=INK, bold=True)
group(8, RW - 16, "LEGACY BUS")
PIN = add(newobj("plugin", "plugin~", numinlets=1, numoutlets=2, outlettype=["signal", "signal"], patching_rect=[30, 250, 60, 22]))
POUT = add(newobj("plugout", "plugout~", numinlets=2, numoutlets=0, patching_rect=[30, 450, 60, 22]))
RL = add(newobj("recvL", "receive~ tpx_bus1_L", numinlets=1, numoutlets=1, outlettype=["signal"], patching_rect=[150, 250, 120, 22]))
RR = add(newobj("recvR", "receive~ tpx_bus1_R", numinlets=1, numoutlets=1, outlettype=["signal"], patching_rect=[290, 250, 120, 22]))
gl = add(newobj("gl", "*~ 1.", numinlets=2, numoutlets=1, outlettype=["signal"], patching_rect=[150, 300, 40, 22]))
gr = add(newobj("gr", "*~ 1.", numinlets=2, numoutlets=1, outlettype=["signal"], patching_rect=[290, 300, 40, 22]))
tl = add(newobj("tl", "*~ 0.", numinlets=2, numoutlets=1, outlettype=["signal"], patching_rect=[30, 300, 40, 22]))
tr = add(newobj("tr", "*~ 0.", numinlets=2, numoutlets=1, outlettype=["signal"], patching_rect=[90, 300, 40, 22]))
sumL = add(newobj("sumL", "+~", numinlets=2, numoutlets=1, outlettype=["signal"], patching_rect=[30, 400, 40, 22]))
sumR = add(newobj("sumR", "+~", numinlets=2, numoutlets=1, outlettype=["signal"], patching_rect=[150, 400, 40, 22]))
line(RL, 0, gl, 0); line(RR, 0, gr, 0); line(PIN, 0, tl, 0); line(PIN, 1, tr, 0)
line(tl, 0, sumL, 0); line(gl, 0, sumL, 1); line(tr, 0, sumR, 0); line(gr, 0, sumR, 1)
line(sumL, 0, POUT, 0); line(sumR, 0, POUT, 1)
label(16, 47, 40, "BUS", 8.5, 0)
rb = add(ui.menu("rbus", "Return Bus", [50, 45, 70, 15], options=[f"Bus {i}" for i in range(1, 9)], shortname="Bus",
                 bgcolor=BLACK, activebgcolor=BLACK, textcolor=LEGEND, activetextcolor=LEGEND, tricolor=SILVER,
                 fontname=FONT, fontsize=9.0))
set_init(rb, 0)
lv = add(ui.dial("rlvl", "Return Level", [14, 64, 52, 54], min_val=-70, max_val=12, initial=0, shortname="Level",
                 unitstyle=4, **DIAL_STYLE))
th = add(ui.live_text("rthru", "Track Thru", [76, 82, 108, 18], text_off="TRACK INPUT OFF", text_on="TRACK INPUT ON",
                      shortname="Thru", bgcolor=BLACK, bgoncolor=SILVER, textcolor=LEGEND, textoncolor=BLACK,
                      activebgcolor=BLACK, activebgoncolor=SILVER, activetextcolor=LEGEND, activetextoncolor=BLACK,
                      rounded=3.0, fontname=FONT_B, fontsize=8.0))
set_init(th, 0)
label(16, 122, 172, "send~ between devices is unsupported;", 8, 0)
label(16, 134, 172, "prefer Audio From > Twin Phasor 3/4.", 8, 0)
dbt = add(newobj("dbt", "dbtoa", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[200, 350, 50, 22]))
line(lv, 0, dbt, 0); line(dbt, 0, gl, 1); line(dbt, 0, gr, 1)
line(th, 0, tl, 1); line(th, 0, tr, 1)
p1 = add(newobj("rb_add", "+ 1", numinlets=2, numoutlets=1, outlettype=["int"], patching_rect=[400, 200, 40, 22]))
tt = add(newobj("rb_t", "t i i", numinlets=1, numoutlets=2, outlettype=["int", "int"], patching_rect=[400, 226, 40, 22]))
fl = add(newobj("rb_fl", "sprintf tpx_bus%ld_L", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[400, 252, 130, 22]))
fr = add(newobj("rb_fr", "sprintf tpx_bus%ld_R", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[540, 252, 130, 22]))
sl = add(newobj("rb_sl", "prepend set", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[400, 278, 80, 22]))
sr_ = add(newobj("rb_sr", "prepend set", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[540, 278, 80, 22]))
line(rb, 0, p1, 0); line(p1, 0, tt, 0); line(tt, 0, fl, 0); line(tt, 1, fr, 0)
line(fl, 0, sl, 0); line(fr, 0, sr_, 0); line(sl, 0, RL, 0); line(sr_, 0, RR, 0)
patch = build_patcher(boxes, lines, name="Twin Phasor Return", width=RW, height=H)
DEV_NAME[0] = "Twin Phasor Return"
stamp(patch)
(OUTDIR / "Twin Phasor Return.amxd").write_bytes(build_amxd(patch, AUDIO_EFFECT))
(OUTDIR / "Twin Phasor Return.maxpat").write_text(json.dumps(patch, indent=1))
print("built")
