clc;
clear;
close all;

%% =========================================
% DetectorDeBode.m
% Autor: Renan Espinar Saavedra
% Visualizador didáctico de Bode
% ==========================================

%% =========================
% DEFINIR SISTEMA
% ==========================
s = tf('s');

% Ejemplo 1: estable simple
G = 1/((s+1)*(s+2)*(s+3));

% Ejemplo 2: motor DC
% R = 2;
% J = 0.02;
% Kt = 0.1;
% L = 0.5;
% b = 0.01;
% Ke = 0.1;
% G = Kt / (L*J*s^2 + (R*J + L*b)*s + (R*b + Kt*Ke));

%% =========================
% DATOS DEL BODE
% ==========================
w = logspace(-2, 2, 2000);   % frecuencia en rad/s
[mag, phase, wout] = bode(G, w);

mag = squeeze(mag);
phase = squeeze(phase);
mag_dB = 20*log10(mag);

%% =========================
% FRECUENCIA DE CORTE (-3 dB)
% ==========================
mag0 = mag_dB(1);                  % magnitud inicial
target = mag0 - 3;                 % punto -3 dB

idx_cut = find(mag_dB <= target, 1, 'first');

if ~isempty(idx_cut)
    wc = wout(idx_cut);
    cutExists = true;
else
    wc = NaN;
    cutExists = false;
end

%% =========================
% INTERPRETACIÓN AUTOMÁTICA
% ==========================
phase_min = min(phase);

if cutExists
    if wc < 0.5
        rapidezTxt = 'Sistema lento: solo sigue señales lentas.';
        rapidezColor = [0.85 0.2 0.2];
    elseif wc < 5
        rapidezTxt = 'Sistema de rapidez media: sigue cambios moderados.';
        rapidezColor = [0.95 0.6 0.1];
    else
        rapidezTxt = 'Sistema rápido: puede seguir cambios veloces.';
        rapidezColor = [0.1 0.6 0.2];
    end
else
    rapidezTxt = 'No se encontró frecuencia de corte en el rango analizado.';
    rapidezColor = [0.2 0.2 0.8];
end

if phase_min > -90
    faseTxt = 'Desfase moderado: la salida se retrasa poco.';
    faseColor = [0.1 0.6 0.2];
elseif phase_min > -180
    faseTxt = 'Desfase importante: la salida llega más tarde.';
    faseColor = [0.95 0.6 0.1];
else
    faseTxt = 'Desfase severo: riesgo de respuesta muy tardía.';
    faseColor = [0.85 0.2 0.2];
end

%% =========================
% FIGURA BONITA
% ==========================
figure('Color','w','Position',[100 80 1200 750]);

t = tiledlayout(2,1,'TileSpacing','compact','Padding','compact');

%% =========================
% MAGNITUD
% ==========================
nexttile;
semilogx(wout, mag_dB, 'LineWidth', 3, 'Color', [0 0.4470 0.7410]); hold on;
grid on; box on;

yline(0,'k--','LineWidth',1.4,'Label','0 dB','LabelHorizontalAlignment','left');
yline(target,'--','LineWidth',1.4,'Color',[0.85 0.2 0.2], ...
    'Label','-3 dB','LabelHorizontalAlignment','left');

if cutExists
    xline(wc,'--','LineWidth',1.8,'Color',[0.1 0.6 0.2], ...
        'Label',sprintf('\\omega_c = %.3f rad/s',wc), ...
        'LabelHorizontalAlignment','left');
    plot(wc, mag_dB(idx_cut), 'o', ...
        'MarkerSize', 9, ...
        'MarkerFaceColor', [0.1 0.6 0.2], ...
        'MarkerEdgeColor', 'k');
end

xlabel('\omega (rad/s)','FontSize',12,'FontWeight','bold');
ylabel('Magnitud (dB)','FontSize',12,'FontWeight','bold');
title('Diagrama de Bode - Magnitud','FontSize',16,'FontWeight','bold');

% Caja de texto interpretación magnitud
if cutExists
    txtMag = {
        'Interpretación de magnitud'
        ' '
        sprintf('Frecuencia de corte aprox: %.3f rad/s', wc)
        rapidezTxt
        ' '
        'Idea clave:'
        '• A bajas frecuencias responde bien'
        '• A altas frecuencias responde menos'
    };
else
    txtMag = {
        'Interpretación de magnitud'
        ' '
        rapidezTxt
        ' '
        'Idea clave:'
        '• A bajas frecuencias responde bien'
        '• A altas frecuencias responde menos'
    };
end

annotation('textbox',[0.70 0.67 0.24 0.18], ...
    'String',txtMag, ...
    'FitBoxToText','on', ...
    'BackgroundColor',[0.97 0.97 0.97], ...
    'EdgeColor',rapidezColor, ...
    'LineWidth',1.5, ...
    'FontSize',11, ...
    'FontWeight','bold');

%% =========================
% FASE
% ==========================
nexttile;
semilogx(wout, phase, 'LineWidth', 3, 'Color', [0.8500 0.3250 0.0980]); hold on;
grid on; box on;

yline(0,'k--','LineWidth',1.4,'Label','0°','LabelHorizontalAlignment','left');
yline(-90,'--','LineWidth',1.3,'Color',[0.95 0.6 0.1], ...
    'Label','-90°','LabelHorizontalAlignment','left');
yline(-180,'--','LineWidth',1.3,'Color',[0.85 0.2 0.2], ...
    'Label','-180°','LabelHorizontalAlignment','left');

xlabel('\omega (rad/s)','FontSize',12,'FontWeight','bold');
ylabel('Fase (°)','FontSize',12,'FontWeight','bold');
title('Diagrama de Bode - Fase','FontSize',16,'FontWeight','bold');

txtPhase = {
    'Interpretación de fase'
    ' '
    faseTxt
    ' '
    'Idea clave:'
    '• La fase indica cuánto se retrasa la salida'
    '• Más negativa = respuesta más tardía'
};

annotation('textbox',[0.70 0.19 0.24 0.18], ...
    'String',txtPhase, ...
    'FitBoxToText','on', ...
    'BackgroundColor',[0.97 0.97 0.97], ...
    'EdgeColor',faseColor, ...
    'LineWidth',1.5, ...
    'FontSize',11, ...
    'FontWeight','bold');

%% =========================
% TÍTULO GENERAL
% ==========================
title(t,'Detector de Bode - Magnitud y Fase', ...
    'FontSize',18,'FontWeight','bold');

%% =========================
% INFO EN COMMAND WINDOW
% ==========================
disp('==============================================');
disp('ANÁLISIS AUTOMÁTICO DEL BODE');
disp('----------------------------------------------');
if cutExists
    fprintf('Frecuencia de corte aproximada: %.4f rad/s\n', wc);
else
    disp('No se encontró frecuencia de corte en el rango analizado.');
end
fprintf('Fase mínima observada: %.4f grados\n', phase_min);
disp('----------------------------------------------');
disp(['Magnitud: ', rapidezTxt]);
disp(['Fase: ', faseTxt]);
disp('==============================================');