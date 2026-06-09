function [m, c, mod_sig, demod_sig] = AM_signal(Am, Ac, fm, fc, t)

m = Am * cos(2*pi*fm*t);
c = Ac * cos(2*pi*fc*t);
mod_sig = (Ac + m) .* cos(2*pi*fc*t);
demod_sig = abs(mod_sig);
end



%function [m, c, mod_sig, demod_sig] = AM_signal(Am, Ac, fm, fc, t)

%% Am → سعة الرسالة
%% Ac → سعة الكارير
%% fm → تردد الرسالة
%% fc → تردد الكارير
%% t  → الزمن

%% 1) Generate Message Signal
%%%%%%%%%%%%%%m = Am * cos(2*pi*fm*t); 
%% دي الإشارة الأصلية (بطيئة)

%% 2) Generate Carrier Signal
%%%%%%%%%%%%%c = Ac * cos(2*pi*fc*t); 
%% دي الإشارة السريعة اللي هتشيل الرسالة

%% 3) AM Modulation
%%%%%%%%%%%%%mod_sig = (Ac + m) .* cos(2*pi*fc*t);
%% هنا السعة بتتغير حسب الرسالة
%% .* معناها ضرب عنصر بعنصر (مهم جدًا)

%% 4) Demodulation
%%%%%%%%%%%demod_sig = abs(mod_sig);
%% بنطلع envelope (شكل الرسالة)

%%%%%%%%%%%%end