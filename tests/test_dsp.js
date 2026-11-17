// Automated DSP tests for Twin Phasor 76. Exit code 1 on any FAIL.
// Usage: node tests/test_dsp.js [--json results.json]
const path = require('path');
const fs = require('fs');
const D = require(path.join(__dirname, 'build', 'dsp_test.js'));

const SR = 48000;
const results = [];
function rec(id, name, pass, detail, cls) {
  results.push({ id, name, status: cls || (pass ? 'PASS' : 'FAIL'), detail });
  console.log(`${cls || (pass ? 'PASS' : 'FAIL')}  ${id} ${name} — ${detail}`);
}

// ---------------------------------------------------------------- signals
function rng(seed) { let s = seed; return () => { s = (s * 48271) % 2147483647; return s / 2147483647 - 0.5; }; }
const sig = {
  silence: n => new Float64Array(n),
  impulse: n => { const x = new Float64Array(n); x[100] = 1; return x; },
  sine: (n, f, a = 0.5) => Float64Array.from({ length: n }, (_, i) => a * Math.sin(2 * Math.PI * f * i / SR)),
  noise: (n, a = 0.2, seed = 7) => { const r = rng(seed); return Float64Array.from({ length: n }, () => a * r()); },
  square: (n, f, a = 1) => Float64Array.from({ length: n }, (_, i) => ((i * f / SR) % 1 < 0.5 ? a : -a)),
  dc: (n, a) => new Float64Array(n).fill(a),
  drums: n => { // kick + clap-like noise bursts every 0.25 s
    const x = new Float64Array(n), r = rng(3);
    for (let t = 0; t < n; t += SR / 4) for (let i = 0; i < SR / 8 && t + i < n; i++) {
      const e = Math.exp(-i / (SR * 0.03));
      x[t + i] += 0.9 * e * Math.sin(2 * Math.PI * (50 + 120 * Math.exp(-i / (SR * 0.01))) * i / SR) + 0.4 * Math.exp(-i / (SR * 0.008)) * r();
    }
    return x;
  },
};
const stats = a => { let mx = 0, s = 0, fin = true; for (const v of a) { if (!Number.isFinite(v)) fin = false; mx = Math.max(mx, Math.abs(v)); s += v * v; } return { peak: mx, rms: Math.sqrt(s / a.length), finite: fin }; };
const db = v => 20 * Math.log10(Math.max(v, 1e-30));
const slice = (a, s, e) => a.subarray(Math.floor(s), Math.floor(e));

// ---------------------------------------------------------------- FFT transfer function
function fft(re, im) {
  const n = re.length;
  for (let i = 1, j = 0; i < n; i++) { let b = n >> 1; for (; j & b; b >>= 1) j ^= b; j ^= b; if (i < j) { [re[i], re[j]] = [re[j], re[i]];[im[i], im[j]] = [im[j], im[i]]; } }
  for (let len = 2; len <= n; len <<= 1) {
    const a = -2 * Math.PI / len, wr = Math.cos(a), wi = Math.sin(a);
    for (let i = 0; i < n; i += len) { let cr = 1, ci = 0; for (let j = 0; j < len / 2; j++) {
      const ur = re[i + j], ui = im[i + j], vr = re[i + j + len / 2] * cr - im[i + j + len / 2] * ci, vi = re[i + j + len / 2] * ci + im[i + j + len / 2] * cr;
      re[i + j] = ur + vr; im[i + j] = ui + vi; re[i + j + len / 2] = ur - vr; im[i + j + len / 2] = ui - vi;
      const t = cr * wr - ci * wi; ci = cr * wi + ci * wr; cr = t; } }
  }
}
function transfer(x, y, N = 8192) { // averaged H1 estimate, Hann, 50% overlap
  const Sxy_r = new Float64Array(N / 2), Sxy_i = new Float64Array(N / 2), Sxx = new Float64Array(N / 2);
  const w = Float64Array.from({ length: N }, (_, i) => 0.5 - 0.5 * Math.cos(2 * Math.PI * i / N));
  for (let s = 0; s + N <= x.length; s += N / 2) {
    const xr = new Float64Array(N), xi = new Float64Array(N), yr = new Float64Array(N), yi = new Float64Array(N);
    for (let i = 0; i < N; i++) { xr[i] = x[s + i] * w[i]; yr[i] = y[s + i] * w[i]; }
    fft(xr, xi); fft(yr, yi);
    for (let k = 0; k < N / 2; k++) { Sxy_r[k] += yr[k] * xr[k] + yi[k] * xi[k]; Sxy_i[k] += yi[k] * xr[k] - yr[k] * xi[k]; Sxx[k] += xr[k] * xr[k] + xi[k] * xi[k]; }
  }
  return Array.from({ length: N / 2 }, (_, k) => ({ f: k * SR / N, db: db(Math.hypot(Sxy_r[k], Sxy_i[k]) / Sxx[k]) }));
}
function minima(H, fmin, fmax, prom = 10) {
  const out = [];
  for (let k = 2; k < H.length - 2; k++) {
    const h = H[k]; if (h.f < fmin || h.f > fmax) continue;
    if (h.db < H[k - 1].db && h.db <= H[k + 1].db) {
      let l = -1e9, r = -1e9; for (let j = Math.max(0, k - 200); j < k; j++) l = Math.max(l, H[j].db); for (let j = k + 1; j < Math.min(H.length, k + 200); j++) r = Math.max(r, H[j].db);
      if (Math.min(l, r) - h.db > prom) out.push(h);
    }
  }
  return out;
}

