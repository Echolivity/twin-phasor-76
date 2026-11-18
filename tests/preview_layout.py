"""Approximate static render of a device's presentation layout (NOT a Max/Live screenshot).

Draws panels, labels, dials (name, value arc at the default, value), tabs, toggles and menus
at their default values, at 2x scale. Live draws its own controls, so fonts and arc shapes differ.
Usage: python3 tests/preview_layout.py [OUT.png] [--device "Twin Phasor Return"] [--maxpat PATH]
"""
import json
import math
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
args = [a for a in sys.argv[1:]]
dev = args[args.index("--device") + 1] if "--device" in args else "Twin Phasor 76"
src = Path(args[args.index("--maxpat") + 1]) if "--maxpat" in args else ROOT / f"{dev}.maxpat"
outs = [a for a in args if a.endswith(".png")]
out = Path(outs[0]) if outs else ROOT / "docs" / "panel_layout_preview.png"

P = json.loads(src.read_text())["patcher"]
pres = [b["box"] for b in P["boxes"] if b["box"].get("presentation") and not b["box"].get("hidden")]
W = int(max(b["presentation_rect"][0] + b["presentation_rect"][2] for b in pres))
H, S = 169, 2
im = Image.new("RGB", (W * S, H * S), (20, 20, 20))
d = ImageDraw.Draw(im)
col = lambda c: tuple(int(v * 255) for v in c[:3])
FONTS = {}


def F(n, bold=False):
    key = (n, bold)
    if key not in FONTS:
        try:
            FONTS[key] = ImageFont.truetype("DejaVuSans-Bold.ttf" if bold else "DejaVuSans.ttf", n)
        except OSError:
            FONTS[key] = ImageFont.load_default(size=n)
    return FONTS[key]


def fmt(v, val):
    us = v.get("parameter_unitstyle", 1)
    if us == 5:
        return f"{val:.0f} %"
    if us == 4:
        return f"{val:.1f} dB"
    if us == 3:
        return f"{val:.2f} Hz" if val < 100 else (f"{val / 1000:.1f} kHz" if val >= 1000 else f"{val:.0f} Hz")
    if us == 2:
        return f"{val:.0f} ms"
    return f"{val:.2f}"


def text_c(cx, y, s, fill, f):
    w = d.textlength(s, font=f)
    d.text((cx - w / 2, y), s, fill=fill, font=f)


order = sorted(pres, key=lambda b: 0 if b.get("background") else 1)
for b in order:
    x, y, w, h = [v * S for v in b["presentation_rect"]]
    mc = b["maxclass"]
    v = b.get("saved_attribute_attributes", {}).get("valueof", {})
    if mc == "panel":
        bf = b.get("bgfillcolor", {})
        r = b.get("rounded", 0) * S / 2
        if bf.get("color", [0, 0, 0, 0])[3] > 0:
            d.rounded_rectangle([x, y, x + w, y + h], radius=r, fill=col(bf["color"]))
        if b.get("border"):
            d.rounded_rectangle([x, y, x + w, y + h], radius=r, outline=col(b["bordercolor"]), width=2)
    elif mc == "live.comment":
        f = F(int(b["fontsize"] * S * 1.0), "Bold" in b.get("fontname", ""))
        t = b["text"]
        if b.get("justification") == 2:
            d.text((x + w - d.textlength(t, font=f), y), t, fill=col(b["textcolor"]), font=f)
        else:
            d.text((x + 2, y), t, fill=col(b["textcolor"]), font=f)
    elif mc == "live.dial":
        lo, hi = v["parameter_mmin"], v["parameter_mmax"]
        val = v.get("parameter_initial", [lo])[0]
        e = v.get("parameter_exponent", 1.0)
        frac = ((val - lo) / (hi - lo)) ** (1 / e) if hi > lo else 0
        fs = int(9 * S * 0.95)
        text_c(x + w / 2, y, v["parameter_shortname"], col(b["textcolor"]), F(fs))
        rad = min(w, h - 2 * fs - 6) / 2 - 2
        cx, cy = x + w / 2, y + fs + 4 + rad + 2
        box = [cx - rad, cy - rad, cx + rad, cy + rad]
        d.arc(box, 135, 405, fill=col(b["dialcolor"]), width=int(3 * S))
        a1 = 135 + 270 * frac
        if frac > 0.002:
            d.arc(box, 135, a1, fill=col(b["activedialcolor"]), width=int(3 * S))
        ang = math.radians(a1)
        d.line([cx + math.cos(ang) * rad * 0.25, cy + math.sin(ang) * rad * 0.25,
                cx + math.cos(ang) * rad * 0.95, cy + math.sin(ang) * rad * 0.95], fill=col(b["needlecolor"]), width=S * 2)
        text_c(x + w / 2, y + h - fs - 2, fmt(v, val), col(b["textcolor"]), F(fs))
    elif mc == "live.tab":
        opts = v["parameter_enum"]; n = len(opts); on = v.get("parameter_initial", [0])[0]
        for i, o in enumerate(opts):
            xx = x + i * w / n; sel = i == on
            d.rectangle([xx, y, xx + w / n - 1, y + h], fill=col(b["bgoncolor"] if sel else b["bgcolor"]), outline=col(b["bordercolor"]))
            text_c(xx + w / n / 2, y + (h - 16) / 2, o, col(b["textoncolor"] if sel else b["textcolor"]), F(16, True))
    elif mc in ("live.text", "live.menu"):
        on = v.get("parameter_initial", [0])[0]
        lit = mc == "live.text" and on
        d.rounded_rectangle([x, y, x + w, y + h], radius=5, fill=col(b["bgoncolor"] if lit else b["bgcolor"]),
                            outline=col(b.get("bordercolor", [.8, .8, .8, 1])))
        t = (b.get("texton") if on else b.get("text", "")) if mc == "live.text" else v["parameter_enum"][on]
        f = F(16, mc == "live.text")
        if mc == "live.text":
            text_c(x + w / 2, y + (h - 16) / 2, t, col(b["textoncolor"] if lit else b["textcolor"]), f)
        else:
            d.text((x + 6, y + (h - 16) / 2), t, fill=col(b["textcolor"]), font=f)
            d.polygon([(x + w - 14, y + h / 2 - 3), (x + w - 6, y + h / 2 - 3), (x + w - 10, y + h / 2 + 3)], fill=col(b.get("tricolor", b["textcolor"])))
out.parent.mkdir(parents=True, exist_ok=True)
im.save(out)
print("wrote", out)
