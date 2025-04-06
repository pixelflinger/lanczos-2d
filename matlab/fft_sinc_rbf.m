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
F_k0 = hankel_transform(@isotropic_function_sinc, r, k)';

% Plot the Fourier transform (radial profile)
figure(1); clf; 
plot(k, ftsinc(k)'); 
xlabel('Radial Frequency (radian/length)', 'FontSize', 16);
ylabel('Magnitude', 'FontSize', 16);
title('Radial sinc Frequency Profile', 'FontSize', 16);
lgd = legend('$sinc(\rho)$', 'Location', 'best');
set(lgd, 'Interpreter', 'latex', 'FontSize', 20, 'Box', 'off');
grid on;
grid minor;

% --- Helper Function Definitions ---

% closed-form of the sinc fourier transform
function y = ftsinc(r)
    y = sqrt(pi) ./ sqrt(pi^2 - r.^2);
end

% --- Isotropic function definitions used by hankel_transform ---

function y = isotropic_function_sinc(r)
    y = Kernels.sinc(r);
end

