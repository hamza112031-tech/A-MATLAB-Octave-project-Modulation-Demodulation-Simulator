function run_simulation(type, params)
% run_simulation - Controller بيشغل أي نوع modulation
%
% Inputs:
%   type   → 'AM' | 'FM' | 'ASK' | 'FSK'
%   params → struct فيه القيم المطلوبة
%
% مثال استخدام:
%   p.Am=1; p.Ac=2; p.fm=5; p.fc=50; p.kf=10;
%   p.data=[1 0 1 1]; p.bit_rate=1; p.f1=50; p.f2=20; p.fs=1000;
%   run_simulation('AM', p)

    figure('Name', ['Modulation: ' type], 'NumberTitle', 'off');

    switch upper(type)

        case 'AM'
            % ── بناء متجه الزمن ──────────────────────────────────────
            fs = params.fs;
            t  = 0 : 1/fs : 1;   % ثانية واحدة (زي ما الزميل عمل)

            % ── استدعاء فنكشن الزميل ─────────────────────────────────
            [m, ~, mod_sig, demod_sig] = AM_signal(params.Am, params.Ac, ...
                                                    params.fm, params.fc, t);
            % ── رسم الإشارات ─────────────────────────────────────────
            plot_signals(t, m, mod_sig, demod_sig, 'AM');

        case 'FM'
            fs = params.fs;
            t  = 0 : 1/fs : 1;

            [m, ~, mod_sig, demod_sig] = FM_signal(params.Am, params.Ac, ...
                                                    params.fm, params.fc, t, params.kf);
            % demod_sig من diff → حجمه أكبر بـ 1، نسوّيه
            if length(demod_sig) > length(t)
                demod_sig = demod_sig(1:length(t));
            end

            plot_signals(t, m, mod_sig, demod_sig, 'FM');

        case 'ASK'
            fs       = params.fs;
            bit_rate = params.bit_rate;
            data     = params.data;

            [data_out, mod_sig, demod_data] = ASK_signal(data, params.Ac, ...
                                                          params.fc, bit_rate, fs);

            % بناء متجه الزمن الكلي
            Tb = 1 / bit_rate;
            t  = 0 : 1/fs : length(data)*Tb - (1/fs);

            % تحويل البيانات لإشارة مستمرة للرسم
            spb      = length(t) / length(data);      % samples per bit
            orig_sig = repelem(data_out,  round(spb));
            dem_sig  = repelem(demod_data, round(spb));

            % ضمان تساوي الطول
            L = min([length(t), length(mod_sig), length(orig_sig), length(dem_sig)]);
            plot_signals(t(1:L), orig_sig(1:L), mod_sig(1:L), dem_sig(1:L), 'ASK');

        case 'FSK'
            fs       = params.fs;
            bit_rate = params.bit_rate;
            data     = params.data;

            [data_out, mod_sig, demod_data] = FSK_signal(data, params.f1, ...
                                                          params.f2, bit_rate, fs);

            Tb  = 1 / bit_rate;
            t   = 0 : 1/fs : length(data)*Tb - (1/fs);

            spb      = length(t) / length(data);
            orig_sig = repelem(data_out,   round(spb));
            dem_sig  = repelem(demod_data, round(spb));

            L = min([length(t), length(mod_sig), length(orig_sig), length(dem_sig)]);
            plot_signals(t(1:L), orig_sig(1:L), mod_sig(1:L), dem_sig(1:L), 'FSK');

        otherwise
            error('نوع مجهول: %s  |  استخدم AM أو FM أو ASK أو FSK', type);
    end
end

% ═══════════════════════════════════════════════════════════════
%  الـ Plot الموحد — كل الأنواع بتستخدمه
% ═══════════════════════════════════════════════════════════════
function plot_signals(t, original, modulated, demodulated, type_label)

    subplot(3,1,1)
    plot(t, original, 'b', 'LineWidth', 1.5)
    title(['[' type_label ']  Original Signal'])
    xlabel('Time (s)');  ylabel('Amplitude')
    grid on

    subplot(3,1,2)
    plot(t, modulated, 'r', 'LineWidth', 1.5)
    title(['[' type_label ']  Modulated Signal'])
    xlabel('Time (s)');  ylabel('Amplitude')
    grid on

    subplot(3,1,3)
    plot(t, demodulated, 'g', 'LineWidth', 1.5)
    title(['[' type_label ']  Demodulated Signal'])
    xlabel('Time (s)');  ylabel('Amplitude')
    grid on

    sgtitle([type_label '  Modulation & Demodulation'], ...
            'FontSize', 14, 'FontWeight', 'bold')
end
