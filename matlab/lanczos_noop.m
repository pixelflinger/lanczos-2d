clear;

N = 8;
S = 4;

rand("seed", 6);
sx = 0:1:N-1;
sy = rand(1, N);
x  = (0:0.1:N)';

figure(1); 
clf();
title("Lanczos-2", 'FontSize', 16)

hold on;

plot(x, Kernels.lanczos(2, x-S) .* sy(S+1), ...
    'LineWidth', 1, ...
    'Color', 'red'); 

stem(sx, sy, "filled", ...
    'Color', 'blue');

yline(0);

hold off;

grid on;
grid minor

