function T_Nan = pcryFillNaN(T,numParticles,numFrames)
%PCRYFILLNAN Fills the missing frames of particles with rows of NaN values
%   The table we obtain from either FIJI or TrackPy only contains the rows
%   for the frames where a particle was detected. If a given particle i was
%   only detected for frames f-1 and f+1, but not for frame f, the rows
%   corresponding two the first two frames will be contiguous. This makes
%   it difficult to perform calculation on the data such as with the
%   functin diff, which simply calculates the difference between two
%   contiguous cells. 
    NUM_ROWS                = numParticles * numFrames;
    
    particle                = unique(Tracking.particle);
    particle                = repmat(particle',[numFrames 1]);
    particle                = reshape(particle,NUM_ROWS,1);
    
    frame                   = unique(Tracking.frame);
    frame                   = repmat(frame,[1 numParticles]);
    frame                   = reshape(frame,NUM_ROWS,1);
    
    x                       = NaN(NUM_ROWS,1);
    y                       = NaN(NUM_ROWS,1);
    vx                      = NaN(NUM_ROWS,1);
    vy                      = NaN(NUM_ROWS,1);
    KE                      = NaN(NUM_ROWS,1);
    
    label = {'background'};
    label = repmat(label,NUM_ROWS,1);
    label = categorical(label,{'background','torsion','cage'});
    
    Tracking_fxd = table(particle,frame,x,y,vx,vy,KE,label);
    
    
    for i = 0:numParticles-1
        currPar     = pcryGetParticle(Tracking,i);
        idx = i * numFrames + currPar.frame + 1;
        
        Tracking_fxd(idx,["particle","frame","x","y","label"]) = currPar;
    end
    
    for i = 0:numParticles-1
        idx = i * numFrames + (1:numFrames);
        idx2 = idx(2:end);
        
        Tracking_fxd.vx(idx2) = diff(Tracking_fxd.x(idx));
        Tracking_fxd.vy(idx2) = diff(Tracking_fxd.y(idx));
    end
end