function [m, c, mod_sig, demod_sig] = FM_signal(Am, Ac, fm, fc, t, kf)
%% FM_signal - Frequency Modulation & Discriminator Demodulation
%
%  INPUTS:
%   Am  → Message signal amplitude
%   Ac  → Carrier signal amplitude
%   fm  → Message frequency  (Hz)
%   fc  → Carrier frequency  (Hz)  — must satisfy fc >> fm
%   t   → Time vector (s)
%   kf  → Frequency sensitivity (Hz/V)  — controls frequency deviation
%          Deviation Δf = kf * Am
%          Modulation Index β = Δf / fm
%
%  OUTPUTS:
%   m         → Message signal
%   c         → Carrier signal
%   mod_sig   → FM modulated signal
%   demod_sig → Recovered message (FM discriminator method)

%% ── 1) Message Signal ───────────────────────────────────────────────────────
m = Am .* cos(2*pi*fm*t);

%% ── 2) Carrier Signal ───────────────────────────────────────────────────────
c = Ac .* cos(2*pi*fc*t);

%% ── 3) FM Modulation ────────────────────────────────────────────────────────
%   s(t) = Ac * cos(2π·fc·t + β·sin(2π·fm·t))
%   where β = kf/fm  (modulation index)
%
%   NOTE: using sin for the phase integral of cos message is mathematically
%         correct:  ∫cos(2π·fm·t)dt = sin(2π·fm·t)/(2π·fm)
%         We absorb the 1/(2π·fm) factor into kf for simplicity.
beta    = kf / fm;
mod_sig = Ac .* cos(2*pi*fc*t + beta .* sin(2*pi*fm*t));

%% ── 4) FM Demodulation (Instantaneous Frequency Discriminator) ──────────────
%   Method: extract instantaneous phase → differentiate → remove carrier offset
%
%   Step 1 : Compute instantaneous phase using angle(hilbert())  [robust]
%   Step 2 : Unwrap phase to remove ±π discontinuities
%   Step 3 : Differentiate to get instantaneous frequency
%   Step 4 : Subtract carrier frequency offset (fc)
%   Step 5 : Scale and low-pass filter to recover m(t)

% --- Analytic signal via Hilbert transform
analytic   = hilbert(mod_sig);

% --- Instantaneous phase (unwrapped)
inst_phase = unwrap(angle(analytic));

% --- Instantaneous frequency  fi(t) = (1/2π) · d[phase]/dt
dt         = t(2) - t(1);
inst_freq  = [0, diff(inst_phase)] / (2*pi*dt);   % Hz

% --- Remove carrier offset → frequency deviation alone
freq_dev   = inst_freq - fc;

% --- Low-pass filter to remove differentiation noise
%     Cutoff slightly above fm; window ≈ 1 carrier period
win_len    = max(3, round(1/(fc*dt)));
lpf_kernel = ones(1, win_len) / win_len;
demod_raw  = filtfilt(lpf_kernel, 1, freq_dev);

% --- Normalise back to original amplitude
if max(abs(demod_raw)) > 0
    demod_sig = demod_raw * (Am / max(abs(demod_raw)));
else
    demod_sig = demod_raw;
end

end
