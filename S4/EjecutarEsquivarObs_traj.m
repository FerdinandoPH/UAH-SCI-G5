

clear; close all;


Ts = 100e-3;


x_0  = 0.1;
y_0  = 0;
th_0 = 0;

obsx = 1.75;
obsy = 0.7;

% Ejecutar la simulacion
sim('EvitarObstaculo_traj.slx');

% Trayectoria del robot
x = salida_x.signals.values;
y = salida_y.signals.values;

figure;
grid on; hold on; axis equal;
plot(x, y, 'b', 'LineWidth', 1.5);
plot(x(1), y(1), 'bo', 'MarkerFaceColor', 'b');   % inicio del robot
leyenda = {'Robot', 'Inicio robot'};


th  = salida_theta.signals.values;
ed  = E_d.signals.values;
eth = E_theta.signals.values;
xr = x + ed .* cos(eth + th);
yr = y + ed .* sin(eth + th);

plot(xr, yr, 'r--', 'LineWidth', 1.5);
plot(x_0, y_0, 'rx', 'MarkerSize', 10, 'LineWidth', 2);   % inicio referencia
plot(x(end), y(end), 'bs', 'MarkerFaceColor', 'b');       % fin robot
plot(xr(end), yr(end), 'rs', 'MarkerFaceColor', 'r');     % fin referencia
plot(obsx, obsy, 'ko', 'MarkerSize', 10, 'LineWidth', 2);   % obstaculo
leyenda = [leyenda, {'Referencia', 'Inicio referencia', 'Fin robot', 'Fin referencia', 'Obstaculo'}];
legend(leyenda, 'Location', 'bestoutside');

