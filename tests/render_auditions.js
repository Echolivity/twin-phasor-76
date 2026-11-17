// Renders A/B audition WAVs for the four sprint scenarios through the offline DSP model,
// plus objective metrics. Listening judgements are NOT produced here.
// Usage: node tests/render_auditions.js <outdir>
const path = require('path'), fs = require('fs');
const D = require(path.join(__dirname, 'build', 'dsp_test.js'));
const M = require(path.join(__dirname, 'material.js'));
const SR = M.SR, SECS = 6, out = process.argv[2] || path.join(__dirname, '..', 'auditions');
fs.mkdirSync(out, { recursive: true });

function wav(file, L, R) { // 24-bit stereo PCM
  const n = L.length, b = Buffer.alloc(44 + n * 6);
  b.write('RIFF', 0); b.writeUInt32LE(36 + n * 6, 4); b.write('WAVEfmt ', 8); b.writeUInt32LE(16, 16); b.writeUInt16LE(1, 20); b.writeUInt16LE(2, 22);
  b.writeUInt32LE(SR, 24); b.writeUInt32LE(SR * 6, 28); b.writeUInt16LE(6, 32); b.writeUInt16LE(24, 34); b.write('data', 36); b.writeUInt32LE(n * 6, 40);
  for (let i = 0; i < n; i++) for (const [c, a] of [[0, L], [1, R]]) b.writeIntLE(Math.max(-8388608, Math.min(8388607, Math.round(a[i] * 8388607))), 44 + i * 6 + c * 3, 3);
  fs.writeFileSync(path.join(out, file), b);
}
const db = v => 20 * Math.log10(Math.max(v, 1e-12));
function lowband(a) { let y = 0, s = 0; const c = 1 - Math.exp(-2 * Math.PI * 120 / SR); for (let i = 0; i < a.length; i++) { y += (a[i] - y) * c; if (i > SR) s += y * y; } return Math.sqrt(s / (a.length - SR)); }
function rms(a) { let s = 0; for (let i = SR; i < a.length; i++) s += a[i] * a[i]; return Math.sqrt(s / (a.length - SR)); }
function corr(a, b) { let ab = 0, aa = 0, bb = 0; for (let i = SR; i < a.length; i++) { ab += a[i] * b[i]; aa += a[i] * a[i]; bb += b[i] * b[i]; } return ab / Math.sqrt(aa * bb); }
function sweepStats(led, x) { // movement of sweep position and its correlation with the input envelope
  let e = 0; const env = new Float64Array(led.length); for (let i = 0; i < x.length; i++) { const v = Math.abs(x[i]); e += (v - e) * (v > e ? 0.01 : 0.0002); env[i] = e; }
  let m = 0, n = 0; for (let i = SR; i < led.length; i++) { m += led[i]; n++; } m /= n; let sd = 0; for (let i = SR; i < led.length; i++) sd += (led[i] - m) ** 2;
  let ma = 0; for (let i = SR; i < led.length; i++) ma += env[i]; ma /= n; let c = 0, va = 0, vb = 0;
  for (let i = SR; i < led.length; i++) { c += (led[i] - m) * (env[i] - ma); va += (led[i] - m) ** 2; vb += (env[i] - ma) ** 2; }
  return { sweepSD: Math.sqrt(sd / n), envCorr: va > 0 ? c / Math.sqrt(va * vb) : 0 };
}
const common = { q_noise_p: 1, insum: 1 };
const scenarios = {
  '1_dub_chord': { src: M.dubChord(SECS), variants: {
    existing_REV: { outmode: 0, b_on: 1, b_input: 0, b_sync: 1, g1_rate: 0.2, a_depth: 0.9, b_depth: 0.9, a_fb: 0.55, b_fb: 0.55 },
    new_QUAD: { outmode: 0, b_on: 1, b_input: 0, b_sync: 2, g1_rate: 0.2, a_depth: 0.9, b_depth: 0.9, a_fb: 0.55, b_fb: 0.55 } } },
  '2_skank_organ': { src: M.skankOrgan(SECS), variants: {
    existing_LFO: { g1_rate: 0.5, a_depth: 0.8, a_fb: 0.5, outmode: 2 },
    new_ENV: { a_sweep: 2, env_amt: 0.6, env_att: 4, env_rel: 150, a_depth: 0.8, a_fb: 0.5, outmode: 2 } } },
  '3_percussion': { src: M.percLoop(SECS), variants: {
    existing_LFO: { g1_rate: 0.3, a_depth: 0.9, a_fb: 0.6, outmode: 2 },
    new_ENV: { a_sweep: 2, env_amt: 0.5, env_att: 2, env_rel: 200, a_depth: 0.9, a_fb: 0.6, outmode: 2 } } },
  '4_bass': { src: M.bassLine(SECS), variants: {
    existing_LFO: { g1_rate: 0.25, a_depth: 0.8, a_fb: 0.35, outmode: 2 },
    new_ENV: { a_sweep: 2, env_amt: 0.5, env_att: 10, env_rel: 300, a_depth: 0.8, a_fb: 0.35, outmode: 2 } } },
};
const rows = [];
for (const s in scenarios) {
  const x = scenarios[s].src;
  const renders = { bypass: D.run({ ...common, a_on: 0, b_on: 0, outmode: 2 }, x, x, SR) };
  for (const v in scenarios[s].variants) renders[v] = D.run({ ...common, ...scenarios[s].variants[v] }, x, x, SR);
  let peak = 0; for (const r in renders) for (const ch of [0, 1]) for (const v of renders[r][ch]) peak = Math.max(peak, Math.abs(v));
  const g = peak > 0.89 ? 0.89 / peak : 1; // same trim for every file of a scenario, so relative levels stay true
  const ref = renders.bypass;
  for (const r in renders) {
    const [L, R] = renders[r]; const Lg = L.map(v => v * g), Rg = R.map(v => v * g);
    wav(`${s}__${r}.wav`, Lg, Rg);
    const sw = sweepStats(renders[r][4], x);
    rows.push({ file: `${s}__${r}.wav`, 'level vs bypass dB': +(db(rms(L)) - db(rms(ref[0]))).toFixed(1), 'low band <120Hz vs bypass dB': +(db(lowband(L)) - db(lowband(ref[0]))).toFixed(1),
      'L/R corr': +corr(L, R).toFixed(2), 'sweep SD': r === 'bypass' ? '-' : +sw.sweepSD.toFixed(3), 'sweep~input env corr': r === 'bypass' ? '-' : +sw.envCorr.toFixed(2), 'file trim dB': +db(g).toFixed(1) });
  }
}
console.table(rows);
fs.writeFileSync(path.join(out, 'metrics.json'), JSON.stringify(rows, null, 1));
