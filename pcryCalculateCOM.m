function COM = pcryCalculateCOM(Table)
%PCRYCALCULATECOM Calculates statistics of the particles sucha as their
%mean position across all the frames, their mean distance away from the
%mean position (r), and the number of frames they remain visible
%   Detailed explanation goes here
    particle = unique(Table.particle);
    NUM_PARTICLES = numel(particle);

    x = zeros(NUM_PARTICLES,1);
    y = zeros(NUM_PARTICLES,1);
    r = zeros(NUM_PARTICLES,1);
    numFrames = zeros(NUM_PARTICLES,1);
    
    label = {'background'};
    label = repmat(label,NUM_PARTICLES,1);
    label = categorical(label,{'background','torsion','cage'});
    
    for i = 1:NUM_PARTICLES
        currentParticle = pcryGetParticle(Table, particle(i));
        
        numFrames(i) = numel(currentParticle.frame);

        x(i) = mean(currentParticle.x);
        y(i) = mean(currentParticle.y);
        r(i) = mean(hypot(currentParticle.x-x(i),currentParticle.y-y(i)));
    end

    COM = table(particle,x,y,r,numFrames,label);
end

