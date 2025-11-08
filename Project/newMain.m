clc; clearvars; close all;

% All of these units are metric
L = .01;
t = .001;
w = .001; 
r = .004;

s = newSpring(L, t, w, r);
s.predictKD;

forces = linspace(0, 2, 10);
gca;
for i = 1:numel(forces)
    cla;
    s.th3Response(forces(i));
    s.fillCoords
    drawnow;
    
end