// clean, matched, static reference configuration
const CLEAN = { vintage: 0, a_depth: 0, b_on: 0, outmode: 2 };

// ================================================================ T1 finite / bounded output across configs
{
  const N = SR * 2;
  const configs = {
    vintage_default: {}, modern_default: { vintage: 0 },
    vint_fb_max: { a_fb: 1, b_fb: 1, b_on: 1 }, mod_fb_max: { vintage: 0, a_fb: 1, b_fb: 1, b_on: 1 },
    vint_fb_max_noclip: { a_fb: 1, b_fb: 1, b_on: 1, q_clip_p: 0 },
    series_double: { b_on: 1, b_input: 1, outmode: 1, a_fb: 1, b_fb: 1 },
    parallel_stereo: { b_on: 1, b_input: 0, outmode: 0, b_sync: 1, a_fb: 0.8, b_fb: 0.8 },
    fullwet_fb_max: { fullwet: 1, a_fb: 1, b_on: 1, b_fb: 1 },
    rate_max_sq: { g1_rate: 18, g1_shape: 1, g2_rate: 18, g2_shape: 1, b_on: 1, b_sweep: 1 },
    rate_min: { g1_rate: 0.1, g2_rate: 0.1, b_on: 1 },
    drive_max: { drive: 24, a_fb: 1 }, drive_min: { drive: -24 },
    all_quirks_hum: { q_hum_p: 1, hum_hz: 1 },
    env_fast_fb_max: { a_sweep: 2, b_on: 1, b_sweep: 3, env_amt: 1, env_att: 1, env_rel: 20, a_fb: 1, b_fb: 1, q_clip_p: 0 },
    env_down_modern: { vintage: 0, a_sweep: 2, env_pol: 1, env_amt: 1, a_fb: 1 },
    quad_sqr_fast: { b_on: 1, b_sync: 2, g1_shape: 1, g1_rate: 18, outmode: 0, b_input: 0, a_fb: 1, b_fb: 1 },
  };
  const signals = { silence: sig.silence(N), impulse: sig.impulse(N), sine100: sig.sine(N, 100, 0.9), sine1k: sig.sine(N, 1000, 0.9),
    noise: sig.noise(N, 0.5), square_fs: sig.square(N, 55, 1), drums: sig.drums(N) };
  let bad = [], worst = { peak: 0, margin: -1e9 };
  // theoretical peak gain per phasor at mix m: (1-m) + m/(1-0.862); two in series multiply. +1 dB margin.
  const gMax = m => (1 - m) + m / (1 - 0.862);
  const bound = c => { const m = c.fullwet ? 1 : 0.5, series = (c.b_on && (c.b_input === undefined || c.b_input === 1) && (c.outmode === undefined || c.outmode === 1));
    const drv = Math.pow(10, Math.max(0, c.drive || 0) / 20); return (series ? gMax(m) ** 2 : gMax(m)) * drv * Math.pow(10, 1 / 20); };
  for (const c in configs) for (const s in signals) {
    const o = D.run(configs[c], signals[s], signals[s], SR);
    for (let ch = 0; ch < 4; ch++) { const st = stats(o[ch]);
      if (!st.finite) bad.push(`${c}/${s}/out${ch + 1} non-finite`);
      const mg = db(st.peak) - db(bound(configs[c]));
      if (mg > worst.margin) worst = { peak: st.peak, margin: mg, where: `${c}/${s}/out${ch + 1}` }; }
  }
  rec('T1', `finite output: ${Object.keys(configs).length} configs x 7 signals x 4 outs`, bad.length === 0, bad.length ? bad.slice(0, 5).join('; ') : `all finite; worst peak ${worst.peak.toFixed(2)} (${db(worst.peak).toFixed(1)} dBFS) at ${worst.where}`);
  // bound: worst-case theoretical = full-wet peak gain 1/(1-0.862) (+17.2 dB) on a 0 dBFS input
  rec('T1b', 'no uncontrolled gain: every output within its theoretical linear bound (+1 dB)', worst.margin <= 0,
    `closest to bound: ${worst.where} peak ${db(worst.peak).toFixed(1)} dBFS, ${(-worst.margin).toFixed(1)} dB under bound (series fb=1 bound is +25.6 dB: by design, see report)`);
}

