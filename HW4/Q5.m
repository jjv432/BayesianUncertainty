clc; clearvars; close all
c = [2 1];


sigma = [1, 3];
% Eqn 9.29
for i = 1:2
    D(i) = c(i)^2 * sigma(i)^2;
end

% Eqn 9.18
S = D/sum(D)

D
