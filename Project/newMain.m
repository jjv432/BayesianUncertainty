clc; clearvars; close all;

L = 4;
t = 1;
w = 1; 
r = 1;

s = newSpring(L, t, w, r);
s.makeCoords;
s.fillCoords