// ================================================================ T2 feedback loop decays (stability)
for (const [name, over] of [['modern fb=1', { ...CLEAN, a_fb: 1 }], ['vintage fb=1 no clip/noise', { a_depth: 0, a_fb: 1, q_clip_p: 0, q_noise_p: 0, outmode: 2 }],
  ['modern fb=1 fast sweep', { vintage: 0, a_fb: 1, a_depth: 1, g1_rate: 18, outmode: 2 }]]) {
  const N = SR * 3, o = D.run(over, sig.impulse(N), sig.impulse(N), SR)[0];
  const head = stats(slice(o, 0, SR * 0.1)).peak, tail = stats(slice(o, SR * 2.5, N)).peak;
  rec('T2', `impulse response decays (${name})`, tail < 1e-6 * head && Number.isFinite(tail), `peak ${head.toExponential(2)}, tail(2.5-3s) ${tail.toExponential(2)}`);
}

// ================================================================ T3 notch positions vs theory (modern, matched cells)
{
  const N = SR * 4, x = sig.noise(N, 0.2), P = D.PARAMS;
  const lo = P.mod_lo[0], hi = P.mod_hi[0], fc = lo * Math.sqrt(hi / lo);
  const H = transfer(x, D.run({ ...CLEAN, a_fb: 0 }, x, x, SR)[0]);
  const nts = minima(H, 50, 20000, 20).map(h => h.f);
  const want = [Math.tan(Math.PI / 12), 1, Math.tan(5 * Math.PI / 12)].map(k => k * fc).filter(f => f < 20000);
  const err = want.map((w, i) => nts[i] ? Math.abs(nts[i] - w) / w : 1);
  rec('T3', 'three notches at 0.268/1/3.73 x fc (modern, depth 0)', nts.length === want.length && err.every(e => e < 0.03),
    `fc=${fc.toFixed(0)} Hz; expected ${want.map(v => v.toFixed(0))}; measured ${nts.map(v => v.toFixed(0))}`);
  // vintage notches exist and are deep
  { // vintage (mismatched cells): locate nulls analytically from the settled coefficients, then verify in the time domain
    const vo = { a_depth: 0, a_fb: 0, b_on: 0, outmode: 2, q_noise_p: 0, insum: 0 }; // baseline test bug: fb was left at 0.35
    D.run(vo, sig.silence(SR), sig.silence(SR), SR); const ks = [0, 1, 2, 3, 4, 5].map(i => globalThis['k_a' + i]);
    const resp = f => { const w = 2 * Math.PI * f / SR; let pr = 1, pi = 0; for (const k of ks) { const nr = k + Math.cos(w), ni = -Math.sin(w), dr = 1 + k * Math.cos(w), di = -k * Math.sin(w), den = dr * dr + di * di;
      const ar = (nr * dr + ni * di) / den, ai = (ni * dr - nr * di) / den, t = pr * ar - pi * ai; pi = pr * ai + pi * ar; pr = t; } return Math.hypot(0.5 * (1 + pr), 0.5 * pi); };
    const nulls = []; let prev = resp(30), cur = resp(30 * 1.0002);
    for (let f = 30 * 1.0004; f < 20000; f *= 1.0002) { const nx = resp(f); if (cur < prev && cur < nx && cur < 0.05) nulls.push(f / 1.0002); prev = cur; cur = nx; }
    const meas = nulls.map(f => { const n = SR; const s1 = sig.sine(n, f, 0.3); const o = D.run(vo, s1, s1, SR)[0];
      let e = 0, ei = 0; for (let i = n / 2; i < n; i++) { e += o[i] * o[i]; ei += s1[i] * s1[i]; } return 10 * Math.log10(e / ei); });
    rec('T3b', 'vintage static: every predicted null measured below -30 dB in the time domain', nulls.length >= 2 && meas.every(m => m < -30),
      nulls.map((f, i) => `${f.toFixed(0)}Hz:${meas[i].toFixed(0)}dB`).join(', '));
  }
  // feedback raises peaks between notches by a bounded amount
  const Hf = transfer(x, D.run({ ...CLEAN, a_fb: 1 }, x, x, SR)[0]);
  const pk = Math.max(...Hf.filter(h => h.f > 30 && h.f < 20000).map(h => h.db));
  rec('T3c', 'feedback=1 peak gain between +8 and +18 dB', pk > 8 && pk < 18, `peak ${pk.toFixed(1)} dB (theory for mix 0.5: 20log10((1+1/(1-0.862))/2)=${db((1 + 1 / (1 - 0.862)) / 2).toFixed(1)} dB)`);
}

