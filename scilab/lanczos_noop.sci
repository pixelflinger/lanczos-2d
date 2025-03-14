clear;

function y = lanczos(n, x)
    y = sinc(%pi.*x).*sinc(%pi.*x/n)
    y(abs(x)>n) = 0;
endfunction

N = 8;
S = 4;

rand("seed", 6);
sx = 0:1:N-1;
sy = rand(1, N);
x=[0:0.1:N]';

scf(0); clf();
gcf().color_map = hsv(N);
title("Lanczos-2")

plot(x, lanczos(2, x-S) .* sy(S+1), 'LineWidth', 2, 'Color', 'red'); 

plot(sx, sy, '.', 'MarkerSize', 10, 'LineWidth', 2);


for i = 1:size(sx, '*')
    u = sx(i);
    v = sy(i);
    plot([u, u], [0, v], '--');
//    //plot(x, lanczos(2, x-u) .* sy(u+1), 'LineWidth', 2, 'Color', i+1); 
end
drawaxis(x=-10:10, y=0, dir='d', sub_int=0, format_n=" ");
