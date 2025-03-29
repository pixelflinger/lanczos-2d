clear;

function w = jinc(x, y)
    r = sqrt(x.^2 + y.^2)
    w = besselj(1, %pi * r)./(%pi * r)
    w(r == 0) = 0.5; 
endfunction

function w = sinc2d(x, y)
    r = sqrt(x.^2 + y.^2)
    w = sinc(%pi * r)
endfunction


scf(0); clf();
x=[-10:0.1:10]';
plot(x, [(%pi/2).*jinc(x, 0) sinc2d(x, 0)]), title("$jinc\ vs.\ sinc$", "fontsize", 4)
hdl = legend("$\frac{\pi}{2}jinc$", "$sinc$", %f);
hdl.font_size = 4;
drawaxis(x=-10:10, y=0, dir='d', sub_int=0, format_n=" ");

