%% Apartado i)
close all;
clear;
rng(7);

% Tiempo de muestreo
Ts = 100e-3;

N = 30;
modelos = {'PositionControl', 'PositionControlNeuronal'};
refs = 10*rand(N, 2) - 5;          % [-5, 5]

tray = cell(N, 2);                 % [x y] de cada simulación (columna 1: original, 2: red)
tFin = zeros(N, 2);                % duración de cada simulación (s)
errFin = zeros(N, 2);              % distancia final al destino (m)
errMedio = zeros(N, 1);            % distancia media entre las dos trayectorias (m)
errMax = zeros(N, 1);              % distancia máxima entre las dos trayectorias (m)

for i = 1:N
    refx = refs(i, 1);
    refy = refs(i, 2);
    for m = 1:2
        sim([modelos{m} '.slx']);
        tray{i, m} = [salida_x.signals.values salida_y.signals.values];
        tFin(i, m) = salida_x.time(end);
        errFin(i, m) = norm(tray{i, m}(end, :) - refs(i, :));
    end
    % Error entre trayectorias: distancia entre las posiciones de los dos
    % robots en el mismo instante (mientras los dos siguen en marcha)
    n = min(size(tray{i, 1}, 1), size(tray{i, 2}, 1));
    d = vecnorm(tray{i, 1}(1:n, :) - tray{i, 2}(1:n, :), 2, 2);
    errMedio(i) = mean(d);
    errMax(i) = max(d);
end

% Tabla de resultados
fprintf('%2s | %13s | %15s | %21s | %19s\n', '', 'Destino (m)', 'Duración (s)', ...
        'Error final (mm)', 'Error tray. (mm)');
fprintf('%2s | %13s | %7s %7s | %10s %10s | %9s %9s\n', 'i', '', 'orig', 'red', ...
        'orig', 'red', 'medio', 'máximo');
fprintf('%s\n', repmat('-', 1, 84));
for i = 1:N
    fprintf('%2d | (%5.2f,%5.2f) | %7.1f %7.1f | %10.2f %10.2f | %9.2f %9.2f\n', i, ...
            refs(i, 1), refs(i, 2), tFin(i, 1), tFin(i, 2), 1000*errFin(i, 1), ...
            1000*errFin(i, 2), 1000*errMedio(i), 1000*errMax(i));
end
fprintf('\nLlegan al destino (error final <= 1 cm): original %d/%d, red %d/%d\n', ...
        sum(errFin(:, 1) <= 0.01), N, sum(errFin(:, 2) <= 0.01), N);
fprintf('Error entre trayectorias: medio %.2f mm, máximo %.2f mm\n', ...
        1000*mean(errMedio), 1000*max(errMax));
fprintf('Diferencia de duración: máxima %.1f s\n', max(abs(tFin(:, 1) - tFin(:, 2))));

% Trayectorias superpuestas (original continua, red discontinua)
figure;
hold on; grid on; axis equal;
for i = 1:N
    h1 = plot(tray{i, 1}(:, 1), tray{i, 1}(:, 2), '-');
    h2 = plot(tray{i, 2}(:, 1), tray{i, 2}(:, 2), '--', 'Color', h1.Color, 'LineWidth', 1.5);
end
plot(refs(:, 1), refs(:, 2), 'kx', 'MarkerSize', 8, 'LineWidth', 1.5);   % destinos
xlim([-5 5]); ylim([-5 5]);
xlabel('x (m)'); ylabel('y (m)');
legend([h1 h2], 'Controlador original', 'Controlador neuronal', 'Location', 'bestoutside');
title(sprintf('Trayectorias hacia %d destinos', N));

% Error entre trayectorias en cada destino
figure;
bar(1000*[errMedio errMax]);
grid on;
xlabel('Destino'); ylabel('Error (mm)');
legend('Medio', 'Máximo', 'Location', 'best');
title('Distancia entre la trayectoria original y la de la red');
