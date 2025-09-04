%% Setup
clc; clear all; close all; format compact

%% Parameters
beta = 0.005;
mu = 0.1;
gamma = .3;
time_int = 0:.1:15;
N = 500;

params = [beta, gamma, mu, N];

%% Initial Conditions
So = 900;
Io = 100;
Ro = 0;
Eo = 0;
alpha = 2.1;
latency = 1/alpha;


init = [So; Io; Ro];

[T1, Y1] = ode45(@(T, Y) SIR(T, Y, params), time_int, init);

%% Plotting

figure();
plot(T1, Y1(:, 2), 'DisplayName', '\alpha_1: ' + string(round(latency, 2)));
grid on
legend()
title("I(t)");

%% SIR ODE
function dY = SIR(t, Y, params)
    beta = params(1);
    gamma = params(2);
    mu = params(3);
    N = params(4);

    S = Y(1);
    I = Y(2);
    R = Y(3);

    dS = mu*(N-S) - beta*I*S;
    dI = beta*I*S - (gamma + mu)*I;
    dR = gamma*I - mu*R;

    dY = [dS; dI; dR];

end












% alphas = [2.1, 1.5, 1, .5];
% figure();
% grid on
% legend()
% title("I(t)");
% hold on
% for i = 1:length(alphas)
%     alpha = alphas(i);
%     %% Simulation
%     latency = 1/alpha;
%
%     init = [So; Io; Ro];
%     alpha = 2.1;
%     [T1, Y1] = ode45(@(T, Y) funcs(T, Y, params), time_int, init);
%
%     %% Plotting
%
%     plot(T1, Y1(:, 2), 'DisplayName', '\alpha_1: ' + string(round(latency, 2)));
%
% end
% hold off
%
