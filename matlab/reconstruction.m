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

filtered = zeros(D, D);
for i = 0:D-1
    for j = 0:D-1
        u = (i / D) * step - step/2;
        v = (j / D) * step - step/2;        
        if (abs(u) < 0.5 && abs(v) < 0.5)
            filtered(j+1, i+1) = F(j+1,i+1);
        end
    end
end

filtered = ifftshift(filtered);

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

tiledlayout(2,2, ...
    "Padding", "compact", ...
    "TileSpacing","compact");

% Comb Pattern
nexttile;
imagesc(nails, [0,1]);
axis image;
title('Comb');
ax = gca;
ax.XMinorTick = "on";
ax.YMinorTick = "on";
ax.TickDir = "out";

% FFT(Comb Pattern)
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
imagesc(abs(ifft2(filtered)).* step^2, [0,1]);
axis image;
title('Reconstructed');
ax = gca;
ax.XMinorTick = "on";
ax.YMinorTick = "on";
ax.TickDir = "out";

% Subplot 6: FFT(Sampled Image)
nexttile;
imagesc(abs(fftshift(filtered)).*(step/D)^2, [0,1]);
axis image;
title('FFT(Sampled * Ideal Filter)');
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

