clear;

function y = kernel(x)
    y = Kernels.lanczos(2, x);
    %y = Kernels.triangle(1, x);
end

N = 10;
S = 5;
D = 2;

sx = (0:1:N-1) + 0.5;
sy = Kernels.step(sx, 3);
x  = (0:0.1:N)';

k = kernel((sx-S)/D);
s = sy .* k;

colors = ["#0072BD" "#D95319" "#EDB120" "#77AC30"];

figure(1); 
clf();

tiledlayout(1,1, ...
    "Padding", "compact", ...
    "TileSpacing","compact");

nexttile
title("Antialiasing filter", 'FontSize', 16)
yline(0);
pb_ = xline(0:D:N, 'LineWidth', 1, 'LineStyle','--');
xline(S, 'LineStyle',':');

hold on;

sm_ = stem(sx, sy, "filled", ...
    'Color', 'blue');

ke_ = plot(x, kernel((x-S)/D), ...
    'LineWidth', 1, ...
    'Color', 'red'); 

we_ = plot(sx, s, ...
    'LineStyle','none', ...
    'Marker', 'o', ...
    'Color', 'red'); 

re_ = stem(S, sum(s) / sum(k), ...
    'Color', 'red');

lgd = legend([pb_(1) sm_ ke_ re_ we_], ...
    'Pixel Boundary', ...
    'Hires Sample', ...
    'Filter weights', ...
    'Anti-aliased sample', ...
    'Weighted sample');
set(lgd, 'Interpreter', 'latex', 'Box','on');

%plot(x, kernel((x-sx)/D) .* sy); 

hold off;
axis tight;
