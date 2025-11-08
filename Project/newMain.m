clc; clearvars; close all;

L = 4;
t = 1;
w = 1; 
r = 1;

s = newSpring(L, t, w, r);

thetas = linspace(pi/2, pi/2 * 1.2, 20);
gca;
for i = 1:numel(thetas)
    cla;
    s.th3 = thetas(i);
    s.fillCoords
    drawnow;
    
end

