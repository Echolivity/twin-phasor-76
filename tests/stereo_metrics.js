// Stereo / mono-compatibility metrics for Out A|B configurations on the dub chord material.
// Usage: node tests/stereo_metrics.js   (prints a table; used as evidence for the stereo decision)
const path = require('path');
const D = require(path.join(__dirname, 'build', 'dsp_test.js'));
const M = require(path.join(__dirname, 'material.js'));
const SR = M.SR, x = M.dubChord(8);
function metrics(L, R) {
  let sl = 0, sr = 0, slr = 0, sm = 0; const s0 = SR; // skip first second
  for (let i = s0; i < L.length; i++) { sl += L[i] * L[i]; sr += R[i] * R[i]; slr += L[i] * R[i]; const m = 0.5 * (L[i] + R[i]); sm += m * m; }
  return { corr: slr / Math.sqrt(sl * sr), monoLossDb: 10 * Math.log10(sm / ((sl + sr) / 4)) };
}
const base = { outmode: 0, b_on: 1, b_input: 0, insum: 1, g1_rate: 0.25, a_depth: 0.9, b_depth: 0.9, a_fb: 0.5, b_fb: 0.5, q_noise_p: 0 };
const cfgs = Object.assign({
  'bypass (reference)': { ...base, a_on: 0, b_on: 0 },
  'A|B NORM (same sweep)': { ...base, b_sweep: 0, b_sync: 0 },
  'A|B REV (180 deg)': { ...base, b_sweep: 0, b_sync: 1 },
  'A|B free (B on Gen2 0.37 Hz)': { ...base, b_sweep: 1, g2_rate: 0.37 },
}, (D.PARAMS.b_sync[2] >= 2) ? { 'A|B QUAD (90 deg)': { ...base, b_sweep: 0, b_sync: 2 } } : {});
const rows = [];
for (const k in cfgs) { const o = D.run(cfgs[k], x, x, SR); const m = metrics(o[0], o[1]); rows.push({ config: k, corr: +m.corr.toFixed(3), 'mono sum vs stereo avg dB': +m.monoLossDb.toFixed(2) }); }
console.table(rows);
module.exports = rows;
