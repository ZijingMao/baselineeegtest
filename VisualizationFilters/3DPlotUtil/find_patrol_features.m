clear all
addpath(genpath(pwd));            % Add to the path all subdirectories                         % Load EEGLAB
close all;
clc

% Load current dataset, as example, the first mision for the first subject
current_dataset = pop_loadset('TX16EEGdata.filt.001.01.1.set');

% Get important information about the dataset
current_signal = current_dataset.data;            % EEG channel-points
[~,events_quantity] = size(current_dataset.event);
event_location = zeros(2,events_quantity+1);      % Points and time locs for events
for i=1:events_quantity                    
    % Get latency in points and time (minutes)
    % Time = (latency(points) / sampling rate) / 60 (minutes)
    event_location(1,i) = current_dataset.event(i).latency;
    event_location(2,i) = ((current_dataset.event(i).latency)/...
        current_dataset.srate)/60;
end
event_location(1,events_quantity+1) = current_dataset.pnts; % 9 position for end of signal
event_location(2,events_quantity+1) = current_dataset.pnts...
    /current_dataset.srate/60;


% Extract Data for groups 1 & 2

% Group 1
temp = event_location(1,2);
temp2 = event_location(1,8) - event_location(1,7);
group_1 = zeros(current_dataset.nbchan,temp + temp2);
[g1a, g1b] = size(group_1);
group_1(:,1:temp) = current_signal(:,1:temp);
group_1(:,temp:g1b) = current_signal(:,event_location(1,7):event_location(1,8));

% Group 2
temp = event_location(1,4) - event_location(1,3);
temp2 = event_location(1,6) - event_location(1,5);
group_2 = zeros(current_dataset.nbchan,temp + temp2);
[g2a, g2b] = size(group_2);
group_2(:,1:temp+1) = current_signal(:,event_location(1,3):event_location(1,4));
group_2(:,temp:g2b) = current_signal(:,event_location(1,5):event_location(1,6));
 
% Visualize TIME DOMAIN
chan = 59;
figure, subplot(2,1,1)
plot(group_1(chan,:));
xlabel('Data Samples');
ylabel('Amplitude');
title('Data from Group 1');

subplot(2,1,2)
plot(group_2(chan,:),'red');
xlabel('Data Samples');
ylabel('Amplitude');
title('Data from Group 2');

%% Visualize Frequency Domain
Fs = 256;
f1 = (-Fs/2):(Fs/g1b):(Fs/2);
f2 = (-Fs/2):(Fs/g2b):(Fs/2);

figure, subplot(2,1,1)
plot(f1(1:g1b), fftshift(abs(fft(group_1(chan,:)))));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Data from Group 1');

subplot(2,1,2)
plot(f2(1:g2b), fftshift(abs(fft(group_2(chan,:)))),'red');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Data from Group 2');

%% Operations in time domain

group_1 = group_1(:,1:10000);
group_2 = group_2(:,1:10000);
f = dct(fftshift(abs(fft(group_2(chan,:)))));
n=length(f);
deri=zeros(1,n); 
deri1=zeros(1,n); 


for i=2:n
    deri(i)=(f(i)-f(i-1)); %deri=derivada de la señal ECG    
end 

x1=abs(deri);              % x1=valor absoluto de deri
x2=fft(f);
x2=abs(x2);                % x2=transformada de fourier de EGC

x3=fft(deri);
x3=abs(x3);                % x3=fourier de la derivada de ECG

for i=2:n
    deri1(i)=(x2(i)-x2(i-1)); % deril1=derivada de x2   
end 

x4=dct(f);                  % transformada discreta del coseno
x5=x4;
x4=abs(x4); 
                            % gráfica de resultados
figure, subplot(2,3,1);
plot(x4,'k');
title('DCT');

subplot(2,3,2);
plot(deri,'r');
title('Derivada');

subplot(2,3,3);
plot(x1,'g');
title('abs derivada');

subplot(2,3,4);
plot(x2,'m');
title('T. Fourier');

subplot(2,3,5);
plot(x3);
title('Fourier de la Derivada');

subplot(2,3,6);
plot(deri1);
title('Derivada de Fourier');