// ================================================================ T4 full wet is all-pass (flat magnitude at fb=0)
{
  const N = SR * 4, x = sig.noise(N, 0.2);
  const H = transfer(x, D.run({ ...CLEAN, a_fb: 0, fullwet: 1 }, x, x, SR)[0]).filter(h => h.f > 40 && h.f < 16000);
  const dev = Math.max(...H.map(h => Math.abs(h.db)));
  rec('T4', 'FULL WET at fb=0 is flat within 0.5 dB (40 Hz-16 kHz, modern)', dev < 0.5, `max deviation ${dev.toFixed(3)} dB`);
}

// ================================================================ T5 bypass transparency
{
  const N = SR, x = sig.noise(N, 0.3);
  const o = D.run({ vintage: 0, a_on: 0, b_on: 0, outmode: 2 }, x, x, SR)[0];
  let e = 0; for (let i = SR / 2; i < N; i++) e = Math.max(e, Math.abs(o[i] - x[i]));
  rec('T5', 'both phasors off (modern) = bit-transparent after fade', e < 1e-9, `max |out-in| ${e.toExponential(2)}`);
  const ov = D.run({ a_on: 0, b_on: 0, outmode: 2, q_noise_p: 0 }, x, x, SR)[0];
  const r = stats(slice(ov, SR / 2, N)).rms / stats(slice(x, SR / 2, N)).rms;
  rec('T5b', 'both phasors off (vintage) level within 0.1 dB', Math.abs(db(r)) < 0.1, `level ${db(r).toFixed(3)} dB (8.7 Hz input coupling only)`);
}

// ================================================================ T6 DC behaviour
{
  const N = SR * 3;
  const ov = stats(slice(D.run({ q_noise_p: 0 }, sig.dc(N, 0.2), sig.dc(N, 0.2), SR)[0], SR * 2, N));
  rec('T6', 'vintage blocks input DC (C2 coupling)', Math.abs(ov.peak) < 1e-3, `residual DC ${ov.peak.toExponential(2)}`);
  const o = D.run({ q_hum_p: 1 }, sig.silence(N), sig.silence(N), SR)[0];
  let m = 0; for (let i = SR; i < N; i++) m += o[i]; m /= (N - SR);
  rec('T6b', 'no DC generated from silence (vintage, hiss+hum on)', Math.abs(m) < 1e-5, `mean ${m.toExponential(2)}`);
  const om = D.run({ vintage: 0, a_fb: 1 }, sig.dc(N, 0.2), sig.dc(N, 0.2), SR)[0];
  const dcm = om[N - 1];
  rec('T6c', 'modern: DC passes at unity, feedback does not amplify DC', Math.abs(dcm - 0.2) < 1e-3, `out DC ${dcm.toFixed(5)} for in 0.2`);
}

// ================================================================ T7 denormals: scan every state value through the decay
{
  const N = SR * 4, x = sig.sine(N, 200, 0.5); x.fill(0, SR);
  const SUB = 2.2250738585072014e-308;
  for (const [name, over] of [['modern', { vintage: 0, b_on: 1 }], ['vintage quiet', { q_noise_p: 0, b_on: 1 }]]) {
    const hits = new Set();
    D.run(over, x, x, SR, [], n => { if (n >= SR) for (const k of D.HKEYS) { const v = globalThis[k]; if (v !== 0 && Math.abs(v) < SUB) hits.add(k); } });
    rec('T7', `no subnormal state value at any sample during 3 s of decay to silence (${name})`, hits.size === 0, hits.size ? `subnormal in: ${[...hits].slice(0, 6).join(', ')}` : `${D.HKEYS.length} states x ${3 * SR} samples clean`);
  }
}

