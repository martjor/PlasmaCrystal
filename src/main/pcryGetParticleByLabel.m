function particleTable = pcryGetParticleByLabel(Table,label)
%PCRYGETPARTICLEBYLABEL Returns as subsection of the table based on their indices
%   Detailed explanation goes here
    idx = Table.label == categorical({label});
    
    particleTable = Table(idx,:);
end

