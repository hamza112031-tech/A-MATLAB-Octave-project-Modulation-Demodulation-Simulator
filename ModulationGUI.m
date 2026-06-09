function ModulationGUI()
    % ══════════════════════════════════════════════════════════
    %   CYBERPUNK OSCILLOSCOPE  —  Color Palette
    % ══════════════════════════════════════════════════════════
    BG_DARK  = [0.02 0.02 0.04];   % void black
    BG_CTRL  = [0.03 0.04 0.07];   % deep navy
    BG_FIELD = [0.05 0.07 0.13];   % midnight blue
    BG_AXES  = [0.01 0.02 0.05];   % CRT phosphor bg
    ACCENT   = [0.00 0.95 1.00];   % electric cyan
    ACCENT2  = [1.00 0.15 0.55];   % hot magenta
    GREEN    = [0.05 1.00 0.60];   % phosphor green
    TXT_W    = [0.92 0.96 1.00];
    TXT_DIM  = [0.35 0.50 0.65];
    GOLD     = [1.00 0.85 0.10];
    ORANGE   = [1.00 0.55 0.05];
    C1 = [0.00 0.95 1.00];        % cyan
    C2 = [1.00 0.15 0.55];        % magenta
    C3 = [0.05 1.00 0.60];        % green

    scr = get(0,'ScreenSize');
    W = 1380; H = 840;
    fig = figure('Name','Modulation & Demodulation — IT 103', ...
                 'NumberTitle','off', ...
                 'Position',[(scr(3)-W)/2 (scr(4)-H)/2 W H], ...
                 'Resize','off', ...
                 'Color',BG_DARK, ...
                 'MenuBar','none','ToolBar','none');

    % ══════════════════════════════════════════════════════════
    %   HEADER BAR  (10% height)
    % ══════════════════════════════════════════════════════════
    HBAR = 0.10;
    HBG  = [0.02 0.03 0.07];

    % Solid header background
    annotation(fig,'rectangle',[0 1-HBAR 1 HBAR], ...
               'FaceColor',HBG,'EdgeColor','none');

    % Glowing top border (thick cyan line + thin magenta accent)
    annotation(fig,'line',[0 1],[1-HBAR+0.003 1-HBAR+0.003], ...
               'Color',ACCENT,'LineWidth',3.5);
    annotation(fig,'line',[0 1],[1-HBAR 1-HBAR], ...
               'Color',ACCENT2,'LineWidth',1.5);
    annotation(fig,'line',[0 1],[1-HBAR-0.003 1-HBAR-0.003], ...
               'Color',ACCENT.*0.30,'LineWidth',0.8);

    % Left corner bracket decoration  ⌐■_■¬
    annotation(fig,'rectangle',[0.008 1-HBAR+0.015 0.004 0.060], ...
               'FaceColor',ACCENT,'EdgeColor','none');
    annotation(fig,'rectangle',[0.008 1-HBAR+0.015 0.040 0.005], ...
               'FaceColor',ACCENT,'EdgeColor','none');
    annotation(fig,'rectangle',[0.008 1-0.015 0.040 0.005], ...
               'FaceColor',ACCENT,'EdgeColor','none');

    % Course badge  [ IT-103 ]
    annotation(fig,'rectangle',[0.055 1-HBAR+0.020 0.072 0.060], ...
               'FaceColor',[0.00 0.18 0.22],'EdgeColor',GOLD,'LineWidth',1.2);
    uicontrol('Parent',fig,'Style','text','String','IT-103', ...
              'Units','normalized','Position',[0.056 1-HBAR+0.030 0.070 0.042], ...
              'HorizontalAlignment','center','FontSize',10,'FontWeight','bold', ...
              'ForegroundColor',GOLD,'BackgroundColor',[0.00 0.18 0.22]);

    % Main title
    uicontrol('Parent',fig,'Style','text', ...
              'String','MODULATION  &  DEMODULATION  SIMULATOR', ...
              'Units','normalized','Position',[0.138 1-HBAR+0.028 0.540 0.055], ...
              'HorizontalAlignment','left','FontSize',14,'FontWeight','bold', ...
              'ForegroundColor',ACCENT,'BackgroundColor',HBG);

    % Subtitle tagline
    uicontrol('Parent',fig,'Style','text', ...
              'String','SIGNALS  ·  SYSTEMS  ·  COMMUNICATIONS', ...
              'Units','normalized','Position',[0.140 1-HBAR+0.010 0.380 0.022], ...
              'HorizontalAlignment','left','FontSize',7.5,'FontWeight','bold', ...
              'ForegroundColor',TXT_DIM,'BackgroundColor',HBG);

    % Right side — decorative hex pattern (3 diamonds)
    for di = 1:3
        dxc = 0.640 + (di-1)*0.020;
        annotation(fig,'rectangle',[dxc 1-HBAR+0.035 0.010 0.030], ...
                   'FaceColor',[0.00 0.30 0.35],'EdgeColor',ACCENT.*0.50,'LineWidth',0.6);
    end

    % ── TYPE selector label + dropdown ──
    uicontrol('Parent',fig,'Style','text','String','◈  MODULATION TYPE', ...
              'Units','normalized','Position',[0.695 1-HBAR+0.065 0.180 0.020], ...
              'HorizontalAlignment','left','FontSize',7.5,'FontWeight','bold', ...
              'ForegroundColor',ACCENT.*0.75,'BackgroundColor',HBG);
    annotation(fig,'rectangle',[0.692 1-HBAR+0.008 0.218 0.060], ...
               'FaceColor',[0.02 0.08 0.14],'EdgeColor',ACCENT.*0.40,'LineWidth',0.8);
    hType = uicontrol('Parent',fig,'Style','popupmenu', ...
              'String',{'AM — Amplitude Modulation', ...
                        'FM — Frequency Modulation', ...
                        'ASK — Amplitude Shift Keying', ...
                        'FSK — Frequency Shift Keying'}, ...
              'Units','normalized','Position',[0.694 1-HBAR+0.014 0.214 0.048], ...
              'BackgroundColor',[0.02 0.08 0.14],'ForegroundColor',ACCENT, ...
              'FontSize',9,'Callback',@onTypeChange);

    % ── STATUS indicator ──
    annotation(fig,'rectangle',[0.916 1-HBAR+0.010 0.076 0.078], ...
               'FaceColor',[0.02 0.07 0.05],'EdgeColor',GREEN.*0.55,'LineWidth',1.0);
    hStatus = uicontrol('Parent',fig,'Style','text','String',sprintf('●\nREADY'), ...
              'Units','normalized','Position',[0.917 1-HBAR+0.012 0.074 0.074], ...
              'HorizontalAlignment','center','FontSize',8,'FontWeight','bold', ...
              'ForegroundColor',GREEN,'BackgroundColor',[0.02 0.07 0.05]);

    % ══════════════════════════════════════════════════════════
    %   PARAMETERS PANEL  (22% height at bottom)
    % ══════════════════════════════════════════════════════════
    HBOTTOM = 0.22;

    annotation(fig,'rectangle',[0 0 1 HBOTTOM], ...
               'FaceColor',BG_CTRL,'EdgeColor','none');
    % Top border of param panel
    annotation(fig,'line',[0 1],[HBOTTOM+0.003 HBOTTOM+0.003], ...
               'Color',ACCENT,'LineWidth',2.5);
    annotation(fig,'line',[0 1],[HBOTTOM HBOTTOM], ...
               'Color',ACCENT2,'LineWidth',1.2);

    % Panel label (top-left of param bar)
    annotation(fig,'rectangle',[0.010 HBOTTOM+0.004 0.100 0.022], ...
               'FaceColor',BG_CTRL,'EdgeColor',ACCENT.*0.45,'LineWidth',0.7);
    uicontrol('Parent',fig,'Style','text','String','⊞  PARAMETERS', ...
              'Units','normalized','Position',[0.011 HBOTTOM+0.005 0.098 0.020], ...
              'HorizontalAlignment','center','FontSize',7.5,'FontWeight','bold', ...
              'ForegroundColor',ACCENT.*0.85,'BackgroundColor',BG_CTRL);

    % Scan-line effect strips across param area (subtle horizontal lines)
    for sl = 1:6
        ys = 0.005 + (sl-1)*0.033;
        annotation(fig,'line',[0 1],[ys ys],'Color',[0.10 0.20 0.30],'LineWidth',0.4);
    end

    % ══════════════════════════════════════════════════════════
    %   PLOT AREA  axes
    % ══════════════════════════════════════════════════════════
    TOP    = 1 - HBAR - 0.012;
    BOTTOM = HBOTTOM + 0.030;
    AVAIL  = TOP - BOTTOM;
    GAP_AX = 0.014;
    AH     = (AVAIL - 2*GAP_AX) / 3;
    AX     = 0.048;
    AW     = 0.938;

    Y3 = BOTTOM;
    Y2 = Y3 + AH + GAP_AX;
    Y1 = Y2 + AH + GAP_AX;

    % CRT-style glow border behind each axes
    glowAlpha = 0.18;
    for yi = [Y1 Y2 Y3]
        cols = {C1, C2, C3};
        idx  = find([Y1 Y2 Y3] == yi);
        gc   = cols{idx};
        annotation(fig,'rectangle',[AX-0.006 yi-0.005 AW+0.012 AH+0.010], ...
                   'FaceColor','none','EdgeColor',gc.*glowAlpha+(1-glowAlpha)*BG_DARK, ...
                   'LineWidth',4.0);
        annotation(fig,'rectangle',[AX-0.003 yi-0.003 AW+0.006 AH+0.006], ...
                   'FaceColor','none','EdgeColor',gc.*0.40,'LineWidth',1.5);
    end

    axProps = {'Color',BG_AXES,'FontSize',8,'Box','on','LineWidth',1.0, ...
               'GridAlpha',0.5,'TickDir','in'};

    ax1 = axes('Parent',fig,'Position',[AX Y1 AW AH], axProps{:}, ...
               'XColor',C1.*0.50,'YColor',C1.*0.50,'GridColor',C1.*0.15, ...
               'MinorGridColor',C1.*0.08);
    ax2 = axes('Parent',fig,'Position',[AX Y2 AW AH], axProps{:}, ...
               'XColor',C2.*0.50,'YColor',C2.*0.50,'GridColor',C2.*0.15, ...
               'MinorGridColor',C2.*0.08);
    ax3 = axes('Parent',fig,'Position',[AX Y3 AW AH], axProps{:}, ...
               'XColor',C3.*0.50,'YColor',C3.*0.50,'GridColor',C3.*0.15, ...
               'MinorGridColor',C3.*0.08);

    % Channel label tabs (left side of each plot)
    LBL_H = 0.024; LBL_W = 0.185;
    CHIP_W = 0.018;

    % CH-1 tab
    annotation(fig,'rectangle',[AX AX+Y1+AH-LBL_H-0.001 CHIP_W LBL_H], ...
               'FaceColor',C1,'EdgeColor','none');
    ax1lbl = annotation(fig,'textbox',[AX+CHIP_W Y1+AH-LBL_H LBL_W-CHIP_W LBL_H], ...
               'String','  CH-1  ORIGINAL SIGNAL', ...
               'Color',C1,'BackgroundColor',C1.*0.08+BG_DARK.*0.92, ...
               'EdgeColor',C1.*0.40,'LineWidth',0.8, ...
               'FontSize',7.5,'FontWeight','bold','FitBoxToText','off');
    % CH-2 tab
    annotation(fig,'rectangle',[AX AX+Y2+AH-LBL_H-0.001 CHIP_W LBL_H], ...
               'FaceColor',C2,'EdgeColor','none');
    ax2lbl = annotation(fig,'textbox',[AX+CHIP_W Y2+AH-LBL_H LBL_W-CHIP_W LBL_H], ...
               'String','  CH-2  MODULATED SIGNAL', ...
               'Color',C2,'BackgroundColor',C2.*0.08+BG_DARK.*0.92, ...
               'EdgeColor',C2.*0.40,'LineWidth',0.8, ...
               'FontSize',7.5,'FontWeight','bold','FitBoxToText','off');
    % CH-3 tab
    annotation(fig,'rectangle',[AX AX+Y3+AH-LBL_H-0.001 CHIP_W LBL_H], ...
               'FaceColor',C3,'EdgeColor','none');
    ax3lbl = annotation(fig,'textbox',[AX+CHIP_W Y3+AH-LBL_H LBL_W-CHIP_W LBL_H], ...
               'String','  CH-3  DEMODULATED SIGNAL', ...
               'Color',C3,'BackgroundColor',C3.*0.08+BG_DARK.*0.92, ...
               'EdgeColor',C3.*0.40,'LineWidth',0.8, ...
               'FontSize',7.5,'FontWeight','bold','FitBoxToText','off');

    % Right-side channel numbering chips
    for ci = 1:3
        yci = [Y1 Y2 Y3]; cc = {C1,C2,C3};
        annotation(fig,'rectangle',[AX+AW-0.028 yci(ci)+AH-LBL_H 0.028 LBL_H], ...
                   'FaceColor',cc{ci}.*0.15+BG_DARK.*0.85,'EdgeColor',cc{ci}.*0.50,'LineWidth',0.8);
    end
    for ci = 1:3
        yci = [Y1 Y2 Y3]; cc = {C1,C2,C3}; lstr = {'01','02','03'};
        uicontrol('Parent',fig,'Style','text','String',lstr{ci}, ...
                  'Units','normalized','Position',[AX+AW-0.027 yci(ci)+AH-LBL_H 0.026 LBL_H], ...
                  'HorizontalAlignment','center','FontSize',8,'FontWeight','bold', ...
                  'ForegroundColor',cc{ci},'BackgroundColor',cc{ci}.*0.15+BG_DARK.*0.85);
    end

    % ══════════════════════════════════════════════════════════
    %   SPINNER CONFIG  (mn=min, mx=max, stp=step, dec=decimals)
    %   spinCfg{i} = [mn  mx  stp  dec]
    % ══════════════════════════════════════════════════════════
    %             Am     Ac     fm    fc    kf    BitR   f1    f2     fs
    spinMn  = [0.1,   0.1,   1,    1,    1,    0.5,  1,    1,    100 ];
    spinMx  = [10,    10,    200,  500,  100,  20,   500,  500,  5000];
    spinStp = [0.1,   0.1,   1,    1,    1,    0.5,  1,    1,    100 ];
    spinDec = [1,     1,     0,    0,    0,    1,    0,    0,    0   ];

    % ── addSpinner: edit + ▲▼ buttons + scroll-wheel ──────────
    function h = addSpinner(lbl, def, xp, wp, idx)
        YL = 0.158;   % label Y
        YE = 0.074;   % edit Y
        BH = 0.028;   % button height (each)
        BW = 0.018;   % button width
        EH = 0.060;   % edit height

        % Outer glow frame
        annotation(fig,'rectangle',[xp-0.003 YE-0.006 wp+BW+0.009 EH+0.015], ...
                   'FaceColor','none','EdgeColor',ACCENT.*0.20,'LineWidth',2.5);
        % Inner field border
        annotation(fig,'rectangle',[xp-0.002 YE-0.004 wp+BW+0.007 EH+0.012], ...
                   'FaceColor',[0.03 0.06 0.12],'EdgeColor',ACCENT.*0.45,'LineWidth',0.9);

        % Label
        uicontrol('Parent',fig,'Style','text','String',lbl, ...
                  'Units','normalized','Position',[xp YL wp+BW 0.020], ...
                  'HorizontalAlignment','left','ForegroundColor',TXT_DIM, ...
                  'BackgroundColor',BG_CTRL,'FontSize',7.5);

        % Edit box
        h = uicontrol('Parent',fig,'Style','edit','String',def, ...
                      'Units','normalized', ...
                      'Position',[xp YE wp EH], ...
                      'BackgroundColor',[0.03 0.06 0.12],'ForegroundColor',ACCENT, ...
                      'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');

        % ▲ UP button
        uicontrol('Parent',fig,'Style','pushbutton','String','▲', ...
                  'Units','normalized', ...
                  'Position',[xp+wp+0.001, YE+BH+0.002, BW, BH], ...
                  'BackgroundColor',[0.04 0.10 0.18], ...
                  'ForegroundColor',ACCENT, ...
                  'FontSize',8,'FontWeight','bold', ...
                  'Callback',@(~,~) stepVal(h, idx, +1));

        % ▼ DOWN button
        uicontrol('Parent',fig,'Style','pushbutton','String','▼', ...
                  'Units','normalized', ...
                  'Position',[xp+wp+0.001, YE+0.001, BW, BH], ...
                  'BackgroundColor',[0.04 0.10 0.18], ...
                  'ForegroundColor',ACCENT2, ...
                  'FontSize',8,'FontWeight','bold', ...
                  'Callback',@(~,~) stepVal(h, idx, -1));

        % Store spinner index; click/enter on edit activates scroll wheel
        h.UserData = idx;
        set(h, 'ButtonDownFcn', @(src,~) activateScroll(src));
        set(h, 'Callback',      @(src,~) activateScroll(src));
    end

    % ── activateScroll: bind figure scroll wheel to active field ──
    function activateScroll(hEdit)
        set(fig, 'WindowScrollWheelFcn', @(~,ev) onScroll(hEdit, ev));
    end

    % ── addTextParam: plain edit box (no spinner) for Binary Data ──
    function h = addTextParam(lbl, def, xp, wp)
        YL = 0.158; YE = 0.074; EH = 0.060;
        annotation(fig,'rectangle',[xp-0.003 YE-0.006 wp+0.006 EH+0.015], ...
                   'FaceColor','none','EdgeColor',ACCENT.*0.20,'LineWidth',2.5);
        annotation(fig,'rectangle',[xp-0.002 YE-0.004 wp+0.004 EH+0.012], ...
                   'FaceColor',[0.03 0.06 0.12],'EdgeColor',ACCENT.*0.45,'LineWidth',0.9);
        uicontrol('Parent',fig,'Style','text','String',lbl, ...
                  'Units','normalized','Position',[xp YL wp 0.020], ...
                  'HorizontalAlignment','left','ForegroundColor',TXT_DIM, ...
                  'BackgroundColor',BG_CTRL,'FontSize',7.5);
        h = uicontrol('Parent',fig,'Style','edit','String',def, ...
                      'Units','normalized','Position',[xp YE wp EH], ...
                      'BackgroundColor',[0.03 0.06 0.12],'ForegroundColor',ACCENT, ...
                      'FontSize',11,'FontWeight','bold','HorizontalAlignment','center');
    end

    % ── stepVal: increment/decrement with clamping ─────────────
    function stepVal(hEdit, idx, direction)
        cur = str2double(hEdit.String);
        if isnan(cur), cur = spinMn(idx); end
        nv  = cur + direction * spinStp(idx);
        nv  = max(spinMn(idx), min(spinMx(idx), nv));
        fmt = sprintf('%%.%df', spinDec(idx));
        hEdit.String = sprintf(fmt, nv);
    end

    % ── onScroll: mouse wheel on focused edit ───────────────────
    function onScroll(hEdit, ev)
        idx = hEdit.UserData;
        if isempty(idx) || ~isnumeric(idx), return; end
        stepVal(hEdit, idx, -ev.VerticalScrollCount);
    end

    % ── Layout ──────────────────────────────────────────────────
    CW  = 0.076;
    GAP = 0.087;
    X0  = 0.022;
    %                    lbl                  def      xpos           width  spinIdx
    hAm      = addSpinner('Am  [Msg Amp]',    '1',   X0+GAP*0, CW,   1);
    hAc      = addSpinner('Ac  [Car Amp]',    '2',   X0+GAP*1, CW,   2);
    hfm      = addSpinner('fm  [Hz]',         '5',   X0+GAP*2, CW,   3);
    hfc      = addSpinner('fc  [Hz]',         '50',  X0+GAP*3, CW,   4);
    hkf      = addSpinner('kf  [FM Sens]',    '10',  X0+GAP*4, CW,   5);
    hData    = addTextParam('Binary Data',    '1 0 1 1', X0+GAP*5, CW+0.026);
    hBitRate = addSpinner('Bit Rate [b/s]',   '1',   X0+GAP*6+0.026, CW, 6);
    hf1      = addSpinner('f1 [Hz] bit=1',    '50',  X0+GAP*7+0.026, CW, 7);
    hf2      = addSpinner('f2 [Hz] bit=0',    '20',  X0+GAP*8+0.026, CW, 8);
    hfs      = addSpinner('fs  [Hz]',         '1000',X0+GAP*9+0.026, CW, 9);

    % Activate scroll on figure click-away → detach wheel
    set(fig,'ButtonDownFcn', @(~,~) set(fig,'WindowScrollWheelFcn',''));

    % Vertical separators between fields (dotted neon lines)
    for k = 1:9
        xv = X0 + GAP*k + 0.026*(k>=6) - 0.005;
        annotation(fig,'line',[xv xv],[0.010 HBOTTOM-0.010], ...
                   'Color',[0.08 0.18 0.28],'LineWidth',0.7,'LineStyle',':');
    end

    % ══════════════════════════════════════════════════════════
    %   RUN & CLEAR BUTTONS  (cyberpunk styled)
    % ══════════════════════════════════════════════════════════
    % RUN button — glowing green frame
    annotation(fig,'rectangle',[0.924 0.060 0.066 0.148], ...
               'FaceColor','none','EdgeColor',GREEN.*0.50,'LineWidth',3.0);
    annotation(fig,'rectangle',[0.926 0.062 0.062 0.144], ...
               'FaceColor',[0.00 0.18 0.10],'EdgeColor',GREEN.*0.80,'LineWidth',1.0);
    uicontrol('Parent',fig,'Style','pushbutton','String',sprintf('▶  RUN'), ...
              'Units','normalized','Position',[0.927 0.063 0.060 0.142], ...
              'FontSize',11,'FontWeight','bold', ...
              'BackgroundColor',[0.00 0.18 0.10],'ForegroundColor',GREEN, ...
              'Callback',@onRun);

    % CLR button — glowing red frame
    annotation(fig,'rectangle',[0.924 0.010 0.066 0.044], ...
               'FaceColor','none','EdgeColor',ACCENT2.*0.45,'LineWidth',2.0);
    annotation(fig,'rectangle',[0.926 0.012 0.062 0.040], ...
               'FaceColor',[0.18 0.02 0.06],'EdgeColor',ACCENT2.*0.75,'LineWidth',0.9);
    uicontrol('Parent',fig,'Style','pushbutton','String','✕  CLR', ...
              'Units','normalized','Position',[0.927 0.013 0.060 0.038], ...
              'FontSize',9,'FontWeight','bold', ...
              'BackgroundColor',[0.18 0.02 0.06],'ForegroundColor',[1.00 0.55 0.70], ...
              'Callback',@onReset);

    onTypeChange([],[]);

    % ════════════════════════════════════════════
    function onTypeChange(~,~)
        lbls  = {'AM','FM','ASK','FSK'};
        sel   = lbls{hType.Value};
        isAM  = strcmp(sel,'AM');
        isFM  = strcmp(sel,'FM');
        isDig = any(strcmp(sel,{'ASK','FSK'}));
        isFSK = strcmp(sel,'FSK');
        isASK = strcmp(sel,'ASK');
        setVis(hAm,      isAM||isFM);
        setVis(hAc,      isAM||isFM||isASK);
        setVis(hfm,      isAM||isFM);
        setVis(hfc,      isAM||isFM||isASK);
        setVis(hkf,      isFM);
        setVis(hData,    isDig);
        setVis(hBitRate, isDig);
        setVis(hf1,      isFSK);
        setVis(hf2,      isFSK);
        setVis(hfs,      true);
    end

    function onRun(~,~)
        lbls = {'AM','FM','ASK','FSK'};
        sel  = lbls{hType.Value};
        hStatus.String          = sprintf('◌\nRUN...');
        hStatus.ForegroundColor = GOLD;
        drawnow;
        p.fs = readNum(hfs,'fs');
        try
            switch sel
                case 'AM'
                    p.Am=readNum(hAm,'Am'); p.Ac=readNum(hAc,'Ac');
                    p.fm=readNum(hfm,'fm'); p.fc=readNum(hfc,'fc');
                    t=0:1/p.fs:1;
                    [m,~,ms,ds]=AM_signal(p.Am,p.Ac,p.fm,p.fc,t);
                    drawPlots(t,m,ms,ds,'AM', ...
                        [0.00 0.85 0.90],[1.00 0.35 0.55],[0.10 0.90 0.55]);
                case 'FM'
                    p.Am=readNum(hAm,'Am'); p.Ac=readNum(hAc,'Ac');
                    p.fm=readNum(hfm,'fm'); p.fc=readNum(hfc,'fc');
                    p.kf=readNum(hkf,'kf');
                    t=0:1/p.fs:1;
                    [m,~,ms,ds]=FM_signal(p.Am,p.Ac,p.fm,p.fc,t,p.kf);
                    if length(ds)>length(t), ds=ds(1:length(t)); end
                    drawPlots(t,m,ms,ds,'FM', ...
                        [0.00 0.85 0.90],[1.00 0.65 0.10],[0.80 0.40 1.00]);
                case 'ASK'
                    p.Ac=readNum(hAc,'Ac'); p.fc=readNum(hfc,'fc');
                    p.bit_rate=readNum(hBitRate,'bit_rate');
                    p.data=str2num(hData.String); %#ok<ST2NM>
                    if isempty(p.data), error('Binary data invalid, e.g.: 1 0 1 1'); end
                    [dout,ms,dd]=ASK_signal(p.data,p.Ac,p.fc,p.bit_rate,p.fs);
                    Tb=1/p.bit_rate; t=0:1/p.fs:length(p.data)*Tb-1/p.fs;
                    spb=round(length(t)/length(p.data));
                    os=repelem(dout,spb); ds2=repelem(dd,spb);
                    L=min([length(t),length(ms),length(os),length(ds2)]);
                    drawPlots(t(1:L),os(1:L),ms(1:L),ds2(1:L),'ASK', ...
                        [0.00 0.85 0.90],[1.00 0.35 0.55],[0.10 0.90 0.55]);
                case 'FSK'
                    p.f1=readNum(hf1,'f1'); p.f2=readNum(hf2,'f2');
                    p.bit_rate=readNum(hBitRate,'bit_rate');
                    p.data=str2num(hData.String); %#ok<ST2NM>
                    if isempty(p.data), error('Binary data invalid, e.g.: 1 0 1 1'); end
                    [dout,ms,dd]=FSK_signal(p.data,p.f1,p.f2,p.bit_rate,p.fs);
                    Tb=1/p.bit_rate; t=0:1/p.fs:length(p.data)*Tb-1/p.fs;
                    spb=round(length(t)/length(p.data));
                    os=repelem(dout,spb); ds2=repelem(dd,spb);
                    L=min([length(t),length(ms),length(os),length(ds2)]);
                    drawPlots(t(1:L),os(1:L),ms(1:L),ds2(1:L),'FSK', ...
                        [0.00 0.85 0.90],[1.00 0.65 0.10],[0.80 0.40 1.00]);
            end
            hStatus.String          = sprintf('✔\nDONE');
            hStatus.ForegroundColor = GREEN;
        catch ME
            hStatus.String          = sprintf('✖\nERR');
            hStatus.ForegroundColor = [1 0.3 0.3];
            errordlg(ME.message,'Simulation Error');
        end
    end

    function onReset(~,~)
        cla(ax1); cla(ax2); cla(ax3);
        ax1lbl.String = '  CH-1  ORIGINAL SIGNAL';
        ax2lbl.String = '  CH-2  MODULATED SIGNAL';
        ax3lbl.String = '  CH-3  DEMODULATED SIGNAL';
        hStatus.String          = sprintf('●\nREADY');
        hStatus.ForegroundColor = GREEN;
    end

    function v = readNum(h,name)
        v = str2double(h.String);
        if isnan(v), error('Field "%s" must be a number.',name); end
    end

    function drawPlots(t,orig,modulated,demodulated,lbl,c1,c2,c3)
        cla(ax1); cla(ax2); cla(ax3);

        % ── CH-1 Original  (filled area + bright line + soft glow layer) ──
        area(ax1,t,orig,'FaceColor',[c1.*0.06],'EdgeColor','none');
        hold(ax1,'on');
        % glow: wide dim line under
        plot(ax1,t,orig,'Color',[c1 0.28],'LineWidth',5.0);
        % core neon line
        plot(ax1,t,orig,'Color',c1,'LineWidth',1.8);
        hold(ax1,'off');
        xlabel(ax1,'TIME  (s)','Color',TXT_DIM,'FontSize',7.5,'FontName','Courier New');
        ylabel(ax1,'V','Color',TXT_DIM,'FontSize',7.5);
        grid(ax1,'on');
        ax1lbl.String = ['  CH-1  ORIGINAL SIGNAL  ›  ' lbl];

        % ── CH-2 Modulated ──
        hold(ax2,'on');
        plot(ax2,t,modulated,'Color',[c2 0.25],'LineWidth',4.5);
        plot(ax2,t,modulated,'Color',c2,'LineWidth',1.6);
        hold(ax2,'off');
        xlabel(ax2,'TIME  (s)','Color',TXT_DIM,'FontSize',7.5,'FontName','Courier New');
        ylabel(ax2,'V','Color',TXT_DIM,'FontSize',7.5);
        grid(ax2,'on');
        ax2lbl.String = ['  CH-2  MODULATED SIGNAL  ›  ' lbl];

        % ── CH-3 Demodulated ──
        area(ax3,t,demodulated,'FaceColor',[c3.*0.06],'EdgeColor','none');
        hold(ax3,'on');
        plot(ax3,t,demodulated,'Color',[c3 0.28],'LineWidth',5.0);
        plot(ax3,t,demodulated,'Color',c3,'LineWidth',1.8);
        hold(ax3,'off');
        xlabel(ax3,'TIME  (s)','Color',TXT_DIM,'FontSize',7.5,'FontName','Courier New');
        ylabel(ax3,'V','Color',TXT_DIM,'FontSize',7.5);
        grid(ax3,'on');
        ax3lbl.String = ['  CH-3  DEMODULATED SIGNAL  ›  ' lbl];
    end

    function setVis(h,visible)
        if visible; s='on'; else; s='off'; end
        h.Visible = s;
        ch  = fig.Children;
        idx = find(ch == h);
        % hide/show up to 2 siblings after (▲ and ▼ buttons)
        for si = 1:2
            if ~isempty(idx) && (idx-si) >= 1
                sib = ch(idx-si);
                if strcmp(sib.Type,'uicontrol') && strcmp(sib.Style,'pushbutton')
                    sib.Visible = s;
                end
            end
        end
        % also check 1 child after (label text)
        if ~isempty(idx) && idx < numel(ch)
            sib2 = ch(idx+1);
            if strcmp(sib2.Type,'uicontrol') && strcmp(sib2.Style,'text')
                sib2.Visible = s;
            end
        end
    end

end
