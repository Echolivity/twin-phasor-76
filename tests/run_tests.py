"""Single entry point: python3 tests/run_tests.py  (exit 0 only if every suite passes).

Requires: python3, `pip install -r requirements.txt`, node >= 18.
Writes machine-readable results to tests/results/.
"""
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "tests" / "results"
OUT.mkdir(parents=True, exist_ok=True)
steps = [
    ("build/static", [sys.executable, str(ROOT / "tests" / "test_build.py"), "--json", str(OUT / "build.json")]),
    ("translate gen->js", [sys.executable, str(ROOT / "tests" / "genjs.py")]),
    ("dsp", ["node", str(ROOT / "tests" / "test_dsp.js"), "--json", str(OUT / "dsp.json")]),
]
rc = 0
for name, cmd in steps:
    print(f"\n=== {name} ===", flush=True)
    r = subprocess.run(cmd)
    if r.returncode != 0:
        print(f"*** {name} FAILED (exit {r.returncode})")
        rc = 1
        if name == "translate gen->js":
            break
print("\nALL SUITES PASSED" if rc == 0 else "\nSOME SUITES FAILED")
sys.exit(rc)
