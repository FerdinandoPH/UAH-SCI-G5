close all;
clear;
load('datos_control.mat');
net = feedforwardnet([15]);
net = configure(net,inputs,outputs);
net = train(net,inputs,outputs);
gensim(net,Ts)