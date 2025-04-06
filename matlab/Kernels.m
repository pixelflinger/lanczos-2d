classdef Kernels
    methods (Static)
        function y = step(x, cutoff_k)
            y = zeros(size(x));
            y(x < cutoff_k) = 1;
        end
        
        function y = sinc(x)
            v = pi * x;
            y = sin(v) ./ v;
            y(x==0) = 1;
        end

        function w = sinc2(x, y)
            w = Kernels.sinc(x) .* Kernels.sinc(y);
        end

        function y = jinc(x)
            y = besselj(1, pi * x) ./ (pi * x);
            y(x == 0) = 0.5; 
        end

        function w = jinc2(x, y)
            r = sqrt(x.^2 + y.^2);
            w = Kernels.jinc(r);
        end

        function y = lanczos(n, x)
            y = Kernels.sinc(x) .* Kernels.sinc(x/n);
            y(abs(x)>n) = 0;
        end

        function y = janczos(n, r)
            y = pi * Kernels.jinc(r) .* Kernels.jinc(r/n);
            y(abs(r)>n) = 0;
        end
        
        function y = triangle(n, x)
            y = (1 - abs(x) / n) / (pi * n^2 / 3);
            y(abs(x)>n) = 0;
        end
        
        function y = rectangle(n, x)
            y = 1 / (pi * n^2);
            y(abs(x)>n) = 0;
        end

        function y = gaussian(n, x)
            w = sqrt(n / pi);
            y =  w * exp(-a * (x.^2));
        end

        function y = blackmanharris(N, x)
            x = x - N / 2;
            a0 = 0.35875;
            a1 = 0.48829;
            a2 = 0.14128;
            a3 = 0.01168;
            w = 1 / (N * a0);
            y = w * (a0 - a1 * cos(2*pi*x / N) + a2 * cos(4*pi*x / N) - a3 * cos(6*pi*x / N));        
            y(abs(x + N/2) >= N/2) = 0;
        end
    end
end
