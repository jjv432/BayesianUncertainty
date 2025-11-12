clc; clear all; close all;

addpath("src");

%% Get the Ideal response to define cost

global idealM
idealKS = 200;
idealKD = 2;
idealM= 10;

[yIdeal, tIdeal] = getResponse(idealKS, idealKD);

%% Define Fixed Point
fixedPoint = [0.0497, 0.0007, 2.9654e-07, 0.0581, 0.0100];

% dF/d(th_i) such that F is the cost function

%% Begin Finite Diff

delta = .0001;
numTestPoints = 100; % MUST BE EVEN

% Each row is a param, each column is a test point
% ! Shoudl really be numTP - 1 b/c th_i duplicated
Costs = zeros(numel(fixedPoint), numTestPoints -1);
testPointMatrix = [];

for i = 1:numel(fixedPoint) % Each parameter
    th_test = fixedPoint; % ensure that it remains the same

    th_i = th_test(i);
    min = th_i - delta*th_i;
    max = th_i + delta*th_i;

    th_i_plus = linspace(th_i, max, numTestPoints/2);
    th_i_minus = linspace(min, th_i, numTestPoints/2);

    testPoints = [th_i_minus, th_i_plus(2:end)];
    testPoints(testPoints <=0) = 1e-12;

    testPointMatrix = [testPointMatrix; testPoints];

    for j = 1:numel(testPoints) % Each test point for cur param
        th_test(i) = testPoints(j); % Test the point

        Costs(i, j) = ModelSimulationCost(th_test, yIdeal);

    end

end

S = zeros(numel(fixedPoint), numTestPoints -2);
for k = 1:(numTestPoints -2)
    S(:, k) = (Costs(:, k+1) - Costs(:, k)) / delta;
end

paramNames = {'L', 't', 'w', 'r', "\alpha"};
figure('WindowState','maximized')
for a = 1:numel(fixedPoint)
    subplot(3, 2, a);
    plot(testPointMatrix(a, 2:end), S(a, :), 'k', "LineWidth", 3)
    ylabel("S (\theta_" + string(a) + ")", 'fontweight', 'bold');
    xlabel(paramNames(a), 'fontweight', 'bold');
    grid on
    ax = gca; % Get the current axes object
    ax.FontSize = 14;
end
% sgtitle('Local Sensitivities');
saveas(gcf, "Reports/LocalSens.jpg");

%% Cost Function
function Cost = ModelSimulationCost(fP, yIdeal)

    s = newSpring(fP(1), fP(2), fP(3), fP(4));
    s.kRatio = fP(5);
    s.predictKD();

    y = getResponse(s.ks, s.kd);

    Cost = sum( (y - yIdeal).^2 );

end