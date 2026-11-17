// Relative cost proxy: samples/second of the JS translation, RC1 vs current. NOT a measurement of Max/Live CPU.
const path = require('path');
const S1 = require(path.join(__dirname, 'build', 'dsp_test.js')), R1 = require(path.join(__dirname, 'build', 'rc1_test.js'));
const SR = 48000, N = SR * 10, x = Float64Array.from({ length: N }, (_, i) => 0.3 * Math.sin(i * 0.05));
const cfgs = { 'default (A on)': {}, 'A+B on, fb max': { b_on: 1, a_fb: 1, b_fb: 1 }, 'A+B on ENV (current only)': { b_on: 1, a_sweep: 2, b_sweep: 3 } };
const rows = [];
for (const k in cfgs) for (const [name, M] of [['RC1', R1], ['S1', S1]]) {
  if (name === 'RC1' && k.includes('ENV')) continue;
  M.run(cfgs[k], x.subarray(0, SR), x.subarray(0, SR), SR); // warm-up / JIT
  let best = 1e9; for (let r = 0; r < 3; r++) { const t = process.hrtime.bigint(); M.run(cfgs[k], x, x, SR); best = Math.min(best, Number(process.hrtime.bigint() - t) / 1e9); }
  rows.push({ config: k, build: name, 'x realtime': +(N / SR / best).toFixed(1) });
}
console.table(rows);
