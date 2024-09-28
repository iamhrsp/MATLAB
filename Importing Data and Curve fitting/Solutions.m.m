%% Question 1
clc;
clear;
% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["x_M", "y_M"];
opts.VariableTypes = ["double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
data = readtable("data_2022.csv", opts);
x = data.x_M;
x_val = (linspace(-10,100,701))'
y = data.y_M;
plot(x_val,y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fit: 'Linear model with a constant'.
[xData, yData] = prepareCurveData( x_val, y );

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'Linear model with a constant' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x_val', 'Linear model with a constant', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x_val', 'Interpreter', 'none' );
ylabel( 'y', 'Interpreter', 'none' );
grid on

% R-Squared value is 0.76881
% Adjusted R-squared value is 0.76848

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fit: 'Quadratic model'.
[xData, yData] = prepareCurveData( x_val, y );

% Set up fittype and options.
ft = fittype( 'poly2' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'Quadratic model' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x_val', 'Quadratic model', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x_val', 'Interpreter', 'none' );
ylabel( 'y', 'Interpreter', 'none' );
grid on

% R-Squared value is 0.88155
% Adjusted R-squared value is 0.88121

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fit: 'Fourth degree polynomial model'.
[xData, yData] = prepareCurveData( x_val, y );

% Set up fittype and options.
ft = fittype( 'poly4' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'Fourth degree polynomial model' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x_val', 'Fourth degree polynomial model', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x_val', 'Interpreter', 'none' );
ylabel( 'y', 'Interpreter', 'none' );
grid on

% R-Squared value is 0.88407
% Adjusted R-squared value is 0.88341

%%% cftool of MATLAB has been used to calculate the required values.
%%% It is desirable to have R-squared value as close to 1 as possible. Thus 
%   Fourth degree polynomial model gives the best fit for the data
%   provided.

%%% the quadratic model is expected to give the best description because 
%   the motion of a thrown ball under the influence of gravity follows a parabolic trajectory.
%   The square term in quadratic model captures this effect.

%%% Rsquare measures how well the model fits the data but does not restrict the fitting 
%   for noisy data. Even though, with higher model parameters (Quadratic to fourth degree in our case)
%   a higher value of R square may be achieved but this will lead to a poor model to describe the general phenomenon.
%   As can be seen in the third model that the curve slightly bends upwards fitting
%   the noisy data but digressing from the general phenomenon of a
%   trajectory despite having a higher Rsquared value.

%%% the adjusted Rsquare value lessens the effect of increasing parameters as
%%% depicted in its value across the three models

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear

%%generate script for importing the data from table
% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 9);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:I1828";

% Specify column names and types
opts.VariableNames = ["Date", "Measurer", "AverageTemperature", "MaximumTemperature", "MinimumTemperature", "AverageRelativeHumidity", "MaximumRelativeHumidity", "MinimumRelativeHumidity", "SolarRatio"];
opts.VariableTypes = ["datetime", "categorical", "double", "double", "double", "double", "double", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, "Measurer", "EmptyFieldRule", "auto");

% Import the data
weather = readtimetable("weather.xls", opts, "UseExcel", false, "RowTimes", "Date");

%%Permorming ANOVA1 test for each variable using a for loop. turned off the
%%box plot to avoid cluttering of results. It can be viewed by deleting the
%%"off" label from anova1() function.
variables = ["AverageTemperature","MaximumTemperature","MinimumTemperature","AverageRelativeHumidity","MaximumRelativeHumidity","MinimumRelativeHumidity","SolarRatio"];
for var = variables
    fprintf("Performing ANOVA1 test on : %s while grouping based on the measurer\n",var)
    p = anova1(weather.(var) , weather.Measurer, "off")
    if p < 0.05
        fprintf("Significant difference between the measured mean %s values by different measurers\n",var)
    else
        fprintf("No significant difference between the measured mean %s values by different measurers\n",var)
    end
end
%%p-value being greater than 0.05 suggests that there is no sound
%%evidence to reject the Null hypothesis. This means that there is no
%%statistically significant difference between the mean values recorded by different
%%observers or groups.

