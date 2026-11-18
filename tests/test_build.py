"""Static build/patcher tests: source <-> artifact sync, wiring, parameter consistency.

These are static checks only. They do NOT show that Live loads or runs the device.
"""
import json
import re
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))
results = []


def rec(tid, name, ok, detail):
    results.append({"id": tid, "name": name, "status": "PASS" if ok else "FAIL", "detail": detail})
    print(f"{'PASS' if ok else 'FAIL'}  {tid} {name} — {detail}")


def load_amxd(p):
    b = Path(p).read_bytes()
    n = struct.unpack("<I", b[28:32])[0]
    hdr_ok = b[:4] == b"ampf" and struct.unpack("<I", b[4:8])[0] == 4 and b[8:12] == b"aaaa" and b[12:16] == b"meta" and b[24:28] == b"ptch" and len(b) == 32 + n
    return hdr_ok, json.loads(b[32:32 + n].rstrip(b"\x00\n").decode())


# --- B1 generated GenExpr in sync with source ------------------------------------
import gen_dsp
code = gen_dsp.build()
rec("B1", "twinphasor.genexpr matches src/gen_dsp.py output", code == (ROOT / "twinphasor.genexpr").read_text(), "regenerated and compared")

# --- B2 artifacts byte-identical to a fresh build ---------------------------------
with tempfile.TemporaryDirectory() as td:
    r = subprocess.run([sys.executable, str(ROOT / "src" / "build_device.py"), "--out", td], capture_output=True, text=True)
    same = r.returncode == 0 and all((Path(td) / f).read_bytes() == (ROOT / f).read_bytes()
                                     for f in ["Twin Phasor 76.amxd", "Twin Phasor Return.amxd", "Twin Phasor 76.maxpat", "Twin Phasor Return.maxpat"])
    rec("B2", "shipped .amxd/.maxpat byte-identical to a clean rebuild", same, r.stderr.strip()[-200:] or "4 files identical")

devs = {}
for name in ["Twin Phasor 76", "Twin Phasor Return"]:
    ok, patch = load_amxd(ROOT / f"{name}.amxd")
    devs[name] = patch["patcher"]
    rec("B3", f"{name}: amxd header/length valid", ok, "ampf v4 / aaaa / meta / ptch, length consistent")
    rec("B4", f"{name}: .maxpat equals .amxd payload", json.loads((ROOT / f"{name}.maxpat").read_text()) == patch, "identical JSON")
    P = patch["patcher"]
    ids = {b["box"]["id"]: b["box"] for b in P["boxes"]}
    bad = []
    for l in P["lines"]:
        (s, so), (d, di) = l["patchline"]["source"], l["patchline"]["destination"]
        if s not in ids or d not in ids:
            bad.append(f"missing {s}->{d}")
        elif so >= ids[s]["numoutlets"] or di >= ids[d]["numinlets"]:
            bad.append(f"range {s}:{so}->{d}:{di}")
    rec("B5", f"{name}: all patchlines reference existing boxes and valid inlets/outlets", not bad and len(ids) == len(P["boxes"]), "; ".join(bad) or f"{len(P['lines'])} lines OK, ids unique")
    names = [b["box"]["saved_attribute_attributes"]["valueof"]["parameter_longname"] for b in P["boxes"] if "saved_attribute_attributes" in b["box"]]
    dup = sorted({n for n in names if names.count(n) > 1})
    rec("B6", f"{name}: parameter long names unique", not dup, f"{len(names)} params" + (f", duplicates {dup}" if dup else ""))

# --- B7 gen~ embedded code == genexpr ------------------------------------------------
M = devs["Twin Phasor 76"]
box = {b["box"]["id"]: b["box"] for b in M["boxes"]}
by_text = lambda t: next(i for i, b in box.items() if b.get("text", "").split(" ")[0] == t)
GEN, PLUGOUT = by_text("gen~"), by_text("plugout~")
cb = box[GEN]["patcher"]["boxes"][0]["box"]["code"]
rec("B7", "gen~ codebox code equals twinphasor.genexpr", cb == code, "embedded copy in sync")

# --- B8 parameter consistency: UI range/initial (after scaling) vs gen Param -------------
gp = {m[0]: (float(m[1]), float(m[2]), float(m[3])) for m in re.findall(r"Param (\w+)\(([-\d.e]+), min=([-\d.e]+), max=([-\d.e]+)\);", code)}
src_of = {}
for l in M["lines"]:
    (s, so), (d, di) = l["patchline"]["source"], l["patchline"]["destination"]
    src_of.setdefault(d, []).append(s)
