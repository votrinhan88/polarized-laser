clc;
clear;
close all;

analyzeMode = true;

% "Water"; "0.5 nM"; "1 nM"; "2 nM"; "5 nM"; "10 nM"; "Ref"; "Blank"
sample = 'Blank';
% "1" "2"
sampleNum = '2';

address = "C:\Users\openit\Desktop\Pre-Thesis\Nanoparticles\" + sample + "\Sample " + sampleNum + "\";

% Measurements read from csv file: 11 parameters * 6 positions * 100 iterations
measurement = zeros(11, 6, 100);
position = ["0" "45" "90" "135" "RC" "LC"];
% Order from 1 to 6: 0, 45, 90, 135, RHS, LHS
for i = 1:1:6
    measurement(:, i, :) = flip(rot90(csvread (address + position(i) + ".csv", 24, 0,[24,0,123,10])), 1);
end

%**************************************************************************
% Stokes parameters
%**************************************************************************
% Stokes vector (S0, S1, S2, S3): 4 vector * 6 positions * 100 iterations
stokes = zeros(4, 6, 100);
% Order: S0, S1, S2, S3 respectively (Matlab indices starts from 1)
stokes(4, :, :) = measurement(11, :, :);
stokes(1, :, :) = measurement(11, :, :).*measurement(2, :, :);
stokes(2, :, :) = measurement(11, :, :).*measurement(3, :, :);
stokes(3, :, :) = measurement(11, :, :).*measurement(4, :, :);
% Degree of polarization
delta_p = measurement(9, :, :);


%**************************************************************************
% Mueller matrix
%**************************************************************************
% Mueller matrix (m11 --> m44): (4 x 4 matrix) * 100 iterations
mueller = zeros(4, 4, 100);
mueller(1, 1, :) = (1/2)*(stokes(4, 1, :) + stokes(4, 3, :));
mueller(1, 2, :) = (1/2)*(stokes(4, 1, :) - stokes(4, 3, :));
mueller(1, 3, :) = (1/2)*(stokes(4, 2, :) - stokes(4, 4, :));
mueller(1, 4, :) = (1/2)*(stokes(4, 5, :) - stokes(4, 6, :));

mueller(2, 1, :) = (1/2)*(stokes(1, 1, :) + stokes(1, 3, :));
mueller(2, 2, :) = (1/2)*(stokes(1, 1, :) - stokes(1, 3, :));
mueller(2, 3, :) = (1/2)*(stokes(1, 2, :) - stokes(1, 4, :));
mueller(2, 4, :) = (1/2)*(stokes(1, 5, :) - stokes(1, 6, :));

mueller(3, 1, :) = (1/2)*(stokes(2, 1, :) + stokes(2, 3, :));
mueller(3, 2, :) = (1/2)*(stokes(2, 1, :) - stokes(2, 3, :));
mueller(3, 3, :) = (1/2)*(stokes(2, 2, :) - stokes(2, 4, :));
mueller(3, 4, :) = (1/2)*(stokes(2, 5, :) - stokes(2, 6, :));

mueller(4, 1, :) = (1/2)*(stokes(3, 1, :) + stokes(3, 3, :));
mueller(4, 2, :) = (1/2)*(stokes(3, 1, :) - stokes(3, 3, :));
mueller(4, 3, :) = (1/2)*(stokes(3, 2, :) - stokes(3, 4, :));
mueller(4, 4, :) = (1/2)*(stokes(3, 5, :) - stokes(3, 6, :));


%**************************************************************************
% Linear diattenuation axis angle (theta), Linear diattenuation (D),
%   Circular diattenuation (R)
%**************************************************************************
% Linear diattenuation axis angle (theta)
c2 = atand(mueller(1, 3, :)./mueller(1, 2, :));
theta_d = (1/2)*c2;
% Linear diattenuation (D)
m114 = (mueller(1, 1, :).^2 - mueller(1, 4, :).^2).^(1/2);
D = zeros(2, 1, 100);
D(1, :, :) = mueller(1, 2, :)./(cosd(c2).*m114);
D(2, :, :) = mueller(1, 3, :)./(sind(c2).*m114);
%Circular diattenuation (R)
R = (mueller(1, 1, :) - m114)./mueller(1, 4, :);


%**************************************************************************
% Mueller matrix of Linear Dichroism: (4 x 4 matrix) * 100 iterations
%**************************************************************************
mueller_ld = zeros(4, 4, 100);

