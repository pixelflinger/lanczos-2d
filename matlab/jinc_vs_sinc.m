clear;

x = (-10:0.1:10)';

figure(1); clf();

plot(x, [(pi/2) .* Kernels.jinc2(x, 0) sinc2d(x, 0)], ...
    'LineWidth', 1);
yline(0);
ax = gca;
ax.FontSize = 14;
ax.XMinorTick = "on";
ax.YMinorTick = "on";


title("$jinc\ vs.\ sinc$", 'Interpreter','latex','FontSize', 20);

lgd = legend('$\frac{\pi}{2}jinc$', '$sinc$', 'Location', 'best');
set(lgd, 'Interpreter', 'latex', 'FontSize', 20, 'Box', 'off');

% grid on;
% grid minor;

% --- Helper Function Definitions ---

function w = sinc2d(x, y)
    r = sqrt(x.^2 + y.^2);
    w = Kernels.sinc(r);
end
