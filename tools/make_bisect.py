"""Builds a diagnostic ladder of devices from the full Twin Phasor 76 patch, to isolate a Live load crash.

  TP Test 1 Passthrough        container + root patcher only (plugin~ -> plugout~), no gen~
  TP Test 2 Gen minimal        gen~ embedded the same way, 6-line codebox (out = in)
  TP Test 3 Gen declarations   gen~ with all 41 Params + 91 History declarations, trivial body
  TP Test 4 Gen full DSP       gen~ with the full code, plugout~ 1 2 3 4, send~; no UI
  TP Test 5 UI only            every panel control and LED; gen~ removed, audio passes through
  (the full device is the last rung)
S2: Live 12.4.15 / Max 9.1.5 crashed inside maxclang (gen~ compiler) when loading the S1 build.

Usage: python3 tools/make_bisect.py OUTDIR
"""
import copy
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))
from m4l_builder.container import build_amxd  # noqa: E402
from m4l_builder.constants import AUDIO_EFFECT  # noqa: E402

out = Path(sys.argv[1]); out.mkdir(parents=True, exist_ok=True)
full = json.loads((ROOT / "Twin Phasor 76.maxpat").read_text())
UI = {"live.dial", "live.tab", "live.text", "live.menu", "live.comment", "panel"}


def variant(keep, extra_lines=(), retext=None, gencode=None):
    p = copy.deepcopy(full)
    P = p["patcher"]
    if gencode is not None:
        for b in P["boxes"]:
            if b["box"].get("text", "").startswith("gen~"):
                b["box"]["patcher"]["boxes"][0]["box"]["code"] = gencode
    P["boxes"] = [b for b in P["boxes"] if keep(b["box"])]
    ids = {b["box"]["id"] for b in P["boxes"]}
    P["lines"] = [l for l in P["lines"] if l["patchline"]["source"][0] in ids and l["patchline"]["destination"][0] in ids]
    for s, so, d, di in extra_lines:
        P["lines"].append({"patchline": {"source": [s, so], "destination": [d, di]}})
    for b in P["boxes"]:
        if retext and b["box"].get("text", "").startswith("plugout~"):
            b["box"]["text"], b["box"]["numinlets"] = retext, 2
    # rebuild root parameter table for the remaining objects
    prm = {k: v for k, v in P["parameters"].items() if k in ids}
    longs = [v[0] for k, v in prm.items()]
    prm["parameterbanks"] = {str(i // 8): {"index": i // 8, "name": "", "parameters": longs[i:i + 8] + ["-"] * (8 - len(longs[i:i + 8]))}
                             for i in range(0, len(longs), 8)} if longs else {}
    prm["inherited_shortname"] = 1
    P["parameters"] = prm
    return p


bid = lambda t: next(b["box"]["id"] for b in full["patcher"]["boxes"] if b["box"].get("text", "").split(" ")[0] == t)
PIN, POUT, GEN = bid("plugin~"), bid("plugout~"), bid("gen~")
is_bg = lambda b: b["maxclass"] == "panel" and b.get("presentation_rect", [1, 1])[:2] in ([0, 0], [3, 3])
code = (ROOT / "twinphasor.genexpr").read_text()
MIN = "out1 = in1;\nout2 = in2;\nout3 = 0;\nout4 = 0;\nout5 = 0;\nout6 = 0;\n"
DECL = "\n".join(l for l in code.splitlines() if l.startswith(("Param ", "History "))) + "\n" + MIN
dsp_only = lambda b: b["maxclass"] not in UI or is_bg(b)
ladder = {
    "TP Test 1 Passthrough": variant(lambda b: b["id"] in (PIN, POUT) or is_bg(b), [(PIN, 0, POUT, 0), (PIN, 1, POUT, 1)], retext="plugout~"),
    "TP Test 2 Gen minimal": variant(dsp_only, gencode=MIN),
    "TP Test 3 Gen declarations": variant(dsp_only, gencode=DECL),
    "TP Test 4 Gen full DSP": variant(dsp_only),
    "TP Test 5 UI only": variant(lambda b: b["id"] != GEN, [(PIN, 0, POUT, 0), (PIN, 1, POUT, 1)]),
}
for name, p in ladder.items():
    (out / f"{name}.amxd").write_bytes(build_amxd(p, AUDIO_EFFECT))
    n = len(p["patcher"]["boxes"])
    print(f"{name}: {n} boxes, {len(p['patcher']['lines'])} lines, {len(p['patcher']['parameters']) - 2} params")
