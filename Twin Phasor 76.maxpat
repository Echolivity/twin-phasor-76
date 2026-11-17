{
 "patcher": {
  "fileversion": 1,
  "appversion": {
   "major": 8,
   "minor": 6,
   "revision": 5,
   "architecture": "x64",
   "modernui": 1
  },
  "classnamespace": "box",
  "rect": [
   100.0,
   100.0,
   900.0,
   700.0
  ],
  "openrect": [
   0.0,
   0.0,
   1064,
   169
  ],
  "bglocked": 0,
  "openinpresentation": 1,
  "default_fontface": 0,
  "default_fontname": "Ableton Sans Medium",
  "default_fontsize": 10.0,
  "gridonopen": 1,
  "gridsize": [
   8.0,
   8.0
  ],
  "gridsnaponopen": 1,
  "objectsnaponopen": 1,
  "statusbarvisible": 2,
  "toolbarvisible": 1,
  "lefttoolbarpinned": 0,
  "toptoolbarpinned": 0,
  "righttoolbarpinned": 0,
  "bottomtoolbarpinned": 0,
  "toolbars_unpinned_last_save": 0,
  "tallnewobj": 0,
  "boxanimatetime": 200,
  "enablehscroll": 1,
  "enablevscroll": 1,
  "devicewidth": 1064,
  "description": "Dual 6-stage optical phasor modelled on the 1975 Bi-Phase circuit, with switchable vintage quirks.",
  "digest": "",
  "tags": "",
  "style": "",
  "subpatcher_template": "",
  "autosave": 0,
  "boxes": [
   {
    "box": {
     "id": "obj-1",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 6,
     "patching_rect": [
      30,
      300,
      400,
      22
     ],
     "text": "gen~",
     "outlettype": [
      "signal",
      "signal",
      "signal",
      "signal",
      "signal",
      "signal"
     ],
     "patcher": {
      "fileversion": 1,
      "appversion": {
       "major": 8,
       "minor": 6,
       "revision": 5,
       "architecture": "x64",
       "modernui": 1
      },
      "classnamespace": "dsp.gen",
      "rect": [
       100.0,
       100.0,
       900.0,
       800.0
      ],
      "boxes": [
       {
        "box": {
         "id": "obj-1",
         "maxclass": "codebox",
         "code": "Param g1_rate(0.6, min=0.1, max=18);\nParam g1_shape(0, min=0, max=1);\nParam g1_src(0, min=0, max=1);\nParam g2_rate(3.5, min=0.1, max=18);\nParam g2_shape(0, min=0, max=1);\nParam a_on(1, min=0, max=1);\nParam a_depth(0.8, min=0, max=1);\nParam a_fb(0.35, min=0, max=1);\nParam a_sweep(0, min=0, max=2);\nParam b_on(0, min=0, max=1);\nParam b_depth(0.8, min=0, max=1);\nParam b_fb(0.35, min=0, max=1);\nParam b_sweep(0, min=0, max=3);\nParam b_sync(0, min=0, max=2);\nParam b_input(1, min=0, max=2);\nParam pedal(0.5, min=0, max=1);\nParam mixamt(0.5, min=0, max=1);\nParam fullwet(0, min=0, max=1);\nParam outmode(1, min=0, max=3);\nParam insum(1, min=0, max=1);\nParam drive(0, min=-24, max=24);\nParam outgain(0, min=-24, max=12);\nParam route(0, min=0, max=2);\nParam vintage(1, min=0, max=1);\nParam q_lag_p(1, min=0, max=1);\nParam q_mis_p(1, min=0, max=1);\nParam q_law_p(1, min=0, max=1);\nParam q_rng_p(1, min=0, max=1);\nParam q_clip_p(1, min=0, max=1);\nParam q_noise_p(1, min=0, max=1);\nParam q_hum_p(0, min=0, max=1);\nParam hum_hz(0, min=0, max=1);\nParam q_fade_p(1, min=0, max=1);\nParam q_lfo_p(1, min=0, max=1);\nParam q_bw_p(1, min=0, max=1);\nParam mod_lo(150, min=20, max=2000);\nParam mod_hi(9000, min=500, max=18000);\nParam env_amt(0.5, min=0, max=1);\nParam env_att(10, min=1, max=100);\nParam env_rel(250, min=20, max=2000);\nParam env_pol(0, min=0, max=1);\n\nHistory ph1(0);\nHistory ph2(0);\nHistory ped_s(0);\nHistory mix_s(0);\nHistory da_s(0);\nHistory db_s(0);\nHistory fa_s(0);\nHistory fb_s(0);\nHistory drv_s(0);\nHistory og_s(0);\nHistory lsa(0);\nHistory lsb(0);\nHistory envf(0);\nHistory eamt_s(0);\nHistory hp_xa(0);\nHistory hp_ya(0);\nHistory hp_xb(0);\nHistory hp_yb(0);\nHistory humph(0);\nHistory fb6_a(0);\nHistory fb6_b(0);\nHistory fhx_a(0);\nHistory fhy_a(0);\nHistory fhx_b(0);\nHistory fhy_b(0);\nHistory fbl_a(0);\nHistory fbl_b(0);\nHistory bp_a(0);\nHistory bp_b(0);\nHistory wV(1);\nHistory wbw(1);\nHistory wcl(1);\nHistory wr0(1);\nHistory wr1(0);\nHistory wr2(0);\nHistory wo0(0);\nHistory wo1(1);\nHistory wo2(0);\nHistory wo3(0);\nHistory wi0(0);\nHistory wi1(1);\nHistory wi2(0);\nHistory wV1(1);\nHistory wbw1(1);\nHistory wcl1(1);\nHistory wr0a(1);\nHistory wr1a(0);\nHistory wr2a(0);\nHistory wo0a(0);\nHistory wo1a(1);\nHistory wo2a(0);\nHistory wo3a(0);\nHistory wi0a(0);\nHistory wi1a(1);\nHistory wi2a(0);\nHistory g_a0(0.3);\nHistory x1_a0(0);\nHistory y1_a0(0);\nHistory g_a1(0.3);\nHistory x1_a1(0);\nHistory y1_a1(0);\nHistory g_a2(0.3);\nHistory x1_a2(0);\nHistory y1_a2(0);\nHistory g_a3(0.3);\nHistory x1_a3(0);\nHistory y1_a3(0);\nHistory g_a4(0.3);\nHistory x1_a4(0);\nHistory y1_a4(0);\nHistory g_a5(0.3);\nHistory x1_a5(0);\nHistory y1_a5(0);\nHistory g_b0(0.3);\nHistory x1_b0(0);\nHistory y1_b0(0);\nHistory g_b1(0.3);\nHistory x1_b1(0);\nHistory y1_b1(0);\nHistory g_b2(0.3);\nHistory x1_b2(0);\nHistory y1_b2(0);\nHistory g_b3(0.3);\nHistory x1_b3(0);\nHistory y1_b3(0);\nHistory g_b4(0.3);\nHistory x1_b4(0);\nHistory y1_b4(0);\nHistory g_b5(0.3);\nHistory x1_b5(0);\nHistory y1_b5(0);\n\nsr = samplerate;\nV = vintage > 0.5;\nq_lag = V && (q_lag_p > 0.5);\nq_mis = V && (q_mis_p > 0.5);\nq_law = V && (q_law_p > 0.5);\nq_rng = V && (q_rng_p > 0.5);\nq_clip = V && (q_clip_p > 0.5);\nq_noise = V && (q_noise_p > 0.5);\nq_hum = V && (q_hum_p > 0.5);\nq_fade = V && (q_fade_p > 0.5);\nq_lfo = V && (q_lfo_p > 0.5);\nq_bw = V && (q_bw_p > 0.5);\nqv_lag = q_lag_p > 0.5;\nqv_mis = q_mis_p > 0.5;\nqv_law = q_law_p > 0.5;\nqv_rng = q_rng_p > 0.5;\neff_a0 = 1.1268;\neff_a1 = 0.8224;\nrm_a0 = 0.8939;\ntk_a0 = 1.2140;\nrm_a1 = 1.0751;\ntk_a1 = 0.9358;\nrm_a2 = 0.9501;\ntk_a2 = 1.0376;\nrm_a3 = 1.0085;\ntk_a3 = 1.2199;\nrm_a4 = 1.1165;\ntk_a4 = 1.2027;\nrm_a5 = 1.0731;\ntk_a5 = 0.8604;\neff_b0 = 1.0490;\neff_b1 = 0.9246;\nrm_b0 = 1.0472;\ntk_b0 = 0.8936;\nrm_b1 = 0.9204;\ntk_b1 = 1.0028;\nrm_b2 = 1.1138;\ntk_b2 = 1.1334;\nrm_b3 = 1.0934;\ntk_b3 = 0.7513;\nrm_b4 = 0.9417;\ntk_b4 = 1.0499;\nrm_b5 = 0.9884;\ntk_b5 = 1.0686;\nc_sm  = 1 - exp(-twopi * 15 / sr);\nc_on  = 1 - exp(-1 / (0.004 * sr));\nc_fb  = 1 - exp(-twopi * 18000 / sr);\nc_bon = 1 - exp(-1 / (0.010 * sr));\nc_boff= 1 - exp(-1 / (0.150 * sr));\nc_fast= 1 - exp(-1 / (0.006 * sr));\nc_sw  = 1 - exp(-1 / (0.003 * sr));\nc_ls  = 1 - exp(-1 / (0.003 * sr));\nc_hp  = exp(-twopi * 8.7 / sr);\nc_fhp = exp(-twopi * 34 / sr);\nmix_t = (fullwet > 0.5) ? 1 : mixamt;\nped_s = ped_s + (pedal - ped_s) * c_sm;\nmix_s = mix_s + (mix_t - mix_s) * c_sm;\nda_s = da_s + (a_depth - da_s) * c_sm;\ndb_s = db_s + (b_depth - db_s) * c_sm;\nfa_s = fa_s + (a_fb - fa_s) * c_sm;\nfb_s = fb_s + (b_fb - fb_s) * c_sm;\ndrv_s = drv_s + (dbtoa(drive) - drv_s) * c_sm;\nog_s = og_s + (dbtoa(outgain) - og_s) * c_sm;\nmlo = min(mod_lo, mod_hi * 0.9); mhi = mod_hi;\nwV1 = fixdenorm(wV1 + (V - wV1) * c_sw); wV = fixdenorm(wV + (wV1 - wV) * c_sw);\nwbw1 = fixdenorm(wbw1 + (q_bw - wbw1) * c_sw); wbw = fixdenorm(wbw + (wbw1 - wbw) * c_sw);\nwcl1 = fixdenorm(wcl1 + (q_clip - wcl1) * c_sw); wcl = fixdenorm(wcl + (wcl1 - wcl) * c_sw);\nwr0a = fixdenorm(wr0a + ((abs(route - 0) < 0.5) - wr0a) * c_sw); wr0 = fixdenorm(wr0 + (wr0a - wr0) * c_sw);\nwi0a = fixdenorm(wi0a + ((abs(b_input - 0) < 0.5) - wi0a) * c_sw); wi0 = fixdenorm(wi0 + (wi0a - wi0) * c_sw);\nwr1a = fixdenorm(wr1a + ((abs(route - 1) < 0.5) - wr1a) * c_sw); wr1 = fixdenorm(wr1 + (wr1a - wr1) * c_sw);\nwi1a = fixdenorm(wi1a + ((abs(b_input - 1) < 0.5) - wi1a) * c_sw); wi1 = fixdenorm(wi1 + (wi1a - wi1) * c_sw);\nwr2a = fixdenorm(wr2a + ((abs(route - 2) < 0.5) - wr2a) * c_sw); wr2 = fixdenorm(wr2 + (wr2a - wr2) * c_sw);\nwi2a = fixdenorm(wi2a + ((abs(b_input - 2) < 0.5) - wi2a) * c_sw); wi2 = fixdenorm(wi2 + (wi2a - wi2) * c_sw);\nwo0a = fixdenorm(wo0a + ((abs(outmode - 0) < 0.5) - wo0a) * c_sw); wo0 = fixdenorm(wo0 + (wo0a - wo0) * c_sw);\nwo1a = fixdenorm(wo1a + ((abs(outmode - 1) < 0.5) - wo1a) * c_sw); wo1 = fixdenorm(wo1 + (wo1a - wo1) * c_sw);\nwo2a = fixdenorm(wo2a + ((abs(outmode - 2) < 0.5) - wo2a) * c_sw); wo2 = fixdenorm(wo2 + (wo2a - wo2) * c_sw);\nwo3a = fixdenorm(wo3a + ((abs(outmode - 3) < 0.5) - wo3a) * c_sw); wo3 = fixdenorm(wo3 + (wo3a - wo3) * c_sw);\nr1 = (g1_src > 0.5) ? (0.1 * pow(180, ped_s)) : g1_rate;\nph1 = wrap(ph1 + r1 / sr, 0, 1);\ntri1 = 1 - 4 * abs(ph1 - 0.5);\nsn1 = q_lfo ? (1.5 * tri1 - 0.5 * tri1 * tri1 * tri1) : sin(halfpi * tri1);\nlfo1 = (g1_shape > 0.5) ? ((ph1 < 0.5) ? -1 : 1) : sn1;\nph2 = wrap(ph2 + g2_rate / sr, 0, 1);\ntri2 = 1 - 4 * abs(ph2 - 0.5);\nsn2 = q_lfo ? (1.5 * tri2 - 0.5 * tri2 * tri2 * tri2) : sin(halfpi * tri2);\nlfo2 = (g2_shape > 0.5) ? ((ph2 < 0.5) ? -1 : 1) : sn2;\nph1q = wrap(ph1 + 0.25, 0, 1);\ntri1q = 1 - 4 * abs(ph1q - 0.5);\nsn1q = q_lfo ? (1.5 * tri1q - 0.5 * tri1q * tri1q * tri1q) : sin(halfpi * tri1q);\nlfo1q = (g1_shape > 0.5) ? ((ph1q < 0.5) ? -1 : 1) : sn1q;\ndet = max(abs(in1), abs(in2));\nca = 1 - exp(-1 / (env_att * 0.001 * sr)); cr = 1 - exp(-1 / (env_rel * 0.001 * sr));\nenvf = fixdenorm(envf + (det - envf) * ((det > envf) ? ca : cr));\neamt_s = eamt_s + (env_amt - eamt_s) * c_sm;\nev = clamp(4 * eamt_s * sqrt(envf), 0, 1);\nse = (env_pol > 0.5) ? (1 - 2 * ev) : (2 * ev - 1);\npv = 2 * ped_s - 1;\nsA = (a_sweep < 0.5) ? lfo1 : ((a_sweep < 1.5) ? pv : se);\ng1b = (b_sync > 1.5) ? lfo1q : lfo1;\nsB = (b_sweep < 0.5) ? g1b : ((b_sweep < 1.5) ? lfo2 : ((b_sweep < 2.5) ? pv : se));\nsB = (abs(b_sync - 1) < 0.5) ? -sB : sB;\nlt_a = clamp(0.5 + 0.5 * sA * da_s, 0, 1);\nlt_b = clamp(0.5 + 0.5 * sB * db_s, 0, 1);\nlsa = fixdenorm(lsa + (lt_a - lsa) * c_ls); ls_a = lsa;\nlsb = fixdenorm(lsb + (lt_b - lsb) * c_ls); ls_b = lsb;\nG_a = fa_s * 0.862; G_b = fb_s * 0.862;\nvs = 2 * drv_s;\ninA = ((insum > 0.5) ? 0.5 * (in1 + in2) : in1) * vs;\ninB = in2 * vs;\nhA = fixdenorm(c_hp * (hp_ya + inA - hp_xa)); hp_xa = inA; hp_ya = hA;\nhB = fixdenorm(c_hp * (hp_yb + inB - hp_xb)); hp_xb = inB; hp_yb = hB;\nx_a = inA + wbw * (hA - inA);\n// ===== PHASOR A =====\nI_a = qv_law ? (0.004 + 0.996*ls_a) : (0.004*pow(250, ls_a));\nfm_a = mlo * pow(mhi / mlo, ls_a);\ngt_a = pow(I_a, 0.85);\ngsum_a = 0;\ntg = gt_a * (qv_mis ? eff_a0 : 1);\ng = g_a0;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_a0 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_a0 = g;\ngsum_a = gsum_a + g;\nR = 3300 * (qv_mis ? rm_a0 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_a * pow(max(fv, 1) / fm_a, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_a0 = (t - 1) / (t + 1);\ntg = gt_a * (qv_mis ? eff_a0 : 1);\ng = g_a1;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_a1 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_a1 = g;\ngsum_a = gsum_a + g;\nR = 3300 * (qv_mis ? rm_a1 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_a * pow(max(fv, 1) / fm_a, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_a1 = (t - 1) / (t + 1);\ntg = gt_a * (qv_mis ? eff_a0 : 1);\ng = g_a2;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_a2 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_a2 = g;\ngsum_a = gsum_a + g;\nR = 3300 * (qv_mis ? rm_a2 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_a * pow(max(fv, 1) / fm_a, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_a2 = (t - 1) / (t + 1);\ntg = gt_a * (qv_mis ? eff_a1 : 1);\ng = g_a3;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_a3 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_a3 = g;\ngsum_a = gsum_a + g;\nR = 3300 * (qv_mis ? rm_a3 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_a * pow(max(fv, 1) / fm_a, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_a3 = (t - 1) / (t + 1);\ntg = gt_a * (qv_mis ? eff_a1 : 1);\ng = g_a4;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_a4 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_a4 = g;\ngsum_a = gsum_a + g;\nR = 3300 * (qv_mis ? rm_a4 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_a * pow(max(fv, 1) / fm_a, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_a4 = (t - 1) / (t + 1);\ntg = gt_a * (qv_mis ? eff_a1 : 1);\ng = g_a5;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_a5 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_a5 = g;\ngsum_a = gsum_a + g;\nR = 3300 * (qv_mis ? rm_a5 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_a * pow(max(fv, 1) / fm_a, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_a5 = (t - 1) / (t + 1);\nfhp_a = fixdenorm(c_fhp * (fhy_a + fb6_a - fhx_a)); fhx_a = fb6_a; fhy_a = fhp_a;\nfbl_a = fixdenorm(fbl_a + (fhp_a - fbl_a) * c_fb);\nfbin_a = fhp_a + wbw * (fbl_a - fhp_a);\nu = -x_a + G_a * fbin_a + (q_noise ? noise() * 1.7e-4 : 0);\nu = u + wcl * (13.5 * tanh(u / 13.5) - u);\ny = fixdenorm(k_a0 * u + x1_a0 - k_a0 * y1_a0);\nx1_a0 = u; y1_a0 = y; u = y;\ny = fixdenorm(k_a1 * u + x1_a1 - k_a1 * y1_a1);\nx1_a1 = u; y1_a1 = y; u = y;\ny = fixdenorm(k_a2 * u + x1_a2 - k_a2 * y1_a2);\nx1_a2 = u; y1_a2 = y; u = y;\ny = fixdenorm(k_a3 * u + x1_a3 - k_a3 * y1_a3);\nx1_a3 = u; y1_a3 = y; u = y;\ny = fixdenorm(k_a4 * u + x1_a4 - k_a4 * y1_a4);\nx1_a4 = u; y1_a4 = y; u = y;\ny = fixdenorm(k_a5 * u + x1_a5 - k_a5 * y1_a5);\nx1_a5 = u; y1_a5 = y; u = y;\nfb6_a = u;\nwet_a = -(u + wcl * (13.5 * tanh(u / 13.5) - u));\nbt = a_on;\ncb = q_fade ? ((bt > bp_a) ? c_bon : c_boff) : c_fast;\nbp_a = fixdenorm(bp_a + (bt - bp_a) * cb);\nmm = mix_s;\no_a = x_a * (1 - mm * bp_a) + wet_a * mm * bp_a;\nled_a = (wV * pow(gsum_a / 6, 1.1765) + (1 - wV) * ls_a) * bp_a;\nsrcB = inB + wbw * (hB - inB);\nx_b = wi0 * x_a + wi1 * o_a + wi2 * srcB;\n// ===== PHASOR B =====\nI_b = qv_law ? (0.004 + 0.996*ls_b) : (0.004*pow(250, ls_b));\nfm_b = mlo * pow(mhi / mlo, ls_b);\ngt_b = pow(I_b, 0.85);\ngsum_b = 0;\ntg = gt_b * (qv_mis ? eff_b0 : 1);\ng = g_b0;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_b0 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_b0 = g;\ngsum_b = gsum_b + g;\nR = 3300 * (qv_mis ? rm_b0 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_b * pow(max(fv, 1) / fm_b, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_b0 = (t - 1) / (t + 1);\ntg = gt_b * (qv_mis ? eff_b0 : 1);\ng = g_b1;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_b1 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_b1 = g;\ngsum_b = gsum_b + g;\nR = 3300 * (qv_mis ? rm_b1 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_b * pow(max(fv, 1) / fm_b, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_b1 = (t - 1) / (t + 1);\ntg = gt_b * (qv_mis ? eff_b0 : 1);\ng = g_b2;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_b2 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_b2 = g;\ngsum_b = gsum_b + g;\nR = 3300 * (qv_mis ? rm_b2 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_b * pow(max(fv, 1) / fm_b, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_b2 = (t - 1) / (t + 1);\ntg = gt_b * (qv_mis ? eff_b1 : 1);\ng = g_b3;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_b3 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_b3 = g;\ngsum_b = gsum_b + g;\nR = 3300 * (qv_mis ? rm_b3 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_b * pow(max(fv, 1) / fm_b, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_b3 = (t - 1) / (t + 1);\ntg = gt_b * (qv_mis ? eff_b1 : 1);\ng = g_b4;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_b4 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_b4 = g;\ngsum_b = gsum_b + g;\nR = 3300 * (qv_mis ? rm_b4 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_b * pow(max(fv, 1) / fm_b, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_b4 = (t - 1) / (t + 1);\ntg = gt_b * (qv_mis ? eff_b1 : 1);\ng = g_b5;\ntoff = clamp(0.020 / sqrt(max(g, 0.004)), 0.02, 0.35) * (qv_mis ? tk_b5 : 1);\ncc = (tg > g) ? c_on : (1 - exp(-1 / (toff * sr)));\ng = qv_lag ? (g + (tg - g) * cc) : tg;\ng_b5 = g;\ngsum_b = gsum_b + g;\nR = 3300 * (qv_mis ? rm_b5 : 1) / max(g, 0.0001);\nR = qv_rng ? (R * 220000 / (R + 220000)) : R;\nfv = 1 / (twopi * R * 6.8e-9);\nfc = fm_b * pow(max(fv, 1) / fm_b, wV);\nfc = clamp(fc, 10, sr * 0.45);\nt = tan(pi * fc / sr);\nk_b5 = (t - 1) / (t + 1);\nfhp_b = fixdenorm(c_fhp * (fhy_b + fb6_b - fhx_b)); fhx_b = fb6_b; fhy_b = fhp_b;\nfbl_b = fixdenorm(fbl_b + (fhp_b - fbl_b) * c_fb);\nfbin_b = fhp_b + wbw * (fbl_b - fhp_b);\nu = -x_b + G_b * fbin_b + (q_noise ? noise() * 1.7e-4 : 0);\nu = u + wcl * (13.5 * tanh(u / 13.5) - u);\ny = fixdenorm(k_b0 * u + x1_b0 - k_b0 * y1_b0);\nx1_b0 = u; y1_b0 = y; u = y;\ny = fixdenorm(k_b1 * u + x1_b1 - k_b1 * y1_b1);\nx1_b1 = u; y1_b1 = y; u = y;\ny = fixdenorm(k_b2 * u + x1_b2 - k_b2 * y1_b2);\nx1_b2 = u; y1_b2 = y; u = y;\ny = fixdenorm(k_b3 * u + x1_b3 - k_b3 * y1_b3);\nx1_b3 = u; y1_b3 = y; u = y;\ny = fixdenorm(k_b4 * u + x1_b4 - k_b4 * y1_b4);\nx1_b4 = u; y1_b4 = y; u = y;\ny = fixdenorm(k_b5 * u + x1_b5 - k_b5 * y1_b5);\nx1_b5 = u; y1_b5 = y; u = y;\nfb6_b = u;\nwet_b = -(u + wcl * (13.5 * tanh(u / 13.5) - u));\nbt = b_on;\ncb = q_fade ? ((bt > bp_b) ? c_bon : c_boff) : c_fast;\nbp_b = fixdenorm(bp_b + (bt - bp_b) * cb);\nmm = mix_s;\no_b = x_b * (1 - mm * bp_b) + wet_b * mm * bp_b;\nled_b = (wV * pow(gsum_b / 6, 1.1765) + (1 - wV) * ls_b) * bp_b;\nhz = (hum_hz > 0.5) ? 60 : 50;\nhumph = wrap(humph + hz / sr, 0, 1);\nhum = q_hum ? (2e-4 * sin(twopi * humph) + 6e-5 * sin(3 * twopi * humph)) : 0;\nmono = wo1 * o_b + wo2 * o_a + wo3 * 0.5 * (o_a + o_b);\noL = wo0 * o_a + mono; oR = wo0 * o_b + mono;\nsc = og_s / vs;\npL = (oL + hum) * sc; pR = (oR + hum) * sc;\nout1 = wr0 * pL + wr1 * in1; out2 = wr0 * pR + wr1 * in2;\nout3 = (wr1 + wr2) * pL; out4 = (wr1 + wr2) * pR;\nout5 = led_a;\nout6 = led_b;\n",
         "fontface": 0,
         "fontname": "<Monospaced>",
         "fontsize": 12.0,
         "numinlets": 2,
         "numoutlets": 6,
         "outlettype": [
          "",
          "",
          "",
          "",
          "",
          ""
         ],
         "patching_rect": [
          50.0,
          80.0,
          700.0,
          600.0
         ]
        }
       },
       {
        "box": {
         "id": "obj-2",
         "maxclass": "newobj",
         "text": "in 1",
         "numinlets": 0,
         "numoutlets": 1,
         "outlettype": [
          ""
         ],
         "patching_rect": [
          150.0,
          30.0,
          30.0,
          22.0
         ]
        }
       },
       {
        "box": {
         "id": "obj-3",
         "maxclass": "newobj",
         "text": "in 2",
         "numinlets": 0,
         "numoutlets": 1,
         "outlettype": [
          ""
         ],
         "patching_rect": [
          250.0,
          30.0,
          30.0,
          22.0
         ]
        }
       },
       {
        "box": {
         "id": "obj-4",
         "maxclass": "newobj",
         "text": "out 1",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          140.0,
          700.0,
          37.0,
          22.0
         ]
        }
       },
       {
        "box": {
         "id": "obj-5",
         "maxclass": "newobj",
         "text": "out 2",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          230.0,
          700.0,
          37.0,
          22.0
         ]
        }
       },
       {
        "box": {
         "id": "obj-6",
         "maxclass": "newobj",
         "text": "out 3",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          320.0,
          700.0,
          37.0,
          22.0
         ]
        }
       },
       {
        "box": {
         "id": "obj-7",
         "maxclass": "newobj",
         "text": "out 4",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          410.0,
          700.0,
          37.0,
          22.0
         ]
        }
       },
       {
        "box": {
         "id": "obj-8",
         "maxclass": "newobj",
         "text": "out 5",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          500.0,
          700.0,
          37.0,
          22.0
         ]
        }
       },
       {
        "box": {
         "id": "obj-9",
         "maxclass": "newobj",
         "text": "out 6",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          590.0,
          700.0,
          37.0,
          22.0
         ]
        }
       }
      ],
      "lines": [
       {
        "patchline": {
         "source": [
          "obj-2",
          0
         ],
         "destination": [
          "obj-1",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-3",
          0
         ],
         "destination": [
          "obj-1",
          1
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-1",
          0
         ],
         "destination": [
          "obj-4",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-1",
          1
         ],
         "destination": [
          "obj-5",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-1",
          2
         ],
         "destination": [
          "obj-6",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-1",
          3
         ],
         "destination": [
          "obj-7",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-1",
          4
         ],
         "destination": [
          "obj-8",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-1",
          5
         ],
         "destination": [
          "obj-9",
          0
         ]
        }
       }
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-2",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 2,
     "patching_rect": [
      30,
      250,
      60,
      22
     ],
     "text": "plugin~",
     "outlettype": [
      "signal",
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-3",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 4,
     "numoutlets": 0,
     "patching_rect": [
      30,
      400,
      100,
      22
     ],
     "text": "plugout~ 1 2 3 4"
    }
   },
   {
    "box": {
     "id": "obj-4",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      150,
      400,
      110,
      22
     ],
     "text": "send~ tpx_bus1_L"
    }
   },
   {
    "box": {
     "id": "obj-5",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      270,
      400,
      110,
      22
     ],
     "text": "send~ tpx_bus1_R"
    }
   },
   {
    "box": {
     "id": "obj-6",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      1064,
      169
     ],
     "presentation": 1,
     "presentation_rect": [
      0,
      0,
      1064,
      169
     ],
     "mode": 0,
     "bgcolor": [
      0.788,
      0.792,
      0.8,
      1.0
     ],
     "border": 0,
     "rounded": 0,
     "background": 1,
     "bgfillcolor": {
      "type": "color",
      "color": [
       0.788,
       0.792,
       0.8,
       1.0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-7",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      1058,
      163
     ],
     "presentation": 1,
     "presentation_rect": [
      3,
      3,
      1058,
      163
     ],
     "mode": 0,
     "bgcolor": [
      0.216,
      0.314,
      0.663,
      1.0
     ],
     "border": 0,
     "rounded": 4,
     "background": 1,
     "bgfillcolor": {
      "type": "gradient",
      "color1": [
       0.216,
       0.314,
       0.663,
       1.0
      ],
      "color2": [
       0.239,
       0.345,
       0.698,
       1.0
      ],
      "color": [
       0.216,
       0.314,
       0.663,
       1.0
      ],
      "angle": 0.0,
      "proportion": 0.5,
      "autogradient": 0
     }
    }
   },
   {
    "box": {
     "id": "obj-8",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      112,
      155
     ],
     "presentation": 1,
     "presentation_rect": [
      8,
      7,
      112,
      155
     ],
     "mode": 0,
     "bgcolor": [
      0,
      0,
      0,
      0
     ],
     "border": 1.5,
     "rounded": 8,
     "background": 1,
     "bordercolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0,
       0,
       0,
       0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-9",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "SWEEP GEN 1",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      104,
      14
     ],
     "presentation": 1,
     "presentation_rect": [
      12,
      9,
      104,
      14
     ]
    }
   },
   {
    "box": {
     "id": "obj-10",
     "maxclass": "live.dial",
     "varname": "Gen1 Rate",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      50
     ],
     "presentation": 1,
     "presentation_rect": [
      12,
      22,
      46,
      50
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Gen1 Rate",
       "parameter_shortname": "G1 Rate",
       "parameter_type": 0,
       "parameter_mmin": 0.1,
       "parameter_mmax": 18.0,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0.6
       ],
       "parameter_unitstyle": 3,
       "parameter_exponent": 3.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-11",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      500,
      120,
      22
     ],
     "text": "prepend g1_rate",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-12",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.0,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "SHAPE",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      52,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      62,
      24,
      52,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-13",
     "maxclass": "live.tab",
     "varname": "Gen1 Shape",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "num_lines_patching": 1,
     "num_lines_presentation": 1,
     "patching_rect": [
      700,
      200,
      52,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      62,
      36,
      52,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Gen1 Shape",
       "parameter_shortname": "G1 Shape",
       "parameter_type": 2,
       "parameter_enum": [
        "SINE",
        "SQR"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.604,
      0.62,
      0.639,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.604,
      0.62,
      0.639,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-14",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      526,
      120,
      22
     ],
     "text": "prepend g1_shape",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-15",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.0,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "RATE",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      52,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      62,
      56,
      52,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-16",
     "maxclass": "live.tab",
     "varname": "Gen1 Rate Src",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "num_lines_patching": 1,
     "num_lines_presentation": 1,
     "patching_rect": [
      700,
      200,
      52,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      62,
      68,
      52,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Gen1 Rate Src",
       "parameter_shortname": "G1 Src",
       "parameter_type": 2,
       "parameter_enum": [
        "MAN",
        "PED"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.659,
      0.792,
      0.91,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.659,
      0.792,
      0.91,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-17",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      552,
      120,
      22
     ],
     "text": "prepend g1_src",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-18",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      150,
      155
     ],
     "presentation": 1,
     "presentation_rect": [
      124,
      7,
      150,
      155
     ],
     "mode": 0,
     "bgcolor": [
      0,
      0,
      0,
      0
     ],
     "border": 1.5,
     "rounded": 8,
     "background": 1,
     "bordercolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0,
       0,
       0,
       0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-19",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "PHASOR A",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      142,
      14
     ],
     "presentation": 1,
     "presentation_rect": [
      128,
      9,
      142,
      14
     ]
    }
   },
   {
    "box": {
     "id": "obj-20",
     "maxclass": "live.dial",
     "varname": "A Depth",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      50
     ],
     "presentation": 1,
     "presentation_rect": [
      128,
      22,
      46,
      50
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "A Depth",
       "parameter_shortname": "A Depth",
       "parameter_type": 0,
       "parameter_mmin": 0,
       "parameter_mmax": 100,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        80
       ],
       "parameter_unitstyle": 5,
       "parameter_exponent": 1.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-21",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      500,
      578,
      50,
      22
     ],
     "text": "* 0.01",
     "outlettype": [
      "float"
     ]
    }
   },
   {
    "box": {
     "id": "obj-22",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      578,
      120,
      22
     ],
     "text": "prepend a_depth",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-23",
     "maxclass": "live.dial",
     "varname": "A Feedback",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      50
     ],
     "presentation": 1,
     "presentation_rect": [
      176,
      22,
      46,
      50
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "A Feedback",
       "parameter_shortname": "A Fdbk",
       "parameter_type": 0,
       "parameter_mmin": 0,
       "parameter_mmax": 100,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        35
       ],
       "parameter_unitstyle": 5,
       "parameter_exponent": 1.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-24",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      500,
      604,
      50,
      22
     ],
     "text": "* 0.01",
     "outlettype": [
      "float"
     ]
    }
   },
   {
    "box": {
     "id": "obj-25",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      604,
      120,
      22
     ],
     "text": "prepend a_fb",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-26",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      142,
      30
     ],
     "presentation": 1,
     "presentation_rect": [
      128,
      80,
      142,
      30
     ],
     "mode": 0,
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "border": 0,
     "rounded": 3,
     "background": 1,
     "bgfillcolor": {
      "type": "color",
      "color": [
       0.184,
       0.192,
       0.204,
       1.0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-27",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.0,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "SWEEP",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      138,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      130,
      81,
      138,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-28",
     "maxclass": "live.tab",
     "varname": "A Sweep",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "num_lines_patching": 1,
     "num_lines_presentation": 1,
     "patching_rect": [
      700,
      200,
      134,
      14
     ],
     "presentation": 1,
     "presentation_rect": [
      132,
      93,
      134,
      14
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "A Sweep",
       "parameter_shortname": "A Sweep",
       "parameter_type": 2,
       "parameter_enum": [
        "GEN 1",
        "PED",
        "ENV"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 2,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.659,
      0.792,
      0.91,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.659,
      0.792,
      0.91,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-29",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      630,
      120,
      22
     ],
     "text": "prepend a_sweep",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-30",
     "maxclass": "live.text",
     "varname": "A On",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "PHASOR A",
     "texton": "PHASOR A",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      70,
      20
     ],
     "presentation": 1,
     "presentation_rect": [
      128,
      120,
      70,
      20
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "A On",
       "parameter_shortname": "A On",
       "parameter_type": 2,
       "parameter_enum": [
        "PHASOR A",
        "PHASOR A"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-31",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      656,
      120,
      22
     ],
     "text": "prepend a_on",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-32",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      12,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      206,
      124,
      12,
      12
     ],
     "mode": 0,
     "bgcolor": [
      0.227,
      0.047,
      0.047,
      1.0
     ],
     "border": 1,
     "rounded": 12,
     "background": 1,
     "bordercolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0.227,
       0.047,
       0.047,
       1.0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-33",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      800,
      682,
      80,
      22
     ],
     "text": "snapshot~ 33",
     "outlettype": [
      "float"
     ]
    }
   },
   {
    "box": {
     "id": "obj-34",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 2,
     "patching_rect": [
      890,
      682,
      40,
      22
     ],
     "text": "t f f",
     "outlettype": [
      "float",
      "float"
     ]
    }
   },
   {
    "box": {
     "id": "obj-35",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      940,
      682,
      110,
      22
     ],
     "text": "expr 0.23+0.77*$f1",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-36",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      1060,
      682,
      110,
      22
     ],
     "text": "expr 0.05+0.13*$f1",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-37",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 4,
     "numoutlets": 1,
     "patching_rect": [
      1180,
      682,
      100,
      22
     ],
     "text": "pack 0. 0. 0.04 1.",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-38",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      1290,
      682,
      110,
      22
     ],
     "text": "prepend bgfillcolor",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-39",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "ACTIVE",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      50,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      222,
      124,
      50,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-40",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      214,
      155
     ],
     "presentation": 1,
     "presentation_rect": [
      278,
      7,
      214,
      155
     ],
     "mode": 0,
     "bgcolor": [
      0,
      0,
      0,
      0
     ],
     "border": 1.5,
     "rounded": 8,
     "background": 1,
     "bordercolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0,
       0,
       0,
       0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-41",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "PHASOR B",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      206,
      14
     ],
     "presentation": 1,
     "presentation_rect": [
      282,
      9,
      206,
      14
     ]
    }
   },
   {
    "box": {
     "id": "obj-42",
     "maxclass": "live.dial",
     "varname": "B Depth",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      50
     ],
     "presentation": 1,
     "presentation_rect": [
      282,
      22,
      46,
      50
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "B Depth",
       "parameter_shortname": "B Depth",
       "parameter_type": 0,
       "parameter_mmin": 0,
       "parameter_mmax": 100,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        80
       ],
       "parameter_unitstyle": 5,
       "parameter_exponent": 1.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-43",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      500,
      708,
      50,
      22
     ],
     "text": "* 0.01",
     "outlettype": [
      "float"
     ]
    }
   },
   {
    "box": {
     "id": "obj-44",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      708,
      120,
      22
     ],
     "text": "prepend b_depth",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-45",
     "maxclass": "live.dial",
     "varname": "B Feedback",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      50
     ],
     "presentation": 1,
     "presentation_rect": [
      330,
      22,
      46,
      50
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "B Feedback",
       "parameter_shortname": "B Fdbk",
       "parameter_type": 0,
       "parameter_mmin": 0,
       "parameter_mmax": 100,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        35
       ],
       "parameter_unitstyle": 5,
       "parameter_exponent": 1.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-46",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      500,
      734,
      50,
      22
     ],
     "text": "* 0.01",
     "outlettype": [
      "float"
     ]
    }
   },
   {
    "box": {
     "id": "obj-47",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      734,
      120,
      22
     ],
     "text": "prepend b_fb",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-48",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.0,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "SWEEP SYNC",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      104,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      382,
      22,
      104,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-49",
     "maxclass": "live.tab",
     "varname": "B Sync",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "num_lines_patching": 1,
     "num_lines_presentation": 1,
     "patching_rect": [
      700,
      200,
      104,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      382,
      34,
      104,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "B Sync",
       "parameter_shortname": "B Sync",
       "parameter_type": 2,
       "parameter_enum": [
        "NORM",
        "REV",
        "QUAD"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 2,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.906,
      0.18,
      0.141,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.906,
      0.18,
      0.141,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-50",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      760,
      120,
      22
     ],
     "text": "prepend b_sync",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-51",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      108,
      34
     ],
     "presentation": 1,
     "presentation_rect": [
      380,
      54,
      108,
      34
     ],
     "mode": 0,
     "bgcolor": [
      0,
      0,
      0,
      0
     ],
     "border": 1.5,
     "rounded": 6,
     "background": 1,
     "bordercolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0,
       0,
       0,
       0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-52",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.0,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "PHASOR B INPUT",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      104,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      382,
      55,
      104,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-53",
     "maxclass": "live.tab",
     "varname": "B Input",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "num_lines_patching": 1,
     "num_lines_presentation": 1,
     "patching_rect": [
      700,
      200,
      100,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      384,
      69,
      100,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "B Input",
       "parameter_shortname": "B Input",
       "parameter_type": 2,
       "parameter_enum": [
        "IN A",
        "OUT A",
        "IN B"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 2,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.847,
      0.827,
      0.753,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.847,
      0.827,
      0.753,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-54",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      786,
      120,
      22
     ],
     "text": "prepend b_input",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-55",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      96,
      30
     ],
     "presentation": 1,
     "presentation_rect": [
      282,
      80,
      96,
      30
     ],
     "mode": 0,
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "border": 0,
     "rounded": 3,
     "background": 1,
     "bgfillcolor": {
      "type": "color",
      "color": [
       0.184,
       0.192,
       0.204,
       1.0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-56",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.0,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "SWEEP",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      92,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      284,
      81,
      92,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-57",
     "maxclass": "live.tab",
     "varname": "B Sweep",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "num_lines_patching": 1,
     "num_lines_presentation": 1,
     "patching_rect": [
      700,
      200,
      88,
      14
     ],
     "presentation": 1,
     "presentation_rect": [
      286,
      93,
      88,
      14
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "B Sweep",
       "parameter_shortname": "B Sweep",
       "parameter_type": 2,
       "parameter_enum": [
        "G1",
        "G2",
        "PED",
        "ENV"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 3,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.847,
      0.827,
      0.753,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.847,
      0.827,
      0.753,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-58",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      812,
      120,
      22
     ],
     "text": "prepend b_sweep",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-59",
     "maxclass": "live.text",
     "varname": "B On",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "PHASOR B",
     "texton": "PHASOR B",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      70,
      20
     ],
     "presentation": 1,
     "presentation_rect": [
      282,
      120,
      70,
      20
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "B On",
       "parameter_shortname": "B On",
       "parameter_type": 2,
       "parameter_enum": [
        "PHASOR B",
        "PHASOR B"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-60",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      838,
      120,
      22
     ],
     "text": "prepend b_on",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-61",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      12,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      360,
      124,
      12,
      12
     ],
     "mode": 0,
     "bgcolor": [
      0.227,
      0.047,
      0.047,
      1.0
     ],
     "border": 1,
     "rounded": 12,
     "background": 1,
     "bordercolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0.227,
       0.047,
       0.047,
       1.0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-62",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      800,
      864,
      80,
      22
     ],
     "text": "snapshot~ 33",
     "outlettype": [
      "float"
     ]
    }
   },
   {
    "box": {
     "id": "obj-63",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 2,
     "patching_rect": [
      890,
      864,
      40,
      22
     ],
     "text": "t f f",
     "outlettype": [
      "float",
      "float"
     ]
    }
   },
   {
    "box": {
     "id": "obj-64",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      940,
      864,
      110,
      22
     ],
     "text": "expr 0.23+0.77*$f1",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-65",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      1060,
      864,
      110,
      22
     ],
     "text": "expr 0.05+0.13*$f1",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-66",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 4,
     "numoutlets": 1,
     "patching_rect": [
      1180,
      864,
      100,
      22
     ],
     "text": "pack 0. 0. 0.04 1.",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-67",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      1290,
      864,
      110,
      22
     ],
     "text": "prepend bgfillcolor",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-68",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "ACTIVE",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      50,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      376,
      124,
      50,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-69",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      112,
      155
     ],
     "presentation": 1,
     "presentation_rect": [
      496,
      7,
      112,
      155
     ],
     "mode": 0,
     "bgcolor": [
      0,
      0,
      0,
      0
     ],
     "border": 1.5,
     "rounded": 8,
     "background": 1,
     "bordercolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0,
       0,
       0,
       0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-70",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "SWEEP GEN 2",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      104,
      14
     ],
     "presentation": 1,
     "presentation_rect": [
      500,
      9,
      104,
      14
     ]
    }
   },
   {
    "box": {
     "id": "obj-71",
     "maxclass": "live.dial",
     "varname": "Gen2 Rate",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      50
     ],
     "presentation": 1,
     "presentation_rect": [
      500,
      22,
      46,
      50
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Gen2 Rate",
       "parameter_shortname": "G2 Rate",
       "parameter_type": 0,
       "parameter_mmin": 0.1,
       "parameter_mmax": 18.0,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        3.5
       ],
       "parameter_unitstyle": 3,
       "parameter_exponent": 3.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-72",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      890,
      120,
      22
     ],
     "text": "prepend g2_rate",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-73",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.0,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "SHAPE",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      52,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      550,
      24,
      52,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-74",
     "maxclass": "live.tab",
     "varname": "Gen2 Shape",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "num_lines_patching": 1,
     "num_lines_presentation": 1,
     "patching_rect": [
      700,
      200,
      52,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      550,
      36,
      52,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Gen2 Shape",
       "parameter_shortname": "G2 Shape",
       "parameter_type": 2,
       "parameter_enum": [
        "SINE",
        "SQR"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.604,
      0.62,
      0.639,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.604,
      0.62,
      0.639,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-75",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      916,
      120,
      22
     ],
     "text": "prepend g2_shape",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-76",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      100,
      1
     ],
     "presentation": 1,
     "presentation_rect": [
      502,
      76,
      100,
      1
     ],
     "mode": 0,
     "bgcolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "border": 0,
     "rounded": 0,
     "background": 1,
     "bgfillcolor": {
      "type": "color",
      "color": [
       0.91,
       0.914,
       0.918,
       1.0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-77",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.0,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "ENVELOPE (ENV)",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      104,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      500,
      79,
      104,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-78",
     "maxclass": "live.dial",
     "varname": "Env Amount",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      36,
      44
     ],
     "presentation": 1,
     "presentation_rect": [
      498,
      92,
      36,
      44
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Env Amount",
       "parameter_shortname": "Env Amt",
       "parameter_type": 0,
       "parameter_mmin": 0,
       "parameter_mmax": 100,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        50
       ],
       "parameter_unitstyle": 5,
       "parameter_exponent": 1.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-79",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      500,
      942,
      50,
      22
     ],
     "text": "* 0.01",
     "outlettype": [
      "float"
     ]
    }
   },
   {
    "box": {
     "id": "obj-80",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      942,
      120,
      22
     ],
     "text": "prepend env_amt",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-81",
     "maxclass": "live.dial",
     "varname": "Env Attack",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      36,
      44
     ],
     "presentation": 1,
     "presentation_rect": [
      534,
      92,
      36,
      44
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Env Attack",
       "parameter_shortname": "Env Atk",
       "parameter_type": 0,
       "parameter_mmin": 1,
       "parameter_mmax": 100,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        10
       ],
       "parameter_unitstyle": 2,
       "parameter_exponent": 2.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-82",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      968,
      120,
      22
     ],
     "text": "prepend env_att",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-83",
     "maxclass": "live.dial",
     "varname": "Env Release",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      36,
      44
     ],
     "presentation": 1,
     "presentation_rect": [
      570,
      92,
      36,
      44
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Env Release",
       "parameter_shortname": "Env Rel",
       "parameter_type": 0,
       "parameter_mmin": 20,
       "parameter_mmax": 2000,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        250
       ],
       "parameter_unitstyle": 2,
       "parameter_exponent": 2.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-84",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      994,
      120,
      22
     ],
     "text": "prepend env_rel",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-85",
     "maxclass": "live.tab",
     "varname": "Env Polarity",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "num_lines_patching": 1,
     "num_lines_presentation": 1,
     "patching_rect": [
      700,
      200,
      100,
      14
     ],
     "presentation": 1,
     "presentation_rect": [
      502,
      140,
      100,
      14
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Env Polarity",
       "parameter_shortname": "Env Pol",
       "parameter_type": 2,
       "parameter_enum": [
        "UP",
        "DOWN"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-86",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1020,
      120,
      22
     ],
     "text": "prepend env_pol",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-87",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      62,
      155
     ],
     "presentation": 1,
     "presentation_rect": [
      612,
      7,
      62,
      155
     ],
     "mode": 0,
     "bgcolor": [
      0,
      0,
      0,
      0
     ],
     "border": 1.5,
     "rounded": 8,
     "background": 1,
     "bordercolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0,
       0,
       0,
       0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-88",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "PEDAL",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      54,
      14
     ],
     "presentation": 1,
     "presentation_rect": [
      616,
      9,
      54,
      14
     ]
    }
   },
   {
    "box": {
     "id": "obj-89",
     "maxclass": "live.dial",
     "varname": "Pedal",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      50
     ],
     "presentation": 1,
     "presentation_rect": [
      620,
      22,
      46,
      50
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Pedal",
       "parameter_shortname": "Pedal",
       "parameter_type": 0,
       "parameter_mmin": 0,
       "parameter_mmax": 100,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        50
       ],
       "parameter_unitstyle": 5,
       "parameter_exponent": 1.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-90",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      500,
      1046,
      50,
      22
     ],
     "text": "* 0.01",
     "outlettype": [
      "float"
     ]
    }
   },
   {
    "box": {
     "id": "obj-91",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1046,
      120,
      22
     ],
     "text": "prepend pedal",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-92",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "map to",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      58,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      614,
      76,
      58,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-93",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "expression",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      58,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      614,
      86,
      58,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-94",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      172,
      155
     ],
     "presentation": 1,
     "presentation_rect": [
      678,
      7,
      172,
      155
     ],
     "mode": 0,
     "bgcolor": [
      0,
      0,
      0,
      0
     ],
     "border": 1.5,
     "rounded": 8,
     "background": 1,
     "bordercolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0,
       0,
       0,
       0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-95",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "OUTPUT",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      164,
      14
     ],
     "presentation": 1,
     "presentation_rect": [
      682,
      9,
      164,
      14
     ]
    }
   },
   {
    "box": {
     "id": "obj-96",
     "maxclass": "live.dial",
     "varname": "Mix",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      50
     ],
     "presentation": 1,
     "presentation_rect": [
      682,
      22,
      46,
      50
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Mix",
       "parameter_shortname": "Mix",
       "parameter_type": 0,
       "parameter_mmin": 0,
       "parameter_mmax": 100,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        50
       ],
       "parameter_unitstyle": 5,
       "parameter_exponent": 1.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-97",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      500,
      1072,
      50,
      22
     ],
     "text": "* 0.01",
     "outlettype": [
      "float"
     ]
    }
   },
   {
    "box": {
     "id": "obj-98",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1072,
      120,
      22
     ],
     "text": "prepend mixamt",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-99",
     "maxclass": "live.dial",
     "varname": "Drive",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      50
     ],
     "presentation": 1,
     "presentation_rect": [
      740,
      22,
      46,
      50
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Drive",
       "parameter_shortname": "Drive",
       "parameter_type": 0,
       "parameter_mmin": -24,
       "parameter_mmax": 24,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_unitstyle": 4,
       "parameter_exponent": 1.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-100",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1098,
      120,
      22
     ],
     "text": "prepend drive",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-101",
     "maxclass": "live.dial",
     "varname": "Output",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      50
     ],
     "presentation": 1,
     "presentation_rect": [
      798,
      22,
      46,
      50
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Output",
       "parameter_shortname": "Output",
       "parameter_type": 0,
       "parameter_mmin": -24,
       "parameter_mmax": 12,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_unitstyle": 4,
       "parameter_exponent": 1.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-102",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1124,
      120,
      22
     ],
     "text": "prepend outgain",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-103",
     "maxclass": "live.text",
     "varname": "Full Wet",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "FULL WET",
     "texton": "FULL WET",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      54,
      16
     ],
     "presentation": 1,
     "presentation_rect": [
      682,
      78,
      54,
      16
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Full Wet",
       "parameter_shortname": "FullWet",
       "parameter_type": 2,
       "parameter_enum": [
        "FULL WET",
        "FULL WET"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-104",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1150,
      120,
      22
     ],
     "text": "prepend fullwet",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-105",
     "maxclass": "live.menu",
     "varname": "Out Mode",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      700,
      104,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      740,
      78,
      104,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Out Mode",
       "parameter_shortname": "OutMode",
       "parameter_type": 2,
       "parameter_enum": [
        "Out A | Out B",
        "Out B (mono)",
        "Out A (mono)",
        "A + B (mono)"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 3,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "tricolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-106",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1176,
      120,
      22
     ],
     "text": "prepend outmode",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-107",
     "maxclass": "live.text",
     "varname": "In A Sum",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "IN A = L",
     "texton": "IN A = L+R",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      54,
      16
     ],
     "presentation": 1,
     "presentation_rect": [
      682,
      98,
      54,
      16
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "In A Sum",
       "parameter_shortname": "InSum",
       "parameter_type": 2,
       "parameter_enum": [
        "IN A = L",
        "IN A = L+R"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-108",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1202,
      120,
      22
     ],
     "text": "prepend insum",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-109",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "ROUTE",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      40,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      740,
      98,
      40,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-110",
     "maxclass": "live.menu",
     "varname": "Route",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      700,
      70,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      774,
      98,
      70,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Route",
       "parameter_shortname": "Route",
       "parameter_type": 2,
       "parameter_enum": [
        "Track",
        "Dry + Bus",
        "Bus only"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 2,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "tricolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-111",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1228,
      120,
      22
     ],
     "text": "prepend route",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-112",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "SEND BUS",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      60,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      682,
      120,
      60,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-113",
     "maxclass": "live.menu",
     "varname": "Bus",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      700,
      50,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      740,
      118,
      50,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Bus",
       "parameter_shortname": "Bus",
       "parameter_type": 2,
       "parameter_enum": [
        "Bus 1",
        "Bus 2",
        "Bus 3",
        "Bus 4",
        "Bus 5",
        "Bus 6",
        "Bus 7",
        "Bus 8"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 7,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "tricolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-114",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      150,
      1500,
      40,
      22
     ],
     "text": "+ 1",
     "outlettype": [
      "int"
     ]
    }
   },
   {
    "box": {
     "id": "obj-115",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 2,
     "patching_rect": [
      150,
      1526,
      40,
      22
     ],
     "text": "t i i",
     "outlettype": [
      "int",
      "int"
     ]
    }
   },
   {
    "box": {
     "id": "obj-116",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      150,
      1552,
      130,
      22
     ],
     "text": "sprintf tpx_bus%ld_L",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-117",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      290,
      1552,
      130,
      22
     ],
     "text": "sprintf tpx_bus%ld_R",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-118",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      150,
      1578,
      80,
      22
     ],
     "text": "prepend set",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-119",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      290,
      1578,
      80,
      22
     ],
     "text": "prepend set",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-120",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "+ Out 3/4",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      54,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      794,
      120,
      54,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-121",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.0,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "Other track: Audio From > 3/4",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      164,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      682,
      138,
      164,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-122",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      202,
      155
     ],
     "presentation": 1,
     "presentation_rect": [
      854,
      7,
      202,
      155
     ],
     "mode": 0,
     "bgcolor": [
      0,
      0,
      0,
      0
     ],
     "border": 1.5,
     "rounded": 8,
     "background": 1,
     "bordercolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0,
       0,
       0,
       0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-123",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "CHARACTER",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      194,
      14
     ],
     "presentation": 1,
     "presentation_rect": [
      858,
      9,
      194,
      14
     ]
    }
   },
   {
    "box": {
     "id": "obj-124",
     "maxclass": "live.tab",
     "varname": "Character",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "num_lines_patching": 1,
     "num_lines_presentation": 1,
     "patching_rect": [
      700,
      200,
      190,
      16
     ],
     "presentation": 1,
     "presentation_rect": [
      860,
      22,
      190,
      16
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Character",
       "parameter_shortname": "Character",
       "parameter_type": 2,
       "parameter_enum": [
        "VINTAGE",
        "MODERN"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-125",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1254,
      120,
      22
     ],
     "text": "prepend vintage",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-126",
     "maxclass": "live.text",
     "varname": "Photocell lag",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "LAG",
     "texton": "LAG",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      36,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      860,
      44,
      36,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Photocell lag",
       "parameter_shortname": "LAG",
       "parameter_type": 2,
       "parameter_enum": [
        "LAG",
        "LAG"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-127",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1280,
      120,
      22
     ],
     "text": "prepend q_lag_p",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-128",
     "maxclass": "live.text",
     "varname": "Cell mismatch",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "CELLS",
     "texton": "CELLS",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      36,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      898,
      44,
      36,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Cell mismatch",
       "parameter_shortname": "CELLS",
       "parameter_type": 2,
       "parameter_enum": [
        "CELLS",
        "CELLS"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-129",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1306,
      120,
      22
     ],
     "text": "prepend q_mis_p",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-130",
     "maxclass": "live.text",
     "varname": "LED sweep law",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "LAW",
     "texton": "LAW",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      36,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      936,
      44,
      36,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "LED sweep law",
       "parameter_shortname": "LAW",
       "parameter_type": 2,
       "parameter_enum": [
        "LAW",
        "LAW"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-131",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1332,
      120,
      22
     ],
     "text": "prepend q_law_p",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-132",
     "maxclass": "live.text",
     "varname": "220k range",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "RANGE",
     "texton": "RANGE",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      36,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      974,
      44,
      36,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "220k range",
       "parameter_shortname": "RANGE",
       "parameter_type": 2,
       "parameter_enum": [
        "RANGE",
        "RANGE"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-133",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1358,
      120,
      22
     ],
     "text": "prepend q_rng_p",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-134",
     "maxclass": "live.text",
     "varname": "Op-amp clip",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "CLIP",
     "texton": "CLIP",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      36,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      1012,
      44,
      36,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Op-amp clip",
       "parameter_shortname": "CLIP",
       "parameter_type": 2,
       "parameter_enum": [
        "CLIP",
        "CLIP"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-135",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1384,
      120,
      22
     ],
     "text": "prepend q_clip_p",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-136",
     "maxclass": "live.text",
     "varname": "Hiss",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "HISS",
     "texton": "HISS",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      36,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      860,
      62,
      36,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Hiss",
       "parameter_shortname": "HISS",
       "parameter_type": 2,
       "parameter_enum": [
        "HISS",
        "HISS"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-137",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1410,
      120,
      22
     ],
     "text": "prepend q_noise_p",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-138",
     "maxclass": "live.text",
     "varname": "Mains hum",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "HUM",
     "texton": "HUM",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      36,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      898,
      62,
      36,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Mains hum",
       "parameter_shortname": "HUM",
       "parameter_type": 2,
       "parameter_enum": [
        "HUM",
        "HUM"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-139",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1436,
      120,
      22
     ],
     "text": "prepend q_hum_p",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-140",
     "maxclass": "live.text",
     "varname": "Optical bypass",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "FADE",
     "texton": "FADE",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      36,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      936,
      62,
      36,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Optical bypass",
       "parameter_shortname": "FADE",
       "parameter_type": 2,
       "parameter_enum": [
        "FADE",
        "FADE"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-141",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1462,
      120,
      22
     ],
     "text": "prepend q_fade_p",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-142",
     "maxclass": "live.text",
     "varname": "Shaped tri LFO",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "LFO",
     "texton": "LFO",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      36,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      974,
      62,
      36,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Shaped tri LFO",
       "parameter_shortname": "LFO",
       "parameter_type": 2,
       "parameter_enum": [
        "LFO",
        "LFO"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-143",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1488,
      120,
      22
     ],
     "text": "prepend q_lfo_p",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-144",
     "maxclass": "live.text",
     "varname": "Circuit bandwidth",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "BW",
     "texton": "BW",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5,
     "patching_rect": [
      700,
      1100,
      36,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      1012,
      62,
      36,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Circuit bandwidth",
       "parameter_shortname": "BW",
       "parameter_type": 2,
       "parameter_enum": [
        "BW",
        "BW"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        1
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-145",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1514,
      120,
      22
     ],
     "text": "prepend q_bw_p",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-146",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "HUM Hz",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      40,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      860,
      84,
      40,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-147",
     "maxclass": "live.tab",
     "varname": "Hum Freq",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "num_lines_patching": 1,
     "num_lines_presentation": 1,
     "patching_rect": [
      700,
      200,
      50,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      898,
      82,
      50,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Hum Freq",
       "parameter_shortname": "Hum Hz",
       "parameter_type": 2,
       "parameter_enum": [
        "50",
        "60"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-148",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1540,
      120,
      22
     ],
     "text": "prepend hum_hz",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-149",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "MODERN RANGE",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      96,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      956,
      84,
      96,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-150",
     "maxclass": "live.dial",
     "varname": "Modern Lo",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      48
     ],
     "presentation": 1,
     "presentation_rect": [
      954,
      98,
      46,
      48
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Modern Lo",
       "parameter_shortname": "Mod Lo",
       "parameter_type": 0,
       "parameter_mmin": 20,
       "parameter_mmax": 2000,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        150
       ],
       "parameter_unitstyle": 3,
       "parameter_exponent": 3.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-151",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1566,
      120,
      22
     ],
     "text": "prepend mod_lo",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-152",
     "maxclass": "live.dial",
     "varname": "Modern Hi",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      46,
      48
     ],
     "presentation": 1,
     "presentation_rect": [
      1004,
      98,
      46,
      48
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Modern Hi",
       "parameter_shortname": "Mod Hi",
       "parameter_type": 0,
       "parameter_mmin": 500,
       "parameter_mmax": 18000,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        9000
       ],
       "parameter_unitstyle": 3,
       "parameter_exponent": 3.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-153",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      560,
      1592,
      120,
      22
     ],
     "text": "prepend mod_hi",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-154",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "Vintage: quirks",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      92,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      860,
      104,
      92,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-155",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "on as lit.",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      92,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      860,
      116,
      92,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-156",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "Modern: all off,",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      92,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      860,
      128,
      92,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-157",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "clean + matched.",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      92,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      860,
      140,
      92,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-158",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      440,
      1600,
      40,
      22
     ],
     "text": "!- 1",
     "outlettype": [
      "int"
     ]
    }
   }
  ],
  "lines": [
   {
    "patchline": {
     "source": [
      "obj-2",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-2",
      1
     ],
     "destination": [
      "obj-1",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-1",
      0
     ],
     "destination": [
      "obj-3",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-1",
      1
     ],
     "destination": [
      "obj-3",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-1",
      2
     ],
     "destination": [
      "obj-4",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-1",
      3
     ],
     "destination": [
      "obj-5",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-1",
      2
     ],
     "destination": [
      "obj-3",
      2
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-1",
      3
     ],
     "destination": [
      "obj-3",
      3
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-10",
      0
     ],
     "destination": [
      "obj-11",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-11",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-13",
      0
     ],
     "destination": [
      "obj-14",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-14",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-16",
      0
     ],
     "destination": [
      "obj-17",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-17",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-20",
      0
     ],
     "destination": [
      "obj-21",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-21",
      0
     ],
     "destination": [
      "obj-22",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-22",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-23",
      0
     ],
     "destination": [
      "obj-24",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-24",
      0
     ],
     "destination": [
      "obj-25",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-28",
      0
     ],
     "destination": [
      "obj-29",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-29",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-30",
      0
     ],
     "destination": [
      "obj-31",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-31",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-1",
      4
     ],
     "destination": [
      "obj-33",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-33",
      0
     ],
     "destination": [
      "obj-34",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-34",
      1
     ],
     "destination": [
      "obj-36",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-34",
      0
     ],
     "destination": [
      "obj-35",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-36",
      0
     ],
     "destination": [
      "obj-37",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-35",
      0
     ],
     "destination": [
      "obj-37",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-37",
      0
     ],
     "destination": [
      "obj-38",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-38",
      0
     ],
     "destination": [
      "obj-32",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-42",
      0
     ],
     "destination": [
      "obj-43",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-43",
      0
     ],
     "destination": [
      "obj-44",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-44",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-45",
      0
     ],
     "destination": [
      "obj-46",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-46",
      0
     ],
     "destination": [
      "obj-47",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-47",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-49",
      0
     ],
     "destination": [
      "obj-50",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-50",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-53",
      0
     ],
     "destination": [
      "obj-54",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-54",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-57",
      0
     ],
     "destination": [
      "obj-58",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-58",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-59",
      0
     ],
     "destination": [
      "obj-60",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-60",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-1",
      5
     ],
     "destination": [
      "obj-62",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-62",
      0
     ],
     "destination": [
      "obj-63",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-63",
      1
     ],
     "destination": [
      "obj-65",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-63",
      0
     ],
     "destination": [
      "obj-64",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-65",
      0
     ],
     "destination": [
      "obj-66",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-64",
      0
     ],
     "destination": [
      "obj-66",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-66",
      0
     ],
     "destination": [
      "obj-67",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-67",
      0
     ],
     "destination": [
      "obj-61",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-71",
      0
     ],
     "destination": [
      "obj-72",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-72",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-74",
      0
     ],
     "destination": [
      "obj-75",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-75",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-78",
      0
     ],
     "destination": [
      "obj-79",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-79",
      0
     ],
     "destination": [
      "obj-80",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-80",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-81",
      0
     ],
     "destination": [
      "obj-82",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-82",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-83",
      0
     ],
     "destination": [
      "obj-84",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-84",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-85",
      0
     ],
     "destination": [
      "obj-86",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-86",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-89",
      0
     ],
     "destination": [
      "obj-90",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-90",
      0
     ],
     "destination": [
      "obj-91",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-91",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-96",
      0
     ],
     "destination": [
      "obj-97",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-97",
      0
     ],
     "destination": [
      "obj-98",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-98",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-99",
      0
     ],
     "destination": [
      "obj-100",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-100",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-101",
      0
     ],
     "destination": [
      "obj-102",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-102",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-103",
      0
     ],
     "destination": [
      "obj-104",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-104",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-105",
      0
     ],
     "destination": [
      "obj-106",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-106",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-107",
      0
     ],
     "destination": [
      "obj-108",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-108",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-110",
      0
     ],
     "destination": [
      "obj-111",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-111",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-113",
      0
     ],
     "destination": [
      "obj-114",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-114",
      0
     ],
     "destination": [
      "obj-115",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-115",
      0
     ],
     "destination": [
      "obj-116",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-115",
      1
     ],
     "destination": [
      "obj-117",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-116",
      0
     ],
     "destination": [
      "obj-118",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-117",
      0
     ],
     "destination": [
      "obj-119",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-118",
      0
     ],
     "destination": [
      "obj-4",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-119",
      0
     ],
     "destination": [
      "obj-5",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-158",
      0
     ],
     "destination": [
      "obj-125",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-125",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-126",
      0
     ],
     "destination": [
      "obj-127",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-127",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-128",
      0
     ],
     "destination": [
      "obj-129",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-129",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-130",
      0
     ],
     "destination": [
      "obj-131",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-131",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-132",
      0
     ],
     "destination": [
      "obj-133",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-133",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-134",
      0
     ],
     "destination": [
      "obj-135",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-135",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-136",
      0
     ],
     "destination": [
      "obj-137",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-137",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-138",
      0
     ],
     "destination": [
      "obj-139",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-139",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-140",
      0
     ],
     "destination": [
      "obj-141",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-141",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-142",
      0
     ],
     "destination": [
      "obj-143",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-143",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-144",
      0
     ],
     "destination": [
      "obj-145",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-145",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-147",
      0
     ],
     "destination": [
      "obj-148",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-148",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-150",
      0
     ],
     "destination": [
      "obj-151",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-151",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-152",
      0
     ],
     "destination": [
      "obj-153",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-153",
      0
     ],
     "destination": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-124",
      0
     ],
     "destination": [
      "obj-158",
      0
     ]
    }
   }
  ],
  "dependency_cache": [],
  "latency": 0,
  "project": {
   "version": 1,
   "creationdate": 1763078400,
   "modificationdate": 1763078400,
   "viewrect": [
    0.0,
    0.0,
    300.0,
    500.0
   ],
   "autoorganize": 1,
   "hideprojectwindow": 1,
   "showdependencies": 1,
   "autolocalize": 0,
   "contents": {
    "patchers": {}
   },
   "layout": {},
   "searchpath": {},
   "detailsvisible": 0,
   "amxdtype": 1633771873,
   "readonly": 0,
   "devpathtype": 0,
   "devpath": ".",
   "sortmode": 0,
   "viewmode": 0,
   "includepackages": 0
  },
  "parameters": {
   "obj-10": [
    "Gen1 Rate",
    "G1 Rate",
    0
   ],
   "obj-13": [
    "Gen1 Shape",
    "G1 Shape",
    0
   ],
   "obj-16": [
    "Gen1 Rate Src",
    "G1 Src",
    0
   ],
   "obj-20": [
    "A Depth",
    "A Depth",
    0
   ],
   "obj-23": [
    "A Feedback",
    "A Fdbk",
    0
   ],
   "obj-28": [
    "A Sweep",
    "A Sweep",
    0
   ],
   "obj-30": [
    "A On",
    "A On",
    0
   ],
   "obj-42": [
    "B Depth",
    "B Depth",
    0
   ],
   "obj-45": [
    "B Feedback",
    "B Fdbk",
    0
   ],
   "obj-49": [
    "B Sync",
    "B Sync",
    0
   ],
   "obj-53": [
    "B Input",
    "B Input",
    0
   ],
   "obj-57": [
    "B Sweep",
    "B Sweep",
    0
   ],
   "obj-59": [
    "B On",
    "B On",
    0
   ],
   "obj-71": [
    "Gen2 Rate",
    "G2 Rate",
    0
   ],
   "obj-74": [
    "Gen2 Shape",
    "G2 Shape",
    0
   ],
   "obj-78": [
    "Env Amount",
    "Env Amt",
    0
   ],
   "obj-81": [
    "Env Attack",
    "Env Atk",
    0
   ],
   "obj-83": [
    "Env Release",
    "Env Rel",
    0
   ],
   "obj-85": [
    "Env Polarity",
    "Env Pol",
    0
   ],
   "obj-89": [
    "Pedal",
    "Pedal",
    0
   ],
   "obj-96": [
    "Mix",
    "Mix",
    0
   ],
   "obj-99": [
    "Drive",
    "Drive",
    0
   ],
   "obj-101": [
    "Output",
    "Output",
    0
   ],
   "obj-103": [
    "Full Wet",
    "FullWet",
    0
   ],
   "obj-105": [
    "Out Mode",
    "OutMode",
    0
   ],
   "obj-107": [
    "In A Sum",
    "InSum",
    0
   ],
   "obj-110": [
    "Route",
    "Route",
    0
   ],
   "obj-113": [
    "Bus",
    "Bus",
    0
   ],
   "obj-124": [
    "Character",
    "Character",
    0
   ],
   "obj-126": [
    "Photocell lag",
    "LAG",
    0
   ],
   "obj-128": [
    "Cell mismatch",
    "CELLS",
    0
   ],
   "obj-130": [
    "LED sweep law",
    "LAW",
    0
   ],
   "obj-132": [
    "220k range",
    "RANGE",
    0
   ],
   "obj-134": [
    "Op-amp clip",
    "CLIP",
    0
   ],
   "obj-136": [
    "Hiss",
    "HISS",
    0
   ],
   "obj-138": [
    "Mains hum",
    "HUM",
    0
   ],
   "obj-140": [
    "Optical bypass",
    "FADE",
    0
   ],
   "obj-142": [
    "Shaped tri LFO",
    "LFO",
    0
   ],
   "obj-144": [
    "Circuit bandwidth",
    "BW",
    0
   ],
   "obj-147": [
    "Hum Freq",
    "Hum Hz",
    0
   ],
   "obj-150": [
    "Modern Lo",
    "Mod Lo",
    0
   ],
   "obj-152": [
    "Modern Hi",
    "Mod Hi",
    0
   ],
   "parameterbanks": {
    "0": {
     "index": 0,
     "name": "Perform",
     "parameters": [
      "A Depth",
      "A Feedback",
      "B Depth",
      "B Feedback",
      "Gen1 Rate",
      "Gen2 Rate",
      "Pedal",
      "Mix"
     ]
    },
    "1": {
     "index": 1,
     "name": "Switch",
     "parameters": [
      "A On",
      "B On",
      "Full Wet",
      "A Sweep",
      "B Sweep",
      "B Sync",
      "B Input",
      "Character"
     ]
    },
    "2": {
     "index": 2,
     "name": "Envelope",
     "parameters": [
      "Env Amount",
      "Env Attack",
      "Env Release",
      "Env Polarity",
      "Gen1 Shape",
      "Gen2 Shape",
      "Gen1 Rate Src",
      "Drive"
     ]
    },
    "3": {
     "index": 3,
     "name": "Output",
     "parameters": [
      "Output",
      "Out Mode",
      "In A Sum",
      "Route",
      "Bus",
      "Modern Lo",
      "Modern Hi",
      "Hum Freq"
     ]
    },
    "4": {
     "index": 4,
     "name": "Quirks 1",
     "parameters": [
      "Photocell lag",
      "Cell mismatch",
      "LED sweep law",
      "220k range",
      "Op-amp clip",
      "-",
      "-",
      "-"
     ]
    },
    "5": {
     "index": 5,
     "name": "Quirks 2",
     "parameters": [
      "Hiss",
      "Mains hum",
      "Optical bypass",
      "Shaped tri LFO",
      "Circuit bandwidth",
      "-",
      "-",
      "-"
     ]
    }
   },
   "inherited_shortname": 1
  },
  "assistshowspatchername": 0,
  "is_mpe": 0,
  "external_mpe_tuning_enabled": 0,
  "minimum_live_version": "",
  "minimum_max_version": "",
  "platform_compatibility": 0,
  "openrectmode": 0
 }
}