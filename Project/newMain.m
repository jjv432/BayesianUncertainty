clc; clearvars; close all;

% All of these units are metric
L = .01;
t = .001;
w = .001; 
r = .004;
m = .25;

s = newSpring(L, t, w, r);
s.predictKD;


A = [0, 1; -s.ks/m, -s.kd/m];
B = [0; 1/m];
C = [1 0];
D = [0];

% offsets.dx = 0;
% offsets.u = 0;
% offsets.x = [0; -m*9.81];
% offsets.y = 0;
% sys = ss(A, B, C, D, 'Offsets', offsets);

sys = ss(A, B, C, D);

t = linspace(0, 10, 200);

u = -m*9.81*ones(numel(t), 1);

[y, t_out, x] = lsim(sys, u, t);

% plot displacement response
figure;
plot(t_out, y, 'LineWidth', 1.2)




%% OLD

% Constantly increasing F

% forces = linspace(0, 2, 10);
% gca;
% for i = 1:numel(forces)
%     cla;
%     s.th3Response(forces(i));
%     s.fillCoords
%     drawnow;
% 
% end

