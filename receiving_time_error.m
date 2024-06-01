close all;
clear all;
clc;

%% This code illustrates the error in capturing the incoming signal due to sampling rate. For this purpose, an emitter and two sensors capturing the signal emitted from different locations are investigated.

%% Distances from emitter to sensors
range_1 = 1000; % Distance from emitter to sensor 1
range_2 = 2000; % Distance from emitter to sensor 2

%% Variables
fs = 2e6; % Sampling rate
dt = 1/fs; % Sampling period
Time = 5e-2; % Time duration
dt = 1/fs; % Sampling period
t = 0:dt:Time-dt; % Time scale
signal_length = 5e-3; % Signal length
fc = 100e3; % Operating frequency

%% Emitter signal construction
window = 1*(t>=0 & t<=signal_length); % Window for selecting the part of the sinusoidal signal
reference = nonzeros(sin(2*pi*fc*t).*window); % Windowing for selecting
sig_emitter = [zeros(3000,1);reference;zeros(length(t)-3000-length(reference),1)]; % Emitter signal with some delay

%% Finding the delays and errors
delay_1 = range_1/physconst("LightSpeed"); % Delay for the first sensor
delay_2 = range_2/physconst("LightSpeed"); % Delay for the second sensor
sample_delay_1 = delay_1*fs; % Corresponding sample size for the delay 1
sample_delay_2 = delay_2*fs; % Corresponding sample size for the delay 2
loss_1 = (ceil(sample_delay_1)-sample_delay_1)/fs; % The error in receiving time due to sampling rate in delay 1
loss_2 = (ceil(sample_delay_2)-sample_delay_2)/fs; % The error in receiving time due to sampling rate in delay 2

%% Constructing the received signals
sig_delay_1 = [zeros(3000 + ceil(sample_delay_1),1);reference;zeros(length(t)-3000-ceil(sample_delay_1)-length(reference),1)];
sig_delay_2 = [zeros(3000 + ceil(sample_delay_2),1);reference;zeros(length(t)-3000-ceil(sample_delay_2)-length(reference),1)];

%% Results
fprintf("The delay in first sensor is %.9f ns.\n",delay_1*1e9);
fprintf("The delay in second sensor is %.9f ns.\n",delay_2*1e9);
fprintf("The sample delay in first sensor is %.9f.\n",sample_delay_1);
fprintf("The sample delay in second sensor is %.9f.\n",sample_delay_2);
fprintf("The receiving error in first sensor is %.9f ns.\n",loss_1*1e9);
fprintf("The receiving error in second sensor is %.9f ns.\n",loss_2*1e9);

%% Plots
figure;
tiledlayout(3,1);
ax1 = nexttile;
plot(t,sig_emitter);
title("Emitter signal")
xlabel("Time(s)")
ylabel("Voltage(V)")
ax2 = nexttile;
plot(t,sig_delay_1);
title("Sensor 1 signal")
xlabel("Time(s)")
ylabel("Voltage(V)")
ax3 = nexttile;
plot(t,sig_delay_2);
title("Sensor 2 signal")
xlabel("Time(s)")
ylabel("Voltage(V)")