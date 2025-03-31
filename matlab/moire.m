clear;

ssaa_factor = 16;

% Define the plane equation: ax + by + cz + d = 0
plane_n = [0 1 0];
plane_o = 0;

% Camera parameters
% Camera Position (eye)
eye = [0 1 0];

% Look-at point (center of view) -  A point *on* the plane is a good choice.
%  We can find one by setting x and y to 0 and solving for z (or any other combination).
lookat = [5 0 10];

% Up vector
up = [0 1 0];

% Field of view (in degrees)
fov_deg = 60;
fov = fov_deg * pi / 180;

% Image dimensions
image_width  = 640 * ssaa_factor;
image_height = 480 * ssaa_factor;

% Aspect ratio
aspect_ratio = image_width / image_height;

% Near and far clipping planes (not strictly necessary for an infinite plane,
% but useful for setting the viewing volume)
near_clip = 0.1;
far_clip = 1000;

% --- Calculate camera coordinate system ---
% 1. Calculate the 'n' vector (view direction):  (eye - lookat)
n = eye - lookat;
n = n / norm(n);

% 2. Calculate the 'u' vector (right): cross product of (up, n)
u = cross(up, n);
u = u / norm(u);

% 3. Calculate the 'v' vector (up in camera space): cross product of (n, u)
v = cross(n, u);

% --- Perspective Projection and Rasterization ---

% Create an image matrix (initialize to background color - e.g., white)
image = ones(image_height, image_width);

% Checkerboard size
checker_size = 0.125;

% Iterate through each pixel in the image
for i = 1:image_height
    for j = 1:image_width
        % Calculate the screen space coordinates (x_s, y_s)
        %    These are normalized coordinates in the range [-1, 1]
        x_s = (2 * (j / image_width) - 1) * tan(fov / 2) * aspect_ratio;
        y_s = (1 - 2 * (i / image_height)) * tan(fov / 2);

        % Create a ray in camera space (origin at (0,0,0), direction (x_s, y_s, -1))
        ray_dir = x_s * u + y_s * v - n;
        ray_dir = ray_dir / norm(ray_dir);

        % Intersect the ray with the plane
        denominator = dot(plane_n, ray_dir);

        % Check for parallel rays (no intersection)
        if abs(denominator) < 1e-6
            image(i, j) = 200;
            continue;
        end

        t = -(dot(plane_n, eye) + plane_o) / denominator;

        % Check if the intersection is behind the camera (t < 0) or beyond the far clip
        if t < near_clip || t > far_clip 
            image(i, j) = 200;
            continue;
        end
        

        % 5. Calculate the intersection point in world space
        intersect = eye + t * ray_dir;

        % 6.  Checkerboard pattern
        %     Use the intersection point's x and z coordinates for the pattern.
        %     We're essentially projecting the checkerboard pattern from the XZ plane
        %     onto our arbitrary plane.
        checker_x = floor(intersect(1) / checker_size);
        checker_z = floor(intersect(3) / checker_size);
        if mod(checker_x + checker_z, 2) == 0
            image(i, j) = 255;
        else
            image(i, j) = 0;
        end
    end
end

if (ssaa_factor > 1)
    image = lanczos3_filter(image, 2, ssaa_factor);
    image = image(1:ssaa_factor:image_height, 1:ssaa_factor:image_width);
    image_width  = image_width  / ssaa_factor;
    image_height = image_height / ssaa_factor;
end

% --- Display the image ---

if ssaa_factor == 1
    figure(1); 
    title_str = 'No Antialiasing';
else
    figure(2); 
    title_str = sprintf('Antialiasing %dx', ssaa_factor^2);
end

clf();
imshow(image, [0 255], 'Border', 'tight');
colormap(gray(256).^(1/2.2));
title(title_str, 'FontSize', 16);
axis image; % Fit the axes bounds tightly around the data

% --- Helper Function Definitions ---

function y = sinc(x)
    if (x == 0)
        y = 1;
    end
    y = sin(x)/x;
end

function y = lanczos(n, x)
    if abs(x) > n
        y = 0;
        return
    end
    y = sinc(pi.*x).*sinc(pi.*x/n);
end

function smoothed_image = lanczos3_filter(image, n, ssaa_factor)
    image = double(image);
    
    % Create the 1D Kernel
    kernel_size = (n * 2) * ssaa_factor;
    kernel1d = zeros(1, kernel_size);
    for i = 1:kernel_size
        kernel1d(i) = lanczos(n, (i - (kernel_size / 2 + 0.5)) ./ ssaa_factor);
    end

    % Normalize the 1D Kernel
    kernel1d = kernel1d / sum(kernel1d);

    % No Padding - Calculate Valid Convolution Region
    [rows, cols] = size(image);

    % Separable Convolution (Without Padding)
    temp_image = zeros(rows, cols);
    for i = 1:rows
      temp_image(i, :) = conv(image(i, :), kernel1d, "same");
    end

    smoothed_image = zeros(rows, cols);
    for j = 1:cols
      smoothed_image(:, j) = conv(temp_image(:, j), kernel1d', "same")';
    end

    smoothed_image = max(1, smoothed_image);
end

