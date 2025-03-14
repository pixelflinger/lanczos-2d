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


m=12;
inc=0.125;
[x, y] = meshgrid(-m:inc:m, -m:inc:m);
f = jinc(x, y) .* (%pi/2);

F = fftshift(fft2(f));

magnitude_F = abs(F) * inc^2;

[rows, cols] = size(f);
fx = (-cols/2:cols/2-1) / (cols * inc);
fy = (-rows/2:rows/2-1) / (rows * inc);
[FX, FY] = meshgrid(fx, fy);

scf(0); clf();
gcf().color_map = jet(100);

//subplot(121), 
surf(x(1,:),y(:,1),f);
//colorbar;
xlabel('x');
ylabel('y');
title('jinc(x,y) Filter');
//gca().rotation_angles=[20 20];

//subplot(122), surf(fx, fy, magnitude_F); 
//colorbar;
//xlabel('Frequency (fx)');
//ylabel('Frequency (fy)');
//title('2D Fourier Transform');

