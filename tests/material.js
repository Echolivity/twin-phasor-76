// Deterministic synthetic test material for the four sprint scenarios (48 kHz, mono source, returned as [L, R]).
// Synthetic stand-ins only: they exercise the device realistically but are no substitute for real recordings.
const SR = 48000;
function rng(seed) { let s = seed; return () => { s = (s * 48271) % 2147483647; return s / 2147483647 - 0.5; }; }
const mtof = m => 440 * Math.pow(2, (m - 69) / 12);

// band-limited-ish saw via additive (partials below 12 kHz)
function saw(phase, f) { let v = 0; const K = Math.min(40, Math.floor(12000 / f)); for (let k = 1; k <= K; k++) v += Math.sin(k * phase) / k; return v * 0.55; }

function dubChord(secs = 8) { // Cm9 stab, 120 bpm, each stab with long decaying tail, gentle LPF
  const N = Math.round(SR * secs), x = new Float64Array(N), notes = [48, 55, 58, 62, 63];
  const beat = SR * 0.5;
  for (let t0 = 0; t0 < N; t0 += beat * 2) {
    for (const m of notes) { const f = mtof(m); let ph = 0, lp = 0;
      for (let i = 0; i < SR * 1.6 && t0 + i < N; i++) { ph += 2 * Math.PI * f / SR; const env = Math.exp(-i / (SR * 0.45)) * Math.min(1, i / 120);
        const s = saw(ph, f); lp += (s - lp) * 0.18; x[t0 + i] += 0.075 * env * lp; } }
  }
  return x;
}
function skankOrgan(secs = 8) { // reggae organ "bubble": offbeat chords (Gm), 76 bpm, short gated drawbar tone
  const N = Math.round(SR * secs), x = new Float64Array(N), notes = [55, 58, 62, 67], beat = SR * 60 / 76;
  for (let t0 = beat / 2; t0 < N; t0 += beat) for (const m of notes) { const f = mtof(m);
    for (let i = 0; i < SR * 0.16 && t0 + i < N; i++) { const env = Math.min(1, i / 200) * Math.min(1, (SR * 0.16 - i) / 400);
      const p = 2 * Math.PI * f * i / SR; x[Math.floor(t0) + i] += 0.07 * env * (Math.sin(p) + 0.6 * Math.sin(2 * p) + 0.35 * Math.sin(3 * p) + 0.2 * Math.sin(4 * p)); } }
  return x;
}
function percLoop(secs = 8) { // one-drop: kick+rim on 3, 8th hats, 76 bpm
  const N = Math.round(SR * secs), x = new Float64Array(N), r = rng(11), beat = SR * 60 / 76;
  for (let b = 0; b * beat < N; b++) { const t0 = Math.floor(b * beat), bar = b % 4;
    if (bar === 2) for (let i = 0; i < SR * 0.4 && t0 + i < N; i++) { const e = Math.exp(-i / (SR * 0.08));
      x[t0 + i] += 0.8 * e * Math.sin(2 * Math.PI * (48 + 90 * Math.exp(-i / (SR * 0.012))) * i / SR) + 0.35 * Math.exp(-i / (SR * 0.006)) * Math.sin(2 * Math.PI * 1700 * i / SR); }
    for (const off of [0, 0.5]) { const h = Math.floor(t0 + off * beat); let hp = 0, prev = 0;
      for (let i = 0; i < SR * 0.06 && h + i < N; i++) { const n = r(); hp = 0.9 * (hp + n - prev); prev = n; x[h + i] += 0.25 * Math.exp(-i / (SR * 0.012)) * hp; } }
  }
  return x;
}
function bassLine(secs = 8) { // roots bass: G1-G1-Bb1-D2 pattern, rounded sine+2nd, 76 bpm
  const N = Math.round(SR * secs), x = new Float64Array(N), pat = [43, 43, 46, 50], beat = SR * 60 / 76; let ph = 0;
  for (let n = 0; n < N; n++) { const b = Math.floor(n / beat), pos = (n - b * beat) / beat, f = mtof(pat[b % 4] - 12);
    ph += 2 * Math.PI * f / SR; const env = pos < 0.75 ? Math.min(1, pos * 60) * Math.exp(-pos * 1.2) : Math.max(0, 1 - (pos - 0.75) * 12) * Math.exp(-0.9);
    x[n] = 0.55 * env * (Math.sin(ph) + 0.25 * Math.sin(2 * ph)); }
  return x;
}
module.exports = { SR, dubChord, skankOrgan, percLoop, bassLine };
