clc; close all; clearvars
%{
Need to add the extra bits at the end of each linkage
%}
L = 5;
l = 1;
link1 = linkage('r', L, l, 'r');
link2 = linkage('l', L, l, 'k');

%% Plotting
% figure()
% axis equal
% axis padded
% grid on
% link.plotLinkage(pi/2)

%% Animating
xmin = -L-1;
xmax = 1;
ymin = -l-1;
ymax = L+1;

figure()
hold on
fill([xmin xmin xmax  xmax], [-1 0 0 -1], 'b', 'FaceAlpha', .5);
axis equal
axis padded
axis([xmin, xmax, ymin, ymax]);

offset = pi/20;
thetas = linspace(pi/2 - offset, pi/2 + offset, 250);

for i = 1:numel(thetas)
    link1 = link1.plotLinkage(thetas(i));
    link2.basePosition = link1.endPosition;
    link2 = link2.plotLinkage(pi-thetas(i));
    pause(.001);
    delete(link1.figs)
    delete(link2.figs)
end


