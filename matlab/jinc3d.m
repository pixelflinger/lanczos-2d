m = 8;
inc = 0.125;
[x, y] = meshgrid(-m:inc:m, -m:inc:m);
f = Kernels.jinc2(x, y) .* (pi/2);

fig  = figure(1); 
fig.Position(3:4) = [1200 1000];

clf();

surf(x(1,:),y(:,1),f, 'FaceColor','interp');
ax = gca;
ax.FontSize = 16;
ax.LabelFontSizeMultiplier = 1.8;
xlabel('$x$', 'Interpreter', 'latex');
ylabel('$y$', 'Interpreter', 'latex');
zlabel('Amplitude');
title('$jinc(\rho)$', 'FontSize', 24, 'Interpreter', 'latex');
axis tight
grid on;
grid minor;
