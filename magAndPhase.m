function [ shortTimeMag, shortTimePhase ] = magAndPhase( speechFrame )
%magAndPhase -  This function is used to get the magnitude and
%               phase spectrum of a short time duration frame of speech.
    
    %hamming window the speechFrame
    %we hamming window the prevent spectral leakage
    width = length(speechFrame);
    h = hamming(width);
    speechFrameH = h .* speechFrame;

    %compute DFT to give complex spectrum xF(2)
    speechFrameFT = fft(speechFrameH);
    
    %take magnitude of complex spectrum abs()
    shortTimeMag = abs(speechFrameFT);
    
    %take phase of complex spectrum angle()
    shortTimePhase = angle(speechFrameFT);
end

