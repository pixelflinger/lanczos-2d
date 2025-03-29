clear;

function H = hankel_transform(f, r, k)
  H = zeros(size(k));
  for i = 1:length(k)
    H(i) = integrate('f(r) .* besselj(0, k(i) .* r) .* r', 'r', 0, max(r));
  end
  H = 2 * %pi * H;
endfunction

// 1. Define your 2D isotropic function (using a function handle)
function y = isotropic_function_sinc(r)
    y = sinc(r .* %pi)
endfunction

// closed-form of the sinc fourier transform
function y = ftsinc(r)
    y = sqrt(%pi) ./ sqrt(%pi^2 - r.^2)
endfunction


// 2. Create the radial coordinate
r_max = 30; // Maximum radial distance (support)
num_points = 512; // Number of points
r = linspace(0, r_max, num_points);

// 4. Create the radial frequency axis
k_max = 2*%pi; // Maximum radial frequency
k = linspace(0, k_max, num_points);

// 5. Calculate the Hankel transform
F_k0 = hankel_transform(isotropic_function_sinc, r, k)';


// 6. Plot the Fourier transform (radial profile)
scf(0); clf();
plot(k,  [ftsinc(k)']); 
xlabel('Radial Frequency');
ylabel('Magnitude');
title('Radial sinc Frequency Profile');
hdl = legend("$sinc(\rho)$", %f);
hdl.font_size = 4;
