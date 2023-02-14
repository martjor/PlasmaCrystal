% File Name:            pcryGetVideo.m
% Author:               Jorge Augusto Martinez-Ortiz
% Date Created:         02.13.2023
% Description:          Function that will open a video file and return 
%                       an object containing its frames, as well as other
%                       information about the video such as frame rate.
function video = pcryGetVid(path,varargin)
    vid = VideoReader(path);
    
    % Read entire video or specific range of frames
    if nargin == 2
        frames = read(vid,varargin{2});         
    elseif nargin == 1
        frames = read(vid);
    else
        error('Invalid number of input arguments');
    end

    frames = frames(:,:,1,:);          % Convert to grayscale
    frames = squeeze(frames);

    video.frame = frames;
    video.frameRate = vid.FrameRate;
    video.numFrames = size(frames,3);
    video.shape     = [size(frames,1) size(frames,2)];
    
    fprintf('Read %3i frames @%3i fps\n',video.numFrames,video.frameRate);
end

