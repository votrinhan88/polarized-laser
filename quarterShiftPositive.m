function [angle] = quarterShiftPositive(angle, toQuarter)
% angle = quarterShiftPositive(angle, toQuarter)
% Typically used after asind, acosd, atand, atan2d of MATLAB, when an angle
% needs to be shifted to the positive range.
% INPUT:
%     angle: angle to be shifted
%     toQuarter:
%         180: (for asind, acosd, atand) shift the values in the negative 
%             4th quarter (-90 to 0) to the positive 2nd quarter (90 to 180)
%             by adding 180 degrees.
%         360: (for atan2d) shift the values in the negative 3rd and
%             4th quarters (-180 to 0) to the positive 3rd and 4th quarters
%             (180 to 360) by adding 360 degrees.
% OUTPUT:
%     angle: the shifted version of angle

switch toQuarter
    case 180
        toBeShifted = ((angle >= -90) & (angle < 0));
        angle(toBeShifted) = angle(toBeShifted) + 180;
    case 360
        toBeShifted = ((angle >= -180) & (angle < 0));
        angle(toBeShifted) = angle(toBeShifted) + 360;
    otherwise
        disp('Invalid input of toQuarter. Type "help quarterShiftPositive" for more instruction.');
end

end

