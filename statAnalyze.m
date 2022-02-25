function [outputArg] = statAnalyze(inputArg)
% [outputArg] = statAnalyze(inputArg)
% Gives general statistical description of inputArg.
% Notice: only performs on the third axis.
% INPUT: inputArg
% OUTPUT:
%     Page 1: mean
%     Page 2: standard deviation
%     Page 3: range
outputArg = zeros(size(inputArg, 1), size(inputArg, 2), 3);
outputArg(:, :, 1) = mean(inputArg, 3);
outputArg(:, :, 2) = std(inputArg, 1, 3);
outputArg(:, :, 3) = max(inputArg, [], 3) - min(inputArg, [], 3);
outputArg = squeeze(outputArg);
end