// ================================================================ T8 parameter bounds
{
  const N = SR / 2, x = sig.noise(N, 0.5); let bad = [];
  for (const k in D.PARAMS) for (const v of [D.PARAMS[k][1], D.PARAMS[k][2], -1e6, 1e6]) {
    const o = D.run({ [k]: v, b_on: 1, a_fb: 1, b_fb: 1 }, x, x, SR);
    for (let ch = 0; ch < 6; ch++) { const st = stats(o[ch]); if (!st.finite || st.peak > 10) bad.push(`${k}=${v} out${ch + 1} peak ${st.peak}`); }
  }
  rec('T8', `every param at min/max/out-of-range (${Object.keys(D.PARAMS).length} params)`, bad.length === 0, bad.length ? bad.slice(0, 4).join('; ') : 'finite and bounded');
}

// ================================================================ T9 sweep rate range matches spec 0.1-18 Hz
{
  const P = D.PARAMS;
  rec('T9', 'Gen rate param range = 0.1-18 Hz (manual spec)', P.g1_rate[1] === 0.1 && P.g1_rate[2] === 18 && P.g2_rate[1] === 0.1 && P.g2_rate[2] === 18,
    `g1 ${P.g1_rate[1]}-${P.g1_rate[2]}, g2 ${P.g2_rate[1]}-${P.g2_rate[2]}`);
  // measured LFO frequency via LED output zero crossings (modern, no lag)
  const meas = (over, secs) => { const N = Math.round(SR * secs), o = D.run({ vintage: 0, a_depth: 1, ...over }, sig.silence(N), sig.silence(N), SR)[4];
    let c = 0; for (let i = SR / 10 + 1; i < N; i++) if ((o[i - 1] - 0.5) < 0 && (o[i] - 0.5) >= 0) c++; return c / (secs - 0.1); };
  const f1 = meas({ g1_rate: 18 }, 2), f2 = meas({ g1_rate: 0.1 }, 40.1), fp0 = meas({ g1_src: 1, pedal: 0 }, 40.1), fp1 = meas({ g1_src: 1, pedal: 1 }, 2);
  rec('T9b', 'measured LFO rate at knob min/max and PED min/max', Math.abs(f1 - 18) < 0.6 && Math.abs(f2 - 0.1) < 0.03 && Math.abs(fp0 - 0.1) < 0.03 && Math.abs(fp1 - 18) < 0.6,
    `knob 18 -> ${f1.toFixed(2)} Hz, knob 0.1 -> ${f2.toFixed(3)} Hz, PED 0 -> ${fp0.toFixed(3)} Hz, PED 1 -> ${fp1.toFixed(2)} Hz`);
}

// ================================================================ T10 routing / output semantics
{
  const N = SR / 2, L = sig.sine(N, 300, 0.4), R = sig.sine(N, 700, 0.4);
  const eq = (a, b) => { let e = 0; for (let i = 0; i < a.length; i++) e = Math.max(e, Math.abs(a[i] - b[i])); return e; };
  const S0 = SR / 10, cut = a => slice(a, S0, N); // routes de-click over ~20 ms: compare after settling
  const r0 = D.run({}, L, R, SR), r1 = D.run({ route: 1 }, L, R, SR), r2 = D.run({ route: 2 }, L, R, SR);
  const ok = eq(cut(r1[0]), cut(L)) < 1e-9 && eq(cut(r1[1]), cut(R)) < 1e-9 && eq(cut(r1[2]), cut(r0[0])) < 1e-9 && stats(cut(r2[0])).peak < 1e-9 && eq(cut(r2[2]), cut(r0[0])) < 1e-9 && stats(cut(r0[2])).peak < 1e-9;
  rec('T10', 'Route: Track / Dry+Bus / Bus-only signal placement', ok, 'route1: track=dry, bus=processed; route2: track silent; route0: bus silent');
  const st = D.run({ vintage: 0, outmode: 0, b_on: 1, b_input: 2, a_depth: 0, b_depth: 0, a_on: 0, insum: 0 }, L, R, SR);
  rec('T10b', 'Out A|B stereo with B Input = IN B keeps channels independent', eq(slice(st[0], SR / 4, N), slice(L, SR / 4, N)) < 1e-6 && stats(slice(st[1], SR / 4, N)).rms > 0.1, 'L = untouched A (off), R = phasor B of right input');
  const s1 = D.run({ vintage: 0, outmode: 1, b_on: 0, b_input: 1, a_depth: 0, insum: 0 }, L, R, SR), s2 = D.run({ vintage: 0, outmode: 2, a_depth: 0, insum: 0 }, L, R, SR);
  rec('T10c', 'Series: Out B (B off) equals Out A', eq(slice(s1[0], SR / 4, N), slice(s2[0], SR / 4, N)) < 1e-6, 'B passes OUT A through when bypassed');
}

