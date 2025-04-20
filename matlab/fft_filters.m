% Clear workspace
clear;

% Create the radial coordinate
r_max = 128; % Maximum radial distance (support)
num_points = 512; % Number of points
r = linspace(-r_max, r_max, num_points);

% Create the radial frequency axis
k_max = 2*pi; % Maximum radial frequency
k = linspace(0, k_max, num_points / 2);

% Calculate the Hankel transforms
F0 = Kernels.step(k, pi)';
F1 = ft(Kernels.lanczos(2, r));
F2 = ft(Kernels.lanczos2Approx(r));
F3 = ft(catmullrom(r));

% Plot the Fourier transform (radial profile)
figure(1); clf; 
plot(k, [F0 F1 F2 F3], 'LineWidth', 1); 
xlabel('Spatial Frequency (radian/length)', 'FontSize', 16);
ylabel('Magnitude', 'FontSize', 16);
title('Fourier Transform', 'FontSize', 16);
lgd = legend( ...
    '$ideal$', ...
    '$lanczos-2$', ...
    '$lanczos_{approx}$', ...
    '$catmull-rom$', ...
    'Location', 'best');
set(lgd, 'Interpreter', 'latex', 'FontSize', 20, 'Box', 'off');
grid on;
grid minor;


function y = ft(x)
    w = sum(x);
    F = abs(fft(x/w));
    y = F(1:size(F, 2)/2)';
end

function y = catmullrom(x)
    d = abs(x);
    a = ( 9*d.^3 - 15*d.^2        +  6) / 6;
    b = (-3*d.^3 + 15*d.^2 - 24*d + 12) / 6;
    y = b;
    y(abs(x)<1) = a(abs(x)<1);
    y(abs(x)>2) = 0;
end