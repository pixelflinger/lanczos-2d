clear;

D = 128
step = 4

image = zeros(D, D);
nails = zeros(D, D);

for i=[1:step:D]
    for j=[1:step:D]
        nails(j,i) = 1
    end
end

for i=[1:D]
    for j=[1:D]
        image(j,i) = (abs(j-D/2)<D/4 && abs(i-D/2)<D/4)
    end
end

Fi = fftshift(fft(image));
Fn = fftshift(fft(nails));
F  = fftshift(fft(image.*nails));

magnitude_Fi = abs(Fi) * (   1/D)^2;
magnitude_Fn = abs(Fn) * (step/D)^2;
magnitude_F  = abs(F ) * (step/D)^2;

function y = mapLinear(x, in_min, in_max, out_min, out_max)
    y = (x - in_min) ./ (in_max - in_min) .* (out_max - out_min) + out_min;
endfunction

scf(0); clf();
gcf().color_map = gray(256).^(1/2.2);

locations = [1 : (D-1)/8 : D];
labels = mapLinear(locations, 1, D, -0.5*step, 0.5*step);
ticks = tlist(["ticks", "locations", "labels", "interperters"], locations, string(labels));
units = "$(\times 2\pi)\ rad / pixel$";

subplot(321), Matplot(image.*256);
title("Image");
 
subplot(322), Matplot(magnitude_Fi.*256);
title("FFT(Image)");
xlabel(units);
ylabel(units);
ax = gca();
ax.x_ticks = ticks;
ax.y_ticks = ticks;


subplot(323), Matplot(nails.*256);
title("Comb");
 
subplot(324), Matplot(magnitude_Fn.*256);
title("FFT(Comb)");
xlabel(units);
ylabel(units);
ax = gca();
ax.x_ticks = ticks;
ax.y_ticks = ticks;

subplot(325), Matplot(nails.*image.*256);
title("Sampled");
 
subplot(326), Matplot(magnitude_F.*256);
title("FFT(Sampled)");
xlabel(units);
ylabel(units);
ax = gca();
ax.x_ticks = ticks;
ax.y_ticks = ticks;

