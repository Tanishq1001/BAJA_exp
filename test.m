% This MATLAB script calculates the required torque at the wheels to move a vehicle
% up a specified incline and checks if the given motor specs are sufficient.

clc;
clear;
close all;

% --- Define Vehicle and Environmental Parameters based on the provided documents ---
vehicle_mass_kg = 250; 
driver_mass_kg = 70;
total_mass_kg = vehicle_mass_kg + driver_mass_kg;
g = 9.81; % Acceleration due to gravity (m/s^2)
total_weight_N = total_mass_kg * g;

% Tire and Aerodynamic parameters from the documents
wheel_radius_m = 0.6604;
fR = 0.16; % Rolling resistance coefficient from user prompt
rho = 1.225; % Air density (kg/m^3)
Cw = 0.9; % Coefficient of drag, using the minimum value from the user prompt
frontal_area_m2 = 0.88; % From previous document
lambda = 1.1; % Mass correction factor from user prompt

% --- Motor Specifications (Nominal and Peak) ---
motor_nominal_torque_Nm = 15.5;
motor_peak_torque_Nm = 90;

% --- Gearbox and Drivetrain Specifications ---
gear_ratio = 8.25;
drivetrain_efficiency = 0.8;

% --- Define Operating Conditions (Velocity and Inclination) ---
max_speed_kmh = 45;
max_speed_ms = max_speed_kmh * (1000/3600);
a = 0; % Assuming acceleration is 0 based on user prompt image

% --- Define the specific angle to run the calculation for ---
target_angle = 40;

fprintf('--- Calculating Torque for a %.0f-degree Incline ---\n\n', target_angle);
fprintf('Vehicle Mass: %.2f kg\n', total_mass_kg);
fprintf('Wheel Radius: %.4f m\n', wheel_radius_m);
fprintf('Motor Peak Torque: %.1f Nm\n', motor_peak_torque_Nm);
fprintf('Gear Ratio: %.2f\n', gear_ratio);
fprintf('Drivetrain Efficiency: %.2f\n', drivetrain_efficiency);
fprintf('Maximum Speed: %.2f km/h (%.2f m/s)\n', max_speed_kmh, max_speed_ms);
fprintf('Drag Coefficient (Cw): %.2f\n', Cw);
fprintf('Rolling Resistance Coefficient (fR): %.2f\n', fR);
fprintf('Mass Correction Factor (lambda): %.1f\n\n', lambda);


% --- Calculate Resistive Forces for the target angle ---
Rr_N = total_mass_kg * g * fR * cosd(target_angle);
Fa_N = 0.5 * rho * Cw * frontal_area_m2 * (max_speed_ms)^2;
Fl_N = total_mass_kg * g * sind(target_angle);
Fd_total_N = Rr_N + Fa_N + Fl_N;


% --- Print Calculated Tractive Forces ---
fprintf('Calculated Tractive Force Components at %.0f degrees:\n', target_angle);
fprintf('Rolling Resistance (F_R): %.2f N\n', Rr_N);
fprintf('Aerodynamic Resistance (F_a): %.2f N\n', Fa_N);
fprintf('Gradient Resistance (F_L): %.2f N\n', Fl_N);
fprintf('TOTAL TRACTIVE EFFORT (F_total): %.2f N\n\n', Fd_total_N);


% --- Calculate Total Tractive Torque and Required Motor Torque ---
Tt_total_Nm = Fd_total_N * wheel_radius_m;
required_motor_torque_per_wheel = Tt_total_Nm / (gear_ratio * drivetrain_efficiency * 4);


% --- Print Calculated Torques ---
fprintf('Required total torque on the wheels: %.2f Nm\n', Tt_total_Nm);
fprintf('Required motor torque per wheel: %.2f Nm\n\n', required_motor_torque_per_wheel);


% --- Check for Sufficiency ---
if required_motor_torque_per_wheel > motor_peak_torque_Nm
    fprintf('The required motor torque (%.2f Nm) EXCEEDS the motor peak torque (%.1f Nm).\n', required_motor_torque_per_wheel, motor_peak_torque_Nm);
    fprintf('The motor is NOT sufficient to climb this incline.\n');
else
    fprintf('The required motor torque (%.2f Nm) is SUFFICIENT to climb the incline, as it is less than the motor peak torque (%.1f Nm).\n', required_motor_torque_per_wheel, motor_peak_torque_Nm);
end


% --- Plot the results for a visual representation. ---
inclination_degrees_plot = 0:1:40; 
required_motor_torque_plot = zeros(size(inclination_degrees_plot));

for i = 1:length(inclination_degrees_plot)
    alpha = inclination_degrees_plot(i);
    
    Rr_N_plot = total_mass_kg * g * fR * cosd(alpha);
    Fa_N_plot = 0.5 * rho * Cw * frontal_area_m2 * (max_speed_ms)^2;
    Fl_N_plot = total_mass_kg * g * sind(alpha);
    Fd_total_N_plot = Rr_N_plot + Fa_N_plot + Fl_N_plot;

    Tt_total_Nm_plot = Fd_total_N_plot * wheel_radius_m;
    required_motor_torque_plot(i) = Tt_total_Nm_plot / (gear_ratio * drivetrain_efficiency * 4);
end

figure;
plot(inclination_degrees_plot, required_motor_torque_plot, '-o', 'LineWidth', 2);
hold on;
plot(inclination_degrees_plot, repmat(motor_nominal_torque_Nm, size(inclination_degrees_plot)), '--r', 'LineWidth', 2);
plot(inclination_degrees_plot, repmat(motor_peak_torque_Nm, size(inclination_degrees_plot)), '-.g', 'LineWidth', 2);
xlabel('Inclination (degrees)');
ylabel('Torque per Wheel (Nm)');
title('Required Torque vs. Motor Capability');
legend('Required Torque', 'Motor Nominal Torque', 'Motor Peak Torque', 'Location', 'best');
grid on;
ylim([0, max(required_motor_torque_plot)*1.1]);
hold off;
