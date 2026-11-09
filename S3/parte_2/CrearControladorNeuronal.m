close all;
clear;
load('datos_control.mat');
rng(1); % semilla fija: misma red que la red 1 del barrido (comprobacion_neuronas.m)
net = feedforwardnet([15]);
net = configure(net,inputs,outputs);
net = train(net,inputs,outputs);
gensim(net,Ts)