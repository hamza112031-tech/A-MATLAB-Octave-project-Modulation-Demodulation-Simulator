function [m, c, mod_sig, demod_sig] = AM_signal(Am, Ac, fm, fc, t)
%% AM_signal - Amplitude Modulation & Envelope Demodulation
%
%  INPUTS:
%   Am  → Message signal amplitude
%   Ac  → Carrier signal amplitude
%   fm  → Message frequency  (Hz)
%   fc  → Carrier frequency  (Hz)  — must satisfy fc >> fm
%   t   → Time vector (s)
%
%  OUTPUTS:
%   m         → Message signal
%   c         → Carrier signal
%   mod_sig   → AM modulated signal
%   demod_sig → Recovered message (after envelope detection + LPF)

%% ── 1) Message Signal ───────────────────────────────────────────────────────
m = Am .* cos(2*pi*fm*t);

%% ── 2) Carrier Signal ───────────────────────────────────────────────────────
c = Ac .* cos(2*pi*fc*t);

%% ── 3) AM Modulation ────────────────────────────────────────────────────────
%   s(t) = [Ac + m(t)] * cos(2π·fc·t)
%   Modulation Index μ = Am/Ac  (must be ≤ 1 to avoid over-modulation)
mod_sig = (Ac + m) .* cos(2*pi*fc*t);

%% ── 4) Envelope Demodulation ────────────────────────────────────────────────
%   Step 1 : Full-wave rectifier  → |s(t)|
%   Step 2 : Low-pass filter (moving average) to smooth out carrier ripple
%   Step 3 : Remove DC offset (Ac) so we recover m(t) cleanly

% --- Rectify
rect = abs(mod_sig);

% --- Low-pass filter: window length ≈ one carrier period
dt        = t(2) - t(1);          % sampling interval
win_len   = max(3, round(1/(fc*dt)));   % samples per carrier cycle
lpf_kernel = ones(1, win_len) / win_len;
smoothed  = filtfilt(lpf_kernel, 1, rect);  % zero-phase filter (no delay)

% --- Remove DC offset and normalise amplitude back to original
demod_sig = smoothed - mean(smoothed);
if max(abs(demod_sig)) > 0
    demod_sig = demod_sig * (Am / max(abs(demod_sig)));
end

end
