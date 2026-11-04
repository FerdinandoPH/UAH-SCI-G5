%% Apartado f) Número de neuronas de la capa oculta
% Se entrenan redes con distinto número de neuronas (H) y se compara su error
% con los datos de test, que la red no usa para ajustar los pesos.
% Como el resultado depende de los pesos iniciales, se entrenan R redes por H.
close all;
clear;
load('datos_control.mat');           % inputs, outputs (de GenerarDatosControl.m)

Hs = [1 2 4 6 8 10 15 20];           % neuronas a probar
R = 5;                               % redes por cada H
mseTrain = zeros(numel(Hs), R);
mseTest = zeros(numel(Hs), R);

for i = 1:numel(Hs)
    for r = 1:R
        rng(r);                                  % para que sea repetible
        net = feedforwardnet(Hs(i));
        net.trainParam.showWindow = false;       % sin ventana de entrenamiento
        [net, tr] = train(net, inputs, outputs);
        mseTrain(i, r) = tr.best_perf;
        mseTest(i, r) = tr.best_tperf;
    end
    fprintf('H = %2d | MSE train %.1e | MSE test %.1e (mediana de %d redes)\n', ...
            Hs(i), median(mseTrain(i, :)), median(mseTest(i, :)), R);
end

figure;
semilogy(Hs, median(mseTrain, 2), 'o-', Hs, median(mseTest, 2), 's-', 'LineWidth', 1.5);
grid on;
xlabel('Neuronas en la capa oculta (H)');
ylabel('MSE (mediana de 5 redes)');
legend('Entrenamiento', 'Test');
title('Error frente al número de neuronas');
