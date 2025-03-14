clear;

D = 128
step = 4

image = zeros(D, D);
nails = zeros(D, D);
filtered = zeros(D, D);

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


for i=[0:D-1]
    for j=[0:D-1]
        u = (i / D) * step - step/2;
        v = (j / D) * step - step/2;        
        if (abs(u) < 0.5 && abs(v) < 0.5)
        //if (u*u+v*v < 0.25)
            filtered(j+1, i+1) = F(j+1,i+1)
        end
    end
end

filtered = ifftshift(filtered);


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

subplot(221), Matplot(nails.*image.*256);
title("Sampled");
 
subplot(222), Matplot(magnitude_F.*256);
title("FFT(Sampled)");
xlabel(units);
ylabel(units);
ax = gca();
ax.x_ticks = ticks;
ax.y_ticks = ticks;

subplot(223), Matplot((abs(ifft(filtered)).* step^2).*256);
title("Reconstructed");
 
subplot(224), Matplot((abs(fftshift(filtered)).*(step/D)^2).*256);
title("FFT(Sampled * Ideal Filter)");
xlabel(units);
ylabel(units);
ax = gca();
ax.x_ticks = ticks;
ax.y_ticks = ticks;