// ================================================================ T11 photocell lag asymmetry (vintage) vs modern
{
  const N = SR * 2, z = sig.silence(N);
  const v = D.run({ a_depth: 1, g1_shape: 1, g1_rate: 1 }, z, z, SR)[4], m = D.run({ vintage: 0, a_depth: 1, g1_shape: 1, g1_rate: 1 }, z, z, SR)[4];
  const t = (a, from, thr, up) => { for (let i = from; i < from + SR / 2; i++) if (up ? a[i] > thr : a[i] < thr) return (i - from) / SR * 1000; return 999; };
  const rise = t(v, SR * 1.5, 0.8, true), fall = t(v, SR, 0.1, false);
  rec('T11', 'vintage LAG: cells light faster than they darken', rise < 20 && fall > 40, `rise to 80% ${rise.toFixed(1)} ms, fall to 10% ${fall.toFixed(1)} ms`);
  rec('T11b', 'modern: square sweep settles within 20 ms both ways', t(m, SR * 1.5, 0.95, true) < 20 && t(m, SR, 0.06, false) < 20, `rise ${t(m, SR * 1.5, 0.95, true).toFixed(1)} ms, fall ${t(m, SR, 0.06, false).toFixed(1)} ms`);
}

// ================================================================ T12 clicks on switch changes during playback
{
  const N = SR * 1.2, sw = Math.floor(SR * 0.6), x = sig.sine(N, 220, 0.4);
  const base = { a_depth: 0.6, b_depth: 0.6, b_on: 1, q_noise_p: 0, a_fb: 0.5, b_fb: 0.5 };
  const d2 = a => { const r = new Float64Array(a.length); for (let i = 2; i < a.length; i++) r[i] = Math.abs(a[i] - 2 * a[i - 1] + a[i - 2]); return r; };
  const cases = [['a_on', 0], ['b_on', 0], ['fullwet', 1], ['route', 1], ['outmode', 0], ['outmode', 3], ['b_input', 0], ['b_input', 2], ['a_sweep', 1],
    ['b_sweep', 1], ['b_sweep', 3], ['a_sweep', 2], ['b_sync', 1], ['b_sync', 2], ['env_pol', 1], ['g1_shape', 1], ['insum', 0], ['vintage', 0], ['q_lag_p', 0], ['q_law_p', 0], ['q_rng_p', 0], ['q_mis_p', 0], ['q_clip_p', 0], ['q_lfo_p', 0], ['q_bw_p', 0], ['mixamt', 1]];
  const clicky = [];
  for (const [k, v] of cases) for (const mode of [{}, { vintage: 0 }]) {
    if (k === 'vintage' && mode.vintage === 0) continue;
    const ref = d2(D.run({ ...base, ...mode }, x, x, SR)[0]), out = d2(D.run({ ...base, ...mode }, x, x, SR, [[sw, { [k]: v }]])[0]);
    let refmax = 0; for (let i = sw - SR / 4; i < sw; i++) refmax = Math.max(refmax, ref[i]);
    let swmax = 0; for (let i = sw; i < sw + SR / 50; i++) swmax = Math.max(swmax, out[i]);
    const ratio = swmax / Math.max(refmax, 1e-9);
    if (ratio > 4) clicky.push(`${k}->${v}${mode.vintage === 0 ? ' (modern)' : ''} x${ratio.toFixed(0)}`);
  }
  { // vintage with LAG off: square sweep must not step the filter (baseline drove cells from the unslewed sweep)
    const ref = d2(D.run({ ...base, q_lag_p: 0, g1_shape: 1, g1_rate: 2 }, x, x, SR)[0]); let m = 0, mm = 1e-9;
    const steady = d2(D.run({ ...base, q_lag_p: 0, g1_rate: 2 }, x, x, SR)[0]); for (let i = SR / 4; i < N; i++) { m = Math.max(m, ref[i]); mm = Math.max(mm, steady[i]); }
    if (m / mm > 4) clicky.push(`vintage LAG off + SQR sweep x${(m / mm).toFixed(0)}`);
  }
  rec('T12', `no step discontinuity when switching (${cases.length} switches x 2 modes; threshold 4x steady-state 2nd difference)`, clicky.length === 0, clicky.length ? 'clicks: ' + clicky.join(', ') : 'all smooth');
}

