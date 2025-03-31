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

plot(x, lanczos(2, x-S) .* sy(S+1), ...
    'LineWidth', 1, ...
    'Color', 'red'); 

stem(sx, sy, "filled", ...
    'Color', 'blue');

yline(0);

hold off;

grid on;
grid minor

% --- Helper Function Definitions ---

function y = sinc(x)
    v = pi * x;
    y = sin(v) ./ v;
    y(x==0) = 1;
end

function y = lanczos(n, x)
    y = sinc(x).*sinc(x/n);
    y(abs(x)>n) = 0;
end
