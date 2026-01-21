% Author: Mareike Wendelmuth
% Date: 21-01-2026
% function to do a (windowed) FFT

%for data cubes of dimension <=5 (i.e. samples, antenna, chirps, frames)
function result= windowed_fft(data,dimension,fft_size,window_flag)
% data - data for processing
% dimension - dimension along which the FFT is applied
% fft_size - number of DFT points, if larger than data length, the signal
% is zero-padded
% window_flog - if 1, Hann window is applied, if 0, no windowing is done
    if dimension==1
        permute_matrix=[1,2,3,4,5];
    elseif dimension==2
        permute_matrix=[2,1,3,4,5];
    elseif dimension==3
        permute_matrix=[3,2,1,4,5];
    elseif dimension==4
        permute_matrix=[4,2,3,1,5];
    elseif dimension==5
        permute_matrix=[5,2,3,4,1];
    else
        error("Wrong dimension")
    end
    tmp=permute(data,permute_matrix);
    if window_flag
        Hann_window=repmat( hann( size(tmp,1)   ) ,1, size(tmp,2),size(tmp,3),size(tmp,4),size(tmp,5));
        tmp=tmp.*Hann_window;
    end
    tmp=fft(tmp,fft_size,1);
    result=permute(tmp,permute_matrix);
end