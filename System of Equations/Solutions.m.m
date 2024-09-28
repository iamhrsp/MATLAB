%% Question 1   
% Submitted on MATLAB GRADER

%% Question 2
% (a)
clc
clear
 

x1 = linspace(-2,3,100);
f = sin(x1).^2 + 3.*cos(x1);

subplot(3,1,1);
plot(x1,f)
xlabel('x');
ylabel('f(x)');
grid on;

% (b)
x2 = linspace(-5,6,10);
y2 = linspace(-5,6,10);
[X2,Y2] = meshgrid(x2,y2);
g = X2.^3 - 6.*Y2.^2 + X2 - 1;

subplot(3,1,2);
surf(X2,Y2,g)
xlabel('x');
ylabel('y');
zlabel('g(x,y)');

% (c)

phi = linspace(0,2*pi,100);
r = 2 + cos(2.*phi);

subplot(3,1,3)
polarplot(phi,r)
title('Plot of r(\phi) = 2 + cos(2\phi)')

%% Question 3
clc
clear
close all 

N = 20000;
x =  2*rand(N,1) - 1;
y =  2*rand(N,1) - 1;

r = sqrt((x.^2) + (y.^2));

group = (r<=1);

gscatter(x,y,group,'rb','x.')
title('Blue points for r <=1 and red crosses for r > 1 ')

LessThan1 = sum(group)
%There are two groups. Group0 and Group1
%Sum will give the number of occurances of 1 which inturn represents the
%number of points inside the circle

p = 4*LessThan1/N

%With N = 2000, p value comes out to be 3.1080. 
% The variation from required value is 1.07% 
% while with N = 20000, the variation is only 0.46%

%% Question 4
clc
clear
close all 

theta = linspace(0,2*pi,100);
r = 3 - 3.*sin(theta) + (sin(theta).*sqrt(abs(cos(theta))))/(sin(theta)+1.4);

p = polarplot(theta,r);
p.Color = 'red';
p.LineWidth = 2;

f = @(phi) (3 - 3.*sin(phi) + (sin(phi).*sqrt(abs(cos(phi))))./(sin(phi)+1.4)).^2;
A = 0.5 * integral(f , 0 , 2*pi)

%% Question 5
clc 
clear
close all
u = linspace(0,6*pi, 100);
v = linspace(0,2*pi, 100);
[U,V] = meshgrid(u,v);
   %%%%%%%
x = @(U,V) 2.*(1-exp(U./(6*pi))).*cos(U).*cos(V./2).^2;
%The value of function x(u,v) is given by integralx
integralx = integral2(x, 0,6*pi, 0,2*pi)
evalFuncx = x(U,V);
subplot(3,1,1)
surf(U,V,evalFuncx)
title('Plot For function x(u,v)');
   %%%%%%%
y = @(U, V) 2.*(-1 + exp(U./(6*pi))).*sin(V).*cos(V./2).^2;
%The value of function y(u,v) is given by integraly
integraly = integral2(y, 0,6*pi, 0,2*pi)

evalFuncy = y(U,V);
subplot(3,1,2)
surf(U,V,evalFuncy)
camlight
title('Plot For function y(u,v)');

   %%%%%%%
z = @(U, V) 1 - exp(U./(3*pi)) - sin(V) + exp(U./(6*pi)).*sin(V);
%The value of function z(u,v) is given by integralz
integralz = integral2(z, 0,6*pi, 0,2*pi)


evalFuncz = z(U,V);
subplot(3,1,3)
surf(U,V,evalFuncz)
view(50,20)
colormap("jet")
shading interp
title('Plot For function z(u,v)');

%% Question 6
clc
clear
close all

function y = smoothstep(left,right,x);
x_sc = (x-left)./(right-left);
% x here is an array of elements. 
% y will also be of the same size as x
% Instead of using if-else-if Logical indexing is used here to define
% the piecewise function y based on the conditions for x
    
    % y = 0 for x < left
    y(x < left) = 0;
    
    % y = 1 for x > right
    y(x > right) = 1;
    
    % Only those x values are selected which lie between left and right
    x_indx = (x >= left) & (x <= right);
    % y is evaluated only for those normalised x_sc values whose x lies
    % between left and right limits.
    y(x_indx) = 3 * x_sc(x_indx).^2 - 2 .* x_sc(x_indx).^3;
end
  
x = linspace(-5,5,100);
left = -3;
right = 2;
y = smoothstep(-3,2,x);
p = plot(x,y)
grid on
p.LineWidth = 2;
p.Color = 'red';
xticks([-5 -3 0 2 5])

