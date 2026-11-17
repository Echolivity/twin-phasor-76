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


def finalize(patch):
    """S2: bring the generated patch in line with what Max itself writes (compared against
    Ableton's maxdevtools sample devices). Live crashed on load of the S1 build."""
    P = patch["patcher"]
    # 1. Max-style object ids (obj-N); remap patchlines
    idmap = {b["box"]["id"]: f"obj-{i + 1}" for i, b in enumerate(P["boxes"])}
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

# ---------------- palette: sampled from a photo of an original unit (S3, 2026-11-17) ----------------
FACE_DARK = [0.216, 0.314, 0.663, 1.0]   # panel blue (photo mode #3750a9)
FACE_LITE = [0.239, 0.345, 0.698, 1.0]   # same blue, barely lifted, for a hint of sheen
SILVER = [0.91, 0.914, 0.918, 1.0]      # white/silver section outlines
CASE = [0.788, 0.792, 0.8, 1.0]        # brushed aluminium case
BLACK = [0.184, 0.192, 0.204, 1.0]       # charcoal switch blocks (photo #383a36, darkened slightly for Live)
LEGEND = [0.957, 0.957, 0.945, 1.0]      # white legends
KNOB_BG = [0.082, 0.086, 0.094, 1.0]     # black knob caps
LEVER_BLUE = [0.659, 0.792, 0.91, 1.0]  # light-blue lever switches (rate control, sweep)
LEVER_GREY = [0.604, 0.62, 0.639, 1.0]  # grey lever switches (shape)
LEVER_RED = [0.906, 0.18, 0.141, 1.0]   # red Sweep Sync lever
LEVER_CREAM = [0.847, 0.827, 0.753, 1.0] # cream Phasor B Input knob
LED_OFF = [0.227, 0.047, 0.047, 1.0]
CLEAR = [0, 0, 0, 0]

W, H = 1064, 169
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


DIAL_STYLE = dict(activedialcolor=LEGEND, dialcolor=KNOB_BG, needlecolor=LEGEND,
                  activeneedlecolor=LEGEND, textcolor=LEGEND, focusbordercolor=SILVER,
                  fontname="Ableton Sans Bold", fontsize=9.0)
TAB_STYLE = dict(bgcolor=BLACK, activebgcolor=BLACK, bgoncolor=SILVER, activebgoncolor=SILVER,
                 textcolor=LEGEND, activetextcolor=LEGEND, textoncolor=BLACK, activetextoncolor=BLACK,
                 bordercolor=SILVER, focusbordercolor=SILVER, fontname="Ableton Sans Bold", fontsize=8.5)

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


# ------------------------------------ panel art ------------------------------------
add(ui.panel("bg_case", [0, 0, W, H], bgcolor=CASE, bgfillcolor={"type": "color", "color": CASE}))
add(ui.panel("bg_face", [3, 3, W - 6, H - 6], bgcolor=FACE_DARK, rounded=4,
             bgfillcolor={"type": "gradient", "color1": FACE_DARK, "color2": FACE_LITE, "color": FACE_DARK,
                          "angle": 0.0, "proportion": 0.5, "autogradient": 0}))


def group(x, w, title):
    add(ui.panel(nid("grp"), [x, 7, w, H - 14], bgcolor=CLEAR, border=1.5, bordercolor=LEGEND, rounded=8,
                 bgfillcolor={"type": "color", "color": CLEAR}))
    add(ui.comment(nid("ttl"), [x + 4, 9, w - 8, 14], title, textcolor=LEGEND, fontsize=9.5,
                   fontname="Ableton Sans Bold", justification=1))


def block(x, y, w, h, outlined=False):
    if outlined:
        add(ui.panel(nid("blk"), [x, y, w, h], bgcolor=CLEAR, border=1.5, bordercolor=LEGEND, rounded=6,
                     bgfillcolor={"type": "color", "color": CLEAR}))
    else:
        add(ui.panel(nid("blk"), [x, y, w, h], bgcolor=BLACK, rounded=3, bgfillcolor={"type": "color", "color": BLACK}))


def label(x, y, w, text, size=8.0, just=1):
    add(ui.comment(nid("lb"), [x, y, w, 12], text, textcolor=LEGEND, fontsize=size, fontname="Ableton Sans Bold", justification=just))


def dial(x, y, var, short, mn, mx, init, unit, param, scale=None, exp=1.0, w=46, h=50):
    d = add(ui.dial(nid("d"), var, [x, y, w, h], min_val=mn, max_val=mx, initial=init, shortname=short,
                    unitstyle=unit, parameter_exponent=exp, **DIAL_STYLE))
    to_gen(d, param, scale)
    return d


