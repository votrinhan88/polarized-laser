function [angleCase, angleMean, angleStd, angleRange] = examineAngle(angle)
% examineAngle returns quick analysis of the angle variable
% [angleCase, angleMean, angleStd, angleRange] = examineAngle(angle)
% INPUT:
%     angle: angle variable to be examined, in degrees, can be of any dimension
% OUTPUT:
%     angleCase:
%         1: stable
%         2: unstable
%         3: highly unstable
%         4: extremely unstable
%         5: seperated at edge
%     angleMean: mean of all values in angle
%     angleStd: standard deviation of all values in angle
%     angleRange: range of all values in angle

angleRange = max(angle) - min(angle);
angleMean = mean(angle);
angleStd = std(angle);

% Define case conditions
if (angleRange >= 10)
    if (angleRange >= 150)
        if (min(angle(angle >= 90)) - max(angle(angle < 90)) >= 10)
            angleCase = 5;              % angle seperated at edge
        else
            angleCase = 4;              % extremely unstable
        end
    else
        angleCase = 3;                  % highly unstable
    end
else
    if (angleStd >= 1.8)
        angleCase = 2;                  % unstable
    else
        angleCase = 1;                  % stable
    end
end

switch angleCase
    case 1
        fprintf("Signal is stable.\nMean = %.6f\t\tStd = %.6f\t\tRange = %.6f\n\n", angleMean, angleStd, angleRange);
    case 2
        fprintf("Signal is unstable.\nMean = %.6f\t\tStd = %.6f\t\tRange = %.6f\n\n", angleMean, angleStd, angleRange);
    case 3
        fprintf("Signal is highly unstable.\nMean = %.6f\t\tStd = %.6f\t\tRange = %.6f\n\n", angleMean, angleStd, angleRange);
    case 4
        fprintf("Signal is extremely unstable.\nMean = %.6f\t\tStd = %.6f\t\tRange = %.6f\n\n", angleMean, angleStd, angleRange);
    case 5
        fprintf("Angle is seperated in different quarters after calculating arc<fun>.\nMean = %.6f\t\tStd = %.6f\t\tRange = %.6f\nShift quarters and recalculate.\n", angleMean, angleStd, angleRange);
        toBeShifted = (angle < 90);
        angle(toBeShifted) = (angle(toBeShifted) + 180);
        % Feedback
        [angleCase, angleMean, angleStd, angleRange] = examineAngle(angle);
    otherwise
end

end