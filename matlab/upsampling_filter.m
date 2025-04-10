clear;

function y = kernel(x)
    y = Kernels.lanczos(2, x);
    %y = Kernels.triangle(1, x);
    %y = Kernels.gaussian(2.29, x);
end

N = 20;
S = 10;
D = 4;
U = D * 2;

rand("seed", 6);
sx = (0:1:N-1) + 0.5;
sy = rand(1, N);
x  = (0:0.1:N)';

k = kernel((sx-S)/D);
s = sy .* k;

colors = ["#0072BD" "#D95319" "#EDB120" "#77AC30"];

figure(2); 
clf();

tiledlayout(8,1, ...
    "Padding", "compact", ...
    "TileSpacing","compact");

R = 0;
RR=0;
KK=0;
for j=1:U
    nexttile;
    if (j==1)
        title("Temporal Upsampling filter", 'FontSize', 16)
    end
    color = colors(int16(j/2));
  
    i = int16((j - 1) / 2) + mod(j - 1, 2) * (D-1) + 1;

    yline(0);
    xline(0:D:N, 'LineWidth', 1, 'LineStyle','--');
    xline(S, 'LineStyle',':');
    hold on;
    ke_ = plot(x, kernel((x-S)/D), ...
        'LineWidth', 1, ...
            'Color', color); 
    
    u = sx(i:U:end);
    v = sy(i:U:end);

    k = kernel((u-S)/D);
    r = v .* k;

    stem(u, v, "filled", ...
        'Color', color);

    plot(u, r, ...
        'LineStyle','none', ...
        'Marker', 'o', ...
        'Color', color);

    stem(S, sum(r) / sum(k));

    R = R + sum(r) / sum(k);
    RR=RR+sum(r);
    KK=KK+sum(k);

    pr_ = stem(S, R/j, ...
        'Marker', '*', ...
        'LineStyle','none');

    % lgd = legend([ke_ pr_], ...
    %     'Frame ' + string(i), ...
    %     'Accumulated Sample ' + string(i));
    %     set(lgd, 'Interpreter', 'latex', 'Box','on');

    hold off;
    axis tight;
end
