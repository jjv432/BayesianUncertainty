clc; clearvars; close all;
l = link();

F_loads = linspace(1, 1e5, 10);
% l.plotMultipleAngularChanges(F_loads);
l.animateLinkMultipleLoads(F_loads);