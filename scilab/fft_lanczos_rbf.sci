clear;

function y = step(x, n)
    y(x<n) = 1;
    y(x>=n) = 0;
endfunction

function y = jinc(x)
    y = besselj(1, %pi * x)./(%pi * x)
    y(x == 0) = 0.5; 
endfunction

function y = janczos(n, x)
    if abs(x) > n then
        y = 0
        return
    end
    y = %pi*jinc(x).*jinc(x/n)
endfunction

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

function w = triangle(n, x)
    if abs(r) > n then
        w = 0
        return
    end
    w = (1 - abs(r) / n) / (%pi * n^2 / 3)
endfunction

function w = rectangle(n, x)
    if abs(r) > n then
        w = 0
        return
    end
    w = 1 / (%pi * n^2)
endfunction


function H = hankel_transform(f, r, k)
  H = zeros(size(k));
  for i = 1:length(k)
    H(i) = integrate('f(r) .* besselj(0, k(i) .* r) .* r', 'r', 0, max(r));
  end
  H = 2 * %pi * H;
endfunction

// 1. Define your 2D isotropic function (using a function handle)
function y = isotropic_function_jinc(r)
    y = (%pi/2).*jinc(r)
endfunction

function y = isotropic_function_janczos2(r)
    y = janczos(2, r)
endfunction

function y = isotropic_function_janczos3(r)
    y = janczos(3, r)
endfunction

function y = isotropic_function_tri2(r)
    y = triangle(1, r)
endfunction

function y = isotropic_function_rect2(r)
    y = rectangle(1, r)
endfunction

function y = isotropic_function_sinc(r)
    y = sinc(r .* %pi)
endfunction

function y = isotropic_function_lanczos2(r)
    y = lanczos(2, r)
endfunction

function y = isotropic_function_lanczos3(r)
    y = lanczos(3, r)
endfunction

// 2. Create the radial coordinate
r_max = 30; // Maximum radial distance (support)
num_points = 512; // Number of points
r = linspace(0, r_max, num_points);

// 4. Create the radial frequency axis
k_max = 2*%pi; // Maximum radial frequency
k = linspace(0, k_max, num_points);

// 5. Calculate the Hankel transform
F_k0 = step(k, %pi);
F_k1 = hankel_transform(isotropic_function_lanczos2, r, k)';
F_k2 = hankel_transform(isotropic_function_lanczos3, r, k)';


// 6. Plot the Fourier transform (radial profile)
scf(0); clf();
plot(k, [abs(F_k0) abs(F_k1) abs(F_k2)]); 
xlabel('Radial Frequency (k)');
ylabel('Magnitude');
title('Hankel Transform (Radial Profile)');
legend("ideal", "lanczos-2", "lanczos-3");
