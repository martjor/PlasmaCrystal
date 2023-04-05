function fig = pcryPlayVid(ImageStack,frameRate)
%PCRYPLAYVID Generates a video from a 3D stack of images
%   Detailed explanation goes here
    [height, width, numFrames] = size(ImageStack);
    
    ratio = height / width;
    maxLen = 700;
    
    if ratio >= 1
        height = maxLen;
        width = height / ratio;
    else
        width = maxLen;
        height = width * ratio;
    end
    
    fig = figure;
    fig.Position = [0 0 width height];
    
    i = 1;
    while(i < numFrames && isgraphics(fig))
        imshow(ImageStack(:,:,i),'initialMagnification','fit');
        
        pause(1/frameRate);

        i = i + 1;
    end
end

