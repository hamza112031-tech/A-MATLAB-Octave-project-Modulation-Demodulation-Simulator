function [m,c,mod_sig,demod_sig] = FM_signal(Am,Ac,fm,fc,t,kf)
% kf → معامل التحكم في التردد 
m=Am*cos(2*pi*fm*t);  % 1) Message Signal

c=Ac*cos(2*pi*fc*t);  % 2) Carrier Signal

mod_sig =Ac*cos(2*pi*fc*t + kf *sin(2*pi*fm*t));  % 3) FM Modulation
% هنا مش بنغير السعة
% بنغير التردد حسب الرسالة

demod_sig = diff([0 mod_sig]);  % 4) Demodulation (تقريبي)
end