temp = 1./(1 + D(1, :, :));

mueller_ld(1, 1, :) = temp;
mueller_ld(1, 2, :) = (1 - temp).*cosd(c2);
mueller_ld(1, 3, :) = (1 - temp).*sind(c2);
mueller_ld(1, 4, :) = 0;

mueller_ld(2, 1, :) = mueller_ld(1, 2, :);
mueller_ld(2, 2, :) = (1/4).*((1 + sqrt(2.*temp - 1)).^2 + cosd(2.*c2).*(1 - sqrt(2.*temp - 1)).^2);
mueller_ld(2, 3, :) = (1/4).*sind(2.*c2).*(1 - sqrt(2.*temp - 1)).^2;
mueller_ld(2, 4, :) = 0;

mueller_ld(3, 1, :) = mueller_ld(1, 3, :);
mueller_ld(3, 2, :) = mueller_ld(2, 3, :);
mueller_ld(3, 3, :) = (1/4).*((1 + sqrt(2.*temp - 1)).^2 - cosd(2.*c2).*(1 - sqrt(2.*temp - 1)).^2);
mueller_ld(3, 4, :) = 0;

mueller_ld(4, 1, :) = 0;
mueller_ld(4, 2, :) = 0;
mueller_ld(4, 3, :) = 0;
mueller_ld(4, 4, :) = sqrt(2.*temp - 1);

%**************************************************************************
% Mueller matrix of Circular Dichroism: (4 x 4 matrix) * 100 iterations
%**************************************************************************
mueller_cd = zeros(4, 4, 100);
mueller_cd(1, 1, :) = 1 + R.^2;
mueller_cd(1, 2, :) = 0;
mueller_cd(1, 3, :) = 0;
mueller_cd(1, 4, :) = 2.*R;

mueller_cd(2, 1, :) = 0;
mueller_cd(2, 2, :) = 1 - R.^2;
mueller_cd(2, 3, :) = 0;
mueller_cd(2, 4, :) = 0;

mueller_cd(3, 1, :) = 0;
mueller_cd(3, 2, :) = 0;
mueller_cd(3, 3, :) = mueller_cd(2, 2, :);
mueller_cd(3, 4, :) = 0;

mueller_cd(4, 1, :) = mueller_cd(1, 4, :);
mueller_cd(4, 2, :) = 0;
mueller_cd(4, 3, :) = 0;
mueller_cd(4, 4, :) = mueller_cd(1, 1, :);

%**************************************************************************
% Mueller matrix of Diattenuation: (4 x 4 matrix) * 100 iterations
% Formula: mueller_D = mueller_ld * mueller_cd
%**************************************************************************
mueller_D = pagemtimes(mueller_ld, 'none', mueller_cd, 'none');


%**************************************************************************
% Solve the System of equations
%**************************************************************************
% Normalized Mueller matrix: (4 x 4 matrix) * 100 iterations
muellerNorm = mueller(:, :, :).*mueller_D(1, 1, :)./mueller(1, 1, :);

% Mueller matrix of Delta and R: (4 x 4 matrix) * 100 iterations
% Formula: mueller_delta_R = muellerNorm * inv(mueller_D)
% 						   = mueller_delta * mueller_R
mueller_D_inv = zeros(4, 4, 100);
for i = 1:1:100
    mueller_D_inv(:, :, i) = inv(squeeze(mueller_D(:, :, i)));
end

mueller_delta_R = pagemtimes(muellerNorm, 'none', mueller_D_inv, 'none');


%**************************************************************************
% Calculate final parameters using INVERSE MATRIX
% p1, p2, p3, alpha, beta, gamma, e1, e2, e3
%**************************************************************************
% p1, p2, p3
p1 = mueller_delta_R(2, 1, :);
p2 = mueller_delta_R(3, 1, :);
p3 = mueller_delta_R(4, 1, :);

% alpha + gamma
alpha_plus_gamma = (1/2).*atan2d(-mueller_delta_R(4, 2, :), mueller_delta_R(4, 3, :));
alpha_plus_gamma_shift = quarterShiftPositive(alpha_plus_gamma, 180);

% beta (calculated in two ways)
beta = zeros(2, 1, 100);
beta(1, :, :) = atan2d(mueller_delta_R(4, 3, :)./cosd(2.*alpha_plus_gamma), mueller_delta_R(4, 4, :));
beta(2, :, :) = atan2d(-mueller_delta_R(4, 2, :)./sind(2.*alpha_plus_gamma), mueller_delta_R(4, 4, :));
beta_shift = quarterShiftPositive(beta, 180);

