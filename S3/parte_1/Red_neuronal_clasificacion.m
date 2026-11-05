%% MLP FROM-SCRATCH para CLASIFICACIÓN
clc; close all; clearvars; rng(42);

% ---------------------------
% 1) Datos de la práctica
% ---------------------------
[inputs,targets] = simpleclass_dataset; % Cambiar a dataset de clasificación V
[D, N] = size(inputs);
C = size(targets,1);



% ---------------------------
% 2) Partición 70/15/15
% ---------------------------
idx = randperm(N);
nTrain = floor(N*0.7); % TODO: porcentaje para entrenamiento (70%) ✔
nVal = floor(N*0.15); % TODO: porcentaje para validación (15%) ✔
nTest = N - nTrain - nVal ; % TODO: porcentaje para test (15%) ✔

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
actName = 'tansig'; % activación oculta (patternnet usa tansig por defecto)
scale = 1e-1; % escala de inicialización (aumentada para clasificación)
printEvery = 10; % cada cuántas épocas se imprime el logging (M)

% Inicialización (apartado 2)
P = init_params(D, H, C, scale);

% Históricos (ahora es entropía cruzada, no MSE)
lossTr = zeros(1, epochs);
lossVa = zeros(1, epochs);
lossTe = zeros(1, epochs);

% ---------------------------
% 4) Entrenamiento (batch completo)
% ---------------------------
for e = 1:epochs
    % FORWARD (apartado 3)
    [Ytr, cacheTr] = forward_classif(Xtr, P, actName);
    % LOSS (apartado 5)
    lossTr(e) = crossentropy_loss(Ytr, Ttr);
    loss = lossTr(e); % cross-entropy (para el fprintf)

    % BACKWARD (apartado 4)
    G = backward_classif(Xtr, Ttr, Ytr, cacheTr, P, actName, lambda);
    P.W1 = P.W1 - lr * G.dW1; % TODO: actualizar pesos capa oculta ✔
    P.b1 = P.b1 - lr * G.db1; % TODO: actualizar bias capa oculta ✔
    P.W2 = P.W2 - lr * G.dW2; % TODO: actualizar pesos capa salida ✔
    P.b2 = P.b2 - lr * G.db2; % TODO: actualizar bias capa salida ✔

    % Validación y test (solo para curvas)
    [Yva, ~] = forward_classif(Xva, P, actName);
    [Yte, ~] = forward_classif(Xte, P, actName);
    lossVa(e) = crossentropy_loss(Yva, Tva); %(apartado 5)
    lossTe(e) = crossentropy_loss(Yte, Tte); %(apartado 5)

    if mod(e, printEvery) == 0 || e == 1 || e == epochs
        acc_val = accuracy_cls(Yva, Tva);   % accuracy de validación
        fprintf('Epoch %2d | Loss = %.4f | Val acc= %.4f\n', e, loss, acc_val);
    end
end

% ---------------------------
% 5) Evaluación final
% ---------------------------
Yhat_tr = forward_classif(Xtr, P, actName);
Yhat_va = forward_classif(Xva, P, actName);
Yhat_te = forward_classif(Xte, P, actName);

accTrain = accuracy_cls(Yhat_tr, Ttr);
accVal   = accuracy_cls(Yhat_va, Tva);
accTest  = accuracy_cls(Yhat_te, Tte);
Ntr = size(Ttr, 2);
Nva = size(Tva, 2);
Nte = size(Tte, 2);
accGlobal = (accTrain*Ntr + accVal*Nva + accTest*Nte) / (Ntr + Nva + Nte);
fprintf('\nFINAL | acc(train)=%.3f  acc(val)=%.3f  acc(test)=%.3f\n acc(global)=%.3f\n', ...
        accTrain, accVal, accTest, accGlobal);

% ---------------------------
% 6) Gráfica de performance (cross-entropy por época)
% ---------------------------
figure;
plot(lossTr, '-', 'LineWidth',1.5); hold on;
plot(lossVa, '--', 'LineWidth',1.5);
plot(lossTe, ':', 'LineWidth',1.5);
grid on; xlabel('Época'); ylabel('Cross-entropy');
legend('Train','Val','Test','Location','best');
title('Performance (cross-entropy) por época - MLP from scratch');

% ---------------------------
% 7) Matriz de confusión
% ---------------------------
% plotconfusion admite targets y "scores" (probabilidades) en columnas
figure('Name','Confusion (Test)');
plotconfusion(Tte, Yhat_te);
title(sprintf('Matriz de confusión (Test) - Acc=%.3f', accTest));


% --------------------------- FUNCIONES-------------------

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
function [Y, cache] = forward_classif(X, P, actName)
    % X: D x N -> Z1=W1*X+b1 ; A1=act(Z1) ; Z2=W2*A1+b2 ; Y=softmax(Z2)
    Z1 = P.W1 * X + P.b1;
    switch lower(actName) 
        case 'tansig', A1 = tansig(Z1);
        case 'logsig', A1 = logsig(Z1);
        case 'relu', A1 = max(0, Z1);
        case 'purelin',A1 = Z1;
        otherwise, A1 = feval(actName, Z1);
    end
    Z2 = P.W2 * A1 + P.b2;
    Z2p = Z2 - max(Z2, [], 1);
    E= exp(Z2p);
    Y = E ./ sum(E, 1); % softmax
    cache = struct('Z1',Z1,'A1',A1);
end

% Apartado 4
function G = backward_classif(X, T, Y, cache, P, actName, lambda)
    N = size(X,2);
    A1 = cache.A1; Z1 = cache.Z1;

    dZ2 = (Y - T) / N;
    G.dW2 = dZ2 * A1' + lambda * P.W2;
    G.db2 = sum(dZ2, 2) + lambda * P.b2;

    dA1 = P.W2' * dZ2;
    switch lower(actName)
        case 'tansig', dZ1 = dA1 .* (1-A1.^2);
        case 'logsig', dZ1 = dA1 .* (A1 .* (1 - A1));
        case 'relu', dZ1 = dA1; dZ1(Z1<=0) = 0;
        case 'purelin',dZ1 = dA1;
        otherwise, dZ1 = dA1; % fallback
    end

    G.dW1 = dZ1 * X' + lambda * P.W1;
    G.db1 = sum(dZ1, 2) + lambda * P.b1;
end

% Apartado 5
function L = crossentropy_loss(Y, T)
    % Entropía cruzada media por muestra
    % Y: C x N, T: C x N (one-hot)
    n = size(T,2);
    L = -sum(T.*log(Y + 1e-12), 'all') / n;
end

function acc = accuracy_cls(Yhat, Y)
% Accuracy: argmax(prob) vs argmax(target one-hot)
    [~, pred]  = max(Yhat, [], 1);
    [~, true_] = max(Y,    [], 1);
    acc = mean(pred == true_);
end