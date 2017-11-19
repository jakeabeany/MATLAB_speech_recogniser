function [ ] = writeMFCC( where )
    for i = 1:10
        %read file
        if i == 10
            string = strcat('Sound Recordings/Training Recordings/Added Noise/Factory/speech0', num2str(i), '.wav');
            name = strcat(where, 'speech0', num2str(i), '.mfcc');
        else
            string = strcat('Sound Recordings/Training Recordings/Added Noise/Factory/speech00', num2str(i), '.wav');
            name = strcat(where, 'speech00', num2str(i), '.mfcc');
        end

        x = audioread(string);
        
        %get mfcc
        mfcc = Utterance(x);
        
        writeToHTK(mfcc, name);
    end
end

