close all;
clear all;
clc;

%% This code illustrates the error in capturing the incoming signal due to sampling rate. In this code, a real FM is used and the IQ datas are recorded. Then, an emitter and two sensors capturing the signal emitted from different locations are investigated.

%% Distances from emitter to sensors
range_1 = 1000; % Distance from emitter to sensor 1
range_2 = 3000; % Distance from emitter to sensor 2

%% The FM signal
filename = "C:\Users\user\Desktop\staj\Recorded sounds\SDRuno_20230815_110704Z_102389kHz.wav"; % File to be read
[y,fs] = audioread(filename); % Reading the file
Y = y(:,1) + 1i*y(:,2); % IQ data

%% Variables
signal_length = 25e-4; % Length of the FM signal to be chosen
Time = 5e-3; % Time duration
t = 0:1/fs:(Time-1/fs); % Time scale

%% Contructing the reference FM signal emitted
fm_signal_selec = Y(120000:120000+signal_length*fs-1); % Selecting the part of the FM signal
reference_signal = [zeros(3000,1);fm_signal_selec;zeros(length(t)-length(fm_signal_selec)-3000,1)]; % Contructing the reference signal 

%% Finding the delays and errors
delay_1 = range_1/physconst("LightSpeed"); % Delay for the first sensor
delay_2 = range_2/physconst("LightSpeed"); % Delay for the second sensor
sample_delay_1 = delay_1*fs; % Corresponding sample size for the delay 1
sample_delay_2 = delay_2*fs; % Corresponding sample size for the delay 2
loss_1 = (ceil(sample_delay_1)-sample_delay_1)/fs; % The error in receiving time due to sampling rate in delay 1
loss_2 = (ceil(sample_delay_2)-sample_delay_2)/fs; % The error in receiving time due to sampling rate in delay 2

%% Constructing the received signals
sig_delay_1 = [zeros(3000 + ceil(sample_delay_1),1);fm_signal_selec;zeros(length(t)-3000-ceil(sample_delay_1)-length(fm_signal_selec),1)];
sig_delay_2 = [zeros(3000 + ceil(sample_delay_2),1);fm_signal_selec;zeros(length(t)-3000-ceil(sample_delay_2)-length(fm_signal_selec),1)];

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
plot(t,abs(reference_signal));
title("Reference FM signal")
xlabel("Time(s)")
ylabel("Voltage(V)")
ax2 = nexttile;
plot(t,abs(sig_delay_1));
title("Sensor 1 signal")
xlabel("Time(s)")
ylabel("Voltage(V)")
ax3 = nexttile;
plot(t,abs(sig_delay_2));
title("Sensor 2 signal")
xlabel("Time(s)")
ylabel("Voltage(V)")