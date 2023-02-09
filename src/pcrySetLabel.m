function Table = pcrySetLabel(Table,particle,label)
%UNTITLED12 Updates the label of the specified particles at the given array
%   Detailed explanation goes here
    if (label~="background")&&(label~="torsion")&&(label~="cage")
        error("Invalid label");
    end

    if any(~ismember(particle,Table.particle))
        error("Invalid particle numbers");
    end
    
    for i = 1:numel(particle) 
        idx = Table.particle == particle(i);
        Table.label(idx) = categorical({label});
    end
end

