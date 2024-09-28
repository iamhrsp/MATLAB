function z = hills(points)
%   z = HILLS(X).
%   X is a n-by-2 matrix
%   z is a n-by-1 vector
%
%   if each row of X corresponds to 2D cartesian coordinates, z gives the
%   height of the surface (3rd coordinate in 3D space)
%
%   example
%   z = hills([1 3]) evaluates the function at point [1 3]. z is a scalar
%
%   z = hills([1 3;...
%              1 4;...
%              2 2]) evaluates the function at three points: [1 3], [1 4]
%              and [2 2]. z is a 3 element vector
x =(points(:,1))-10;

y =(points(:,2));

e1 = x-sin(2*x+3*y) - cos(3*x-5*y);
e2 = y-sin(x-2*y)+cos(x+ 3*y);

z = real((e1.^1.2+e2.^1.6)+0.1*x.^2+0.06*y.^2);
%z = z+5*rand(size(z));

end