% Buffer parameters to calculate alpha
F1 = (mueller_delta_R(2, 2, :).*mueller_delta_R(4, 2, :) + mueller_delta_R(2, 3, :).*mueller_delta_R(4, 3, :))./cosd(beta(1, :, :))./sind(beta(1, :, :));
F2 = (mueller_delta_R(2, 2, :).*mueller_delta_R(4, 3, :) - mueller_delta_R(2, 3, :).*mueller_delta_R(4, 3, :))./sind(beta(1, :, :));
F3 = (mueller_delta_R(3, 2, :).*mueller_delta_R(4, 3, :) - mueller_delta_R(3, 3, :).*mueller_delta_R(4, 2, :))./sind(beta(1, :, :));
F4 = (mueller_delta_R(3, 2, :).*mueller_delta_R(4, 2, :) + mueller_delta_R(3, 3, :).*mueller_delta_R(4, 3, :))./cosd(beta(1, :, :))./sind(beta(1, :, :));

% alpha (calculated in two ways)
alpha = zeros(2, 1, 100);
alpha(1, :, :) = (1/2).*atan2d(-F1, F2);
alpha(2, :, :) = (1/2).*atan2d(F3, F4);
alpha_shift = quarterShiftPositive(alpha, 180);

% Buffer parameters to calculate gamma
C1 = cosd(2.*alpha(1, :, :)).^2 + sind(2.*alpha(1, :, :)).^2.*cosd(beta(1, :, :));
C2 = cosd(2.*alpha(1, :, :)).*sind(2.*alpha(1, :, :)).*(1 - cosd(beta(1, :, :)));
C3 = sind(2.*alpha(1, :, :)).^2 + cosd(2.*alpha(1, :, :)).^2.*cosd(beta(1, :, :));

C_numerator_1 = -C2.*mueller_delta_R(2, 2, :) + C1.*mueller_delta_R(2, 3, :);
C_denominator_1 = C1.*mueller_delta_R(2, 2, :) + C2.*mueller_delta_R(2, 3, :);
C_numerator_2 = -C3.*mueller_delta_R(3, 2, :) + C2.*mueller_delta_R(3, 3, :);
C_denominator_2 = C2.*mueller_delta_R(3, 2, :) + C3.*mueller_delta_R(3, 3, :);

% gamma (calculated in three ways)
gamma = zeros(3, 1, 100);
gamma(1, :, :) = (1/2).*atan2d(C_numerator_1, C_denominator_1);
gamma(2, :, :) = (1/2).*atan2d(C_numerator_2, C_denominator_2);
gamma(3, :, :) = alpha_plus_gamma - alpha(1, :, :);
gamma_shift = quarterShiftPositive(gamma, 180);

% Mueller matrix of Linear Birefringence (4 x 4 matrix) * 100 iterations
mueller_lb = zeros(4, 4, 100);
mueller_lb(1, 1, :) = 1; 
mueller_lb(2, 2, :) = cosd(4.*alpha(1, :, :)).*(sind(beta(1, :, :)/2)).^2 + (cosd(beta(1, :, :)/2)).^2;
mueller_lb(2, 3, :) = sind(4.*alpha(1, :, :)).*(sind(beta(1, :, :)/2)).^2;
mueller_lb(2, 4, :) = -sind(2.*alpha(1, :, :)).*sind(beta(1, :, :));
mueller_lb(3, 2, :) = mueller_lb(2, 3, :);
mueller_lb(3, 3, :) = -cosd(4.*alpha(1, :, :)).*(sind(beta(1, :, :)/2)).^2 + (cosd(beta(1, :, :)/2)).^2;
mueller_lb(3, 4, :) = cosd(2.*alpha(1, :, :)).*sind(beta(1, :, :));
mueller_lb(4, 2, :) = -mueller_lb(2, 4, :);
mueller_lb(4, 3, :) = -mueller_lb(3, 4, :);
mueller_lb(4, 4, :) = cosd(beta(1, :, :));

% Mueller matrix of Circular Birefringence (4 x 4 matrix) * 100 iterations
mueller_cb = zeros(4, 4, 100);
mueller_cb(1, 1, :) = 1;
mueller_cb(2, 2, :) = cosd(2.*gamma(1, :, :));
mueller_cb(2, 3, :) = sind(2.*gamma(1, :, :));
mueller_cb(3, 2, :) = -mueller_cb(2, 3, :);
mueller_cb(3, 3, :) = mueller_cb(2, 2, :);
mueller_cb(4, 4, :) = 1;

