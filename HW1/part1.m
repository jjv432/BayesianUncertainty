%% Setup
clc; clearvars; close all; format compact

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

%% SIR
init_SIR = [So; Io; Ro];

[T, Y] = ode45(@(T, Y) SIR(T, Y, params), time_int, init_SIR);

%% Plotting
figure(1);
hold on
plot(T, Y(:, 2), 'DisplayName', 'SIR', 'Linewidth', 3);


%% SEIR
init_SEIR = [So; Io; Ro; Eo];
alphas = [1.1 2.1 6.1 12.1];

for i = 1:length(alphas)
    params(5) = alphas(i);
    [T, Y] = ode45(@(T, Y) SEIR(T, Y, params), time_int, init_SEIR);
    plot(T, Y(:, 2),'--', 'DisplayName', '\alpha: ' + string(alphas(i)), 'Linewidth', 1.5);
end

hold off
grid on
legend()
title("I(t)");


%% Discussion
type q1discussion.txt

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

%% SEIR ODE
function dY = SEIR(t, Y, params)
    beta = params(1);
    gamma = params(2);
    mu = params(3);
    N = params(4);
    alpha = params(5);

    S = Y(1);
    I = Y(2);
    R = Y(3);
    E = Y(4);

    dS = mu*(N-S) - beta*I*S;
    dE = beta*I*S - (alpha + mu)*E;
    dI = alpha*E - (gamma + mu)*I;
    dR = gamma*I - mu*R;

    dY = [dS; dI; dR; dE];

end