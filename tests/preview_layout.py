"""Rough static render of the device's presentation layout (not a Max/Live screenshot)."""
import json, sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
ROOT = Path(__file__).resolve().parent.parent
p = json.loads((ROOT / "Twin Phasor 76.maxpat").read_text())["patcher"]
W, H, S = 1064, 169, 2
im = Image.new('RGB', (W * S, H * S)); d = ImageDraw.Draw(im)
col = lambda c: tuple(int(v * 255) for v in c[:3])
F = lambda n: ImageFont.load_default(size=n)
for b in p['boxes']:
    b = b['box']
    if not b.get('presentation'): continue
    x, y, w, h = [v * S for v in b['presentation_rect']]; mc = b['maxclass']
    if mc == 'panel':
        bf = b.get('bgfillcolor', {})
        if bf.get('type') == 'gradient':
            c1, c2 = col(bf['color1']), col(bf['color2'])
            for i in range(int(w)): d.line([(x + i, y), (x + i, y + h)], fill=tuple(int(c1[k] + (c2[k] - c1[k]) * i / w) for k in range(3)))
        elif bf.get('color', [0, 0, 0, 0])[3] > 0: d.rounded_rectangle([x, y, x + w, y + h], radius=b.get('rounded', 0) * S / 2, fill=col(bf['color']))
        if b.get('border'): d.rounded_rectangle([x, y, x + w, y + h], radius=b.get('rounded', 0) * S / 2, outline=col(b['bordercolor']), width=2)
    elif mc == 'live.comment':
        d.text((x + 2, y), b['text'], fill=col(b['textcolor']), font=F(int(b['fontsize'] * S * 0.95)))
    elif mc == 'live.dial':
        cx, cy, r = x + w / 2, y + h * 0.42, min(w, h) * 0.26
        d.ellipse([cx - r, cy - r, cx + r, cy + r], outline=col(b['activedialcolor']), width=3)
        d.text((x, y), b['saved_attribute_attributes']['valueof']['parameter_shortname'][:9], fill=col(b['textcolor']), font=F(15))
    elif mc in ('live.tab', 'live.text', 'live.menu'):
        v = b['saved_attribute_attributes']['valueof']; on = v.get('parameter_initial', [0])[0]
        if mc == 'live.tab':
            opts = v['parameter_enum']; n = len(opts)
            for i, o in enumerate(opts):
                xx = x + i * w / n; sel = i == on
                d.rectangle([xx, y, xx + w / n - 2, y + h], fill=col(b['bgoncolor'] if sel else b['bgcolor']), outline=col(b['bordercolor']))
                d.text((xx + 3, y + 3), o, fill=col(b['textoncolor'] if sel else b['textcolor']), font=F(15))
        else:
            lit = mc == 'live.text' and on
            d.rounded_rectangle([x, y, x + w, y + h], radius=4, fill=col(b['bgoncolor'] if lit else b['bgcolor']), outline=col(b.get('bordercolor', [.8, .8, .8, 1])))
            t = (b.get('texton') if on else b.get('text', '')) if mc == 'live.text' else v['parameter_enum'][on]
            d.text((x + 4, y + 3), t, fill=col(b['textoncolor'] if lit else b['textcolor']), font=F(15))
out = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "docs" / "panel_layout_preview.png"
im.save(out); print("wrote", out)
