% two input arguments- low , high
% two output arguments- x s. Out Arg behave just like local variables. No 
%scope outside the function. Notice the square brackets.
% If ";" used, function only echoes one first output argument. To echo all
%out arguments, assign the function to new variables using sq brackets in
%the command window

function [x,s] = MyRand(low, high) 
x = low+rand(3,4)*(high-low);
v = x(:); % creates a stacked up column vector of columns of matrix "a"
s = sum(v);
end