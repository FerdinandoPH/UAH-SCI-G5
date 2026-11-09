%% REGRESIÓN con red feedforward (fitnet) - Script base 
% Objetivo:
%   - Cargar un dataset de regresión de la toolbox
%   - Crear y entrenar una MLP con una capa oculta (fitnet)
%   - Evaluar el rendimiento (MSE) y errores
%   - (Opcional) visualizar la red y curvas de entrenamiento
%
% Notas:
%   * fitnet está pensado para REGRESIÓN (salida lineal por defecto).
%   * Por defecto: capa oculta 'tansig' y capa de salida 'purelin'.
%   * La métrica por defecto es MSE (net.performFcn = 'mse').

clc; close all; clearvars; rng(42);   

%% 0) Elección del algoritmo de entrenamiento
trainFcn = 'traingdm';                    % 'traingdm' (primer apartado) | 'trainlm' (segundo apartado)

%% Carga de datos de ejemplo disponibles en la toolbox
[inputs,targets] = simplefit_dataset;   % 1 entrada -> 1 salida (seno perturbado)
% [inputs,targets] = bodyfat_dataset;     % varias entradas -> % de grasa corporal

%% Creación de la red
hiddenLayerSize = 10;                     % nº de neuronas en la capa oculta (hiperparámetro)

% fitnet crea una red para REGRESIÓN:  [inputs] -> [tansig(H)] -> [linear output]
net = fitnet(hiddenLayerSize);            % net.layers{1}.transferFcn = 'tansig'; net.layers{2}.transferFcn = 'purelin'

% (Opcional) Alternativas:
% net = feedforwardnet(hiddenLayerSize);  % Similar; configurable a mano

% Algoritmo de entrenamiento (optimizador):
% Por defecto en fitnet suele ser 'trainlm' (Levenberg-Marquardt), muy rápido en problemas pequeños.
% Aquí se fija con la variable trainFcn (sección 0): 'traingdm' (descenso gradiente con momento) o 'trainlm'.
net.trainFcn = trainFcn;                  % algoritmo elegido en la sección 0

% (Opcional) Otros hiperparámetros del optimizador:
%net.trainParam.lr       = 1e-2;         % tasa de aprendizaje (relevante en traingdm)
%net.trainParam.mc       = 0.01;         % momentum (traingdm)
%net.trainParam.epochs   = 1000;         % nº máx. de épocas
%net.trainParam.max_fail = 6;            % early stopping

%% División del conjunto de datos para entrenamiento, validación y test
net.divideFcn = 'dividerand';              % división aleatoria por defecto
net.divideParam.trainRatio = 70/100;      % 70% para entrenar (ajuste de pesos)
net.divideParam.valRatio   = 15/100;      % 15% para validación (early stopping)
net.divideParam.testRatio  = 15/100;      % 15% para test (evaluación final)

%% Entrenamiento de la red
% 'train' gestiona el bucle de entrenamiento, normalización de entradas (mapminmax por defecto),
% y early stopping usando el conjunto de validación.
[net,tr] = train(net,inputs,targets);

%% Inferencia
outputs = net(inputs);                    % predicción (misma forma que targets)
% outputs = sim(net, inputs);             % equivalente a la línea anterior

%% Errores y métricas
errors     = gsubtract(outputs,targets);  % error = y_pred - y_true (vector columna por muestra)
meanerror  = mean(errors)                 % media del error (puede ser ~0 por cancelación de signos)
performance = perform(net,targets,outputs) % MSE global (net.performFcn='mse')

% MSE y R por subconjunto usando los índices guardados en 'tr'
iTrain = tr.trainInd; iVal = tr.valInd; iTest = tr.testInd;
mseSet = @(i) mean(errors(i).^2);         % MSE de un subconjunto (i: índices de las muestras)
fprintf('\n=== %s ===\n', trainFcn);
fprintf('Épocas: %d | Mejor época (validación): %d | Parada: %s\n', tr.num_epochs, tr.best_epoch, tr.stop);
fprintf('MSE  |  Train: %.4g   Val: %.4g   Test: %.4g   (Global: %.4g)\n', ...
        mseSet(iTrain), mseSet(iVal), mseSet(iTest), performance);
fprintf('R    |  Train: %.5f   Val: %.5f   Test: %.5f   (Global: %.5f)\n', ...
        regression(targets(iTrain),outputs(iTrain)), regression(targets(iVal),outputs(iVal)), ...
        regression(targets(iTest),outputs(iTest)), regression(targets,outputs));

%% Visualización (opcional)
% Curva de rendimiento por época (train/val/test):
figure; plotperform(tr);

% Estado del entrenamiento (gradiente, valid checks, etc.):
figure; plottrainstate(tr);

% Histograma del error por subconjunto (convenio de la toolbox: targets - outputs):
eHist = gsubtract(targets,outputs);
figure; ploterrhist(eHist(iTrain),'Training', eHist(iVal),'Validation', eHist(iTest),'Test');

% Regresión objetivo vs predicción (scatter + recta ideal), por subconjunto:
figure; plotregression(targets(iTrain),outputs(iTrain),'Training', targets(iVal),outputs(iVal),'Validation', ...
                       targets(iTest),outputs(iTest),'Test', targets,outputs,'All');

% Ajuste de la función por subconjunto (curva de la red sobre los puntos):
figure; plotfit(net, inputs(iTrain),targets(iTrain),'Training', inputs(iVal),targets(iVal),'Validation', ...
                inputs(iTest),targets(iTest),'Test');

% Visualización de la arquitectura de la red:
% view(net)

% Ploteo de los datos estimados vs targets en la regresión
figure;
plot(inputs, outputs, '+');hold on;
plot(inputs, targets,'-r'); hold off;
title('Ajuste de la regresión');
xlabel('Vector de entrada');
ylabel('Vector targets vs outputs');
