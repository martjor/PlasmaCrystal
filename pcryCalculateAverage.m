function MU = pcryCalculateAverage(T,varargin)
%PCRYCALCULATEAVERAGE calculates the average of the quantity stored in the
%vector T for each of the particles in the array.
%   MU = PCRYCALCULATEAVERAGE(T,NUMPARTICLES) calculates the average of 
%   the quantity for every particle. Therefore, MU is a vector of length 
%   NUMPARTICLES (the number of particles in the array).
%         
%   MU = PCRYCALCULATEAVERAGE(T,NUMPARTICLES,NUMFRAMES): calculates the
%   average of the quantity for every particle, along intervals of
%   NUMFRAMES frames. MU is a two-dimensional array, where each row
%   corresponds to a single particle, and a colum indicates the interval it
%   is taken from.
    
    % CHECK FOR VALID INPUT
    if nargin == 1 || nargin > 3
        error('Number of input arguments is invalid.')
    end

    numParticles = varargin{1};
    simpleAvg = true;
    if nargin == 3
        numFrames = varargin{2};
        simpleAvg = false;
    end

    if mod(length(T),numParticles) ~= 0
            error(['Dimensions of indicated array must be a multiple of the'...
                   'number of particles'])
    end
    
    
    % COMPUTE THE AVERAGE
    TOTAL_FRAMES = length(T) / numParticles;
    
    MU = reshape(T,TOTAL_FRAMES,numParticles);

    if simpleAvg
        MU = mean(MU,1,'omitnan');
    else
        numIntervals = floor(TOTAL_FRAMES/numFrames);
        MU = MU(1:(numIntervals * numFrames),:);
        MU = reshape(MU,numFrames,numIntervals,numParticles);
        MU = squeeze(mean(MU,1,'omitnan'));

        fprintf('Interval size: %i (%i intervals created), the last %i frames were dropped\n',...
                numFrames,numIntervals,mod(length(T)/numParticles,numFrames));
    end

    MU = transpose(MU);

    
end