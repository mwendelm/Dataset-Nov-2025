% Author: Mareikke Wendelmuth
% Date: 15-01-2026

close all 
clear

%% add additional functions from the Dopplium parser
addpath(genpath("../dopplium-parser/matlab"))

%% load files
node="backNode";

filename=strcat("Calibration_","2_2_",node,".bin");
[data_22,hdr_22]=doppliumParser(fullfile("data/",filename));

filename=strcat("Calibration_","2_4_",node,".bin");
[data_24,hdr_24]=doppliumParser(fullfile("data/",filename));

filename=strcat("Calibration_","4_2_",node,".bin");
[data_42,hdr_42]=doppliumParser(fullfile("data/",filename));

filename=strcat("Calibration_","4_4_",node,".bin");
[data_44,hdr_44]=doppliumParser(fullfile("data/",filename));

filename=strcat("Calibration_","emptyRoom_",node,".bin");
[data_empty,hdr_empty]=doppliumParser(fullfile("data/",filename));


%% use only one frame and chirp
frame_22 = squeeze(data_22(:,60, :, 80));
frame_24 = squeeze(data_24(:,60, :, 80));
frame_42 = squeeze(data_42(:,60, :, 80));
frame_44 = squeeze(data_44(:,60, :, 80));
frame_empty = squeeze(data_empty(:,60, :, 80));

%% substract empty room
frame_22 = frame_22 - frame_empty;
frame_24 = frame_24 - frame_empty;
frame_42 = frame_42 - frame_empty;
frame_44 = frame_44 - frame_empty;

%% rearrange for azimuth and elevation
frame22_cube=zeros([80,2,8]);
frame22_cube(:,1,[3:6])=frame_22(:,9:end);
frame22_cube(:,2,:)=frame_22(:,1:8);

frame24_cube=zeros([80,2,8]);
frame24_cube(:,1,[3:6])=frame_24(:,9:end);
frame24_cube(:,2,:)=frame_24(:,1:8);

frame42_cube=zeros([80,2,8]);
frame42_cube(:,1,[3:6])=frame_42(:,9:end);
frame42_cube(:,2,:)=frame_42(:,1:8);

frame44_cube=zeros([80,2,8]);
frame44_cube(:,1,[3:6])=frame_44(:,9:end);
frame44_cube(:,2,:)=frame_44(:,1:8);

%% range profiles
rangeProfile_22 = fft(frame22_cube, 256, 1);
rangeProfile_24 = fft(frame24_cube, 256, 1);
rangeProfile_42 = fft(frame42_cube, 256, 1);
rangeProfile_44 = fft(frame44_cube, 256, 1);

[~,range_peak_22]=max(sum(abs(rangeProfile_22(:,2,:)),3));
[~,range_peak_24]=max(sum(abs(rangeProfile_24(:,2,:)),3));
[~,range_peak_42]=max(sum(abs(rangeProfile_42(:,2,:)),3));
[~,range_peak_44]=max(sum(abs(rangeProfile_44(:,2,:)),3));


%% plot range profile
subplot(2,4,1)
plot(linspace(0,11.99,256),mag2db(abs(squeeze(rangeProfile_22(:,2,:)))));
xlabel('Distance (m)')
title('Position [2,2]')

subplot(2,4,2)
plot(linspace(0,11.99,256),mag2db(abs(squeeze(rangeProfile_24(:,2,:)))));
xlabel('Distance (m)')
title('Position [2,4]')

subplot(2,4,3)
plot(linspace(0,11.99,256),mag2db(abs(squeeze(rangeProfile_42(:,2,:)))));
xlabel('Distance (m)')
title('Position [4,2]')

subplot(2,4,4)
plot(linspace(0,11.99,256),mag2db(abs(squeeze(rangeProfile_44(:,2,:)))));
xlabel('Distance (m)')
title('Position [4,4]')


%% azimuth and elevation
azim_elev_22=fft(rangeProfile_22,8,2);
azim_elev_22=fft(azim_elev_22,16,3);

azim_elev_24=fft(rangeProfile_24,8,2);
azim_elev_24=fft(azim_elev_24,16,3);

azim_elev_42=fft(rangeProfile_42,8,2);
azim_elev_42=fft(azim_elev_42,16,3);

azim_elev_44=fft(rangeProfile_44,8,2);
azim_elev_44=fft(azim_elev_44,16,3);

%% plot azim elev plots
subplot(2,4,5)
imagesc(linspace(-1,1,16),linspace(-1,1,8),abs(squeeze(azim_elev_22(range_peak_22,:,:))))
xlabel('Azimuth cos(\phi)sin(\theta)')
ylabel('Elevation cos(\theta)')

subplot(2,4,6)
imagesc(linspace(-1,1,16),linspace(-1,1,8),abs(squeeze(azim_elev_24(range_peak_24,:,:))))
xlabel('Azimuth cos(\phi)sin(\theta)')
ylabel('Elevation cos(\theta)')

subplot(2,4,7)
imagesc(linspace(-1,1,16),linspace(-1,1,8),abs(squeeze(azim_elev_42(range_peak_42,:,:))))
xlabel('Azimuth cos(\phi)sin(\theta)')
ylabel('Elevation cos(\theta)')

subplot(2,4,8)
imagesc(linspace(-1,1,16),linspace(-1,1,8),abs(squeeze(azim_elev_44(range_peak_44,:,:))))
xlabel('Azimuth cos(\phi)sin(\theta)')
ylabel('Elevation cos(\theta)')

sgtitle(node) 