def lever(color, text_on=None):
    """Tab style whose selected segment takes the colour of the original's lever switch."""
    st = dict(TAB_STYLE)
    st.update(bgoncolor=color, activebgoncolor=color)
    if text_on:
        st.update(textoncolor=text_on, activetextoncolor=text_on)
    return st


def tab(x, y, w, h, var, short, options, init, param, multiline=0, style=None):
    t = add(ui.tab(nid("t"), var, [x, y, w, h], options=options, **(style or TAB_STYLE)))
    set_init(t, init, shortname=short)
    to_gen(t, param)
    return t


def txt(x, y, w, h, var, short, off, on, init, param, mode=0):
    t = add(ui.live_text(nid("x"), var, [x, y, w, h], text_off=off, text_on=on, shortname=short, mode=mode,
                         bgcolor=BLACK, bgoncolor=SILVER, textcolor=LEGEND, textoncolor=BLACK, rounded=3.0,
                         fontname="Ableton Sans Bold", fontsize=8.5,
                         activebgcolor=BLACK, activebgoncolor=SILVER, activetextcolor=LEGEND,
                         activetextoncolor=BLACK, bordercolor=SILVER))
    set_init(t, init)
    to_gen(t, param)
    return t


def menu(x, y, w, var, short, options, init, param=None):
    m = add(ui.menu(nid("m"), var, [x, y, w, 15], options=options, shortname=short,
                    bgcolor=BLACK, activebgcolor=BLACK, textcolor=LEGEND, activetextcolor=LEGEND,
                    tricolor=SILVER, bordercolor=SILVER, fontname="Ableton Sans Bold", fontsize=8.5))
    set_init(m, init)
    if param:
        to_gen(m, param)
    return m


def led(x, y, gen_outlet):
    lp = add(ui.panel(nid("led"), [x, y, 12, 12], bgcolor=LED_OFF, rounded=12, border=1, bordercolor=BLACK,
                      bgfillcolor={"type": "color", "color": LED_OFF}))
    y0 = _py[0]; _py[0] += 26
    s = add(newobj(nid("snap"), "snapshot~ 33", numinlets=2, numoutlets=1, outlettype=["float"], patching_rect=[800, y0, 80, 22]))
    t = add(newobj(nid("tff"), "t f f", numinlets=1, numoutlets=2, outlettype=["float", "float"], patching_rect=[890, y0, 40, 22]))
    er = add(newobj(nid("er"), "expr 0.23+0.77*$f1", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[940, y0, 110, 22]))
    eg = add(newobj(nid("eg"), "expr 0.05+0.13*$f1", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[1060, y0, 110, 22]))
    pk = add(newobj(nid("pk"), "pack 0. 0. 0.04 1.", numinlets=4, numoutlets=1, outlettype=[""], patching_rect=[1180, y0, 100, 22]))
    pr = add(newobj(nid("pr"), "prepend bgfillcolor", numinlets=1, numoutlets=1, outlettype=[""], patching_rect=[1290, y0, 110, 22]))
    line(GEN, gen_outlet, s, 0); line(s, 0, t, 0); line(t, 1, eg, 0); line(t, 0, er, 0)
    line(eg, 0, pk, 1); line(er, 0, pk, 0); line(pk, 0, pr, 0); line(pr, 0, lp, 0)


DY = 22  # first control row

# SWEEP GENERATOR 1
x = 8; group(x, 112, "SWEEP GEN 1")
dial(x + 4, DY, "Gen1 Rate", "G1 Rate", 0.1, 18.0, 0.6, 3, "g1_rate", exp=3.0)
label(x + 54, DY + 2, 52, "SHAPE")
tab(x + 54, DY + 14, 52, 15, "Gen1 Shape", "G1 Shape", ["SINE", "SQR"], 0, "g1_shape", style=lever(LEVER_GREY))
label(x + 54, DY + 34, 52, "RATE")
tab(x + 54, DY + 46, 52, 15, "Gen1 Rate Src", "G1 Src", ["MAN", "PED"], 0, "g1_src", style=lever(LEVER_BLUE))

# PHASOR A
x = 124; group(x, 150, "PHASOR A")
dial(x + 4, DY, "A Depth", "A Depth", 0, 100, 80, 5, "a_depth", scale=0.01)
dial(x + 52, DY, "A Feedback", "A Fdbk", 0, 100, 35, 5, "a_fb", scale=0.01)
block(x + 4, 80, 142, 30)
label(x + 6, 81, 138, "SWEEP")
tab(x + 8, 93, 134, 14, "A Sweep", "A Sweep", ["GEN 1", "PED", "ENV"], 0, "a_sweep", style=lever(LEVER_BLUE))
txt(x + 4, 120, 70, 20, "A On", "A On", "PHASOR A", "PHASOR A", 1, "a_on")
led(x + 82, 124, 4)
label(x + 98, 124, 50, "ACTIVE", 7.5, 0)