issues, mapped = [], set()
for bid, b in box.items():
    t = b.get("text", "")
    if not t.startswith("prepend ") or t in ("prepend set", "prepend bgfillcolor"):
        continue
    param = t.split()[1]
    mapped.add(param)
    up = src_of[bid][0]
    scale = 1.0
    if box[up].get("text", "").startswith("* "):
        scale = float(box[up]["text"].split()[1]); up = src_of[up][0]
    if box[up].get("text") == "!- 1":
        up = src_of[up][0]
    ctl = box[up]
    v = ctl["saved_attribute_attributes"]["valueof"]
    if param not in gp:
        issues.append(f"{param}: no gen Param"); continue
    d0, lo, hi = gp[param]
    if v.get("parameter_type") == 0:
        umin, umax = v["parameter_mmin"] * scale, v["parameter_mmax"] * scale
        if abs(umin - lo) > 1e-9 or abs(umax - hi) > 1e-9:
            issues.append(f"{param}: UI {umin:g}-{umax:g} vs gen {lo:g}-{hi:g}")
    else:
        n = len(v["parameter_enum"])
        if n - 1 != hi or lo != 0:
            issues.append(f"{param}: {n} enum items vs gen 0-{hi:g}")
    init = v.get("parameter_initial", [None])[0]
    if init is None:
        issues.append(f"{param}: no initial value")
    else:
        ui0 = (1 - init) if box[src_of[bid][0]].get("text") == "!- 1" else init * scale
        if abs(ui0 - d0) > 1e-9:
            issues.append(f"{param}: UI initial {ui0:g} vs gen default {d0:g}")
rec("B8", "every UI control range/enum/initial agrees with its gen Param", not issues, "; ".join(issues) or f"{len(mapped)} controls checked")
rec("B9", "every gen Param is driven by a control", set(gp) <= mapped, f"unmapped: {sorted(set(gp) - mapped)}" if set(gp) - mapped else f"{len(gp)} params")

# --- B10 audio I/O wiring ---------------------------------------------------------------
po = box[PLUGOUT]
wired = {(l["patchline"]["source"][1], l["patchline"]["destination"][1]) for l in M["lines"] if l["patchline"]["source"][0] == GEN and l["patchline"]["destination"][0] == PLUGOUT}
rec("B10", "plugout~ exposes 4 outputs; gen out1-4 wired to 1-4", po["text"] == "plugout~ 1 2 3 4" and wired == {(0, 0), (1, 1), (2, 2), (3, 3)}, f"{po['text']}, wired {sorted(wired)}")
R = devs["Twin Phasor Return"]
rn = sorted(b["box"]["text"] for b in R["boxes"] if b["box"].get("text", "").startswith(("receive~", "sprintf")))
sn = sorted(b["box"]["text"] for b in M["boxes"] if b["box"].get("text", "").startswith(("send~", "sprintf")))
rec("B11", "legacy bus names match between sender and Return", [x.replace("receive~", "send~") for x in rn] == sn, f"{sn}")

# --- B12 Max-saved conventions (S2: Live crashed loading the S1 build) -------------------------------
for name, P in devs.items():
    bx = [b["box"] for b in P["boxes"]]
    pv = {b["id"]: b["saved_attribute_attributes"]["valueof"] for b in bx if "saved_attribute_attributes" in b}
    prm = P.get("parameters", {})
    issues = []
    if not all(re.fullmatch(r"obj-\d+", b["id"]) for b in bx): issues.append("non obj-N ids")
    for b in bx:
        if "patcher" in b and not all(re.fullmatch(r"obj-\d+", x["box"]["id"]) for x in b["patcher"]["boxes"]): issues.append("non obj-N ids inside " + b.get("text", ""))
    for i, v in pv.items():
        if prm.get(i) != [v["parameter_longname"], v["parameter_shortname"], 0]: issues.append(f"{i} missing/wrong in root parameters")
        if v.get("parameter_type") == 2 and v.get("parameter_mmax") != len(v["parameter_enum"]) - 1: issues.append(f"{i} enum mmax")
    if any(b["maxclass"] == "live.text" and b.get("mode") == 0 for b in bx): issues.append("live.text in momentary mode")
    banks = prm.get("parameterbanks", {})
    if any(len(bk["parameters"]) != 8 for bk in banks.values()): issues.append("bank not 8 slots")
    inbanks = [x for bk in banks.values() for x in bk["parameters"] if x != "-"]
    if sorted(inbanks) != sorted(v["parameter_longname"] for v in pv.values()): issues.append("banks do not list every parameter once")
    rec("B12", f"{name}: ids, root parameter table, enum ranges, toggle mode, banks follow Max conventions", not issues, "; ".join(issues) or f"{len(pv)} params, {len(banks)} banks")

# --- B13 S4: first Push bank holds the performance controls ------------------------------------
b0 = devs["Twin Phasor 76"]["parameters"]["parameterbanks"]["0"]
rec("B13", "Push bank 1 'Perform' = depths, feedbacks, rates, pedal, mix", b0["name"] == "Perform" and b0["parameters"] == ["A Depth", "A Feedback", "B Depth", "B Feedback", "Gen1 Rate", "Gen2 Rate", "Pedal", "Mix"], str(b0["parameters"]))

