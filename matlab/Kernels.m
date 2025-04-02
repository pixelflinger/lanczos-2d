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

        function y = janczos(n, x)
            y = pi * Kernels.jinc(x) .* Kernels.jinc(x/n);
            y(abs(x)>n) = 0;
        end
        
        function w = triangle(n, r)
            w = (1 - abs(r) / n) / (pi * n^2 / 3);
            w(abs(r)>n) = 0;
        end
        
        function w = rectangle(n, r)
            w = 1 / (pi * n^2);
            w(abs(r)>n) = 0;
        end
    end
end