% Mueller matrix of Birefringence (4 x 4 matrix) * 100 iterations
% Formula: mueller_delta_R = mueller_lb * mueller_cb
mueller_R = pagemtimes(mueller_lb, 'none', mueller_cb, 'none');

% Mueller matrix of Delta (4 x 4 matrix) * 100 iterations
% Formula: mueller_delta = mueller_delta_R * inv(mueller_R)
mueller_R_inv = zeros(4, 4, 100);
for i = 1:1:100
    mueller_R_inv(:, :, i) = inv(squeeze(mueller_R(:, :, i)));
end
mueller_delta = pagemtimes(mueller_delta_R, 'none', mueller_R_inv, 'none');

% e1, e2, e3
e1 = mueller_delta(2, 2, :);
e2 = mueller_delta(3, 3, :);
e3 = mueller_delta(4, 4, :);


%**************************************************************************
% Statistical analysis of each parameters
% 	  p1, p2, p3, alpha, beta, gamma, e1, e2, e3
% Toggle manually with analyzeHere
%**************************************************************************
% Have multiple formulas but only keep results from one for each parameter
D = D(1, :, :);
beta = beta(1, :, :);
alpha = alpha(1, :, :);
gamma = gamma(1, :, :);

analyzeHere = false;
if (analyzeMode*analyzeHere == true)
    stokes_stat = statAnalyze(stokes)
    mueller_stat = statAnalyze(mueller)
    mueller_ld_stat = statAnalyze(mueller_ld)
    mueller_cd_stat = statAnalyze(mueller_cd)
    mueller_D_stat = statAnalyze(mueller_D)
    muellerNorm_stat = statAnalyze(muellerNorm)
    mueller_delta_R_stat = statAnalyze(mueller_delta_R)
    mueller_lb_stat = statAnalyze(mueller_lb)
    mueller_cb_stat = statAnalyze(mueller_cb)
    mueller_R_stat = statAnalyze(mueller_R)
    mueller_delta_stat = statAnalyze(mueller_delta)
end

analyzeHere = false;
if (analyzeMode*analyzeHere == true)
    delta_p_stat = statAnalyze(delta_p)
    theta_d_stat = statAnalyze(theta_d)
    D_stat = statAnalyze(D)
    R_stat = statAnalyze(R)
    beta_stat = statAnalyze(beta)
    alpha_stat = statAnalyze(alpha)
    gamma_stat = statAnalyze(gamma)
    p1_stat = statAnalyze(p1)
    p2_stat = statAnalyze(p2)
    p3_stat = statAnalyze(p3)
    e1_stat = statAnalyze(e1)
    e2_stat = statAnalyze(e2)
    e3_stat = statAnalyze(e3)
end


%**************************************************************************
% Save data
%**************************************************************************
% 12 parameters
varNames ={'theta_d', 'D', 'R', 'alpha', 'beta', 'gamma', 'p1', 'p2', 'p3', 'e1', 'e2', 'e3'};
effectiveParameters = table(squeeze(theta_d), squeeze(D), squeeze(R), squeeze(alpha), squeeze(beta), squeeze(gamma), squeeze(p1), squeeze(p2), squeeze(p3), squeeze(e1), squeeze(e2), squeeze(e3), 'VariableNames', varNames);
effectiveParameters_Top5Rows = effectiveParameters(1:5, :)

fileAddress = "C:\Users\openit\Desktop\Pre-Thesis\Nanoparticles\effectiveParameters.xls";
sheetName = sample + " (" + sampleNum + ")";
writetable(effectiveParameters, fileAddress, 'Sheet', sheetName);

% Degree of polarization (delta_p)
varNames = "Pos" + position;
temp = flip(rot90(squeeze(delta_p)));
degreeOfPolarization = table(temp(:, 1), temp(:, 2), temp(:, 3), temp(:, 4), temp(:, 5), temp(:, 6), 'VariableNames', varNames);
degreeOfPolarization_Top5Rows = degreeOfPolarization(1:5, :)

fileAddress = "C:\Users\openit\Desktop\Pre-Thesis\Nanoparticles\degreeOfPolarization.xls";
sheetName = sample + " (" + sampleNum + ")";
writetable(degreeOfPolarization, fileAddress, 'Sheet', sheetName);