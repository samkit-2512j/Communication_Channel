function [rc,time_axis] = raised_cosine_2(a,m,length)
length_os = floor(length*m); %number of samples on each side of peak
%time vector (in units of symbol interval) on one side of the peak
z = cumsum(ones(length_os,1))/m;
A= sin(pi*(1-a)*z)./(z); %term 1
B= 4*a*cos(pi*(1+a)*z); %term 2
C= (1 - (4*a*z).^2)*pi; %term 3
zerotest = m/(4*a); %location of zero in denominator
%check whether any sample coincides with zero location
if (zerotest == floor(zerotest))
    % B(zerotest) = pi*a;
    % C(zerotest) = 4*a;
%alternative is to perturb around the sample
%(find L’Hospital limit numerically)
A(zerotest) = sin(pi*(1-a)*(z(zerotest)+0.001))/(z(zerotest)+0.001); %term 1
B(zerotest) = 4*a*cos(pi*(1+a)*(z(zerotest)+0.001));
C(zerotest) = (1 - (4*a*(z(zerotest)+0.001)).^2)*pi;
end
D = (A+B)./C; %response to one side of peak
rc = [flipud(D);1;D]; %add in peak and other side
rc(length_os+1) = (4*a + pi*(1-a))/pi  ;
time_axis = [flipud(-z);0;z];
end