# PHASOR B
x = 278; group(x, 214, "PHASOR B")
dial(x + 4, DY, "B Depth", "B Depth", 0, 100, 80, 5, "b_depth", scale=0.01)
dial(x + 52, DY, "B Feedback", "B Fdbk", 0, 100, 35, 5, "b_fb", scale=0.01)
label(x + 104, DY, 104, "SWEEP SYNC")
tab(x + 104, DY + 12, 104, 15, "B Sync", "B Sync", ["NORM", "REV", "QUAD"], 0, "b_sync", style=lever(LEVER_RED, LEGEND))
block(x + 102, DY + 32, 108, 34, outlined=True)
label(x + 104, DY + 33, 104, "PHASOR B INPUT")
tab(x + 106, DY + 47, 100, 15, "B Input", "B Input", ["IN A", "OUT A", "IN B"], 1, "b_input", style=lever(LEVER_CREAM))
block(x + 4, 80, 96, 30)
label(x + 6, 81, 92, "SWEEP")
tab(x + 8, 93, 88, 14, "B Sweep", "B Sweep", ["G1", "G2", "PED", "ENV"], 0, "b_sweep", style=lever(LEVER_CREAM))
txt(x + 4, 120, 70, 20, "B On", "B On", "PHASOR B", "PHASOR B", 0, "b_on")
led(x + 82, 124, 5)
label(x + 98, 124, 50, "ACTIVE", 7.5, 0)

# SWEEP GENERATOR 2
x = 496; group(x, 112, "SWEEP GEN 2")
dial(x + 4, DY, "Gen2 Rate", "G2 Rate", 0.1, 18.0, 3.5, 3, "g2_rate", exp=3.0)
label(x + 54, DY + 2, 52, "SHAPE")
tab(x + 54, DY + 14, 52, 15, "Gen2 Shape", "G2 Shape", ["SINE", "SQR"], 0, "g2_shape", style=lever(LEVER_GREY))
# S1: envelope sweep source, placed in the unused lower half of the Gen 2 panel (no layout change elsewhere)
add(ui.panel(nid("div"), [x + 6, 76, 100, 1], bgcolor=SILVER, bgfillcolor={"type": "color", "color": SILVER}))
label(x + 4, 79, 104, "ENVELOPE (ENV)")
dial(x + 2, 92, "Env Amount", "Env Amt", 0, 100, 50, 5, "env_amt", scale=0.01, w=36, h=44)
dial(x + 38, 92, "Env Attack", "Env Atk", 1, 100, 10, 2, "env_att", exp=2.0, w=36, h=44)
dial(x + 74, 92, "Env Release", "Env Rel", 20, 2000, 250, 2, "env_rel", exp=2.0, w=36, h=44)
tab(x + 6, 140, 100, 14, "Env Polarity", "Env Pol", ["UP", "DOWN"], 0, "env_pol")

# PEDAL (stands in for the C-100 optical pedal; map it to an expression pedal / macro)
x = 612; group(x, 62, "PEDAL")
dial(x + 8, DY, "Pedal", "Pedal", 0, 100, 50, 5, "pedal", scale=0.01)
label(x + 2, DY + 54, 58, "map to", 7.5)
label(x + 2, DY + 64, 58, "expression", 7.5)

# OUTPUT / ROUTING
x = 678; group(x, 172, "OUTPUT")
dial(x + 4, DY, "Mix", "Mix", 0, 100, 50, 5, "mixamt", scale=0.01)
dial(x + 62, DY, "Drive", "Drive", -24, 24, 0, 4, "drive")
dial(x + 120, DY, "Output", "Output", -24, 12, 0, 4, "outgain", w=46)
txt(x + 4, 78, 54, 16, "Full Wet", "FullWet", "FULL WET", "FULL WET", 0, "fullwet")
menu(x + 62, 78, 104, "Out Mode", "OutMode", ["Out A | Out B", "Out B (mono)", "Out A (mono)", "A + B (mono)"], 1, "outmode")
txt(x + 4, 98, 54, 16, "In A Sum", "InSum", "IN A = L", "IN A = L+R", 1, "insum")
label(x + 62, 98, 40, "ROUTE", 7.5, 0)
menu(x + 96, 98, 70, "Route", "Route", ["Track", "Dry + Bus", "Bus only"], 0, "route")
label(x + 4, 120, 60, "SEND BUS", 7.5, 0)
bus = menu(x + 62, 118, 50, "Bus", "Bus", [f"Bus {i}" for i in range(1, 9)], 0)
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
label(x + 116, 120, 54, "+ Out 3/4", 7.5, 0)
label(x + 4, 138, 164, "Other track: Audio From > 3/4", 7.0, 0)

