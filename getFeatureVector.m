function [ mfcc ] = getFeatureVector( magSpec )
    numChannels = 16;
    
    % remove second half of magspec, don't need it
    magSpec = magSpec(1:length(magSpec)/2);

    %calculate the amount of samples in each channel
    samplesPerChannel = length(magSpec)/numChannels;
    
    channelStartIndex = 1;
    
    %loop through the channels
    for i = 1:numChannels
        %sum the values in each channel
        channelTotal = sum(magSpec(channelStartIndex : (channelStartIndex-1)+samplesPerChannel));
        
        %calculate average value in the channel
        channelAvg = channelTotal / samplesPerChannel;
        
        %populate filterbank vector
        filterBank(i) = channelAvg;
        
        %increment startSample by samplesPerChannel to get start position
        %of next channel
        channelStartIndex = channelStartIndex + samplesPerChannel;
    end
    
    logFilterBank = log10(filterBank);
    
    %first half is vocal tract information, second half is excitation
    %information
    mfcc = dct(logFilterBank);
    
    %truncate excitation information
    mfcc = mfcc(1:length(mfcc)/2);
end

