function pcryWriteImages(ImageStack,dir,format)
%WRITEIMGS Writes a stack of images into a specified folder
%   Detailed explanation goes here
    numFrames = size(ImageStack,3);

    for i = 1:numFrames
        name = strcat(dir,'%05i',['.' format]);
        name = sprintf(name,i-1);
        fprintf([name '\n']);
        imwrite(ImageStack(:,:,i),name,format);
    end
end

