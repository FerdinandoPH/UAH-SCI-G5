%% Apartado e) 
close all;
clear;
rng(42);    % semilla fija

% Tiempo de muestreo
Ts = 100e-3;

% Generar N posiciones aleatorias
N = 30;
E_d_vec = [];
E_theta_vec = [];
V_vec = [];
W_vec = [];

refs = zeros(N, 2);          % destinos usados (para las gráficas)
tFinal = zeros(N, 1);        % duración de cada simulación
trayectorias = cell(N, 1);   % [x y] de cada simulación

for i = 1:N
    refx = 10*rand - 5;      % [-5, 5]
    refy = 10*rand - 5;
    sim('PositionControl.slx');
    E_d_vec = [E_d_vec; E_d.signals.values];
    E_theta_vec = [E_theta_vec; E_theta.signals.values];
    V_vec = [V_vec; V.signals.values];
    W_vec = [W_vec; W.signals.values];

    refs(i, :) = [refx refy];
    tFinal(i) = E_d.time(end);
    trayectorias{i} = [salida_x.signals.values salida_y.signals.values];
end

inputs = [E_d_vec'; E_theta_vec'];
outputs = [V_vec'; W_vec'];

fprintf('inputs:  %d x %d\n', size(inputs, 1), size(inputs, 2));
fprintf('outputs: %d x %d\n', size(outputs, 1), size(outputs, 2));
fprintf('Duración de las simulaciones: entre %.1f y %.1f s (media %.1f s)\n', ...
        min(tFinal), max(tFinal), mean(tFinal));

% Guardar para entrenar la red más tarde
save('datos_control.mat', 'inputs', 'outputs', 'refs', 'Ts');

% Trayectorias de las N simulaciones
figure;
hold on; grid on; axis equal;
for i = 1:N
    plot(trayectorias{i}(:, 1), trayectorias{i}(:, 2));
end
plot(refs(:, 1), refs(:, 2), 'kx', 'MarkerSize', 8, 'LineWidth', 1.5);   % destinos
plot(0, 0, 'ko', 'MarkerFaceColor', 'k');                                  % origen
xlim([-5 5]); ylim([-5 5]);
xlabel('x (m)'); ylabel('y (m)');
title(sprintf('Trayectorias de las %d simulaciones', N));
