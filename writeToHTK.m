function [ ] = writeToHTK( mfccVectors, location )
    try
        %open files for writing
        fid = fopen(location, 'w', 'ieee-be');
    catch
       fail = ['Couldnt open file'];
       disp(fail);
    end
    
    bytesPerVector = length(mfccVectors(1,:))*4;
    
    % Write the header information% 
    fwrite(fid, length(mfccVectors), 'int32');   % number of vectors in file (4 byte int)
    fwrite(fid, 100000, 'int32');               % vector rate in 100ns units (4 byte int)
    fwrite(fid, bytesPerVector, 'int16');      % number of bytes per vector (2 byte int)
    fwrite(fid, 9, 'int16');     % code for the sample kind (2 byte int)
                                 % set to 6 for MFCC
                          
    % Write the data: one coefficient at a time:
    for i = 1:length(mfccVectors)
        for j = 1:length(mfccVectors(1,:))
            fwrite(fid, mfccVectors(i, j), 'float32');    
        end
    end
    
    fclose(fid);
end