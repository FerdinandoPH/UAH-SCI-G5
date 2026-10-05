%% MLP FROM-SCRATCH para REGRESIÓN
clc; close all; clearvars; rng(42);

% ---------------------------
% 1) Datos de la práctica
% ---------------------------
[inputs,targets] = simplefit_dataset;
[D, N] = size(inputs);
C = size(targets,1);
figure;
% TODO: plotear inputs vs targets
plot(inputs,targets,".-");
title('Función objetivo de la regresión');
xlabel('Vector de entrada');
ylabel('Vector Target');

% ---------------------------
% 2) Partición 70/15/15
% ---------------------------
idx = randperm(N);
nTrain = floor(N*0.7); % TODO: porcentaje para entrenamiento (70%)
nVal = floor(N*0.15); % TODO: porcentaje para validación (15%)
nTest = N - nTrain - nVal ; % TODO: porcentaje para test (15%)

iTrain = idx(1:nTrain);
iVal = idx(nTrain+1 : nTrain+nVal);
iTest = idx(nTrain+nVal+1 : end);

Xtr = inputs(:, iTrain); Ttr = targets(:, iTrain);
Xva = inputs(:, iVal); Tva = targets(:, iVal);
Xte = inputs(:, iTest); Tte = targets(:, iTest);

% ---------------------------
% 3) Hiperparámetros y modelo
% ---------------------------
H = 10; % neuronas ocultas
epochs = 1000; % épocas máximas
lr = 1e-2; % learning rate
lambda = 0.01; % regularización por momento (0 = sin regularización)
actName = 'tansig'; % activación oculta (fitnet usa tansig por defecto)
scale = 1e-2; % escala de inicialización
printEvery = 10; % cada cuántas épocas se imprime el logging (M)

% Inicialización (apartado 2)
P = init_params(D, H, C, scale);

% Históricos
mseTr = zeros(1, epochs);
mseVa = zeros(1, epochs);
mseTe = zeros(1, epochs);

% ---------------------------
% 4) Entrenamiento (batch completo)
% ---------------------------
for e = 1:epochs
    % FORWARD (apartado 3)
    [Ytr, cacheTr] = forward_regression(Xtr, P, actName);
    % LOSS (apartado 5)
    mseTr(e) = mse_loss(Ytr, Ttr);
    loss = mseTr(e); % MSE (para el fprintf)

    % BACKWARD (apartado 4)
    G = backward_regression(Xtr, Ttr, Ytr, cacheTr, P, actName, lambda);
    P.W1 = P.W1 - lr * G.dW1; % TODO: actualizar pesos capa oculta
    P.b1 = P.b1 - lr * G.db1; % TODO: actualizar bias capa oculta
    P.W2 = P.W2 - lr * G.dW2; % TODO: actualizar pesos capa salida
    P.b2 = P.b2 - lr * G.db2; % TODO: actualizar bias capa salida

    % Validación y test (solo para curvas)
    [Yva, ~] = forward_regression(Xva, P, actName);
    [Yte, ~] = forward_regression(Xte, P, actName);
    mseVa(e) = mse_loss(Yva, Tva); %(apartado 5)
    mseTe(e) = mse_loss(Yte, Tte); %(apartado 5)

    % ---- Logging cada M épocas (usa MSE como "Val acc") ----
    if mod(e, printEvery) == 0 || e == 1 || e == epochs
        acc_val = mseVa(e); % MSE validación
        fprintf('Epoch %2d | Loss = %.4f | Val acc= %.4f\n', e, loss, acc_val);
    end
end


% Apartado 2
function P = init_params(D, H, C, scale)
% W1: HxD, b1: Hx1 ; W2: CxH, b2: Cx1
    if nargin < 4, scale = 1e-2; end
    P.W1 = randn(H, D) * scale; % Pesos capa oculta
    P.b1 = zeros(H, 1); % Bias capa oculta
    P.W2 = randn(C, H) * scale; % Pesos capa salida
    P.b2 = zeros(C, 1); % Bias capa salida
end


% Apartado 3
function [Y, cache] = forward_regression(X, P, actName)
    % X: D x N -> Z1=W1*X+b1 ; A1=act(Z1) ; Y=W2*A1 + b2 (lineal)
    Z1 = P.W1 * X + P.b1; % TODO: calcular combinación lineal capa oculta
    switch lower(actName) 
        case 'tansig', A1 = tansig(Z1); % TODO: A1=f(Z1)
        case 'logsig', A1 = logsig(Z1);
        case 'relu', A1 = max(0, Z1);
        case 'purelin',A1 = Z1;
        otherwise, A1 = feval(actName, Z1);
    end
    Y = P.W2 * A1 + P.b2; % TODO: calcular salida final
    cache = struct('Z1',Z1,'A1',A1);
end


% Apartado 4
function G = backward_regression(X, T, Y, cache, P, actName, lambda)
% Gradientes medios para MSE: L = mean( (Y-T).^2 )
% dL/dY = 2*(Y-T)/m
    m = size(X,2);
    A1 = cache.A1; Z1 = cache.Z1;

    dY = 2 * (Y - T) / m; % TODO: dY
    G.dW2 = dY * A1' + lambda * P.W2; % TODO: dW2
    G.db2 = sum(dY, 2); % TODO: db2

    dA1 = P.W2' * dY; % TODO: dA1
    switch lower(actName)
        case 'tansig', dZ1 = dA1 .* (1-A1.^2); % TODO: dZ1
        case 'logsig', dZ1 = dA1 .* (A1 .* (1 - A1));
        case 'relu', dZ1 = dA1; dZ1(Z1<=0) = 0;
        case 'purelin',dZ1 = dA1;
        otherwise, dZ1 = dA1; % fallback
    end
    
    G.dW1 = dZ1 * X'; % TODO: dW1
    G.db1 = sum(dZ1, 2); % TODO: db1
end


% Apartado 5
function m = mse_loss(Y, T)
% MSE medio por muestra y salida (independiente de dimensiones)
    C = size(T,1);
    m = mean((Y - T).^2); % TODO: calcular MSE
end