# CHARACTER / QUIRKS
x = 854; group(x, 202, "CHARACTER")
tab(x + 6, DY, 190, 16, "Character", "Character", ["VINTAGE", "MODERN"], 0, "vintage_inv")
quirks = [("LAG", "Photocell lag", "q_lag_p", 1), ("CELLS", "Cell mismatch", "q_mis_p", 1),
          ("LAW", "LED sweep law", "q_law_p", 1), ("RANGE", "220k range", "q_rng_p", 1),
          ("CLIP", "Op-amp clip", "q_clip_p", 1), ("HISS", "Hiss", "q_noise_p", 1),
          ("HUM", "Mains hum", "q_hum_p", 0), ("FADE", "Optical bypass", "q_fade_p", 1),
          ("LFO", "Shaped tri LFO", "q_lfo_p", 1), ("BW", "Circuit bandwidth", "q_bw_p", 1)]
for i, (short, longn, param, init) in enumerate(quirks):
    cx = x + 6 + (i % 5) * 38
    cy = DY + 22 + (i // 5) * 18
    txt(cx, cy, 36, 15, longn, short, short, short, init, param)
label(x + 6, 84, 40, "HUM Hz", 7.5, 0)
tab(x + 44, 82, 50, 15, "Hum Freq", "Hum Hz", ["50", "60"], 0, "hum_hz")
label(x + 102, 84, 96, "MODERN RANGE", 7.5, 0)
dial(x + 100, 98, "Modern Lo", "Mod Lo", 20, 2000, 150, 3, "mod_lo", exp=3.0, w=46, h=48)
dial(x + 150, 98, "Modern Hi", "Mod Hi", 500, 18000, 9000, 3, "mod_hi", exp=3.0, w=46, h=48)
label(x + 6, 104, 92, "Vintage: quirks", 7.5, 0)
label(x + 6, 116, 92, "on as lit.", 7.5, 0)
label(x + 6, 128, 92, "Modern: all off,", 7.5, 0)
label(x + 6, 140, 92, "clean + matched.", 7.5, 0)

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

patch = build_patcher(boxes, lines, name="Twin Phasor 76", width=W, height=H)
patch["patcher"]["description"] = "Dual 6-stage optical phasor modelled on the 1975 Bi-Phase circuit, with switchable vintage quirks."
stamp(patch)
(OUTDIR / "Twin Phasor 76.amxd").write_bytes(build_amxd(patch, AUDIO_EFFECT))
(OUTDIR / "Twin Phasor 76.maxpat").write_text(json.dumps(patch, indent=1))

# ================================ RETURN DEVICE ================================
boxes, lines = [], []
_py[0] = 500
RW = 200
add(ui.panel("bg_case", [0, 0, RW, H], bgcolor=CASE, bgfillcolor={"type": "color", "color": CASE}))
add(ui.panel("bg_face", [3, 3, RW - 6, H - 6], bgcolor=FACE_DARK, rounded=4,
             bgfillcolor={"type": "gradient", "color1": FACE_DARK, "color2": FACE_LITE, "color": FACE_DARK,
                          "angle": 0.0, "proportion": 0.5, "autogradient": 0}))
group(8, RW - 16, "PHASOR RETURN")
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
label(14, 26, 60, "BUS", 8.0, 0)
rb = add(ui.menu("rbus", "Return Bus", [50, 24, 70, 15], options=[f"Bus {i}" for i in range(1, 9)], shortname="Bus",
                 bgcolor=BLACK, activebgcolor=BLACK, textcolor=LEGEND, activetextcolor=LEGEND, tricolor=SILVER,
                 fontname="Ableton Sans Bold", fontsize=8.5))
set_init(rb, 0)
lv = add(ui.dial("rlvl", "Return Level", [14, 48, 50, 52], min_val=-70, max_val=12, initial=0, shortname="Level",
                 unitstyle=4, **DIAL_STYLE))
th = add(ui.live_text("rthru", "Track Thru", [80, 62, 100, 18], text_off="TRACK INPUT OFF", text_on="TRACK INPUT ON",
                      shortname="Thru", bgcolor=BLACK, bgoncolor=SILVER, textcolor=LEGEND, textoncolor=BLACK,
                      activebgcolor=BLACK, activebgoncolor=SILVER, activetextcolor=LEGEND, activetextoncolor=BLACK,
                      rounded=3.0, fontname="Ableton Sans Bold", fontsize=8.0))
set_init(th, 0)
label(14, 104, 172, "LEGACY: send~ between devices is", 7.5, 0)
label(14, 116, 172, "unsupported, latency varies.", 7.5, 0)
label(14, 128, 172, "Prefer Audio From: Twin Phasor 3/4.", 7.5, 0)
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
stamp(patch)
(OUTDIR / "Twin Phasor Return.amxd").write_bytes(build_amxd(patch, AUDIO_EFFECT))
(OUTDIR / "Twin Phasor Return.maxpat").write_text(json.dumps(patch, indent=1))
print("built")
