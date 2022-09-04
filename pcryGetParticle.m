function particleTable = pcryGetParticle(Table,particle)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    idx = Table.particle == particle;
    
    particleTable = Table(idx,:);
end

