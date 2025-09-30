clc; close all; clearvars
L = 5;
l = 1;
link1 = linkage('r', L, l);
link2 = linkage('l', L, l);
link1 = link1.defineCoords(pi/2);

%% Plotting
% figure()
% axis equal
% axis padded
% grid on
% link.plotLinkage(pi/2)

%% Animating
figure()
axis equal
axis padded
% xlim([-L-1, L+1])
% ylim([-L-1, L+1])
thetas = linspace(0, pi/2, 100);

for i = 1:numel(thetas)
    link1 = link1.plotLinkage(thetas(i));
    link2.basePosition = link1.endPosition;
    link2 = link2.plotLinkage(thetas(i));
    pause(.1);
    delete(link1.fig1)
    delete(link1.fig2)
    delete(link2.fig1)
    delete(link2.fig2)
end