# --- B14/B15 UI redesign: parameter contract identical to S4 (names, ranges, defaults, enums, units, ids, order)
# Approved display-only changes (same stored values): on/off buttons now read OFF/ON instead of
# "PHASOR A" in both states (UI redesign 2026-11-18).
APPROVED = {("A On", "parameter_enum"): ["OFF", "ON"], ("B On", "parameter_enum"): ["OFF", "ON"]}
contract = json.loads((ROOT / "tests" / "fixtures" / "parameter_contract_s4.json").read_text())
for name, P in devs.items():
    now, issues = {}, []
    order = list(P["parameters"].keys())
    for b in P["boxes"]:
        bx = b["box"]; v = bx.get("saved_attribute_attributes", {}).get("valueof")
        if v:
            now[v["parameter_longname"]] = (bx, v)
    want = contract[name]
    if set(now) != set(want):
        issues.append(f"names differ: missing {sorted(set(want) - set(now))}, new {sorted(set(now) - set(want))}")
    for ln, w in want.items():
        if ln not in now:
            continue
        bx, v = now[ln]
        for k in ["parameter_shortname", "parameter_type", "parameter_mmin", "parameter_mmax", "parameter_enum",
                  "parameter_initial", "parameter_unitstyle", "parameter_exponent", "parameter_invisible"]:
            if v.get(k) != w[k] and APPROVED.get((ln, k)) != v.get(k):
                issues.append(f"{ln}.{k}: {v.get(k)!r} != S4 {w[k]!r}")
        if bx["maxclass"] != w["maxclass"]:
            issues.append(f"{ln}: class {bx['maxclass']} != {w['maxclass']}")
        if bx["id"] != w["s4_id"]:
            issues.append(f"{ln}: id {bx['id']} != S4 {w['s4_id']}")
        if order.index(bx["id"]) != w["s4_order"]:
            issues.append(f"{ln}: order {order.index(bx['id'])} != S4 {w['s4_order']}")
    rec("B14", f"{name}: parameter contract identical to S4 (names, ranges, defaults, enums, units, ids, order)", not issues,
        "; ".join(issues[:6]) or f"{len(want)} parameters unchanged")
    # every control is visible in presentation and inside the device, and no two controls overlap
    ctl = [b for b, _ in now.values() if b["maxclass"] != "newobj"]
    Wd = max(b["presentation_rect"][0] + b["presentation_rect"][2] for b in ctl)
    bad = [b["varname"] for b in ctl if not b.get("presentation") or b["presentation_rect"][1] < 0 or
           b["presentation_rect"][1] + b["presentation_rect"][3] > 169 or b.get("background")]
    ov = []
    for i, a in enumerate(ctl):
        for c in ctl[i + 1:]:
            ax, ay, aw, ah = a["presentation_rect"]; cx, cy, cw, ch = c["presentation_rect"]
            if ax < cx + cw and cx < ax + aw and ay < cy + ch and cy < ay + ah:
                ov.append(f"{a['varname']}/{c['varname']}")
    rec("B15", f"{name}: every control on the panel, inside 169 px, in the foreground, none overlapping", not bad and not ov,
        f"off-panel/background: {bad}; overlaps: {ov}" if bad or ov else f"{len(ctl)} controls, device width {Wd:.0f} px")

# --- B16 routing readout: exactly one line visible, follows B Input -----------------------------------
M = devs["Twin Phasor 76"]
bx = {b["box"]["id"]: b["box"] for b in M["boxes"]}
flows = [i for i, b in bx.items() if b.get("text", "").startswith(("IN  →", "L  →"))]
binput = next(i for i, b in bx.items() if b.get("saved_attribute_attributes", {}).get("valueof", {}).get("parameter_longname") == "B Input")
sel = next(l["patchline"]["destination"][0] for l in M["lines"] if l["patchline"]["source"][0] == binput and bx[l["patchline"]["destination"][0]].get("text") == "sel 0 1 2")
reach = {f: set() for f in flows}
for k in range(3):
    trig = next(l["patchline"]["destination"][0] for l in M["lines"] if l["patchline"]["source"] == [sel, k])
    for l in M["lines"]:
        if l["patchline"]["source"][0] == trig:
            m = l["patchline"]["destination"][0]
            tgt = next(l2["patchline"]["destination"][0] for l2 in M["lines"] if l2["patchline"]["source"][0] == m)
            reach[tgt].add((k, bx[m]["text"]))
ok = len(flows) == 3 and sum(1 for f in flows if not bx[f].get("hidden")) == 1 and \
    all(sum(1 for f in flows if (k, "hidden 0") in reach[f]) == 1 and sum(1 for f in flows if (k, "hidden 1") in reach[f]) == 2 for k in range(3))
rec("B16", "routing readout: 3 lines, one visible by default, each B Input value shows one and hides two", ok, f"{len(flows)} lines")

failed = [r for r in results if r["status"] == "FAIL"]
print(f"\n{len(results) - len(failed)}/{len(results)} passed")
if "--json" in sys.argv:
    Path(sys.argv[sys.argv.index("--json") + 1]).write_text(json.dumps(results, indent=1))
sys.exit(1 if failed else 0)