// ================================================================ T13 continuous-control zipper: fast automation
{
  const N = SR * 2, x = sig.sine(N, 220, 0.4), ev = [];
  for (let i = 0; i < 40; i++) ev.push([Math.floor(SR * 0.5 + i * SR / 40), { a_depth: (i % 2), a_fb: (i % 2), mixamt: (i % 2) * 0.8, drive: (i % 2) * 12, outgain: -(i % 2) * 12, pedal: i % 2, env_amt: i % 2, env_att: 1 + 99 * (i % 2), env_rel: 20 + 1980 * (i % 2) }]);
  const o = D.run({ a_sweep: 1, q_noise_p: 0 }, x, x, SR, ev)[0];
  let mx = 0; for (let i = 2; i < N; i++) mx = Math.max(mx, Math.abs(o[i] - 2 * o[i - 1] + o[i - 2]));
  rec('T13', 'square-wave automation of depth/fb/mix/drive/out/pedal/env amt/att/rel at 20 Hz: no steps', mx < 0.02 && stats(o).finite, `max 2nd difference ${mx.toExponential(2)} (a 220 Hz 0.4 sine has ${(0.4 * (2 * Math.PI * 220 / SR) ** 2).toExponential(2)})`);
}

// ================================================================ T14 level change engage vs bypass (report, bounded)
{
  const N = SR * 3, x = sig.noise(N, 0.2), rms = a => stats(slice(a, SR, N)).rms;
  const r = [0, 0.5, 1].map(fb => db(rms(D.run({ a_fb: fb, q_noise_p: 0, outmode: 2 }, x, x, SR)[0]) / rms(x)));
  rec('T14', 'engaged level vs bypass on white noise, fb 0/0.5/1 (bounded to -6..+9 dB)', r.every(v => v > -6 && v < 9), r.map(v => v.toFixed(1) + ' dB').join(' / '));
}

