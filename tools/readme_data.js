// Dumps data for the README plots from the offline model of the shipped gen~ code.
// Usage: python3 tests/genjs.py && node tools/readme_data.js > /tmp/readme_data.json
const path = require('path');
const D = require(path.join(__dirname, '..', 'tests', 'build', 'dsp_test.js'));
const M = require(path.join(__dirname, '..', 'tests', 'material.js'));
const SR = 48000, out = {};

// 1. Frequency response at three pedal positions, computed from the settled all-pass coefficients (modern, mix 50 %)
function coeffs(over) { D.run(over, new Float64Array(SR / 2), new Float64Array(SR / 2), SR); return [0, 1, 2, 3, 4, 5].map(i => globalThis['k_a' + i]); }
function resp(ks, G, f) {
  const w = 2 * Math.PI * f / SR; let ar = 1, ai = 0;
  for (const k of ks) { const nr = k + Math.cos(w), ni = -Math.sin(w), dr = 1 + k * Math.cos(w), di = -k * Math.sin(w), den = dr * dr + di * di;
    const r = (nr * dr + ni * di) / den, i = (ni * dr - nr * di) / den, t = ar * r - ai * i; ai = ar * i + ai * r; ar = t; }
  // wet = A/(1 - G A); out = 0.5 (1 + wet)
  const dr = 1 - G * ar, di = -G * ai, den = dr * dr + di * di, wr = (ar * dr + ai * di) / den, wi = (ai * dr - ar * di) / den;
  return 20 * Math.log10(Math.hypot(0.5 * (1 + wr), 0.5 * wi));
}
const freqs = []; for (let f = 20; f <= 20000; f *= 1.01) freqs.push(f);
out.freqs = freqs; out.resp = {};
for (const ped of [0.15, 0.5, 0.85]) for (const fb of [0, 0.8]) {
  const ks = coeffs({ vintage: 0, a_sweep: 1, pedal: ped, a_depth: 1, outmode: 2 });
  out.resp[`p${ped}_fb${fb}`] = freqs.map(f => resp(ks, fb * 0.862, f));
}
// 2. Square-wave sweep: vintage photocell lag vs modern
const z = new Float64Array(SR * 2);
out.lag = { vintage: Array.from(D.run({ a_depth: 1, g1_shape: 1, g1_rate: 1 }, z, z, SR)[4]).filter((_, i) => i % 48 === 0),
  modern: Array.from(D.run({ vintage: 0, a_depth: 1, g1_shape: 1, g1_rate: 1 }, z, z, SR)[4]).filter((_, i) => i % 48 === 0) };
// 3. ENV following on the organ skank
const x = M.skankOrgan(4);
out.env = { input: Array.from(x).filter((_, i) => i % 48 === 0),
  env: Array.from(D.run({ vintage: 0, a_sweep: 2, env_amt: 0.6, env_att: 4, env_rel: 150, a_depth: 1 }, x, x, SR)[4]).filter((_, i) => i % 48 === 0),
  lfo: Array.from(D.run({ vintage: 0, g1_rate: 0.5, a_depth: 1 }, x, x, SR)[4]).filter((_, i) => i % 48 === 0) };
process.stdout.write(JSON.stringify(out));
