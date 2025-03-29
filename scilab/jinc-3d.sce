clear;

function y = lanczos(n, x)
    if abs(x) > n then
        y = 0
        return
    end
    y = sinc(%pi.*x).*sinc(%pi.*x/n)
endfunction

function w = lanczos2D(n, x, y)
    w = lanczos(n, x).*lanczos(n, y)
endfunction

function w = lanczos2Di(n, x, y)
    w = lanczos(n, sqrt(x.^2 + y.^2))
endfunction

function w = jinc(x, y)
    r = sqrt(x.^2 + y.^2)
    w = besselj(1, %pi * r)./(%pi * r)
    w(r == 0) = 0.5; 
endfunction

function w = sinc2d(x, y)
    r = sqrt(x.^2 + y.^2)
    w = sinc(%pi * r)
endfunction


m = 8;
inc = 0.125;
[x, y] = meshgrid(-m:inc:m, -m:inc:m);
f = jinc(x, y) .* (%pi/2);

F = fftshift(fft2(f));
magnitude_F = abs(F) * inc^2;

[rows, cols] = size(f);
fx = (-cols/2:cols/2-1) / (cols * inc);
fy = (-rows/2:rows/2-1) / (rows * inc);

scf(0); clf();
gcf().color_map = jet(100);
gcf().figure_size = [600, 600+98];

surf(x(1,:),y(:,1),f);
xlabel('$x$', 'fontsize', 4);
ylabel('$y$', 'fontsize', 4);
zlabel('A');
title('$jinc(\rho)$', 'fontsize', 4);
gca().box = "back_half";
xgrid;

