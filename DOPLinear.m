clc;
clear all;
close all;

%**************************************************************************
% Figure 2: semilogx
% 5 samples: 0.5 nM, 1 nM, 2 nM, 5 nM, 10 nM
% 6 positions
%**************************************************************************
figure;
% Initialize the loading
fileAddress = "C:\Users\openit\Desktop\Pre-Thesis\Nanoparticles\degreeOfPolarization.xls";

sample = strings(8, 2);
for i = 1:1:2
    sample(:, i) = ["Water"; "0.5 nM"; "1 nM"; "2 nM"; "5 nM"; "10 nM"; "Ref"; "Blank"];
end
sampleNum = strings(8, 2);
for i=1:1:8
    sampleNum(i, :) = ["1" "2"];
end
sheetName = sample + " (" + sampleNum + ")";

% Load data
concentration = [0 0.5 1 2 5 10];
data = zeros(6, 8, 2, 100);
for i = 1:1:8
    for j = 1:1:2
        degreeOfPolarization = readtable(fileAddress, 'Sheet', sheetName(i, j), 'ReadVariableNames', true);
        data(:, i, j, :) = flip(rot90(degreeOfPolarization{:, :}, 1));
    end
end

% Initialize the plotting
titleName = ["0", "45", "90", "135", "RC", "LC"];
rowNum = 3;
colNum = 2;
temp = 1:1:rowNum*colNum;
indexSubplotByColumn = rem(floor((rowNum*colNum + 1)/rowNum.*(temp - 1) + 1), rowNum*colNum);
indexSubplotByColumn(end) = rowNum*colNum;

for i = 1:1:6
    % Feed data into parameter & calculate statistics
    parameter = squeeze(data(i, :, :, :));
    parameter_stat = statAnalyze(parameter);
    % Plot
    ax = subplot(rowNum, colNum, i);
    errorbar(ax, concentration, parameter_stat(1:6, 1, 1), parameter_stat(1:6, 1, 2),'LineWidth',2);
    hold on;
    errorbar(ax, concentration, parameter_stat(1:6, 2, 1), parameter_stat(1:6, 2, 2),'LineWidth',2);
    errorbar(ax, 12, parameter_stat(7, 1, 1), parameter_stat(7, 1, 2),'LineWidth',2);
    errorbar(ax, 14, parameter_stat(8, 1, 1), parameter_stat(8, 1, 2),'LineWidth',2);
    set(ax, 'XScale', 'log');
    legend('Sample 1', 'Sample 2', 'Ref', 'Blank');
    title(titleName(i), 'FontSize', 12);
    xlabel('Concentration (nM)');
    ylabel('%');
    hold off;
end



%**************************************************************************
% Figure 3: linear
% 8 samples: Water, 0.5 nM, 1 nM, 2 nM, 5 nM, 10 nM, Ref, Blank
% 6 positions
%**************************************************************************
figure;
% Initialize the loading
fileAddress = "C:\Users\openit\Desktop\Pre-Thesis\Nanoparticles\degreeOfPolarization.xls";

sample = strings(8, 2);
for i = 1:1:2
    sample(:, i) = ["Water"; "0.5 nM"; "1 nM"; "2 nM"; "5 nM"; "10 nM"; "Ref"; "Blank"];
end
sampleNum = strings(8, 2);
for i=1:1:8
    sampleNum(i, :) = ["1" "2"];
end
sheetName = sample + " (" + sampleNum + ")";

% Load data
concentration = [0 0.5 1 2 5 10];
data = zeros(6, 8, 2, 100);
for i = 1:1:8
    for j = 1:1:2
        degreeOfPolarization = readtable(fileAddress, 'Sheet', sheetName(i, j), 'ReadVariableNames', true);
        data(:, i, j, :) = flip(rot90(degreeOfPolarization{:, :}, 1));
    end
end

% Initialize the plotting
titleName = ["0", "45", "90", "135", "RC", "LC"];
rowNum = 3;
colNum = 2;
temp = 1:1:rowNum*colNum;
indexSubplotByColumn = rem(floor((rowNum*colNum + 1)/rowNum.*(temp - 1) + 1), rowNum*colNum);
indexSubplotByColumn(end) = rowNum*colNum;

for i = 1:1:rowNum*colNum
    % Feed data into parameter & calculate statistics
    parameter = squeeze(data(i, :, :, :));
    parameter_stat = statAnalyze(parameter);
    % Plot
    ax = subplot(rowNum, colNum, i);
    errorbar(ax, concentration, parameter_stat(1:6, 1, 1), parameter_stat(1:6, 1, 2),'LineWidth',2);
    hold on;
    errorbar(ax, concentration, parameter_stat(1:6, 2, 1), parameter_stat(1:6, 2, 2),'LineWidth',2);
    errorbar(ax, 12, parameter_stat(7, 1, 1), parameter_stat(7, 1, 2),'LineWidth',2);
    errorbar(ax, 14, parameter_stat(8, 1, 1), parameter_stat(8, 1, 2),'LineWidth',2);
    legend('Sample 1', 'Sample 2', 'Ref', 'Blank');
    title(titleName(i), 'FontSize', 12);
    xlabel('Concentration (nM)');
    ylabel('%');
    hold off;
end