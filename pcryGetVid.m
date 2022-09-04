function video = getVid(fileName)
%getVid Extracts the frames from a video file
%   Detailed explanation goes here
    
    vid = VideoReader(fileName);

    frames = read(vid);         % Read frames
    frames = frames(:,:,1,:);   % Convert to grayscale
    frames = squeeze(frames);

    video.frame = frames;
    video.frameRate = vid.FrameRate;
    video.numFrames = vid.NumFrames;
    video.shape     = [size(frames,1) size(frames,2)];
    
    fprintf('Read %3i frames @%3i fps',video.numFrames,video.frameRate);
end

