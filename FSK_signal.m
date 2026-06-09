function [data, mod_sig, demod_data] = FSK_signal(data, f1, f2, bit_rate, fs)

Tb = 1 / bit_rate;               % مدة كل بت
t_bit = 0 : 1/fs : Tb-(1/fs);   % الزمن لكل بت

carrier1 = sin(2 * pi * f1 * t_bit);  % كارير البت 1
carrier2 = sin(2 * pi * f2 * t_bit);  % كارير البت 0

% 1) FSK Modulation
mod_sig = [];
for i = 1 : length(data)
    if data(i) == 1
        mod_sig = [mod_sig, carrier1];  % بت 1 → تردد f1
    else
        mod_sig = [mod_sig, carrier2];  % بت 0 → تردد f2
    end
end

% 2) FSK Demodulation
demod_data = zeros(1, length(data));
for i = 1 : length(data)
    start_idx = (i-1) * length(t_bit) + 1;
    end_idx = i * length(t_bit);

    current_bit_sig = mod_sig(start_idx : end_idx);

    corr1 = sum(current_bit_sig .* carrier1);  % مقارنة مع كارير 1
    corr2 = sum(current_bit_sig .* carrier2);  % مقارنة مع كارير 2

    if corr1 > corr2
        demod_data(i) = 1;  % لو أقرب لـ f1 → بت 1
    else
        demod_data(i) = 0;  % لو أقرب لـ f2 → بت 0
    end
end
end
