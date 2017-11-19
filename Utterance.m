function [ mfccVectors ] = Utterance( speech )
    numSamples = length(speech);
    mfccVectors = [];
    
    %320 samples is 20ms when the frequency is 16kHz
    frameLength = 320;
    
    %high-pass filter, spectrally flatten the signal
    preemphasis = [1, -0.97];
    
    speech = filter(preemphasis,1,speech);
   
    % important to half frames length so we include whole utterance
    numFrames = floor(numSamples / (frameLength/2)) -1;
    
    firstSample = 1;
    lastSample = frameLength;
    
    for frame = 1:numFrames
        %get 20ms window
       shortTimeFrame = speech(firstSample:lastSample); 
       
       %get mag and phase of 20ms window
       [magSpec, phaseSpec] = magAndPhase(shortTimeFrame);
       
       %extract feature vector from the magnitude spectrum of the 
       %20ms window
       featureVector = getFeatureVector(magSpec);%getMelVector(magSpec);%%
       
       %append feature vector of last 20ms window
       mfccVectors = [mfccVectors; featureVector];
       
       %move window along half a frame
       firstSample = (firstSample + (frameLength/2));
       lastSample = (lastSample + (frameLength/2));
    end
end

