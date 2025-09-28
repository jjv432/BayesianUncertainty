function [s_model] = spring_damper_function_Dolzyk(param,t) %parameters that can be inferred and time
C = param(1);
wn = param(2);
yo = param(3);

z = sqrt(wn^2-C*C/4);

s_model = yo*exp(-C*t/2).*cos(z*t);
s_model = s_model(:);

end

