clc; clearvars; close all;

% All of these units are metric
L = .005;
t = .0005;
w = .001; 
r = .0005;

s = newSpring(L, t, w, r);

forces = linspace(0, 2, 10);
gca;
for i = 1:numel(forces)
    cla;
    s.th3Response(forces(i));
    s.fillCoords
    drawnow;
    
end

