function [ mfcc ] = getMelVector( magSpec )
    % remove second half of magspec, don't need it
    magSpecNew = magSpec(1:length(magSpec)/2);
    
    fs = 16000; %recording sample rate
    numFilters = 32; %filterbanks wanted
    NFFT = length(magSpec);
    
    %choose an upper and lower frequency
    upperFreq = 8000;
    lowerFreq = 300;
    
    %convert frequency to the mel scale
    upperMel = 1125*log(1 + upperFreq/700);
    lowerMel = 1125*log(1 + lowerFreq/700);

    % create mel scaled vector
    mel = linspace(lowerMel, upperMel, numFilters+2);
  
    %convert back to Hz
    Freq = 700*((10.^(mel/2595))-1);
    
    % get power of the frames
    pow_frames = ((1.0 / NFFT) * ((magSpecNew) .^ 2));
    
    %get start, middle, and end sample values for triangles
    for i = 1:length(mel)
       f(i) = floor((NFFT +1) * Freq(i)/fs);
       f(i) = f(i) + 1;
    end
    
    %create a matrix that can be used to get the multiplication values
    %for the triangle * magSpec
    for i = 2: numFilters+1
        f_m_minus = f(i-1); %left point
        f_m = f(i);         %center point
        f_m_plus = f(i+1);  %right point
        
        for k = f_m_minus: f_m
           fbank(i-1, k) = (k - f(i-1)) / (f(i) - f(i-1));
        end
        for j = f_m: f_m_plus
           fbank(i-1,j) = (f(i+1) - j) / (f(i+1) - f(i));
        end
    end
    
    channelValue = zeros(160);
    for i = 1:numFilters
        channelTotal = 0;
        for j = 1:length(fbank)%calculate scaled channel values
            channelValue(i,j) = channelValue(i,j) + (magSpecNew(j) * fbank(i,j));
            channelTotal = channelTotal + channelValue(i,j);
        end
        
        %calculate average of channel
        channelAVG = channelTotal / ((f(i+2) - f(i)) + 1);
        
        filter(i) = channelAVG;
    end
    
    logFilterBank = log10(filter);
        
    mfcc = dct(logFilterBank);
    
    %truncate excitation information
    mfcc = mfcc(1:length(mfcc)/2);
end
