% Author: Mareike Wendelmuth
% Date: 29-01-2026
% example to do the beamforming with FFT

function beamformed_cube=beamforming(subcube)
%dimensions of subcube: Range x Chirp x Channel x Frame
    azim_fft_size=32; % zero-padding before FFT in azimuth
    elev_fft_size=8; % zero-padding before FFT in elevation
    cube_pattern=zeros([2,8,size(subcube,1),size(subcube,2),size(subcube,4)]);
    cube_pattern(2,1,:,:,:)=squeeze(subcube(:,:,1,:));
    cube_pattern(2,2,:,:,:)=squeeze(subcube(:,:,2,:));
    cube_pattern(2,3,:,:,:)=squeeze(subcube(:,:,3,:));
    cube_pattern(2,4,:,:,:)=squeeze(subcube(:,:,4,:));
    cube_pattern(2,5,:,:,:)=squeeze(subcube(:,:,5,:));
    cube_pattern(2,6,:,:,:)=squeeze(subcube(:,:,6,:));
    cube_pattern(2,7,:,:,:)=squeeze(subcube(:,:,7,:));
    cube_pattern(2,8,:,:,:)=squeeze(subcube(:,:,8,:));
    
    cube_pattern(1,3,:,:,:)=squeeze(subcube(:,:,9,:));
    cube_pattern(1,4,:,:,:)=squeeze(subcube(:,:,10,:));
    cube_pattern(1,5,:,:,:)=squeeze(subcube(:,:,11,:));
    cube_pattern(1,6,:,:,:)=squeeze(subcube(:,:,12,:));
    
    azim_cube=fftshift(windowed_fft(cube_pattern,2,azim_fft_size,0),2); %azimuth
    beamformed_cube=fftshift(windowed_fft(azim_cube,1,elev_fft_size,0),1); %elevation
end

