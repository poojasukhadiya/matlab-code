fis = mamfis('Name', 'intelligentflatagent');
fis.AndMethod = 'min';
fis.OrMethod = 'max';
fis.ImpMethod = 'min'; 
fis.AggMethod = 'max'; 
fis.DefuzzMethod = 'centroid';
% Add input variables
fis = addInput(fis, [0 50], 'Name', 'temp');
fis = addMF(fis, 'temp', 'trimf', [-10 0 10], 'Name', 'cold');
fis = addMF(fis, 'temp', 'trimf', [10 15 20], 'Name', 'ideal');
fis = addMF(fis, 'temp', 'trimf', [20 35 50], 'Name', 'hot');
fis = addInput(fis, [0 10], 'Name', 'lightlevel');
fis = addMF(fis, 'lightlevel', 'trimf', [0 2 3], 'Name', 'dark');
fis = addMF(fis, 'lightlevel', 'trimf', [2 4 6], 'Name', 'dim');
fis = addMF(fis, 'lightlevel', 'trimf', [6 8 10], 'Name', 'neutral');
fis = addMF(fis, 'lightlevel', 'trimf', [8 9 10], 'Name', 'VB');

fis = addInput(fis, [0 24], 'Name', 'daytime');
fis = addMF(fis, 'daytime', 'trimf', [0 4 10], 'Name', 'morning');
fis = addMF(fis, 'daytime', 'trimf', [10 15 17], 'Name', 'afternoon');
fis = addMF(fis, 'daytime', 'trimf', [17 21 24], 'Name', 'night');
% Add output variable
fis = addOutput(fis, [0 3], 'Name', 'AC');
fis = addMF(fis, 'AC', 'trimf', [0 0.5 1], 'Name', 'off');
fis = addMF(fis, 'AC', 'trimf', [1 1.5 2], 'Name', 'low');
fis = addMF(fis, 'AC', 'trimf', [1 2 2.5], 'Name', 'medium');
fis = addMF(fis, 'AC', 'trimf', [2 2.5 3], 'Name', 'high');
% Define the rules
ruleList = [
    % Temp, Light, Time, AC (Weight)
    1 1 1, 1, 1, 1;
    1 2 1, 1, 1, 1;
    1 3 1, 1, 1, 1;
    1 4 1, 2, 1, 1; 
    2 1 1, 2, 1, 1;
    2 2 1, 2, 1, 1;
    2 3 1, 2, 1, 1;
    2 4 1, 2, 1, 1;
    3 1 1, 3, 1, 1;
    3 2 1, 3, 1, 1;
    3 3 1, 4, 1, 1;
    3 4 1, 4, 1, 1;
    1 1 2, 1, 1, 1;
    2 2 2, 1, 1, 1;
    3 3 2, 2, 1, 1;
    1 4 2, 2, 1, 1;
    2 1 2, 2, 1, 1;
    3 2 2, 2, 1, 1;
    2 3 2, 2, 1, 1;
    2 4 2, 3, 1, 1;
    3 1 2, 3, 1, 1;
    3 2 2, 3, 1, 1;
    3 3 2, 4, 1, 1;
    3 4 2, 4, 1, 1;
    1 1 3, 1, 1, 1;
    1 2 3, 1, 1, 1;
    1 3 3, 1, 1, 1;
    1 4 3, 2, 1, 1;
    2 1 3, 2, 1, 1;
    2 2 3, 2, 1, 1;
    2 3 3, 3, 1, 1;
    2 4 3, 3, 1, 1;
    3 1 3, 3, 1, 1;
    3 2 3, 3, 1, 1;
    3 3 3, 4, 1, 1;
    3 4 3, 4, 1, 1;
];
fis = addRule(fis, ruleList);
% Display the FIS
fis

% Define input values
inputValues = [10, 7, 16]; % [Temperature, LightLevel, TimeOfDay]

% Evaluate the FIS
output = evalfis(fis, inputValues);

% Display the output
disp(['Air Conditioning Setting: ', num2str(output)]);

for i = 1:length(fis.input)
    figure;
    [x,mf] = plotmf(fis, 'input', i);
    plot(x, mf);
    title(['Input variable #' num2str(i)]);
end

for i = 1:length(fis.output)
    figure;
    [x,mf] = plotmf(fis, 'output', i);
    plot(x, mf);
    title(['Output variable #' num2str(i)]);
end
gensurf(fis, [1 2], 1);
title('Surface plot of AC based on inputs 1 and 2');
% Create an options object with 'NoDefuzz' set to true
options = evalfisOptions('NoDefuzz', true);

% Evaluate the FIS with these options
fuzzyOutput = evalfis(fis, inputValues, options);

% Display the fuzzy output
disp(['Fuzzy Output: ', num2str(fuzzyOutput)]);
