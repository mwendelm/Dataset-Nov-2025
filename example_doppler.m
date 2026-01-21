% Author: Mareikke Wendelmuth
% Date: 20-01-2026

clear
close all
clc

%% add additional functions from the Dopplium parser
addpath(genpath("../dopplium-parser/matlab"))

%% add additional helper functions
addpath(genpath("../helper_functions"))

%% load files
node="backNode";
participantNr=1;
activity=3;

filename=strcat("Participant",string(participantNr),"_activity",string(activity),"_data_",node,".bin");
[data,hdr]=doppliumParser(fullfile("data/",filename));

%% remove static clutter
decluttered_data=data(:,:,:,:)-mean(data(:,:,:,:),4);
RangeMap=windowed_fft(decluttered_data,1,256,1);

%% Range map
starttime=datetime(uint64(hdr.file.file_created_utc_ticks),'ConvertFrom','.net','Format','dd-MMM-uuuu HH:mm:ss.SSS');
time_axis=[starttime:milliseconds(hdr.body.frame_periodicity_ms):starttime+milliseconds(hdr.body.frame_periodicity_ms*(size(hdr.frame,1)-1))];
range_axis=linspace(0,hdr.body.max_range_m,256);

%plot
figure
imagesc(time_axis,range_axis,squeeze(mag2db(abs(RangeMap(:,50,3,:)))))
colorbar;
ylabel('Range (m)');
xlabel('Time');
title(strcat(node,': Range map [dB]'))

%% Doppler map
%subcube of relevant range
subdata=RangeMap(65:90,:,:,:);
DopplerMap=fftshift(windowed_fft(subdata,2,256,1),2);
doppler_axis=linspace(-hdr.body.max_velocity_mps,hdr.body.max_velocity_mps,256);

%plot
figure
imagesc(time_axis,doppler_axis,squeeze(mag2db(abs(DopplerMap(75-65,:,3,:)))))
colorbar;
ylabel('Doppler (m/s)');
xlabel('Time');
title(strcat(node,': Doppler map [dB]'))