clc; clearvars; close all;
%{
FIX THE PART WHERE K IS CALC'D => th3Response
There's still the issue of differing test forces giving different spring
constants. Idk
%}

% All of these units are metric
L = .05;
t = L * (1/10);
w = L * 10; 
r = L * (1/2.5);
m = 100;

s = newSpring(L, t, w, r);

s.predictKD();

A = [0, 1; -s.ks/m, -s.kd/m];
B = [0; 1/m];
C = [1 0];
D = [0];

sys = ss(A, B, C, D);

t = linspace(0, 10, 1000);

u = -m*9.81*ones(numel(t), 1);
iter = numel(t)/2;

% u(numel(t)/2 : end) = zeros(numel(t)/2 + 1, 1);
% u(iter) = u(iter).*2;

[y, t_out, x] = lsim(sys, u, t);

% plot displacement response
figure;
plot(t_out, y, 'LineWidth', 1.2)


figure;
for i = 1:numel(y)
    cla;
    s.inverseKinematics(y(i));
    s.fillCoords;
    drawnow;

end


%% OLD

% % Constantly increasing F
% 
% forces = linspace(0, 2, 10);
% gca;
% for i = 1:numel(forces)
%     cla;
%     s.th3Response(forces(i));
%     s.fillCoords
%     drawnow;
% 
% end