// ================================================================ S1 sprint tests
const R1 = require(path.join(__dirname, 'build', 'rc1_test.js'));
const MAT = require(path.join(__dirname, 'material.js'));
// T15 preset compatibility: every pre-sprint setting renders bit-identically to RC1
{
  const N = SR * 2, x = MAT.dubChord(2), y = MAT.percLoop(2); let worst = 0, n = 0;
  const sets = [];
  for (const as of [0, 1]) for (const bs of [0, 1, 2]) for (const sy of [0, 1]) for (const vin of [0, 1])
    sets.push({ a_sweep: as, b_sweep: bs, b_sync: sy, vintage: vin, b_on: 1, outmode: 0, b_input: 0, g1_rate: 3, g2_rate: 5, a_fb: 0.7, b_fb: 0.7 });
  sets.push({}, { b_on: 1, b_input: 1, outmode: 1 }, { route: 1 }, { fullwet: 1, b_on: 1 });
  for (const c of sets) { const a = D.run(c, x, y, SR), b = R1.run(c, x, y, SR);
    for (let ch = 0; ch < 6; ch++) for (let i = 0; i < N; i++) worst = Math.max(worst, Math.abs(a[ch][i] - b[ch][i])); n++; }
  rec('T15', `preset compatibility: ${n} pre-sprint settings bit-identical to RC1 (all 6 outputs)`, worst === 0, `max difference ${worst}`);
}
// T16 QUAD: B sweep leads A by 90 degrees on Gen 1 (measured on the LED/sweep outputs, modern)
{
  const N = SR * 4, z = sig.silence(N);
  const o = D.run({ vintage: 0, b_on: 1, b_sync: 2, g1_rate: 1, a_depth: 1, b_depth: 1 }, z, z, SR);
  const ph = a => { let re = 0, im = 0; for (let i = SR; i < N; i++) { const w = 2 * Math.PI * 1 * i / SR; re += (a[i] - 0.5) * Math.cos(w); im += (a[i] - 0.5) * Math.sin(w); } return Math.atan2(im, re); };
  let d = (ph(o[4]) - ph(o[5])) * 180 / Math.PI; d = ((d % 360) + 540) % 360 - 180;
  const o2 = D.run({ vintage: 0, b_on: 1, b_sync: 1, g1_rate: 1, a_depth: 1, b_depth: 1 }, z, z, SR);
  let d2 = (ph(o2[4]) - ph(o2[5])) * 180 / Math.PI; d2 = ((d2 % 360) + 540) % 360 - 180;
  rec('T16', 'Sweep Sync QUAD = 90 deg offset; REV still 180 deg', Math.abs(Math.abs(d) - 90) < 3 && Math.abs(Math.abs(d2) - 180) < 3, `QUAD ${d.toFixed(1)} deg, REV ${d2.toFixed(1)} deg`);
}
// T17 envelope sweep: follows input, polarity, amount, attack/release timing
{
  const x = MAT.percLoop(4), N = x.length, ma = []; let e = 0;
  for (let i = 0; i < N; i++) { const v = Math.abs(x[i]); e += (v - e) * (v > e ? 1 - Math.exp(-1 / (0.010 * SR)) : 1 - Math.exp(-1 / (0.25 * SR))); ma.push(Math.sqrt(e)); }
  const corr = (a, b) => { let sa = 0, sb = 0, n = 0; for (let i = SR; i < N; i++) { sa += a[i]; sb += b[i]; n++; } sa /= n; sb /= n; let c = 0, va = 0, vb = 0;
    for (let i = SR; i < N; i++) { c += (a[i] - sa) * (b[i] - sb); va += (a[i] - sa) ** 2; vb += (b[i] - sb) ** 2; } return c / Math.sqrt(va * vb); };
  const base = { vintage: 0, a_sweep: 2, a_depth: 1, env_amt: 0.25 }; // 25 %: follower stays below the full-sweep clamp on this material
  const up = D.run(base, x, x, SR)[4], dn = D.run({ ...base, env_pol: 1 }, x, x, SR)[4], zero = D.run({ ...base, env_amt: 0 }, x, x, SR)[4];
  const cu = corr(up, ma), cd = corr(dn, ma); const zs = stats(slice(zero.map(v => v - zero[SR]), SR, N)).peak;
  rec('T17', 'ENV sweep tracks input envelope; DOWN inverts; amount 0 holds the rest position', cu > 0.9 && cd < -0.9 && zs < 1e-6, `corr UP ${cu.toFixed(3)}, DOWN ${cd.toFixed(3)}, amount-0 movement ${zs.toExponential(1)}`);
  // timing on a tone burst
  const bN = SR * 4, burst = Float64Array.from({ length: bN }, (_, i) => (i >= SR / 2 && i < SR) ? 0.5 * Math.sin(2 * Math.PI * 440 * i / SR) : 0);
  const tm = (att, rel) => { const l = D.run({ vintage: 0, a_sweep: 2, a_depth: 1, env_amt: 0.25, env_att: att, env_rel: rel }, burst, burst, SR)[4];
    const lo = l[SR / 2 - 1], hi = l[SR - 1], span = hi - lo; let r = -1, f = -1;
    for (let i = SR / 2; i < SR; i++) if (r < 0 && l[i] - lo > 0.63 * span) r = (i - SR / 2) / SR * 1000;
    for (let i = SR; i < bN; i++) if (f < 0 && hi - l[i] > 0.63 * span) f = (i - SR) / SR * 1000; return [r, f]; };
  const [r1, f1] = tm(5, 100), [r2, f2] = tm(50, 1000);
  // sweep is proportional to sqrt(envelope), so its 63% release point lands at ~2x the release constant
  rec('T17b', 'ENV attack/release set response time; release 63% point = 2x release setting (sqrt law) within 15%', r2 > 3 * r1 && Math.abs(f1 / 200 - 1) < 0.15 && Math.abs(f2 / 2000 - 1) < 0.15, `att 5/rel 100 -> ${r1.toFixed(1)}/${f1.toFixed(0)} ms; att 50/rel 1000 -> ${r2.toFixed(1)}/${f2.toFixed(0)} ms`);
}

const failed = results.filter(r => r.status === 'FAIL');
console.log(`\n${results.length - failed.length}/${results.length} passed`);
const ji = process.argv.indexOf('--json');
if (ji > 0) fs.writeFileSync(process.argv[ji + 1], JSON.stringify(results, null, 1));
process.exit(failed.length ? 1 : 0);