%% (b)
%Running Anova test while grouping the data based on the month of recording
%the observation.

clc
for var = variables
    fprintf("Performing ANOVA1 test on : %s while grouping by month of observation\n",var)
    p = anova1(weather.(var) , month(weather.Date), "off")
    if p < 0.05
        fprintf("Significant difference between the measured mean %s values across 12 months\n",var)
    else
        fprintf("No significant difference between the measured mean %s values across 12 months\n",var)
    end
end

%%Yes while grouping the data by months, there is a significant statistical
%%difference between the means. This is evident from the box graphs as well
%%which can be seen by deleting the the "off" label from the anova1(_)
%%function. Also p value is less than 0.05 which also signifies the
%%difference in the means of the observations recorded in 12 months.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc

a = readmatrix("lifetime.txt")
photons = a(:,1);
time = a(:,2);
plot(photons,time)

xlabel("No. of Photons")
ylabel("Time(ns)")
title("Florence lifetime of Rhodamine 6G")
%%
clc
[p,l] = findpeaks(time,"MinPeakProminence",70)

peakMatrix = [l p]
%plot(peakMatrix(:,1),peakMatrix(:,2))
%findpeaks(time,"MinPeakProminence",75)
decaydata_x1 = photons(57:319-10)
decaydata_y1 = time(57:319-10)
plot (decaydata_x1,decaydata_y1)
subplot(4,1,1)

decaydata_x2 = photons(319:584-10)
decaydata_y2 = time(319:584-10)
plot(decaydata_x2,decaydata_y2)
subplot(4,1,2)

decaydata_x3 = photons(584:852-10)
decaydata_y3 = time(584:852-10)
plot(decaydata_x3,decaydata_y3)
subplot(4,1,3)

decaydata_x4 = photons(852:end)
decaydata_y4 = time(852:end)
plot(decaydata_x4,decaydata_y4)
subplot(4,1,4)

%% Fit: 'decay1'.
[xData, yData] = prepareCurveData( decaydata_x1, decaydata_y1 );

% Detect peaks in the yData
[peaks, locs] = findpeaks(yData, 'MinPeakProminence', 0.1); % Adjust MinPeakProminence as needed


% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [173.754716461142 -0.381349381841543 8.53441255609202 0.0522703939273061];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'decay1' );
h = plot( fitresult, xData, yData );
legend( h, 'decaydata_y1 vs. decaydata_x1', 'decay1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'decaydata_x1', 'Interpreter', 'none' );
ylabel( 'decaydata_y1', 'Interpreter', 'none' );
grid on

%%
%% Fit: 'decay2'.
[xData, yData] = prepareCurveData( decaydata_x2, decaydata_y2 );

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [4892553514.72773 -1.1582037259274 46.8466115554179 -0.0341760433269804];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'decay2' );
h = plot( fitresult, xData, yData );
legend( h, 'decaydata_y2 vs. decaydata_x2', 'decay2', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'decaydata_x2', 'Interpreter', 'none' );
ylabel( 'decaydata_y2', 'Interpreter', 'none' );
grid on

%%

%% Fit: 'decay3'.
[xData, yData] = prepareCurveData( decaydata_x3, decaydata_y3 );

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [7067099.19043598 -0.405120271320403 2.97616474188136 0.0443008348539868];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'decay3' );
h = plot( fitresult, xData, yData );
legend( h, 'decaydata_y3 vs. decaydata_x3', 'decay3', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'decaydata_x3', 'Interpreter', 'none' );
ylabel( 'decaydata_y3', 'Interpreter', 'none' );
grid on

%%
%% Fit: 'decay4'.
[xData, yData] = prepareCurveData( decaydata_x4, decaydata_y4 );

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [2502567589772.07 -0.585771052279229 7.65999067250352 0.0192266924386489];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'decay4' );
h = plot( fitresult, xData, yData );
legend( h, 'decaydata_y4 vs. decaydata_x4', 'decay4', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'decaydata_x4', 'Interpreter', 'none' );
ylabel( 'decaydata_y4', 'Interpreter', 'none' );
grid on