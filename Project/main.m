clc; close all; clearvars
L = 5;
l = 1;
link = linkage('r', L, l);
% 
% figure()
% axis equal
% axis padded
% grid on
% link.plotLinkage(pi/2)

figure()
axis equal
xlim([-L-1, L+1])
ylim([-L-1, L+1])
thetas = linspace(0, pi/2, 100);
link.animateLinkage(thetas);