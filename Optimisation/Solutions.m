clc
clear
%Objective function coefficients
f = [3,-1,4];

%Comparing and writing the coefficients from the standard form of the expressions

%Inequality constraint values
A = [1,0,1 ; 0,-1,-2];
a = [2;-1];

%Equality constraint values
B = [1,1,-1];
b = 0;

%Upper and lower bounds
lb = [-10;-10;-10];
ub = [10 ;10 ;10];

[x fval] = linprog(f,A,a,B,b,lb,ub)

%The condition in the question says all three variables need to be integers
intcon = [1 2 3];

[x fval] = intlinprog(f,intcon,A,a,B,b,lb,ub)

%%the objective value is within a gap tolerance of the optimal value. 
% The values found in the first part using linprog() are identical with the
% values found in the second part using intlinprog() function.

%% Question 2
clc
clear
%production rates for rowboats, canoes and kayaks
syms x1 x2 x3;
x = [x1 ;x2 ;x3];

%Coefficients determining the cash flows for the products
a = [750 , 300 , 400];
b = [12 , 5 , 17];

%Revenue function
H1 = [-24,0,0 ; 0,-10,0 ; 0,0,-34]; 
T =  0.5*x'*H1*x + a*x; 

%Cost Function
cp = [22,35,40];
cf = 1000;

R = [5 1 0; 4 2 6; 1 2 4];
y = R*x;
cm = [12 20 7]*y + 0.5*y'*[-0.05 0 0; 0 -0.01 0; 0 0 -0.08]*y;
ctot = cp*x + cf + cm;

%Profit function
%%Maximising f(x) is equivalent to minimising -f(x)
P = T - ctot;

expr = simplify(P);

H_min = 2*[-2251/200, 49/100  ,  14/25 
            0       , -959/200,  19/25
            0       , 0       ,  -809/50];
H_max = -1*H_min;

f_min = [581, 199, 212];
f_max = -1*f_min;

% constraints
%%upper bound values found from y = Rx <= [35;100;70]
ub_values = R\[35;100;70]; 

%%inequality parameters
A = [1,1,1];
b_ineq = 24;

% Minimising -f(x) implies maximising f(x)
[p_rates profit] = quadprog(H_max,f_max,A,b_ineq,[],[],[],ub_values)
fprintf("Rowboats production rate is %d units per day\n" + ...
    "Canoes production rate is %d units per day\n" + ...
    "Kayaks production rate is %d units per day\n" + ...
    "Total Production rate is %d <= 24\n",floor(p_rates(1)),floor(p_rates(2)),floor(p_rates(3)), ...
    floor(p_rates(1)) + floor(p_rates(2)) + floor(p_rates(3)))

% Profit
op_profit = -(profit + 1000); % -f(x) needs to be maximised. 
fprintf("The optimum profit is %s\n",op_profit)

%% Question3

%%Two sections for this question for (a) and (b)
clc
clear
% Defining bounds for the optimization problem
lb = [-50 -50];  % Lower bounds for x and y
ub = [50 50];    % Upper bounds for x and y

% Seting the GA options
options = optimoptions('ga', ...
    'PopulationSize', 10, ...
    'MaxGenerations', 400, ...
    'Display', 'off');  % Turn off display for each iteration

% Storing the solutions from 100 runs
%%Allocating space for 100 solutions
solutions = zeros(100, 2);  

%%Running GA for 100 runs in order to minimise the hills function
for i = 1:100
    minPoint = ga(@(x) hills(x), 2, [], [], [], [], lb, ub, [], options);
    solutions(i, :) = minPoint;  
end

% Creating a contour plot of the 'hills' function
xrange = linspace(-10, 10, 100);  % X-axis range for the contour plot
yrange = linspace(-10, 10, 100);  % Y-axis range for the contour plot
[X, Y] = meshgrid(xrange, yrange);  % Create a grid of x and y values
Z = zeros(size(X));  % Preallocate space for Z values

% Evaluate 'hills' at each point in the grid
for i = 1:size(X, 1)
    for j = 1:size(X, 1)
        Z(i, j) = hills([X(i, j), Y(i, j)]);
    end
end

% Plotting contour plot of the function
figure;
contour(X, Y, Z, 20);  % Create a contour plot with 20 levels. Contour lines resemble closely to the given plot in the question
hold on;

% Plotting the solutions found by GA as red scatter starry points
scatter(solutions(:, 1), solutions(:, 2), 50, 'r', '*');

%The points are too close to each other. As such, not visible
%distinctly. A modification shown below can make the clustered points
%become visible
%jitter = 0.01 * randn(size(solutions));
%scatter(solutions(:, 1)+ jitter(:, 1), solutions(:, 2)+ jitter(:, 2), 80, 'r', '*');

xlabel('X-coordinate');
ylabel('Y-coordinate');
title('Contour Plot of Hills Function and GA Solutions');


%%

% Allocating space for values for each crossover method
crossover_scattered = zeros(100, 1);
crossover_intermediate = zeros(100, 1);
crossover_arithmetic = zeros(100, 1);

% Setting the GA options for crossoverscattered
scattered_options = optimoptions('ga', ...
    'PopulationSize', 10, ...
    'MaxGenerations', 400, ...
    'CrossoverFcn', @crossoverscattered, ...
    'Display', 'off'); 

% Running GA for crossoverscattered 100 times
for i = 1:100
    [~, fval] = ga(@(x) hills(x), 2, [], [], [], [], lb, ub, [], scattered_options);
    crossover_scattered(i) = fval;  
end

% Setting the GA options for crossoverintermediate
intermediate_options = optimoptions('ga', ...
    'PopulationSize', 10, ...
    'MaxGenerations', 400, ...
    'CrossoverFcn', @crossoverintermediate, ...
    'Display', 'off');

% Running GA for crossoverintermediate 100 times
for i = 1:100
    [~, fval] = ga(@(x) hills(x), 2, [], [], [], [], lb, ub, [], intermediate_options);
    crossover_intermediate(i) = fval;
end

% Setting the GA options for crossoverarithmetic
arithmetic_options = optimoptions('ga', ...
    'PopulationSize', 10, ...
    'MaxGenerations', 400, ...
    'CrossoverFcn', @crossoverarithmetic, ...
    'Display', 'off');

% Running GA for crossoverarithmetic 100 times
for i = 1:100
    [~, fval] = ga(@(x) hills(x), 2, [], [], [], [], lb, ub, [], arithmetic_options);
    crossover_arithmetic(i) = fval;
end

% Plotting the values for each crossover function using boxchart
figure;


title('Comparison of Crossover Functions Using GA');

% Group the data into one matrix and plotting with corresponding labels
function_values= [crossover_scattered, crossover_intermediate, crossover_arithmetic];

boxchart(function_values);
xticklabels({'Scattered','Intermediate','Arithmetic'})
xlabel('Crossover Function');
ylabel('Fitness Value');
title('Comparison of Crossover Functions Using GA');

%%The scatter crossover function has the most number of outliers i.e., the
% points lying outside the whiskers.
%%The arithmetic crossover function gives a consistent lower value of median
% fitness value
%%The arithmetic crossover function gives a consistent lower value of spread
% i.e., the size of the box which represents the variability in the fitness
% values.