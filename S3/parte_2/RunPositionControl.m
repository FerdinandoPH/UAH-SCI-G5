close all;
clear;
modelo = 'PositionControl';   % PositionControl o PositionControlNeuronal
%Tiempo de muestreo
Ts=100e-3;
% Referencia x-y de posicion
refx=2.0;
refy=2.0;
% Ejecutar Simulacion
sim([modelo '.slx'])

%% Apartado d)
x=salida_x.signals.values;
y=salida_y.signals.values;
figure;
plot(x,y);
grid on;
hold on;
plot(refx, refy, 'rx', 'MarkerSize', 10, 'LineWidth', 2);   % destino
plot(x(1), y(1), 'ko', 'MarkerFaceColor', 'k');             % posición inicial
xlabel('x (m)'); ylabel('y (m)');
title(sprintf('%s: trayectoria hasta (%.1f, %.1f)', modelo, refx, refy), 'Interpreter', 'none');
legend('Trayectoria', 'Destino', 'Inicio', 'Location', 'best');