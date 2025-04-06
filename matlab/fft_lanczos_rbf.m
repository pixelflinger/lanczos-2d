% Clear workspace
clear;

% Create the radial coordinate
r_max = 30; % Maximum radial distance (support)
num_points = 512; % Number of points
r = linspace(0, r_max, num_points);

% Create the radial frequency axis
k_max = 2*pi; % Maximum radial frequency
k = linspace(0, k_max, num_points);

% Calculate the Hankel transforms
F_k0 = Kernels.step(k, pi)';
F_k1 = hankel_transform(@isotropic_function_lanczos2, r, k)';
F_k2 = hankel_transform(@isotropic_function_lanczos3, r, k)';

% Plot the Fourier transform (radial profile)
figure(1); clf; 
plot(k, [abs(F_k0) abs(F_k1) abs(F_k2)], 'LineWidth', 1); 
xlabel('Radial Frequency (radian/length)', 'FontSize', 16);
ylabel('Magnitude', 'FontSize', 16);
title('Fourier Transform (Radial Profile)', 'FontSize', 16);
lgd = legend('$ideal$', '$lanczos-2$', '$lanczos-3$', 'Location', 'best');
set(lgd, 'Interpreter', 'latex', 'FontSize', 20, 'Box', 'off');
grid on;
grid minor;

% --- Isotropic function definitions used by hankel_transform ---

function y = isotropic_function_lanczos2(r)
    y = Kernels.lanczos(2, r);
end

function y = isotropic_function_lanczos3(r)
    y = Kernels.lanczos(3, r);
end

