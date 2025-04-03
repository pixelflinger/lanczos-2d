clear;

function y = kernel(x)
    y = Kernels.lanczos(2, x);
    %y = Kernels.triangle(1, x);
end

N = 20;
S = 10;
D = 4;

rand("seed", 6);
sx = (0:1:N-1) + 0.5;
sy = rand(1, N);
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

figure(2); 
clf();

tiledlayout(4,1, ...
    "Padding", "compact", ...
    "TileSpacing","compact");

R = 0;
for i=1:D
    nexttile;
    if (i==1)
        title("Temporal Antialiasing filter", 'FontSize', 16)
    end
    yline(0);
    xline(0:D:N, 'LineWidth', 1, 'LineStyle','--');
    xline(S, 'LineStyle',':');
    hold on;
    ke_ = plot(x, kernel((x-S)/D), ...
        'LineWidth', 1, ...
            'Color', colors(i)); 
    
        u = sx(i:D:end);
        v = sy(i:D:end);

        k = kernel((u-S)/D);
        r = v .* k;
    
        stem(u, v, "filled", ...
            'Color', colors(i));
    
        plot(u, r, ...
            'LineStyle','none', ...
            'Marker', 'o', ...
            'Color', colors(i));

        stem(S, sum(r) / sum(k));

        R = R + sum(r) / sum(k);

        pr_ = stem(S, R/i, ...
            'Marker', '*', ...
            'LineStyle','none');

        lgd = legend([ke_ pr_], ...
            'Frame ' + string(i), ...
            'Accumulated Sample ' + string(i));
        set(lgd, 'Interpreter', 'latex', 'Box','on');

    hold off;
    axis tight;
end
