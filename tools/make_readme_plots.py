"""Renders the README plots into docs/img/ from the offline model (tools/readme_data.js).

Usage: python3 tools/make_readme_plots.py   (needs node, numpy, matplotlib)
"""
import json
import subprocess
import sys
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "docs" / "img"
OUT.mkdir(parents=True, exist_ok=True)
subprocess.run([sys.executable, str(ROOT / "tests" / "genjs.py")], check=True, capture_output=True)
d = json.loads(subprocess.run(["node", str(ROOT / "tools" / "readme_data.js")], check=True, capture_output=True, text=True).stdout)

BG, FACE, INK, SUB, LBLUE, RED, GREY = "#22336f", "#3750a9", "#f4f4f1", "#c3cfee", "#a8cae8", "#e72e24", "#9a9ea3"
plt.rcParams.update({"font.family": "DejaVu Sans", "text.color": INK, "axes.labelcolor": SUB, "xtick.color": SUB, "ytick.color": SUB,
                     "axes.edgecolor": SUB, "axes.facecolor": FACE, "figure.facecolor": BG, "savefig.facecolor": BG, "font.size": 11})


def finish(ax, fig, name, title, note):
    ax.set_title(title, loc="left", fontsize=14, fontweight="bold", pad=12)
    ax.grid(color=INK, alpha=0.12)
    for s in ax.spines.values():
        s.set_alpha(0.4)
    fig.text(0.01, 0.01, note, fontsize=8.5, color=SUB, alpha=0.9)
    fig.tight_layout(rect=(0, 0.04, 1, 1))
    fig.savefig(OUT / name, dpi=110)
    plt.close(fig)


# 1. frequency response
f = np.array(d["freqs"])
fig, ax = plt.subplots(figsize=(10, 4.8))
cols = {0.15: LBLUE, 0.5: INK, 0.85: "#f2c14e"}
for ped, c in cols.items():
    ax.semilogx(f, d["resp"][f"p{ped}_fb0"], color=c, lw=2, label=f"sweep {int(ped * 100)} %")
ax.semilogx(f, d["resp"]["p0.5_fb0.8"], color=RED, lw=1.6, ls="--", label="sweep 50 %, feedback 80 %")
ax.set_xlim(20, 20000); ax.set_ylim(-40, 15)
ax.set_xlabel("Frequency (Hz)"); ax.set_ylabel("Gain (dB)")
ax.set_xticks([20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000]); ax.set_xticklabels(["20", "50", "100", "200", "500", "1k", "2k", "5k", "10k", "20k"])
ax.legend(loc="upper center", bbox_to_anchor=(0.5, -0.2), frameon=False, ncol=4, fontsize=10)
finish(ax, fig, "frequency_response.png", "Three notches per phasor, moving with the sweep",
       "Computed from the shipped gen~ code's settled all-pass coefficients (MODERN mode, Mix 50 %, one phasor). Simulation, not a hardware measurement.")

# 2. photocell lag
t = np.arange(len(d["lag"]["vintage"])) / 1000
fig, ax = plt.subplots(figsize=(10, 4.2))
ax.plot(t, d["lag"]["modern"], color=LBLUE, lw=1.6, label="MODERN: clean square")
ax.plot(t, d["lag"]["vintage"], color=RED, lw=2.2, label="VINTAGE: photocell lag")
ax.set_xlabel("Time (s)"); ax.set_ylabel("Sweep position"); ax.set_ylim(-0.05, 1.08); ax.set_xlim(0.4, 2)
ax.legend(loc="upper center", bbox_to_anchor=(0.5, -0.22), frameon=False, ncol=2, fontsize=10)
finish(ax, fig, "photocell_lag.png", "Square-wave sweep: cells light fast, darken slowly",
       "Gen 1 SQR at 1 Hz, Depth 100 %. Photocell constants are estimates, not measured on an original unit.")

# 3. envelope sweep
inp = np.array(d["env"]["input"]); t = np.arange(len(inp)) / 1000
fig, ax = plt.subplots(figsize=(10, 4.2))
ax.fill_between(t, -np.abs(inp) * 1.2 + 0, np.abs(inp) * 1.2, color=INK, alpha=0.18, lw=0, label="input (organ skank)")
ax.plot(t, d["env"]["lfo"], color=GREY, lw=1.6, label="Gen 1 LFO sweep")
ax.plot(t, d["env"]["env"], color="#f2c14e", lw=2.2, label="ENV sweep")
ax.set_xlabel("Time (s)"); ax.set_ylabel("Sweep position"); ax.set_xlim(0.5, 4); ax.set_ylim(-0.3, 1.08)
ax.legend(loc="upper center", bbox_to_anchor=(0.5, -0.22), frameon=False, ncol=3, fontsize=10)
finish(ax, fig, "envelope_sweep.png", "ENV: the sweep follows your playing",
       "Synthetic offbeat organ at 76 bpm. ENV Amount 60 %, Attack 4 ms, Release 150 ms, UP. Simulation of the shipped gen~ code.")
print("wrote", [p.name for p in OUT.glob("*.png")])
