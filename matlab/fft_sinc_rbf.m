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

function H = hankel_transform(f_handle, r_values, k_values)
    % Calculates the 0-th order Hankel transform using numerical integration.
    % f_handle: Handle to the isotropic function f(r)
    % r_values: Vector of radial points where f(r) is defined/sampled
    % k_values: Vector of radial frequencies where the transform is desired
    H = zeros(size(k_values)); % Initialize output
    r_max = max(r_values);     % Upper integration limit (support of f(r))
    
    % Loop through each desired frequency k
    for i = 1:length(k_values)
        current_k = k_values(i);
        
        % Define the integrand for the current k: f(r) * J0(k*r) * r
        integrand = @(r) f_handle(r) .* besselj(0, current_k .* r) .* r;
        
        % Perform numerical integration from 0 to r_max
        % 'ArrayValued', true can speed up integration if f_handle is vectorized
        H(i) = integral(integrand, 0, r_max, 'ArrayValued', true);
    end
    H = 2 * pi * H; % Multiply by 2*pi convention
end

% --- Isotropic function definitions used by hankel_transform ---

function y = isotropic_function_sinc(r)
    y = Kernels.sinc(r);
end

