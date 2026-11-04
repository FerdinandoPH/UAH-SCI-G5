close all;
clear;
%Tiempo de muestreo
Ts=100e-3;
% Referencia x-y de posicion
refx=2.0;
refy=2.0;
% Ejecutar Simulacion
sim('PositionControl.slx')

%% Apartado d) Mostrar la trayectoria del robot
x=salida_x.signals.values;
y=salida_y.signals.values;
figure;
plot(x,y);
grid on;
hold on;
plot(refx, refy, 'rx', 'MarkerSize', 10, 'LineWidth', 2);   % destino
plot(x(1), y(1), 'ko', 'MarkerFaceColor', 'k');             % posición inicial
xlabel('x (m)'); ylabel('y (m)');
title(sprintf('Trayectoria del robot hasta (%.1f, %.1f)', refx, refy));
legend('Trayectoria', 'Destino', 'Inicio', 'Location', 'best');