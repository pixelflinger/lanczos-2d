clear;      % Clear workspace variables

D = 256;    % Dimension of the image
step = 8;   % Step for the comb pattern

image = zeros(D, D); % Initialize image matrix
nails = zeros(D, D); % Initialize comb matrix (nails pattern)

% Create the comb pattern (sampling grid)
for i = 1:step:D
    for j = 1:step:D
        nails(j, i) = 1;
    end
end

% Create the image pattern (a centered square)
for i = 1:D
    for j = 1:D
        image(j, i) = (abs(j - D/2) < D/4) & (abs(i - D/2) < D/4);
    end
end

% Perform 2D Fast Fourier Transforms
Fi = fftshift(fft2(image));          % FFT of the original image
Fn = fftshift(fft2(nails));          % FFT of the comb pattern
F  = fftshift(fft2(image .* nails)); % FFT of the sampled image

% Calculate magnitudes
magnitude_Fi = abs(Fi) * (1/D)^2;
magnitude_Fn = abs(Fn) * (step/D)^2;
magnitude_F  = abs(F)  * (step/D)^2;

% Define the linear mapping function (using an anonymous function)
mapLinear = @(x, in_min, in_max, out_min, out_max) ...
            (x - in_min) ./ (in_max - in_min) .* (out_max - out_min) + out_min;

% --- Plotting ---
figure(1); clf; % Create figure 1 and clear it

% Set colormap to grayscale with gamma correction
colormap(gray(256).^(1/2.2));

% Define locations for axis ticks (in pixel coordinates)
locations = 1 : (D-1)/8 : D;

% Map these locations to the desired frequency range labels
labels_num = mapLinear(locations, 1, D, -0.5*step, 0.5*step);

% Convert numerical labels to strings for setting tick labels
labels_str = string(labels_num);

% Define units string with LaTeX formatting for axes
units = '$(\times 2\pi)\ rad / pixel$';

tiledlayout(3,2, ...
    "Padding", "compact", ...
    "TileSpacing","compact");

% Subplot 1: Image
nexttile;
imagesc(image, [0,1]);
axis image;
title('Image');
ax = gca;
ax.XMinorTick = "on";
ax.YMinorTick = "on";
ax.TickDir = "out";

% Subplot 2: FFT(Image)
nexttile;
imagesc(magnitude_Fi, [0,1]);
axis image;
title('FFT(Image)');
xlabel(units, 'Interpreter', 'latex'); % Add label with LaTeX rendering
ylabel(units, 'Interpreter', 'latex');
ax = gca; % Get current axes handle
ax.XTick = locations; % Set custom tick positions
ax.YTick = locations;
ax.XTickLabel = labels_str; % Set custom tick labels
ax.YTickLabel = labels_str;
ax.XMinorTick = "on";
ax.YMinorTick = "on";
ax.TickDir = "out";

% Subplot 3: Comb Pattern
nexttile;
imagesc(nails, [0,1]);
axis image;
title('Comb');
ax = gca;
ax.XMinorTick = "on";
ax.YMinorTick = "on";
ax.TickDir = "out";

% Subplot 4: FFT(Comb Pattern)
nexttile;
imagesc(magnitude_Fn, [0,1]);
axis image;
title('FFT(Comb)');
xlabel(units, 'Interpreter', 'latex');
ylabel(units, 'Interpreter', 'latex');
ax = gca;
ax.XTick = locations;
ax.YTick = locations;
ax.XTickLabel = labels_str;
ax.YTickLabel = labels_str;
ax.XMinorTick = "on";
ax.YMinorTick = "on";
ax.TickDir = "out";

% Subplot 5: Sampled Image
nexttile;
imagesc(image .* nails, [0,1]);
axis image;
title('Sampled');
ax = gca;
ax.XMinorTick = "on";
ax.YMinorTick = "on";
ax.TickDir = "out";

% Subplot 6: FFT(Sampled Image)
nexttile;
imagesc(magnitude_F, [0,1]);
axis image;
title('FFT(Sampled)');
xlabel(units, 'Interpreter', 'latex');
ylabel(units, 'Interpreter', 'latex');
ax = gca;
ax.XTick = locations;
ax.YTick = locations;
ax.XTickLabel = labels_str;
ax.YTickLabel = labels_str;
ax.XMinorTick = "on";
ax.YMinorTick = "on";
ax.TickDir = "out";

