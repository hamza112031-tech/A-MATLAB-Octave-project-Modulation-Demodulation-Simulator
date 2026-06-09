function [data, mod_sig, demod_data] = ASK_signal(data, Ac, fc, bit_rate, fs)

Tb = 1 / bit_rate;               % مدة كل بت
t_bit = 0 : 1/fs : Tb-(1/fs);   % الزمن لكل بت
carrier = Ac * sin(2 * pi * fc * t_bit);  % إشارة الكارير

% 1) ASK Modulation
mod_sig = [];
for i = 1 : length(data)
    if data(i) == 1
        mod_sig = [mod_sig, carrier];              % بت 1 → كارير موجود
    else
        mod_sig = [mod_sig, zeros(1, length(t_bit))];  % بت 0 → صفر
    end
end

% 2) ASK Demodulation
demod_data = zeros(1, length(data));
for i = 1 : length(data)
    start_idx = (i-1) * length(t_bit) + 1;
    end_idx = i * length(t_bit);

    current_bit_sig = mod_sig(start_idx : end_idx);

    correlation = sum(current_bit_sig .* carrier);  % حساب الـ correlation

    if correlation > 0
        demod_data(i) = 1;  % لو الـ correlation موجب → بت 1
    else
        demod_data(i) = 0;  % لو لأ → بت 0
    end
end
end
