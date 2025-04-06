% Calculates the 0-th order Hankel transform using numerical integration.
% f_handle: Handle to the isotropic function f(r)
% r_values: Vector of radial points where f(r) is defined/sampled
% k_values: Vector of radial frequencies where the transform is desired

function H = hankel_transform(f_handle, r_values, k_values)
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
