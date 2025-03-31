clear;

m = 8;
inc = 0.125;
[x, y] = meshgrid(-m:inc:m, -m:inc:m);
f = sinc2d(x, y);

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
title('$sinc(x) \times sinc(y)$', 'FontSize', 24, 'Interpreter', 'latex');
axis tight
grid on;
grid minor;

% --- Helper Function Definitions ---

function y = sinc(x)
    v = pi * x;
    y = sin(v) ./ v;
    y(x==0) = 1;
end

function w = sinc2d(x, y)
    w = sinc(x) .* sinc(y);
end
