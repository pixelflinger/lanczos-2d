clear;

ssaa_factor = 1;

function y = lanczos(n, x)
    if abs(x) > n then
        y = 0
        return
    end
    y = sinc(%pi.*x).*sinc(%pi.*x/n)
endfunction

function y = lanczos3(x)
    y = lanczos(3, x./ssaa_factor)
endfunction

function smoothed_image = lanczos3_filter(image)
    // 1. Input Validation and Type Conversion
    if ~isreal(image) then
        error("Input image must be a real-valued matrix.");
    end
    if ~ismatrix(image) then
        error("Input must be a 2D matrix.");
    end
    image = double(image); // Ensure we work with doubles

    // 2. Define the Lanczos-3 Kernel (1D)

    // 3. Create the 1D Kernel
    kernel_size = (3*2)*ssaa_factor;
    kernel1d = zeros(1, kernel_size);
    for i = 1:kernel_size
        kernel1d(i) = lanczos3(i - (kernel_size / 2 + 0.5));
    end

    // 4. Normalize the 1D Kernel
    kernel1d = kernel1d / sum(kernel1d);

    // 5. No Padding - Calculate Valid Convolution Region
    [rows, cols] = size(image);

    // 6. Separable Convolution (Without Padding)
    temp_image = zeros(rows, cols); // Intermediate result
    for i = 1:rows
      // Apply horizontal convolution, but only keep the 'valid' part.
      temp_row = conv(image(i, :), kernel1d, "same");
      temp_image(i, :) = temp_row'; // Store valid part
    end

    smoothed_image = zeros(rows, cols); // Final result
    for j = 1:cols
      // Apply vertical convolution, keeping only the 'valid' part.
      temp_col = conv(temp_image(:, j), kernel1d', "same")';
      smoothed_image(:, j) = temp_col; // Store valid part
    end

    smoothed_image = max(1, smoothed_image)
  
    // 7. Return the smoothed image (smaller than the original)
endfunction


// Define the plane equation: ax + by + cz + d = 0
// Example:  x + 2y + z - 5 = 0
a = 0;
b = 1;
c = 0;
d = 0;

// Camera parameters
// Camera Position (eye)
eye_x = 0;
eye_y = 1;
eye_z = 0;

// Look-at point (center of view) -  A point *on* the plane is a good choice.
//  We can find one by setting x and y to 0 and solving for z (or any other combination).
lookat_x = 5;
lookat_y = 0;
lookat_z = 10;

// Up vector
up_x = 0;
up_y = 1;  // Standard up vector
up_z = 0;

// Field of view (in degrees)
fov_deg = 60;
fov = fov_deg * %pi / 180; // Convert to radians

// Image dimensions
image_width = 640*ssaa_factor;
image_height = 480*ssaa_factor;

// Aspect ratio
aspect_ratio = image_width / image_height;

// Near and far clipping planes (not strictly necessary for an infinite plane,
// but useful for setting the viewing volume)
near_clip = 0.1;
far_clip = 1000;

// --- Calculate camera coordinate system ---
// 1. Calculate the 'n' vector (view direction):  (eye - lookat)
n_x = eye_x - lookat_x;
n_y = eye_y - lookat_y;
n_z = eye_z - lookat_z;
n_mag = sqrt(n_x^2 + n_y^2 + n_z^2);
n_x = n_x / n_mag;
n_y = n_y / n_mag;
n_z = n_z / n_mag;

// 2. Calculate the 'u' vector (right): cross product of (up, n)
u_x = up_y * n_z - up_z * n_y;
u_y = up_z * n_x - up_x * n_z;
u_z = up_x * n_y - up_y * n_x;
u_mag = sqrt(u_x^2 + u_y^2 + u_z^2);
u_x = u_x / u_mag;
u_y = u_y / u_mag;
u_z = u_z / u_mag;

// 3. Calculate the 'v' vector (up in camera space): cross product of (n, u)
v_x = n_y * u_z - n_z * u_y;
v_y = n_z * u_x - n_x * u_z;
v_z = n_x * u_y - n_y * u_x;
// No need to normalize 'v', as 'n' and 'u' are already normalized and orthogonal.


// --- Perspective Projection and Rasterization ---

// Create an image matrix (initialize to background color - e.g., white)
image = ones(image_height, image_width);

// Checkerboard size
checker_size = 0.125; // Adjust for the size of the squares

// Iterate through each pixel in the image
for i = 1:image_height
    for j = 1:image_width
        // 1. Calculate the screen space coordinates (x_s, y_s)
        //    These are normalized coordinates in the range [-1, 1]
        x_s = (2 * (j / image_width) - 1) * tan(fov / 2) * aspect_ratio;
        y_s = (1 - 2 * (i / image_height)) * tan(fov / 2);

        // 2. Create a ray in camera space (origin at (0,0,0), direction (x_s, y_s, -1))
        ray_dir_x = x_s * u_x + y_s * v_x - n_x;
        ray_dir_y = x_s * u_y + y_s * v_y - n_y;
        ray_dir_z = x_s * u_z + y_s * v_z - n_z;
        
        // Normalize ray direction.
        ray_dir_mag = sqrt(ray_dir_x^2 + ray_dir_y^2 + ray_dir_z^2);
        ray_dir_x = ray_dir_x/ray_dir_mag;
        ray_dir_y = ray_dir_y/ray_dir_mag;
        ray_dir_z = ray_dir_z/ray_dir_mag;

        // 3. Transform the ray to world space
        //    Ray origin in world space: eye position
        ray_origin_x = eye_x;
        ray_origin_y = eye_y;
        ray_origin_z = eye_z;
        //    Ray direction is already in world space (calculated using u, v, n)

        // 4. Intersect the ray with the plane
        //    Plane equation: ax + by + cz + d = 0
        //    Ray equation:  P = O + tD  (where O is origin, D is direction, t is parameter)
        //    Substitute ray equation into plane equation:
        //    a(Ox + tDx) + b(Oy + tDy) + c(Oz + tDz) + d = 0
        //    Solve for t:
        //    t = -(aOx + bOy + cOz + d) / (aDx + bDy + cDz)

        denominator = a * ray_dir_x + b * ray_dir_y + c * ray_dir_z;

        // Check for parallel rays (no intersection)
        if abs(denominator) < 1e-6  // Use a small tolerance
            continue; // Skip this pixel
        end

        t = -(a * ray_origin_x + b * ray_origin_y + c * ray_origin_z + d) / denominator;

        // Check if the intersection is behind the camera (t < 0) or beyond the far clip
        if t < near_clip || t > far_clip 
            image(i, j) = 200;
            continue; // Skip this pixel
        end
        

        // 5. Calculate the intersection point in world space
        intersect_x = ray_origin_x + t * ray_dir_x;
        intersect_y = ray_origin_y + t * ray_dir_y;
        intersect_z = ray_origin_z + t * ray_dir_z;

        // 6.  Checkerboard pattern
        //     Use the intersection point's x and z coordinates for the pattern.
        //     We're essentially projecting the checkerboard pattern from the XZ plane
        //     onto our arbitrary plane.
        checker_x = floor(intersect_x / checker_size);
        checker_z = floor(intersect_z / checker_size);
        if modulo(checker_x + checker_z, 2) == 0
            image(i, j) = 256;
        else
            image(i, j) = 1;
        end
    end
end

if (ssaa_factor > 1) then
    image = lanczos3_filter(image);
    image = image(1:ssaa_factor:image_height, 1:ssaa_factor:image_width);
    image_width = image_width / ssaa_factor;
    image_height = image_height / ssaa_factor;
end

// --- Display the image ---
scf(0); clf();
//gcf().pixel_drawing = "on";
gcf().figure_size = [image_width/2, image_height/2+98];
gcf().color_map = gray(256).^(1/2.2);
Matplot(image);
title("Aliasing");
ax = gca();  // Get the current axes handle
ax.axes_visible(1) = "off"; // Hide the x-axis line
ax.axes_visible(2) = "off"; // Hide the y-axis line
ax.margins = [0, 0, 0, 0];
