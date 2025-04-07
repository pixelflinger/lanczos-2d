% --- Parameters ---
fs = 10000;     % Sampling frequency (Hz) - Must be at least 2*F (Nyquist)
F  =  6000;     % Maximum frequency (Hz)
M  = 256;       % Number of frequency steps
N  = 512;       % Number of samples per frequency step

% --- Derived Parameters ---
dt = 1 / fs;             % Time step between samples (s)
T_step = N * dt;         % Duration of each fft
total_samples = M * N;   % Total number of samples in the signal
T = M * T_step;          % Total time

% --- Initialize Signal Array ---
t = (0:total_samples-1) * dt;
signal = linear_chirp(t, 0, T, F, 0);


% --- Calculate Waterfall FFT Data ---

% Initialize matrix to store FFT results (M rows, N/2+1 columns)
% We only store the positive frequencies (up to Nyquist)
waterfall_data = zeros(M, N/2);

% Process each frequency step (segment)
for i = 1:M
    % Extract the i-th segment from the signal
    start_idx = (i-1)*N + 1;
    end_idx = start_idx + N - 1;
    current_segment = signal(start_idx:end_idx);

    % Compute the FFT of the segment
    fft_result = fft(current_segment);

    % Calculate the magnitude (absolute value)
    fft_mag = abs(fft_result);

    % Keep only the first half (positive frequencies + DC)
    % FFT output is symmetric, so we discard the redundant negative frequencies
    fft_mag_positive = fft_mag(1:N/2);

    % Store the result in the waterfall matrix
    waterfall_data(i, :) = fft_mag_positive * (2/N);
end

% --- Prepare Axes for Plotting ---

% Frequency axis (horizontal) goes from 0 Hz to fs/2 Hz (Nyquist)
freq_axis = linspace(0, fs/2, N/2);

% Time axis (vertical) represents the start time of each segment
time_axis = (0:M-1) * T_step;

figure(1);
clf();

% Create axes, setting Units to pixels FIRST
ax = axes;

% Use imagesc as before for color scaling and plotting
imagesc(freq_axis, time_axis, waterfall_data);

% force correct aspect ratio
daspect(ax, [fs/N T_step 1]);

set(ax, 'YDir', 'normal');
xlabel(ax, 'Frequency (Hz)', 'FontSize', 16);
ylabel(ax, 'Time (s)', 'FontSize', 16);
title(ax, 'Chirp Fourier Transform (Waterfall)', 'FontSize', 16);
colorbar(ax, 'FontSize', 12);
ax.XMinorTick = "on";
ax.YMinorTick = "on";
ax.TickDir = "out";
